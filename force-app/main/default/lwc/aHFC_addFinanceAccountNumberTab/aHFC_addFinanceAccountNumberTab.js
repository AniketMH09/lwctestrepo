/** Controller Name:      AHFC_addFinanceAccountNumberTab
 *  Description:          Add Finance account page logic when customer wants to add finance account to the person account.
 *  Developer Name:       Akash Solanki
 *  Created Date:         08-May-2021 
 *  Modified By :         Akash Solanki
 *  Modification Logs:    Updated for US 10316 for Google Re-captcha on 18-Aug-2021
 *  Modification Logs     Updated for US 4965 for Enrollnment in communication preferences.
 */
import { LightningElement, track, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import infoSvg from "@salesforce/resourceUrl/AHFC_info";
import warningSvg from "@salesforce/resourceUrl/AHFC_warning";
import AHFC_Privacy_Policy_Esign from "@salesforce/resourceUrl/ESIGN_Disclosure_and_Consent";
import { fireAdobeEvent } from "c/aHFC_adobeServices";

import SFDecrypt from "@salesforce/apex/AHFC_FLOW_Controller.SFDecrypt";
import AHFC_CIAM_HONDA_APP_ID from "@salesforce/label/c.AHFC_CIAM_HONDA_APP_ID";
import AHFC_CIAM_ACURA_APP_ID from "@salesforce/label/c.AHFC_CIAM_ACURA_APP_ID";
import AHFC_CIAM_HONDA_LOGIN_URL from "@salesforce/label/c.AHFC_CIAM_HONDA_LOGIN_URL";
import AHFC_CIAM_ACURA_LOGIN_URL from "@salesforce/label/c.AHFC_CIAM_ACURA_LOGIN_URL";

import AHFC_Required_Fields_Error from "@salesforce/label/c.AHFC_Required_Fields_Error";
import AHFC_RegistrationError from "@salesforce/label/c.AHFC_RegistrationError";
import AHFC_ServiceAccExistsError from "@salesforce/label/c.AHFC_ServiceAccExistsError";
import AHFC_AccountNotFound from "@salesforce/label/c.AHFC_Account_Not_Found";
import AHFC_AccountNoMatchCriteria from "@salesforce/label/c.AHFC_Account_No_Match_Criteria";
import AHFC_HFS_Site_URL from "@salesforce/label/c.AHFC_HFS_Site_URL";
import AHFC_Exception_Message from "@salesforce/label/c.AHFC_Exception_Message";
import AHFC_AddAccount_WebOnlineError2 from "@salesforce/label/c.AHFC_AddAccount_WebOnlineError_Part2";

//Added By Aswin - US 7522
import AHFC_AddAccount_DatabaseError from "@salesforce/label/c.AHFC_AddAccount_DatabaseError";
import AHFC_AddAccount_PageError from "@salesforce/label/c.AHFC_AddAccount_PageError";
import AHFC_AddAccount_WebOnlineN from "@salesforce/label/c.AHFC_AddAccount_WebOnlineN";
import AHFC_AddAccount_WebOnlineError from "@salesforce/label/c.AHFC_AddAccount_WebOnlineError";

import addCustomerFinanceAccount from "@salesforce/apex/AHFC_AddFinanceAccountController.updateCustomerFinanceAccount"
import getFinanceAccountExists from "@salesforce/apex/AHFC_AddFinanceAccountController.getFinanceAccountExists"
import updateCommPrefs from "@salesforce/apex/AHFC_AddFinanceAccountController.updateCommPrefs"
import getFinanceAccount from "@salesforce/apex/AHFC_AddFinanceAccountController.getFinanceAccount"
import { getConstants } from "c/ahfcConstantUtil";
import { NavigationMixin } from "lightning/navigation";

import AHFC_Customer_URL from "@salesforce/label/c.AHFC_Customer_URL";

//Added by Supriya on 18/10/2021 - new requirement during UAT testing(use of captcha configurable)
import AHFC_Is_Captcha_Required from "@salesforce/label/c.AHFC_Is_Captcha_Required";

const CONSTANTS = getConstants();

export default class AHFC_addFinanceAccountNumberTab extends NavigationMixin(
    LightningElement
) {
    @track isLoaded = false;
    @track billing = true;
    @track payment = true;
    @track specialOffersCheck = true; //US 4965 by Akash 
    @track showPopover = false;
    @track SSN = "";
    @track accountNumber = "";
    @track addAccountError = false;
    @track addAccountErrorMsg = "";
    @track addAccountPageError = false; 
    @track addAccountPageErrorMsg = "";
    @track specialChars = false;
    @track errorMessageValidation = '';
    @track errorMessageValidationAcc = '';
    @track isAlphaSpecial = false;
    @track finAccExists = false;
    @track WebOnlineError = false;
    @track iframeShow = true;
    @track addAccountPageErrorMsg2 = "";
    @track eSignTnCUrl = AHFC_Privacy_Policy_Esign;
    acuraLoginUrl = AHFC_CIAM_ACURA_LOGIN_URL;
    hondaLoginUrl = AHFC_CIAM_HONDA_LOGIN_URL;
    acuraAppId = AHFC_CIAM_ACURA_APP_ID;
    hodaAppId = AHFC_CIAM_HONDA_APP_ID;
    @track parameters = '';
    @track encodedValue = '';
    @track financeAccNumber = '';
    @track currentEmailAdd = '';
    @track finAcctExists = false;
    @track isHondaURL = false;
    @track isAcuraURL = true;
    @track finalURL = '';
    @track registrationURL = '';
    @track brandName = '';
    hasEnceaUrlParameters = false;
    brandParameter = '';
    commprefUpdateMsg = '';
    isCommPrefUpdated = true;

    @api useremail;
    @api strUserProfile;
    financeAccountCustomer;
    error;
    warningSvg = warningSvg;
    infoSvg = infoSvg;
    @api boolguestprofile = false;
    @api strfedid = '';
    @api email = '';
    @track isValid = false;
    @track isValidSSN = false;
    @track showButton = false;
    @track msgData = '';

    @track checkedBilling = 'true'; //US 4965 - Akash Solanki
    @track checkedPayment = 'true'; //US 4965 - Akash Solanki
    @track checkedSpecialOffers = 'true'; //US 4965 - Akash Solanki
    @track isRegistrationFlow = false; // Bug 22322

    //US 4965 - Akash Solanki
    handleChangeSpecialOffers(e) {
        if (e.detail.checked) {
            this.checkedSpecialOffers = 'true';
            this.passCommPrefValues(this.checkedSpecialOffers, 'SpecialOffers');//Bug Fix 21492
            let adobedata = {
                'Event_Metadata.action_type': 'Checkbox',
                "Event_Metadata.action_label": "Account Setup:Checkbox:Special Offers & Promotions",
                "Event_Metadata.action_category": "Comm Pref Enrollment",
                "Page.page_name": "Account Setup (Welcome)",
            };
            fireAdobeEvent(adobedata, 'click-event');
        } else {
            this.checkedSpecialOffers = 'false';
            this.passCommPrefValues(this.checkedSpecialOffers, 'SpecialOffers');//Bug Fix 21492
        }
        console.log('check Special Offers final-----> ', this.checkedSpecialOffers);
    }
    //US 4965 - Akash Solanki
    handleChangePayment(e) {
        if (e.detail.checked) {
            this.checkedPayment = 'true';
            this.passCommPrefValues(this.checkedPayment, 'Payment');//Bug Fix 21492
            let adobedata = {
                'Event_Metadata.action_type': 'Checkbox',
                "Event_Metadata.action_label": "Account Setup:Checkbox:Paperless Statements & Correspondence",
                "Event_Metadata.action_category": "Comm Pref Enrollment",
                "Page.page_name": "Account Setup (Welcome)",
            };
            fireAdobeEvent(adobedata, 'click-event');
        } else {
            this.checkedPayment = 'false';
            this.passCommPrefValues(this.checkedPayment, 'Payment');//Bug Fix 21492
        }
        console.log('check payment final-----> ', this.checkedPayment);
    }

   
    //US 4965 - Akash Solanki 
    handleChangeBilling(e) {
        console.log('Hiiii2', e.detail.checked);
        if (e.detail.checked) {
            this.checkedBilling = 'true';
            this.passCommPrefValues(this.checkedBilling, 'Billing');//Bug Fix 21492
            let adobedata = {
                'Event_Metadata.action_type': 'Checkbox',
                "Event_Metadata.action_label": "Account Setup:Checkbox:Account Updates and Payment Activity",
                "Event_Metadata.action_category": "Comm Pref Enrollment",
                "Page.page_name": "Account Setup (Welcome)",
            };
            fireAdobeEvent(adobedata, 'click-event');

        } else {
            this.checkedBilling = 'false';
            this.passCommPrefValues(this.checkedBilling, 'Billing');//Bug Fix 21492
        }
        console.log('check billing final-----> ', this.checkedBilling);
    }
    /*Bug Fix 21492 Starts*/
    @api
    setCommPrefValues(isChecked, commprefValue) {

        if (commprefValue == 'SpecialOffers') {
            this.checkedSpecialOffers = 'false';
            this.specialOffersCheck = false;
            if (isChecked == 'true') {
                this.checkedSpecialOffers = 'true';
                this.specialOffersCheck = true;
            }
        } else if (commprefValue == 'Payment') {
            this.checkedPayment = 'false';
            this.payment = false;
            if (isChecked == 'true') {
                this.checkedPayment = 'true';
                this.payment = true;
            }
        } else if (commprefValue == 'Billing') {
            this.checkedBilling = 'false';
            this.billing = false;
            if (isChecked == 'true') {
                this.checkedBilling = 'true';
                this.billing = true;
            }

        }
        //SpecialOffers // Payment //Billing
    }
    /*Bug Fix 21492 Ends*/
    passCommPrefValues(isChecked, changedCommprefValue) {
        const selectedEvent = new CustomEvent('setvalues', { detail: { checked: isChecked, commprefValueChanged: changedCommprefValue } });
        this.dispatchEvent(selectedEvent);
    }
    //US 10316 for Google Re-captcha by Akash starts 
    listenForMessage(message) {
        var editor = this.template.querySelector('iframe');
        if (message.data.action === 'unlock') {
            this.showButton = true;
            this.msgData = message.data;
            editor.classList.remove('reCaptchaBig');
            editor.classList.add('reCaptchaSmall');
        }
        if (message.data.captchaVisible === 'visible') {
            var editor = this.template.querySelector('iframe');
            editor.classList.add('reCaptchaBig');
            editor.classList.remove('reCaptchaSmall');
        } else {
            editor.classList.remove('reCaptchaBig');
            editor.classList.add('reCaptchaSmall');
        }

        // To make the captha feature configurable
        if (AHFC_Is_Captcha_Required == 'no') {
            this.showButton = true;
            this.iframeShow = false;
        }
    }
    //US 10316 for Google Re-captcha Ends

    connectedCallback() {
        this.isDisabled = false;
        this.decryptUrl();
        this._listenForMessage = this.listenForMessage.bind(this); //US 10316 for Google Re-captcha
        window.addEventListener("message", this._listenForMessage); //US 10316 for Google Re-captcha
        console.log('this.hasEnceaUrlParameters', this.hasEnceaUrlParameters);
        if (this.hasEnceaUrlParameters == false) {
            this.getFinanceAccountExistsfn();
        }
        const selectedEvent = new CustomEvent('setvaluesfromparent');//Bug Fix 21492
        this.dispatchEvent(selectedEvent);//Bug Fix 21492
    }
    //US 10316 for Google Re-captcha by Akash
    disconnectedCallback() {
        window.removeEventListener('message', this._listenForMessage);
    }

    getFinanceAccountExistsfn() {
        getFinanceAccountExists().then((result) => {
            if (result === true) {
                this.finAccExists = true;
                if ((sessionStorage.getItem('addProductFromDashboard') == null || sessionStorage.getItem('addProductFromDashboard') == 'false') &&
                    (sessionStorage.getItem('addProductFromBlankDashboard') == null || sessionStorage.getItem('addProductFromBlankDashboard') == 'false')
                ) {
                    this.navigateToDashboard();
                } else if (sessionStorage.getItem('addProductFromBlankDashboard') == 'true') {
                    this.finAccExists = false;
                }

            } else {
                this.finAccExists = false;
            }
        }).catch((error) => {
            this.error = error;
        })

    }

    onIconEnter() {
        this.showPopover = true;
    }

    onIconLeave() {
        this.showPopover = false;
    }

    navigateToDashboard() {
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Account Setup:Button:Skip to Dashboard",
            "Event_Metadata.action_category": "",
            "Page.page_name": "Account Setup (Welcome)",
        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "dashboard"
            }
        });
        var delayInMilliseconds = 100;

        setTimeout(function () {
            window.location.reload();
        }, delayInMilliseconds);
    }

    navigateToHFSSite() {
        // Navigate to a URL
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: AHFC_HFS_Site_URL
            }
        },
            true // Replaces the current page in your browser history with the URL
        );
    }

    handlechangeSSN(event) {
        this.SSN = event.target.value;
    }

    handlechangeAccountnumber(event) {
        this.accountNumber = event.target.value;   
        // this.onValidate(event);    
    }

    onValidate(event) {
        let targetId = event.target.getAttribute("data-id");
        let target = this.template.querySelector("." + targetId);
        if (targetId === 'accountnumber-input')  // added the check as part ob bug fix 14357
            this.accountNumber = event.target.value;
        if (targetId === 'ssn-input')
            this.SSN = event.target.value;
        if (!event.target.value.length) {
            target.classList.add("slds-has-error");
            this.isValid = false;
            this.specialChars = false;
            if (targetId === 'ssn-input')
                this.errorMessageValidation = 'Error: This field is mandatory';
            if (targetId === 'accountnumber-input')
                this.errorMessageValidationAcc = 'Error: This field is mandatory';

        } else if (event.target.value.length < 8 && targetId === 'accountnumber-input') {

            target.classList.add("slds-has-error");
            this.isValid = false;
            this.errorMessageValidationAcc = 'Error: Account Number Should be 8 or 9 digits.';

        } else if (event.target.value.length < 4 && targetId === 'ssn-input') {
            target.classList.add("slds-has-error");
            this.isValidSSN = false;
            this.errorMessageValidation = 'Error: Last 4 of SSN or Tax ID Should be 4 digits.';

        } else if (event.target.validity.valid == false && targetId == 'accountnumber-input') {
            target.classList.add("slds-has-error");
            this.isValid = false;

        } else if (event.target.validity.valid == false && targetId == 'ssn-input') {
            target.classList.add("slds-has-error");
            this.isValidSSN = false;

        } else if (targetId == 'ssn-input') {
            target.classList.remove("slds-has-error");
            this.isValidSSN = true;
        } else if (targetId == 'accountnumber-input') {
            target.classList.remove("slds-has-error");
            this.isValid = true;

        } else {
            console.log('Inside success >>>>>>>>>>>>>');
        }

        return true;
    }

    onValidateType(event) {
        // this.addAccountError = false;

        const reg = new RegExp('^.{8,9}$');
        if (!reg.test(event.target.value)) {
            // this.onValidate(event);
            event.preventDefault();
        } else {
            //this.onValidate(event);
        }
        this.onValidate(event);
    }
    /**
     * 	@description 			    : US 4965 This method will check the flags on the basis of 3 checkboxes check on the Add Account Page under customer's email.
     * 	@author 				      : Akash Solanki | Aug 23 2021
     * 	@return<String> 		  : returns the message in form of string
     * 	@param accountNumber 	: 8 or 9 digit account number coming from UI
     *	  @param billingCheck 	: Finance Account Updates and Payment Activity checkbox on Add Account Page
     *	  @param paymentCheck 	: Paperless Statements & Correspondence checkbox on Add Account Page
     *	  @param offersCheck 		: Special Offers & Promotions checkbox on Add Account Page
     *	  @return String
     **/

    handleCommPrefs() {
        updateCommPrefs({
            accountNumber: this.accountNumber,
            billingCheck: this.checkedBilling,
            paymentCheck: this.checkedPayment,
            offersCheck: this.checkedSpecialOffers,
            customerEmail: this.useremail
        }).then((result) => {
            if (result == 'SUCCESS') {
                this.isCommPrefUpdated = true;
                console.log('navigation success');
                this.navigateToDashBoardPage();
            } else {
                this.isCommPrefUpdated = false;
                this.commprefUpdateMsg = 'Your email preferences could not be saved at this time. To make changes, go to Communication Preferences under My Account';
                this.showErrorToast();
                console.log(result);
                setTimeout(() => {
                    this.navigateToDashBoardPage();
                }, 3000);

            }

        }).catch((error) => {

            console.log('Error-----> ', error);
            this.isCommPrefUpdated = false;
            this.commprefUpdateMsg = 'Your email preferences could not be saved at this time. To make changes, go to Communication Preferences under My Account';
            this.showErrorToast();
            console.log('failed success');
            setTimeout(() => {
                this.navigateToDashBoardPage();
            }, 3000);

        })
    }
    navigateToDashBoardPage() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "dashboard"
            }
        });
    }
    showErrorToast() {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: 'Your email preferences could not be saved at this time. To make changes, go to Communication Preferences under My Account',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
    getFinanceAccountNo() {
        console.log('289 line');
        getFinanceAccount({
            accountNumber: this.accountNumber,
            last4Digits: this.SSN
        }).then((result) => {
            let data = result;
            sessionStorage.setItem('recentfinanceAccountNo', result);
        }).catch((error) => {
            console.log('Error-----> NS', error);
        })
    }

    handleaddAccount() {
        if(this.isRegistrationFlow == true){ // Bug 22322 - for welcome email registration flow account number validations is not required
            this.isValid = true;
        }
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Account Setup:Button:Add Account",
            "Event_Metadata.action_category": "",
            "Page.page_name": "Account Setup (Welcome)",
        };
        fireAdobeEvent(adobedata, 'click-event');
        const inputList = this.template.querySelectorAll(".slds-input");
        for (let i = 0; i < inputList.length; i++) {
            inputList[i].focus();
            inputList[i].blur();
        }
        if (this.accountNumber !== '' && this.SSN !== '' && this.accountNumber.length > 7 && this.SSN.length == 4 && this.isValid == true && this.isValidSSN == true) {
            this.isLoaded = true;
            addCustomerFinanceAccount({
                accountNumber: this.accountNumber,
                last4Digits: this.SSN,
                strFedId: this.strfedid,
                strEmail: this.email
            }).then((result) => {
                this.isLoaded = false;
                this.financeAccountCustomer = result;
                console.log('RESULT**' + result);
                if (this.financeAccountCustomer === 'SUCCESS') {
                    console.log('line 317');
                    this.handleCommPrefs(); // US 4965 by Akash Solanki
                    this.getFinanceAccountNo(); // US 6850 by Narain

                } else if (this.financeAccountCustomer === AHFC_ServiceAccExistsError) {
                    this.addAccountPageError = false;
                    this.WebOnlineError = false;
                    this.addAccountError = true;
                    this.addAccountErrorMsg = AHFC_ServiceAccExistsError;
                } else if (this.financeAccountCustomer === AHFC_AccountNotFound) {
                    this.addAccountPageError = false;
                    this.WebOnlineError = false;
                    this.addAccountError = true;
                    this.addAccountErrorMsg = AHFC_AccountNotFound;
                } else if (this.financeAccountCustomer === AHFC_AccountNoMatchCriteria) {
                    this.addAccountPageError = false;
                    this.WebOnlineError = false;
                    this.addAccountError = true;
                    this.addAccountErrorMsg = AHFC_AccountNoMatchCriteria;
                } else if (this.financeAccountCustomer === AHFC_AddAccount_DatabaseError) {
                    this.addAccountError = false;
                    this.addAccountPageError = true;
                    this.WebOnlineError = false;
                    this.addAccountPageErrorMsg = AHFC_AddAccount_PageError;
                } else if (this.financeAccountCustomer === AHFC_AddAccount_WebOnlineN) {
                    this.addAccountError = false;
                    this.addAccountPageError = true;
                    this.addAccountPageErrorMsg = AHFC_AddAccount_WebOnlineError;
                    this.addAccountPageErrorMsg2 = AHFC_AddAccount_WebOnlineError2;
                    this.WebOnlineError = true;
                }

            }).catch((error) => {
                this.isLoaded = false;
                this.error = error;
                this.addAccountError = false;
                this.WebOnlineError = false;
                this.addAccountPageError = true;
                this.addAccountPageErrorMsg = AHFC_AddAccount_PageError;
                this.error.message;
            })
        } else {
            console.log('Inside else!!!')
        }
    }



    //Added by Aswin Jose US : 7522
    restrictAlphabetsAndSpecialChars(event) {
        var x = event.which || event.keycode;
        if ((x >= 48 && x <= 57) || x == 49 || x == 8) {
            this.onValidate(event);
            return true;
        } else {
            event.preventDefault();
            return false;
        }
    }

    /*  validateBackSpace(event){
          var x = event.which || event.keycode;
          if ( x==8 || x == 46) { 
              this.onValidate(event);
             return true;
          }  
      }*/

    //Added by Aswin Jose US : 7522
    validateAlphaSpecialChars(event) {

        var clipboardData = event.clipboardData || window.clipboardData;
        var pastedData = clipboardData.getData('Text');
        let targetId = event.target.getAttribute("data-id");

        var eventVal = '';
        if (targetId == 'accountnumber-input') {
            eventVal = pastedData.substring(0, 9);
        } else if (targetId == 'ssn-input') {
            eventVal = pastedData.substring(0, 4);
        }

        console.log('eventVal : ' + eventVal);

        var pattern = new RegExp("^(?=.*[-+_!@#$%^&*.,?]).+$");
        var pattern2 = /^[a-zA-Z ]*$/;
        if (pattern.test(eventVal) || pattern2.test(eventVal)) {
            this.isAlphaSpecial = true;
        } else {
            this.isAlphaSpecial = false;

        }
        if (this.isAlphaSpecial && targetId == 'accountnumber-input') {
            this.errorMessageValidationAcc = 'Error: Account Number Should be 8 or 9 digits.';
        } else if (this.isAlphaSpecial && targetId == 'ssn-input') {
            this.errorMessageValidation = 'Error: Last 4 of SSN or Tax ID Should be 4 digits.';
        } else {
            this.errorMessageValidation = '';
            this.errorMessageValidationAcc = '';
        }


    }

    //navigate to contact Us page
    navigateToContactUs() {        
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: ''
            },
        });
    }

    onToastLinkClicked() {
        //navigate to contact Us page
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-post-login'
            }
        });

    }

    /****Caim Starts */
    decryptUrl() {
        this.parameters = this.getQueryParameters();
        this.encodedValue = this.parameters['encea'];
        this.brandParameter = this.parameters['brand'];
        if (!(this.brandParameter == '' || this.brandParameter == undefined || this.brandParameter == null)) {
            sessionStorage.setItem('domainBrand', this.brandParameter);
        }
        if (!(this.encodedValue == '' || this.encodedValue == undefined || this.encodedValue == null)) {
            this.hasEnceaUrlParameters = true;
            if (this.encodedValue.includes(':honda')) {
                this.encodedValue = this.encodedValue.replace(':honda', '');
                sessionStorage.setItem('domainBrand', 'honda');
            } else if (this.encodedValue.includes(':acura')) {
                this.encodedValue = this.encodedValue.replace(':acura', '');
                sessionStorage.setItem('domainBrand', 'acura')
            }
            this.decryptParams(this.encodedValue);
            let url = window.location.href;
            let refURL = document.referrer;
            if (refURL !== undefined || refURL !== '' || refURL !== null) {
                if (refURL.includes('.honda')) {
                    this.isHondaURL = true
                    this.finalURL = this.hondaLoginUrl + 'login/?app=' + this.hodaAppId;
                } else if (refURL.includes('.acura')) {
                    this.isAcuraURL = true;
                    this.finalURL = this.acuraLoginUrl + 'login/?app=' + this.acuraAppId;
                } else {
                    this.isHondaURL = false;
                    this.isAcuraURL = false;
                }
            }
            if (url !== undefined || url !== '') {
                if (url.includes('.honda')) {
                    this.finalURL = this.hondaLoginUrl + 'login/?app=' + this.hodaAppId;
                    this.isHondaURL = true
                } else if (url.includes('.acura')) {
                    this.isAcuraURL = true;
                    this.finalURL = this.acuraLoginUrl + 'login/?app=' + this.acuraAppId;
                } else {
                    this.isHondaURL = false;
                    this.isAcuraURL = false;
                }
            } else {
                console.log('error Url')
            }
        }
    }

    getQueryParameters() {

        var params = {};
        var search = location.search.substring(1);

        if (search) {
            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
                return key === "" ? value : decodeURIComponent(value)
            });
        }

        return params;
    }
    @ track isDisabled =  false;
    decryptParams(encryptedValue) {
        SFDecrypt({
            value: encryptedValue
        }).then((result) => {
            this.enceaDecrypted = result;
           /* this.financeAccNumber = result.substring(0, result.indexOf(":"));
            this.currentEmailAdd = result.substring(result.indexOf(":") + 1, result.length);
            if (!(this.financeAccNumber == undefined || this.financeAccNumber == '')) {
                this.accountNumber = this.financeAccNumber;
            }*/
            
            this.financeAccNumber = result.substring(result.indexOf(":")+1 , result.length);           
            if (!(this.financeAccNumber == undefined || this.financeAccNumber == '')) {
                this.accountNumber = this.financeAccNumber;
                this.isDisabled = true;
                if(this.accountNumber.length >9){
                    this.accountNumber =  this.accountNumber.slice(-9);
                    this.isRegistrationFlow = true; // Bug 22322
                }
            }
           
        }).catch((error) => {
            console.log('error', error);
            this.finAcctExists = false;
        })
    }
    /****Caim Ends */


}