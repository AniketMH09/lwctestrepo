/** Controller Name:      AHFC_addFinanceAccountVinZipTab
 *  Description:          Add Finance account page logic when customer wants to add finance account to the person account.
 *  Developer Name:       Akash Solanki
 *  Created Date:         10-May-2021 
 *  Modified By :         Akash Solanki
 *  Modification Logs:    Updated for US 10316 for Google Re-captcha on 18-Aug-2021
 */
import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import warningSvg from "@salesforce/resourceUrl/AHFC_warning";
import infoSvg from "@salesforce/resourceUrl/AHFC_info";
import AHFC_Privacy_Policy_Esign from "@salesforce/resourceUrl/ESIGN_Disclosure_and_Consent";
import { fireAdobeEvent } from "c/aHFC_adobeServices";

import AHFC_Required_Fields_Error from "@salesforce/label/c.AHFC_Required_Fields_Error";
import AHFC_RegistrationError from "@salesforce/label/c.AHFC_RegistrationError";
import AHFC_ServiceAccExistsError from "@salesforce/label/c.AHFC_ServiceAccExistsError";
import AHFC_AccountNotFound from "@salesforce/label/c.AHFC_Account_Not_Found";
import AHFC_AccountNoMatchCriteria from "@salesforce/label/c.AHFC_Account_No_Match_Criteria";
import AHFC_Exception_Message from "@salesforce/label/c.AHFC_Exception_Message";

import createCustomerFinanceAccount from "@salesforce/apex/AHFC_AddFinanceAccountController.createCustomerFinanceAccount";
import getFinanceAccountExists from "@salesforce/apex/AHFC_AddFinanceAccountController.getFinanceAccountExists"
import updateCommPrefsVinTab from "@salesforce/apex/AHFC_AddFinanceAccountController.updateCommPrefsVinTab"

import { NavigationMixin } from "lightning/navigation";
import { getConstants } from "c/ahfcConstantUtil";
import AHFC_HFS_Site_URL from "@salesforce/label/c.AHFC_HFS_Site_URL";
import AHFC_AddAccount_WebOnlineError2 from "@salesforce/label/c.AHFC_AddAccount_WebOnlineError_Part2"; //Added by Aswin Jose for regression bug fix


//Added By Aswin - US 7522
import AHFC_AddAccount_DatabaseError from "@salesforce/label/c.AHFC_AddAccount_DatabaseError";
import AHFC_AddAccount_PageError from "@salesforce/label/c.AHFC_AddAccount_PageError";
import AHFC_AddAccount_WebOnlineN from "@salesforce/label/c.AHFC_AddAccount_WebOnlineN";
import AHFC_AddAccount_WebOnlineError from "@salesforce/label/c.AHFC_AddAccount_WebOnlineError";

//Added by Supriya on 18/10/2021 - new requirement during UAT testing(use of captcha configurable)
import AHFC_Is_Captcha_Required from "@salesforce/label/c.AHFC_Is_Captcha_Required";

//assign the values returned from the getConstants method from util class
const CONSTANTS = getConstants();

export default class AHFC_addFinanceAccountVinZipTab extends NavigationMixin(
  LightningElement
) {
  @track isLoaded = false;
  @track vinNumber = "";
  @track zipCode = "";
  @track last4Digits = "";
  @api useremail;
  @track billing = true;
  @track payment = true;
  @track specialOffersCheck = true;   //US 4965 by Akash 
  @track showPopover = false;
  @track addAccountError = false;
  @track addAccountErrorMsg = "";
  @api boolguestprofile = false;
  @api strfedid = '';
  @api email = '';
  @track isValid = false;
  @track isValidSSN = false;
  @track isValidZIP = false;
  @track addAccountPageError = false;
  @track addAccountPageErrorMsg = "";
  @track addAccountPageErrorMsg2 = "";

  @track errorMessageValidationSSN = '';
  @track errorMessageValidationZIP = '';
  @track errorMessageValidationVIN = '';
  @track isAlphaSpecial = false;
  @track isSpecialChars = false;
  @track finAccExists = false;
  @track WebOnlineError = false;
  @track iframeShow = true;
  @track showButton = false;
  @track msgData = '';
  @api checkedBilling = 'true'; //US 4965 - Akash Solanki
  @api checkedPayment = 'true'; //US 4965 - Akash Solanki
  @api checkedSpecialOffers = 'true'; //US 4965 - Akash Solanki
  @track eSignTnCUrl = AHFC_Privacy_Policy_Esign;
  @track commprefUpdateMsg = '';
  @track isCommPrefUpdated = true;

  serviceAccountCustomer;
  error;
  warningSvg = warningSvg;
  infoSvg = infoSvg;

  //US 4965 - Akash Solanki
  handleChangeSpecialOffers(e) {
    if (e.detail.checked) {
      this.checkedSpecialOffers = 'true';
      this.passCommPrefValues(this.checkedSpecialOffers, 'SpecialOffers');
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
      this.passCommPrefValues(this.checkedPayment, 'Payment');
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
    if (e.detail.checked) {
      this.checkedBilling = 'true';
      this.passCommPrefValues(this.checkedBilling, 'Billing');
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

  passCommPrefValues(isChecked, changedCommprefValue) {
    const selectedEvent = new CustomEvent('setvalues', { detail: { checked: isChecked, commprefValueChanged: changedCommprefValue } });
    this.dispatchEvent(selectedEvent);
  }
  /*Bug Fix 21492 Ends*/

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
    this._listenForMessage = this.listenForMessage.bind(this); //US 10316 for Google Re-captcha
    window.addEventListener("message", this._listenForMessage); //US 10316 for Google Re-captcha
    this.getFinanceAccountExistsfn();
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
          (sessionStorage.getItem('addProductFromBlankDashboard') == null || sessionStorage.getItem('addProductFromBlankDashboard') == 'false')) {
          this.navigateToDashboard();
        }
      }
      else {
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

  changeVinNumber(event) {
    this.vinNumber = event.target.value;
  }
  changeLast4Digits(event) {
    this.last4Digits = event.target.value;
  }
  changeZipCode(event) {
    this.zipCode = event.target.value;
  }

  onValidate(event) {
    let targetId = event.target.getAttribute("data-id");
    let target = this.template.querySelector("." + targetId);
    if (targetId == 'ssn-input') // added the check as part ob bug fix 14357
      this.last4Digits = event.target.value;
    if (targetId == 'zipcode-input')
      this.zipCode = event.target.value;
    if (targetId == 'vinnumber-input')
      this.vinNumber = event.target.value;
    if (!event.target.value.length) {
      target.classList.add("slds-has-error");
      if (targetId == 'ssn-input')
        this.errorMessageValidationSSN = 'Error: This field is mandatory';
      if (targetId == 'zipcode-input')
        this.errorMessageValidationZIP = 'Error: This field is mandatory';
      if (targetId == 'vinnumber-input')
        this.errorMessageValidationVIN = 'Error: This field is mandatory';
    } else if (event.target.value.length < 17 && targetId === 'vinnumber-input') {
      target.classList.add("slds-has-error");
      this.errorMessageValidationVIN = 'Error: VIN should be Should be 17 characters.';
    } else if (event.target.value.length < 4 && targetId === 'ssn-input') {
      target.classList.add("slds-has-error");
      this.errorMessageValidationSSN = 'Error: Last 4 of SSN or Tax ID Should be 4 digits.';
    } else if (event.target.value.length < 5 && targetId === 'zipcode-input') {
      target.classList.add("slds-has-error");
      this.errorMessageValidationZIP = 'Error: Current Zip must be in 99999 or 99999-9999 format.';
    }
    else if (event.target.validity.valid == false && targetId == 'vinnumber-input') {
      target.classList.add("slds-has-error");
      this.isValid = false;
    }
    else if (event.target.validity.valid == false && targetId == 'ssn-input') {
      target.classList.add("slds-has-error");
      this.isValidSSN = false;
    }
    else if (event.target.validity.valid == false && targetId == 'zipcode-input') {
      target.classList.add("slds-has-error");
      this.isValidZIP = false;
    }
    else if (targetId == 'vinnumber-input') {
      target.classList.remove("slds-has-error");
      this.isValid = true;
    }
    else if (targetId == 'ssn-input') {
      target.classList.remove("slds-has-error");
      this.isValidSSN = true;
    }
    else if (targetId == 'zipcode-input') {
      target.classList.remove("slds-has-error");
      this.isValidZIP = true;
    }
    else {
      target.classList.remove("slds-has-error");
      this.isValid = true;
    }
  }

  onValidateType(event) {
    this.addAccountError = false
    this.onValidate(event);
  }
  //added by supriya
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
    updateCommPrefsVinTab({
      Vin: this.vinNumber,
      billingCheck: this.checkedBilling,
      paymentCheck: this.checkedPayment,
      offersCheck: this.checkedSpecialOffers,
      customerEmail: this.useremail
    }).then((result) => {
      if (result == 'SUCCESS') {
        this.isCommPrefUpdated = true;
        this.navigateToDashBoardPage();
      } else {
        this.isCommPrefUpdated = false;
        this.commprefUpdateMsg = 'Your email preferences could not be saved at this time. To make changes, go to Communication Preferences under My Account';
        this.showErrorToast();
        setTimeout(() => {
          this.navigateToDashBoardPage();
        }, 3000);
      }
    }).catch((error) => {
      this.isCommPrefUpdated = false;
      this.commprefUpdateMsg = 'Your email preferences could not be saved at this time. To make changes, go to Communication Preferences under My Account';
      console.log('Error-----> ', error);
      this.showErrorToast();
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
  //creates the respective object record
  createAccount() {
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

    if (this.vinNumber !== "" && this.zipCode !== "" &&
      this.last4Digits !== "" &&
      this.vinNumber.length == 17 &&
      this.zipCode.length == 5 && this.last4Digits.length == 4
      && this.isValid == true && this.isValidZIP == true && this.isValidSSN == true) {
      this.isLoaded = true;
      createCustomerFinanceAccount({
        vinNumber: this.vinNumber,
        zipCode: this.zipCode,
        last4Digits: this.last4Digits,
        strFedId: this.strfedid,
        strEmail: this.email

      }).then((result) => {
        this.isLoaded = false;
        this.financeAccountCustomer = result;
        console.log(this.financeAccountCustomer);
        console.log("this.accountNumber " + this.vinNumber);

        if (this.financeAccountCustomer === 'SUCCESS') {
          this.handleCommPrefs();   // US 4965 by Akash Solanki
        } else if (this.financeAccountCustomer === AHFC_ServiceAccExistsError) {
          this.addAccountPageError = false;
          this.WebOnlineError = false;
          this.addAccountError = true;
          this.addAccountErrorMsg = AHFC_ServiceAccExistsError;
        }
        else if (this.financeAccountCustomer === AHFC_AccountNotFound) {
          this.addAccountPageError = false;
          this.WebOnlineError = false;
          this.addAccountError = true;
          this.addAccountErrorMsg = AHFC_AccountNotFound;
        }
        else if (this.financeAccountCustomer === AHFC_AccountNoMatchCriteria) {
          this.addAccountPageError = false;
          this.WebOnlineError = false;
          this.addAccountError = true;
          this.addAccountErrorMsg = AHFC_AccountNoMatchCriteria;
        } else if (this.financeAccountCustomer === AHFC_AddAccount_DatabaseError) {
          this.addAccountError = false;
          this.WebOnlineError = false;
          this.addAccountPageError = true;
          this.addAccountPageErrorMsg = AHFC_AddAccount_PageError;
        } else if (this.financeAccountCustomer === AHFC_AddAccount_WebOnlineN) {
          this.addAccountError = false;
          this.addAccountPageError = true;
          this.addAccountPageErrorMsg = AHFC_AddAccount_WebOnlineError;
          this.addAccountPageErrorMsg2 = AHFC_AddAccount_WebOnlineError2; //Added by Aswin Jose for regression bug fix
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
      console.log('Inside Error!!!!')
    }
  }



  //Added by Aswin Jose US : 7522
  restrictSpecialChars(event) {
    var x = event.which || event.keycode;
    if ((x >= 48 && x <= 57) || (x >= 65 && x <= 90) || (x >= 97 && x <= 122)) {
      return true;
    }
    else {
      event.preventDefault();
      return false;

    }

  }

  //Added by Aswin Jose US : 7522
  restrictAlphabetsAndSpecialChars(event) {
    var x = event.which || event.keycode;

    if ((x >= 48 && x <= 57)) {
      return true;
    }
    else {
      event.preventDefault();
      return false;

    }

  }

  //Added by Aswin Jose for US:7522
  validateAlphaSpecialChars(event) {

    var clipboardData = event.clipboardData || window.clipboardData;
    var pastedData = clipboardData.getData('Text');
    let targetId = event.target.getAttribute("data-id");

    var eventVal = '';
    if (targetId == 'zipcode-input') {
      eventVal = pastedData.substring(0, 5);
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

    if (this.isAlphaSpecial && targetId == 'zipcode-input') {
      this.errorMessageValidationZIP = 'Error: Current Zip must be in 99999 or 99999-9999 format.';
    } else if (this.isAlphaSpecial && targetId == 'ssn-input') {
      this.errorMessageValidationSSN = 'Error: Last 4 of SSN or Tax ID Should be 4 digits.';
    } else {
      this.errorMessageValidationSSN = '';
      this.errorMessageValidationZIP = '';
    }

  }

  validateSpecialChars(event) {
    var pattern = new RegExp("^(?=.*[-+_!@#$%^&*.,?]).+$");

    var clipboardData = event.clipboardData || window.clipboardData;
    var pastedData = clipboardData.getData('Text');
    let targetId = event.target.getAttribute("data-id");

    var eventVal = '';
    if (targetId == 'vinnumber-input') {
      eventVal = pastedData.substring(0, 17);
    }
    console.log('eventVal VIN : ' + eventVal);

    if (pattern.test(eventVal)) {
      this.isSpecialChars = true;
    } else {
      this.isSpecialChars = false;
    }

    if (this.isSpecialChars && targetId == 'vinnumber-input') {
      this.errorMessageValidationVIN = 'Error: VIN should be Should be 17 characters.';
    } else {
      this.errorMessageValidationVIN = '';
    }

  }

  //Added by Aswin Jose for regression bug fix
  onToastLinkClicked() {
    //navigate to scheduled payment page
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        pageName: 'contact-us-post-login'
      }
    });

  }



}