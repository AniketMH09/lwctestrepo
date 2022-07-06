/*
@description The component aHFC_communicationPreferenc is used to display all statements
@ author vishnu
@copyright L&T
@version 1.000
*/
import { LightningElement, track, wire } from 'lwc';
import { loadStyle } from "lightning/platformResourceLoader";
import { getConstants } from "c/ahfcConstantUtil";
import { CurrentPageReference, NavigationMixin } from "lightning/navigation";
import AHFC_Header_AccountNumber from "@salesforce/label/c.AHFC_Header_AccountNumber";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import AHFC_CommunicationPreferenceHeading from "@salesforce/label/c.AHFC_CommunicationPreferenceHeading";
import AHFC_CommunicationPreferenceSectionNote2 from "@salesforce/label/c.AHFC_CommunicationPreferenceSectionNote2";
import AHFC_CommunicationPreferenceSectionNote1 from "@salesforce/label/c.AHFC_CommunicationPreferenceSectionNote1";
import AHFC_CommunicationPreferenceunSubscribeWarningMessage2 from "@salesforce/label/c.AHFC_CommunicationPreferenceunSubscribeWarningMessage2";
import AHFC_CommunicationPreferenceunSubscribeWarningMessage1 from "@salesforce/label/c.AHFC_CommunicationPreferenceunSubscribeWarningMessage1";
import commPrefDetail from "@salesforce/apex/AHFC_CommunicationPreference.commPrefDetail";
import saveCommPref from "@salesforce/apex/AHFC_CommunicationPreference.saveCommPref";
import allTnC from "@salesforce/resourceUrl/AHFC_Terms_and_Conditions_pdf";
import { fireEvent } from 'c/pubsub'; // Added by Kanagaraj for US_8878
import { fireAdobeEvent } from "c/aHFC_adobeServices";


import { registerListener, unregisterAllListeners } from 'c/pubsub';


const CONSTANTS = getConstants();
export default class AHFC_communicationPreferenc extends NavigationMixin(LightningElement) {
    @track eSignTnCUrl = allTnC + "/ESIGN_Disclosure_and_Consent.pdf";
    @track emailEnrolled;
    @track textEnrolled;
    @track showPopUp = false;
    @track servAccName;
    @track dueReminderPickerDisabled = false;
    @track dueRemindervalue = '';
    @track telphoneValue;
    @track pageLoading;
    @track isSmsBounced = false;
    @track isEmailBounced = false;
    @track isSmsAndEmailBounced = false;
    @track unsubscribeAccept = false;
    errorMail = false;
    errorText = false;
    currentPageReference = null;
    pageRef;
    financeDetails;
    communicationDataChanged;
    showEmailMessage;
    showTextMessage;
    showTextEmailMessage;
    showToast = false;
    @track toastLabel;
    @track toastType;
    @track toastLabelUnsbscribe;
    @track toastTypeUnsbscribe;
    @track toastMessageUnsbscribe = '';

    unsubscribeShowToast = false;
    emailEnrolledChange = false;
    textEnrolledChange = false;
    unSubscribeToastLabel = 'Success';
    isPageLoaded;
    sacRecordId = '';
    communicationPrefData;
    finData;
    fieldsDisabled;
    communicationPrefDataUpdated;
    valueChanged = false;

    label = {
        AHFC_Header_AccountNumber,
        AHFC_CommunicationPreferenceHeading,
        AHFC_CommunicationPreferenceSectionNote2,
        AHFC_CommunicationPreferenceSectionNote1,
        AHFC_CommunicationPreferenceunSubscribeWarningMessage2,
        AHFC_CommunicationPreferenceunSubscribeWarningMessage1
    };

    get dueReminderDateValues() {
        return [{ label: '1', value: '1' }, { label: '2', value: '2' }, { label: '3', value: '3' }, { label: '4', value: '4' }, { label: '5', value: '5' }, { label: '6', value: '6' }, { label: '7', value: '7' }, { label: '8', value: '8' }, { label: '9', value: '9' }, { label: '10', value: '10' }]
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.pageRef = currentPageReference;
    }

    /*
    @description clears value after navigation during vehicle switcher
    @ author vishnu
    */
    clearValues() {

        this.valueChanged = false;
        this.finData = {}
        this.dueReminderPickerDisabled = false
        this.communicationPrefData = {};
        this.communicationPrefDataOld = {};
        this.textEnrolled = false;
        this.emailEnrolled = false;
        this.communicationPrefDataUpdated = {};
        this.financeDetails = {};
        this.dueRemindervalue = '';
        this.showToast = false;
        this.isSmsBounced = false;
        this.isEmailBounced = false;
        this.isSmsAndEmailBounced = false;
        this.fieldsDisabled = false;
        if (this.template.querySelector('c-a-h-f-c_page-title') != null) {
            this.template.querySelector('c-a-h-f-c_page-title').clearVariables();
        }

    }

    /*
    @description get communicationPreferance details
    @ author vishnu
    */
    renderedCallback() {
        let firstClass = this.template.querySelector(".main-content");
        fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
    }
    @track isClosed = true;
    getCommPrefDetail() {
        this.unsubscribeShowToast = false;

        commPrefDetail({
            finid: this.sacRecordId
        }).then(result => {
            this.finData = JSON.parse(JSON.stringify(result)).financeDetails;
            console.log('Disabled Feilds', JSON.parse(JSON.stringify(result)));
            console.log('Disabled financeDetails ', JSON.parse(JSON.stringify(result)).financeDetails);

            /*US 3825 */
            if (this.finData.AHFC_Web_Manage_Comm_Pref__c == 'NE') {
                this.dueReminderPickerDisabled = true;
                this.fieldsDisabled = true;
                this.isClosed = false;
            }
            this.communicationPrefData = JSON.parse(JSON.stringify(result)).commPrefDetails;
            this.communicationPrefDataOld = JSON.parse(JSON.stringify(result)).commPrefDetails;
            console.log('communicationPrefData', this.communicationPrefData);
            /*US 3827 by Vishnu*/
            if (this.communicationPrefData.Is_SMS_Bounced_Back__c && this.communicationPrefData.IsEmailBounced__c) {
                this.isSmsAndEmailBounced = true;
            } else if (this.communicationPrefData.Is_SMS_Bounced_Back__c) {
                this.isSmsBounced = true;
            } else if (this.communicationPrefData.IsEmailBounced__c) {
                this.isEmailBounced = true;
            }
            /*US 3827 by Vishnu Ends*/
            this.textEnrolled = false;
            this.emailEnrolled = false;
            if (this.communicationPrefData.Account_Status_Updates_via_Email__c || this.communicationPrefData.Marketing_Communications_Via_Email__c ||
                this.communicationPrefData.Paperless_Statements_Letters__c || this.communicationPrefData.EasyPay_Communications_via_Email__c ||
                this.communicationPrefData.Payment_Confirmations_via_Email__c || this.communicationPrefData.Payment_Reminders_via_Email__c) {
                this.emailEnrolled = true;
            }
            if (this.communicationPrefData.Account_Status_Updates_via_Text__c ||
                this.communicationPrefData.EasyPay_Communications_via_Text__c || this.communicationPrefData.Payment_Confirmations_via_Text__c ||
                this.communicationPrefData.Payment_Reminders_via_Text__c) {
                this.textEnrolled = true;
            }
            this.financeDetails = JSON.parse(JSON.stringify(result)).financeDetails;
            this.communicationPrefDataUpdated = this.communicationPrefData;
            this.telphoneValue = this.fetchActualTelVal(this.communicationPrefData.Text_Number__c);
            this.checkPaymentReminderValue();
            this.checkEmailTextEnrolled();
            let emailSection = this.template.querySelector('.email');
            let telSection = this.template.querySelector('.telNum');
            if (emailSection != null) {
                emailSection.setCustomValidity('');
                emailSection.reportValidity();
            }
            if (telSection != null) {
                telSection.setCustomValidity('');
                telSection.reportValidity();
            }
            if (this.fieldsDisabled) {
                this.dueReminderPickerDisabled = true;

            }
            this.closePageLoader();
        }).catch((error) => {
            console.log('No Communication Pref found', error);
            this.closePageLoader();
            // if(error.body.message == 'invalid access'){
            //     this[NavigationMixin.Navigate]({
            //         type: "comm__namedPage",
            //         attributes: {
            //             pageName: "dashboard"
            //         }
            //     });
            // }
            
        });
    }

    /*
    @description setting PaymentReminderValue by default
    @ author vishnu
    */
    checkPaymentReminderValue() {

        if ((this.communicationPrefData.Payment_Reminders_via_Email__c || this.communicationPrefData.Payment_Reminders_via_Text__c) && (typeof this.communicationPrefData.Days_Prior_Reminder__c == CONSTANTS.UNDEFINED)) {
            this.dueRemindervalue = '3';
            this.dueReminderPickerDisabled = false;
        } else if (!(this.communicationPrefData.Payment_Reminders_via_Email__c || this.communicationPrefData.Payment_Reminders_via_Text__c)) {
            this.dueReminderPickerDisabled = true;
            this.dueRemindervalue = '';
        } else {
            this.dueRemindervalue = this.communicationPrefData.Days_Prior_Reminder__c;
            this.dueReminderPickerDisabled = false;
        }
    }

    /*
    @description loads Ui theme and vehicle switche eventlistner
    @ author vishnu
    */
    connectedCallback() {
        let adobedata = {
            "Page.page_name": "Communication Prefernce",
            "Page.site_section": "Communication Prefernce",
            "Page.referrer_url": document.referrer
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        loadStyle(this, ahfctheme + "/theme.css").then(() => {});
        this.handleValidate;
        try {
            registerListener('AHFC_Account_Selected', this.getDataFromPubsubEvent, this);
        } catch (error) {
            console.log('157', error);
        }
    }

    /*
     @description unregisterAllListeners
     @ author vishnu
     */
    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    /*
     @description get values from vehicle switcher
     @ author vishnu
     */
    getDataFromPubsubEvent(data) {
        this.clearValues();
        this.sacRecordId = JSON.parse(data).serAccRec.Id;
        this.isPageLoaded = true;
        this.isClosed = true;
        this.getCommPrefDetail();
    }

    /*
     @description loads the pageloader
     @ author vishnu
     */
    openPageLoader() {
        this.template
            .querySelector("c-a-h-f-c_vehicleswitcher")
            .openLoader();
    }

    /*
     @description closes the pageloader
     @ author vishnu
     */
    closePageLoader() {
            this.template
                .querySelector("c-a-h-f-c_vehicleswitcher")
                .closeLoader();
        }
        /*
         @description onchange Sets the values for saving
         @ author vishnu
         */
    onChangeValues(event) {
      //  this.valueChanged = true;
        this.showToast = false;
        this.communicationDataChanged = false;
        let reminderValueSet = false;
        this.unsubscribeShowToast = false;
        this.template.querySelector('c-a-h-f-c_page-title').setValueOnChange();
        if (event.currentTarget.name == 'Email_Address__c') {
            this.communicationPrefDataUpdated.Email_Address__c = event.detail.value;
            this.checkEmailValid(event);
        } else if (event.currentTarget.name == 'Text_Number__c') {
            let telVal = this.clearTelVal(event.detail.value);
            this.communicationPrefDataUpdated.Text_Number__c = telVal;
            this.checkTelValid(event);
        } else if (event.currentTarget.name == 'Account_Status_Updates_via_Email__c') {
            this.communicationPrefDataUpdated.Unsubscribe_from_all__c = false;
            this.communicationPrefDataUpdated.Account_Status_Updates_via_Email__c = event.target.checked;
        } else if (event.currentTarget.name == 'Account_Status_Updates_via_Text__c') {
            this.communicationPrefDataUpdated.Unsubscribe_from_all__c = false;
            this.communicationPrefDataUpdated.Account_Status_Updates_via_Text__c = event.target.checked;
        } else if (event.currentTarget.name == 'Marketing_Communications_Via_Email__c') {
            this.communicationPrefDataUpdated.Unsubscribe_from_all__c = false;
            this.communicationPrefDataUpdated.Marketing_Communications_Via_Email__c = event.target.checked;
        } else if (event.currentTarget.name == 'Paperless_Statements_Letters__c') {
            this.communicationPrefDataUpdated.Unsubscribe_from_all__c = false;
            this.communicationPrefDataUpdated.Paperless_Statements_Letters__c = event.target.checked;
        } else if (event.currentTarget.name == 'EasyPay_Communications_via_Text__c') {
            this.communicationPrefDataUpdated.Unsubscribe_from_all__c = false;
            this.communicationPrefDataUpdated.EasyPay_Communications_via_Text__c = event.target.checked;
        } else if (event.currentTarget.name == 'EasyPay_Communications_via_Email__c') {
            this.communicationPrefDataUpdated.Unsubscribe_from_all__c = false;
            this.communicationPrefDataUpdated.EasyPay_Communications_via_Email__c = event.target.checked;
        } else if (event.currentTarget.name == 'Payment_Confirmations_via_Text__c') {
            this.communicationPrefDataUpdated.Unsubscribe_from_all__c = false;
            this.communicationPrefDataUpdated.Payment_Confirmations_via_Text__c = event.target.checked;
        } else if (event.currentTarget.name == 'Payment_Confirmations_via_Email__c') {
            this.communicationPrefDataUpdated.Unsubscribe_from_all__c = false;
            this.communicationPrefDataUpdated.Payment_Confirmations_via_Email__c = event.target.checked;
        } else if (event.currentTarget.name == 'Payment_Reminders_via_Email__c') {
            this.communicationPrefDataUpdated.Unsubscribe_from_all__c = false;
            reminderValueSet = true;
            this.dueReminderPickerDisabled = true;
            this.communicationPrefDataUpdated.Payment_Reminders_via_Email__c = event.target.checked;
            if (event.target.checked || this.communicationPrefDataUpdated.Payment_Reminders_via_Text__c) {
                this.dueReminderPickerDisabled = false;
            }
        } else if (event.currentTarget.name == 'Payment_Reminders_via_Text__c') {
            this.communicationPrefDataUpdated.Unsubscribe_from_all__c = false;
            reminderValueSet = true;
            this.dueReminderPickerDisabled = true;
            this.communicationPrefDataUpdated.Payment_Reminders_via_Text__c = event.target.checked;

            if (event.target.checked || this.communicationPrefDataUpdated.Payment_Reminders_via_Email__c) {
                this.dueReminderPickerDisabled = false;

            }
        } else if (event.currentTarget.name == 'dueReminderPicker') {
            this.dueRemindervalue = event.detail.value;
            console.log('this.dueRemindervalue', this.dueRemindervalue);
        }

        if (reminderValueSet && this.dueReminderPickerDisabled) {
            this.dueRemindervalue = '';
        } else if (reminderValueSet && !this.dueReminderPickerDisabled) {
            if (typeof this.communicationPrefData.Days_Prior_Reminder__c != CONSTANTS.UNDEFINED) {
                this.dueRemindervalue = this.communicationPrefData.Days_Prior_Reminder__c;
            } else {
                this.dueRemindervalue = '3';
            }
        }
        if (this.communicationPrefData != this.communicationPrefDataUpdated) {
            this.communicationDataChanged = true;
        }

        this.checkEmailTextEnrolled();
    }

    checkEmailTextEnrolled() {
        this.emailEnrolledChange = false;
        this.textEnrolledChange = false;
        if (this.communicationPrefDataUpdated.Account_Status_Updates_via_Email__c || this.communicationPrefDataUpdated.Marketing_Communications_Via_Email__c ||
            this.communicationPrefDataUpdated.Paperless_Statements_Letters__c || this.communicationPrefDataUpdated.EasyPay_Communications_via_Email__c ||
            this.communicationPrefDataUpdated.Payment_Confirmations_via_Email__c || this.communicationPrefDataUpdated.Payment_Reminders_via_Email__c) {
            this.emailEnrolledChange = true;
        }
        if (this.communicationPrefDataUpdated.Account_Status_Updates_via_Text__c ||
            this.communicationPrefDataUpdated.EasyPay_Communications_via_Text__c || this.communicationPrefDataUpdated.Payment_Confirmations_via_Text__c ||
            this.communicationPrefDataUpdated.Payment_Reminders_via_Text__c) {
            this.textEnrolledChange = true;
        }
    }

    /*
     @description while clicking unsubscribe all check boxes are unchecked
     @ author vishnu
     */
    unSubscribe() {

        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Communication Preferences",
            "Event_Metadata.action_category": "Comm Prefs:Button:Unsubscribe",
            "Page.page_name": "Communication Preferences"
        };
        fireAdobeEvent(adobedata, 'click-event');

        this.unsubscribeShowToast = false;
        this.showPopUp = false;
        this.showEmailMessage = false;
        this.showTextMessage = false;
        this.showTextEmailMessage = false;


        if (!(typeof this.communicationPrefData.Email_Address__c == CONSTANTS.UNDEFINED || this.communicationPrefData.Email_Address__c == '') && this.emailEnrolled) {

            this.showEmailMessage = true;
        }

        if (!(typeof this.communicationPrefData.Text_Number__c == CONSTANTS.UNDEFINED || this.communicationPrefData.Text_Number__c == '') && this.textEnrolled) {

            this.showTextMessage = true;
        }
        if (this.showTextMessage && this.showEmailMessage) {
            this.showTextEmailMessage = true;
            this.showPopUp = true;

            this.unSubscribeWarningMessage = this.label.AHFC_CommunicationPreferenceunSubscribeWarningMessage1 + ' ' + this.finData.AHFC_Product_Nickname__c + ' at ' + this.communicationPrefData.Email_Address__c + ' and ' + this.telphoneValue + ' ' + this.label.AHFC_CommunicationPreferenceunSubscribeWarningMessage2;

        } else if (this.showTextMessage) {
            this.showPopUp = true;
            this.unSubscribeWarningMessage = this.label.AHFC_CommunicationPreferenceunSubscribeWarningMessage1 + ' ' + this.finData.AHFC_Product_Nickname__c + ' at ' + this.telphoneValue + ' ' + this.label.AHFC_CommunicationPreferenceunSubscribeWarningMessage2;

        } else if (this.showEmailMessage) {
            this.showPopUp = true;
            this.unSubscribeWarningMessage = this.label.AHFC_CommunicationPreferenceunSubscribeWarningMessage1 + ' ' + this.finData.AHFC_Product_Nickname__c + ' at ' + this.communicationPrefData.Email_Address__c + ' ' + this.label.AHFC_CommunicationPreferenceunSubscribeWarningMessage2;
        }
        if (!this.showPopUp) {
            this.acceptContinue();
        }
    }

    /*
    @description validating email
    @ author vishnu
    */
    checkEmailValid(event) {
        this.errorMail = false;
        const emailRegex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        let email = event.currentTarget;
        let emailVal = event.detail.value;
        console.log(emailVal);
        if (emailVal.match(emailRegex) || emailVal == '') {
            email.setCustomValidity("");

        } else {
            email.setCustomValidity("Error: Use format email@domain.com");
            this.errorMail = true;
        }
        email.reportValidity();
    }

    /*
     @description validating phone number
     @ author vishnu
     */
    checkTelValid(event) {
        this.errorText = false;
        const telRegex = /^[0-9]+$/;
        let tel = event.currentTarget;
        let telVal = this.clearTelVal(event.detail.value);
        if ((telRegex.test(telVal) && telVal.length == 10) || telVal.length == 0) {   //Bug Fix 20909 - vishnu
            tel.setCustomValidity("");
        } else {
            this.errorText = true;
            tel.setCustomValidity("Error: Enter a 10-digit Mobile Number");
        }
        tel.reportValidity();
        event.target.value = this.fetchActualTelVal(event.target.value);
    }

    /*
     @description Formatting phone number
     @ author vishnu
     */
    fetchActualTelVal(telValue) {
        if (telValue != undefined) {
            const x = telValue
                .replace(/\D+/g, '')
                .match(/(\d{0,3})(\d{0,3})(\d{0,4})/);
            telValue = !x[2] ? x[1] : `(${x[1]}) ${x[2]}` + (x[3] ? `-${x[3]}` : ``);
        }
        return telValue;
    }

    /*
     @description clear Formatting phone number on save
     @ author vishnu
     */
    clearTelVal(telValue) {
        if (telValue != undefined) {
            telValue = telValue.replaceAll(' ', '');
            telValue = telValue.replaceAll(')', '');
            telValue = telValue.replaceAll('(', '');
            telValue = telValue.replaceAll('-', '');
        }
        return telValue;
    }


    /*
     @description saves the record on save
     @ author vishnu
     */
    SaveData() {

        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Communication Preferences",
            "Event_Metadata.action_category": "Comm Prefs:Button:Save",
            "Page.page_name": "Communication Preferences"
        };
        fireAdobeEvent(adobedata, 'click-event');
        this.openPageLoader();
        const topDiv = this.template.querySelector('[data-id="redDiv"]');
        const emailSection = this.template.querySelector('.email');
        const telSection = this.template.querySelector('.telNum');
        if (!this.unsubscribeAccept) {
            topDiv.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
        }
        if (this.emailEnrolledChange && (typeof this.communicationPrefDataUpdated.Email_Address__c == CONSTANTS.UNDEFINED || this.communicationPrefDataUpdated.Email_Address__c == '')) {
            emailSection.setCustomValidity("Error: Enter an Email Address");
            emailSection.reportValidity();
        }

        if (!this.emailEnrolledChange && (typeof this.communicationPrefDataUpdated.Email_Address__c == CONSTANTS.UNDEFINED || this.communicationPrefDataUpdated.Email_Address__c == '')) {
            emailSection.setCustomValidity("");
            emailSection.reportValidity();
        }

        if (this.textEnrolledChange && (typeof this.communicationPrefDataUpdated.Text_Number__c == CONSTANTS.UNDEFINED || this.communicationPrefDataUpdated.Text_Number__c == '')) {
            telSection.setCustomValidity("Error: Enter a Mobile Number");
            telSection.reportValidity();
        }

        if (!this.textEnrolledChange && (typeof this.communicationPrefDataUpdated.Text_Number__c == CONSTANTS.UNDEFINED || this.communicationPrefDataUpdated.Text_Number__c == '')) {
            telSection.setCustomValidity("");
            telSection.reportValidity();
        }

        const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                return validSoFar && inputCmp.checkValidity();
            }, true);

        if (!allValid) {
            this.closePageLoader();
            return;
        }


        this.communicationPrefDataUpdated.Days_Prior_Reminder__c = this.dueRemindervalue;
        this.unsubscribeShowToast = false;
        this.showToast = false;
        console.log(JSON.stringify(this.communicationPrefDataUpdated), JSON.stringify(this.communicationPrefDataOld));
        console.log('FinAcc', JSON.stringify(this.finData.Finance_Account_Number__c));

        saveCommPref({
            recDetails: JSON.stringify(this.communicationPrefDataUpdated),
            finNumber: this.finData.Finance_Account_Number__c,
            oldRecDetails: JSON.stringify(this.communicationPrefDataOld)
        }).then(result => {
            console.log('result.errorMessage', result.errorMessage);
            console.log('result.errorMessage', result);
            if (result.errorMessage == 'Success') {
                this.template.querySelector('c-a-h-f-c_page-title').clearVariables();
                this.emailEnrolled = false;
                this.textEnrolled = false;
                this.communicationPrefData = result.commPrefDetails;
                this.telphoneValue = this.fetchActualTelVal(this.communicationPrefData.Text_Number__c);
                if (this.communicationPrefData.Account_Status_Updates_via_Email__c || this.communicationPrefData.Marketing_Communications_Via_Email__c ||
                    this.communicationPrefData.Paperless_Statements_Letters__c || this.communicationPrefData.EasyPay_Communications_via_Email__c ||
                    this.communicationPrefData.Payment_Confirmations_via_Email__c || this.communicationPrefData.Payment_Reminders_via_Email__c) {
                    this.emailEnrolled = true;
                }
                if (this.communicationPrefData.Account_Status_Updates_via_Text__c ||
                    this.communicationPrefData.EasyPay_Communications_via_Text__c || this.communicationPrefData.Payment_Confirmations_via_Text__c ||
                    this.communicationPrefData.Payment_Reminders_via_Text__c) {
                    this.textEnrolled = true;
                }
                if (!this.unsubscribeAccept) {
                    this.toastLabel = 'Success';
                    this.toastType = 'success';
                    this.toastMessage = 'Your Communication Preferences have been successfully saved.'; //
                    this.showToast = true;
                    this.closePageLoader();
                } else {
                    this.unsubscribeShowToast = true;
                    this.toastLabelUnsbscribe = 'Success';
                    this.toastTypeUnsbscribe = 'success';
                    this.toastMessageUnsbscribe = 'You have unsubscribed from communications for your ' + this.finData.AHFC_Product_Nickname__c;
                    this.unsubscribeAccept = false;
                    this.closePageLoader();
                }
            } else {
                if (!this.unsubscribeAccept) {
                    /*Us 13853  starts*/
                    this.toastLabel = 'Error';
                    this.toastType = 'error';
                    this.toastMessage = 'There was an error updating your preferences. Please refresh the page or try again later.';
                    this.showToast = true;
                    this.closePageLoader();
                } else {
                    this.unsubscribeShowToast = true;
                    this.toastLabelUnsbscribe = 'Error';
                    this.toastTypeUnsbscribe = 'error';
                    this.toastMessageUnsbscribe = 'There was an error in unsubscribing from communications for your ' + this.finData.AHFC_Product_Nickname__c + '. Please refresh the page or try again later.';
                    this.unsubscribeAccept = false;
                    this.closePageLoader();
                }
            }

        }).catch((error) => {
            /*Us 13853  */
            if (!this.unsubscribeAccept) {
                console.log('Errorrrr', error);
                this.toastLabel = 'Error';
                this.toastType = 'error';
                this.toastMessage = 'There was an error updating your preferences. Please refresh the page or try again later.';
                this.showToast = true;
                this.closePageLoader();
            } else {
                this.unsubscribeShowToast = true;
                this.toastLabelUnsbscribe = 'Error';
                this.toastTypeUnsbscribe = 'error';
                this.toastMessageUnsbscribe = 'There was an error in unsubscribing from communications for your ' + this.finData.AHFC_Product_Nickname__c + '. Please refresh the page or try again later.';
                this.unsubscribeAccept = false;
                this.closePageLoader();
            }
        });

    }

    /*
    @description closing toast messages
    @ author vishnu
    */
    closeToast() {
        this.showToast = false;
    }

    /*
     @description cancling the popup message
     @ author vishnu
     */
    onCancel() {
        this.showPopUp = false;
    }

    /*
     @description unchecking all check boxes
     @ author vishnu
     */

    acceptContinue() {
        this.textEnrolled = false;
        this.emailEnrolled = false;
        //       this.unsubscribeShowToast = true;
        this.unsubscribeAccept = true;
        //   this.toastLabel = 'Error';
        //   this.toastType = 'error';
        //   this.toastLabel = 'Success';
        //   this.toastType = 'success';

        try {
            this.communicationPrefDataUpdated.Email_Address__c = this.communicationPrefData.Email_Address__c;
            this.communicationPrefDataUpdated.Text_Number__c = this.communicationPrefData.Text_Number__c;
            this.communicationPrefDataUpdated.Unsubscribe_from_all__c = true;
            this.communicationPrefDataUpdated.Account_Status_Updates_via_Email__c = false;
            this.communicationPrefDataUpdated.Account_Status_Updates_via_Text__c = false;
            this.communicationPrefDataUpdated.Marketing_Communications_Via_Email__c = false;
            this.communicationPrefDataUpdated.Paperless_Statements_Letters__c = false;
            this.communicationPrefDataUpdated.EasyPay_Communications_via_Text__c = false;
            this.communicationPrefDataUpdated.EasyPay_Communications_via_Email__c = false;
            this.communicationPrefDataUpdated.Payment_Confirmations_via_Text__c = false;
            this.communicationPrefDataUpdated.Payment_Confirmations_via_Email__c = false;
            this.communicationPrefDataUpdated.Payment_Reminders_via_Email__c = false;
            this.communicationPrefDataUpdated.Payment_Reminders_via_Text__c = false;
            let selected = this.template.querySelectorAll('.combox_selector');
            for (var i = 0; i < selected.length; i++) {
                selected[i].checked = false;
                this.dueReminderPickerDisabled = true;
                this.dueRemindervalue = '';
            }
            this.SaveData();
        } catch (e) {
            console.log(e);
        }
        this.showPopUp = false;
    }
    closeToastUnsubscribe() {
        this.unsubscribeShowToast = false;
    }
    navigatetoContactUS() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-post-login'
            }
        });
    }

}