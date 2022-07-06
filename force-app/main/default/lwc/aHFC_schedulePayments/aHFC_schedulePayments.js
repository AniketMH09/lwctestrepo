/*Component Name         :    AHFC_schedulePayments
    * @description       :    This Component is used to display schedule payment page
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Satish                     06/07/2021              Created
    * Edwin                      22/07/2021              Modified US: 3793  Included edit and cancel logic for OTP payment  
    * Edwin                      29/07/2021              Modified US: 3794  Included Payoff/purchase records under OTP section
    * 
*********************************************************************************/
import {
    LightningElement,
    track,
    wire
} from "lwc";
import AHFC_No_Scheduled_Payments_Msg from "@salesforce/label/c.AHFC_No_Scheduled_Payments_Msg";
import AHFC_SchPayments_Label_Information from "@salesforce/label/c.AHFC_SchPayments_Label_Information";
import AHFC_No_Scheduled_Payments from "@salesforce/label/c.AHFC_No_Scheduled_Payments";
import AHFC_Label_EasyPay from "@salesforce/label/c.AHFC_Label_EasyPay";
import AHFC_EZP_Not_Enrolled_Msg from "@salesforce/label/c.AHFC_EZP_Not_Enrolled_Msg";
import AHFC_EZP_Enrolled_Msg from "@salesforce/label/c.AHFC_EZP_Enrolled_Msg";
import AHFC_SchPayments_NextWithdraw from "@salesforce/label/c.AHFC_SchPayments_NextWithdraw";
import AHFC_SchPayments_Suspended from "@salesforce/label/c.AHFC_SchPayments_Suspended";
import AHFC_SchPayments_Scheduled from "@salesforce/label/c.AHFC_SchPayments_Scheduled";
import AHFC_SchPayments_PaymentAmt from "@salesforce/label/c.AHFC_SchPayments_PaymentAmt";
import AHFC_SchPayments_LastWithdraw from "@salesforce/label/c.AHFC_SchPayments_LastWithdraw";
import AHFC_SchPayments_SuspendMsg from "@salesforce/label/c.AHFC_SchPayments_SuspendMsg";
import AHFC_Cancel_EasyPay_Button from "@salesforce/label/c.AHFC_Cancel_EasyPay_Button";
import AHFC_CuttOffDisabledErrorMsg from "@salesforce/label/c.AHFC_CuttOffDisabledErrorMsg";
import AHFC_CutOffTime from "@salesforce/label/c.AHFC_CutOffTime";


import AHFC_SchPayments_OTP from "@salesforce/label/c.AHFC_SchPayments_OTP";
import AHFC_SchPayments_PaymentType from "@salesforce/label/c.AHFC_SchPayments_PaymentType";
import AHFC_SchPayments_ConfirmationNumber from "@salesforce/label/c.AHFC_SchPayments_ConfirmationNumber";
import AHFC_SchPayments_AuthorisedOn from "@salesforce/label/c.AHFC_SchPayments_AuthorisedOn";

import AHFC_SchPayments_CancelPayment from "@salesforce/label/c.AHFC_SchPayments_CancelPayment";
import AHFC_SchPayments_Edit from "@salesforce/label/c.AHFC_SchPayments_Edit";

import {
    getConstants
} from "c/ahfcConstantUtil";
import paymentList from "@salesforce/apex/AHFC_SchedulePaymentController.paymentList";
import paymentDetails from "@salesforce/apex/AHFC_SchedulePaymentController.paymentDetails";
import {
    CurrentPageReference
} from "lightning/navigation";
import {
    NavigationMixin
} from "lightning/navigation";
import {
    registerListener,
    unregisterAllListeners
} from 'c/pubsub';
import System_CL0001 from "@salesforce/label/c.System_CL0001";
const CONSTANTS = getConstants();
export default class AHFC_schedulePayments extends NavigationMixin(LightningElement) {

    noScheduledPayments;
    @track chargentAmountEZP;
    @track labels = {
        AHFC_No_Scheduled_Payments,
        AHFC_No_Scheduled_Payments_Msg,
        AHFC_SchPayments_Label_Information,
        AHFC_EZP_Not_Enrolled_Msg,
        AHFC_EZP_Enrolled_Msg,
        AHFC_Label_EasyPay,
        AHFC_SchPayments_NextWithdraw,
        AHFC_SchPayments_Suspended,
        AHFC_SchPayments_Scheduled,
        AHFC_SchPayments_PaymentAmt,
        AHFC_SchPayments_LastWithdraw,
        AHFC_SchPayments_SuspendMsg,
        AHFC_Cancel_EasyPay_Button,
        AHFC_SchPayments_OTP,
        AHFC_SchPayments_PaymentType,
        AHFC_SchPayments_ConfirmationNumber,
        AHFC_SchPayments_AuthorisedOn,
        AHFC_SchPayments_CancelPayment,
        AHFC_SchPayments_Edit,
        AHFC_CuttOffDisabledErrorMsg

    };


    @track openModalFlag = false;
    @track successMessageUpdateCancel = false;
    @track showEasyPaySuccessMsg = false;
    @track paySource;
    @track PayLast4;
    @track lastWithdrawalDateEZP;
    @track nextWithdrawalDateEZP;
    @track oneTimePaymentMessage = true;
    @track EZPDisableFlag = false;

    @track paymentsOTP;
    @track lstPaymentsOTP = {
        isOTPCutOff: false,
        Source: " ",
        Last4: " ",
        Payment_Type__c: " ",
        Payment_Display_Status__c: " ",
        boolIsEligible: false,
        ChargentOrders__Payment_Start_Date__c: " ",
        PaymentAuthorizedOn__c: " ",
        ChargentOrders__Charge_Amount__c: " ",
    };
    @track paymentEZP;
    @track ezpPaymentData;

    @track sacRecordId;
    currentPageReference = null;
    urlStateParameters = null;

    @track showEZP = false;
    @track isDisplayNotEnrolled = false;
    @track cutOffFlag = false;

    @track openCancelEZPEligibility = false;
    @track suspendedPayment = false;
    @track boolShowSuccessMsg = false;

    //US:3793 by edwin
    @track paymentSourceId;
    @track paymentAmount;
    @track paymentDate;
    @track openEditModalFlag = false;
    @track paymentRecId;
    @track paymentType;
    @track financeAccNum;
    @track openCancelModalFlag = false;
    @track isEligibleForEdit = false;
    @track pageRef;
    @track financeAccData = {};
    @track jsonData;
    @track cutOffTime = AHFC_CutOffTime;
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.pageRef = currentPageReference;
    }
    connectedCallback() {
        console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>',new Date());
        registerListener('AHFC_Account_Selected', this.getDataFromPubsubEvent, this);


    }
    getDataFromPubsubEvent(data) {
        this.jsonData = JSON.parse(data);
        this.sacRecordId = this.jsonData.serAccRec.Id;
        this.schPaymentBoolean(this.jsonData);
        this.schPaymentDetails(this.jsonData);
        this.boolShowSuccessMsg = false;
    }
    goToMakeAPayment() {
            this[NavigationMixin.Navigate]({
                type: "comm__namedPage",
                attributes: {
                    pageName: "make-a-payment"
                },
                state: {
                    sacRecordId: this.sacRecordId,
                    showOTPDefault: true // Added by Aswin for Bug fix #14775
                }
            });
        }
        /**
         * @description     schPaymentDetails to check the schedule payments related to the finance account. if not display the No Schedule screen.
         */

    schPaymentBoolean(data) {

        paymentList({
                sacRecID: data.serAccRec.Id
                //sacRecID: '00000444549136'
            })
            .then((result) => {
                this.noScheduledPayments = (result.length > 0) ? false : true;
                console.log('noScheduledPayments>>>>>>>>' + this.noScheduledPayments);
            })
            .catch((error) => {
                this.error = error;
                //Record access check exception handling - Supriya Chakraborty 11-Nov-2021
                if(error.body.message == 'invalid access'){
                    this[NavigationMixin.Navigate]({
                        type: "comm__namedPage",
                        attributes: {
                            pageName: "dashboard"
                        }
                    });
                }
            });
    }

    //Added by Narain For US 14480
    get schPaymentsLabelInformation() {
        var schPaymentsLabelInformationValue = "You can edit and/or cancel payments until the cut-off time (" + this.cutOffTime + ") on the payment date. Same day one-time payments cannot be edited or cancelled after " + this.cutOffTime + ". Payments scheduled for Sunday will process on Monday and be credited to your account as of the payment date.";

        return schPaymentsLabelInformationValue;
    }


    get eZPEnrolledMsg() {
        var eZPEnrolledMsgValue = "You are enrolled in EasyPay. Cancellations completed by " + this.cutOffTime + " on the payment date will be effective immediately starting with the current scheduled payment.";

        return eZPEnrolledMsgValue;
    }

    schPaymentDetails(data) {
        paymentDetails({
                sacRecID: data.serAccRec.Id
                //sacRecID: '00000444549136'
            })
            .then((result) => {
                this.oneTimePaymentMessage = true;
                this.paymentsOTP = result.lstOtpPayments;
                console.log(' this.paymentsOTP', this.paymentsOTP);
                this.lstPaymentsOTP = (this.paymentsOTP) ? this.paymentsOTP : "";
                this.isEZPEnrolled = result.isEZPEnrolled;
                this.showEZP = result.showEZP;
                this.cutOffFlag = result.cutOffFlag;
                console.log('result.lstOtpPayments: ' + JSON.stringify(result.lstOtpPayments));
                this.openCancelEZPEligibility = result.openCancelEZPEligibility;
                if (result.lstOtpPayments.length > 0) {
                    this.oneTimePaymentMessage = false;
                    for (var i = 0; i < this.paymentsOTP.length; i++) {
                        if (this.lstPaymentsOTP[i].Payment_Display_Status__c === "Processing") {
                            this.lstPaymentsOTP[i].isOTPCutOff = true;
                            this.lstPaymentsOTP[i].boolIsEligible = false;
                        } else if (this.lstPaymentsOTP[i].Payment_Display_Status__c === "Pending") {
                            if (this.lstPaymentsOTP[i].ChargentOrders__Payment_Start_Date__c < result.dateToday) {
                                this.lstPaymentsOTP[i].isOTPCutOff = true;
                            } else if (this.lstPaymentsOTP[i].ChargentOrders__Payment_Start_Date__c == result.dateToday && this.cutOffFlag == true) {
                                this.lstPaymentsOTP[i].isOTPCutOff = true;
                            } else {
                                this.lstPaymentsOTP[i].isOTPCutOff = false;
                            }

                            this.lstPaymentsOTP[i].Payment_Display_Status__c = 'Scheduled';
                            this.lstPaymentsOTP[i].boolIsEligible = true;
                        }
                        if (typeof this.lstPaymentsOTP[i].Payment_Source_Nickname__c !== CONSTANTS.UNDEFINED) {
                            this.lstPaymentsOTP[i].Source = this.lstPaymentsOTP[i].Payment_Source_Nickname__r.Payment_Source_Nickname__c;
                            this.lstPaymentsOTP[i].Last4 = this.lstPaymentsOTP[i].Payment_Source_Nickname__r.Last_4__c;
                        }

                        if (this.lstPaymentsOTP[i].RecordType.Name === "Standard One-Time Payment") {
                            this.lstPaymentsOTP[i].Payment_Type__c = 'Standard';
                        } else if (this.lstPaymentsOTP[i].RecordType.Name === "Principal One-Time Payment") {
                            this.lstPaymentsOTP[i].Payment_Type__c = 'Principal';
                        }

                        //US:3794 condition for payoff and purchase by edwin
                        else if (this.lstPaymentsOTP[i].RecordType.Name === "Payoff Payment") {
                            //checking whether user is eligible for edit/cancel
                            if (this.lstPaymentsOTP[i].Finance_Account_Number__r.Fl_Payoff_Payment_Eligible_Web__c && this.lstPaymentsOTP[i].isOTPCutOff == false && this.lstPaymentsOTP[i].boolIsEligible == true) {
                                this.lstPaymentsOTP[i].isEligibleForEdit = true;
                            }
                            if ((this.lstPaymentsOTP[i].Account_Type__c === 'Balloon' && this.lstPaymentsOTP[i].Fl_Refinanced__c === true) ||
                                this.lstPaymentsOTP[i].Account_Type__c === 'Retail') {
                                this.lstPaymentsOTP[i].Payment_Type__c = 'Payoff';
                            } else {
                                this.lstPaymentsOTP[i].Payment_Type__c = 'Purchase';
                            }
                        }
                        if (typeof this.lstPaymentsOTP[i].ChargentOrders__Payment_Start_Date__c !== CONSTANTS.UNDEFINED)
                             console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>0000000000000000');
                                console.log('this.lstPaymentsOTP[i].ChargentOrders__Payment_Start_Date__c000000000000000',this.lstPaymentsOTP[i].ChargentOrders__Payment_Start_Date__c);
                            this.lstPaymentsOTP[i].ChargentOrders__Payment_Start_Date__c = this.formatDate(this.lstPaymentsOTP[i].ChargentOrders__Payment_Start_Date__c);
                            
                            console.log('this.lstPaymentsOTP[i].ChargentOrders__Payment_Start_Date__c000000000000000',this.lstPaymentsOTP[i].ChargentOrders__Payment_Start_Date__c);
                            console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>0000000000000000');
                        if (typeof this.lstPaymentsOTP[i].PaymentAuthorizedOn__c !== CONSTANTS.UNDEFINED)
                            this.lstPaymentsOTP[i].PaymentAuthorizedOn__c = this.formatDate(this.lstPaymentsOTP[i].PaymentAuthorizedOn__c);
                        if (this.lstPaymentsOTP[i].boolIsEligible == true && (this.lstPaymentsOTP[i].Payment_Type__c === 'Standard' || this.lstPaymentsOTP[i].Payment_Type__c === 'Principal') && this.lstPaymentsOTP[i].Finance_Account_Number__r.Fl_OneTime_Payment_Eligible_Web__c && this.lstPaymentsOTP[i].isOTPCutOff == false) {
                            this.lstPaymentsOTP[i].isEligibleForEdit = true;
                        }
                        if (this.lstPaymentsOTP[i].ChargentOrders__Charge_Amount__c) {
                            this.lstPaymentsOTP[i].ChargentOrders__Charge_Amount__c = this.formatCurrency(this.lstPaymentsOTP[i].ChargentOrders__Charge_Amount__c);
                        }
                    }
                }

                this.isDisplayNotEnrolled = (result.lstOtpPayments.length > 0) && (this.showEZP == false);

                this.paymentEZP = result.lstEasyPayPayments;
                console.log('EZP rec : ' + JSON.stringify(this.paymentEZP));
                this.ezpPaymentData = this.paymentEZP[0];
                //Added by aswin for 3797 - check next withdrawal date to enable/disable cancel button
                if (this.ezpPaymentData) {
                    if (!this.openCancelEZPEligibility) {
                        if ((this.ezpPaymentData.Next_Withdrawal_Date__c == result.dateToday && this.cutOffFlag) || this.ezpPaymentData.Next_Withdrawal_Date__c < result.dateToday) {
                            this.EZPDisableFlag = true;
                        } else {
                            this.EZPDisableFlag = false;
                        }
                    }

                    if (this.ezpPaymentData.Payment_Source_Nickname__c) {
                        this.paySource = this.ezpPaymentData.Payment_Source_Nickname__r.Payment_Source_Nickname__c;
                        this.PayLast4 = this.ezpPaymentData.Payment_Source_Nickname__r.Last_4__c;
                    }
                    if (this.ezpPaymentData.Last_Extraction_Date__c) {
                        this.lastWithdrawalDateEZP = this.formatDate(this.ezpPaymentData.Last_Extraction_Date__c);
                    }
                    if (this.ezpPaymentData.Next_Withdrawal_Date__c) {
                        console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>0000000000000000');
                        this.nextWithdrawalDateEZP = this.formatDate(this.ezpPaymentData.Next_Withdrawal_Date__c);
                        console.log('this.ezpPaymentData.Next_Withdrawal_Date__c11111111111111111111110000000000',this.ezpPaymentData.Next_Withdrawal_Date__c);
                        console.log('this.nextWithdrawalDateEZ11111111111111100000000000',this.nextWithdrawalDateEZP);
                        console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>0000000000000000');
                    }
                    if (this.ezpPaymentData.ChargentOrders__Charge_Amount__c) {
                        this.chargentAmountEZP = this.formatCurrency(this.ezpPaymentData.ChargentOrders__Charge_Amount__c);
                    }
                }
            })
            .catch((error) => {
                this.error = error;
                //Record access check exception handling - Supriya Chakraborty 11-Nov-2021
                if(error.body.message == 'invalid access'){
                    this[NavigationMixin.Navigate]({
                        type: "comm__namedPage",
                        attributes: {
                            pageName: "dashboard"
                        }
                    });
                }
            });
    }
    onCloseToast() {
        this.boolShowSuccessMsg = false;
    }

    //For US:3797 Aswin Jose
    openModalMethod() {
        this.openModalFlag = true;
        this.successMessageUpdateCancel = false;
        this.showEasyPaySuccessMsg = false;
        this.boolShowSuccessMsg = false;
    }

    closePopUp(event) {
            //access object parameters and assign the value
            this.openModalFlag = event.detail.closemodalflag;
            this.successmessage = event.detail.successmessagevalue;

            if (!this.successmessage == '') {

                this.successSaveMsg = this.successmessage;
                this.openModalFlag = false;
                this.successMessageUpdateCancel = true;
                this.boolShowSuccessMsg = true;
                this.toastType = "Success";
                this.schPaymentBoolean(this.jsonData);
                this.schPaymentDetails(this.jsonData);

            }
        }
        //For US:3797 Aswin Jose

    formatDate(dt) {
        var formatdate = new Date(dt);
        console.log('0000000000000011111111111 1 ',formatdate);
        formatdate = new Date(formatdate.getTime() + formatdate.getTimezoneOffset() * 60 * 1000);
        console.log('0000000000000011111111111 2 ',formatdate);
        if (formatdate !== CONSTANTS.INVALID_DATE) {
            const options = {
                year: "numeric",
                month: "short",
                day: "numeric"
            };
            return formatdate.toLocaleDateString("en-US", options);
        } else {
            return "";
        }
    }

    //US:3793 by edwin starts here

    /** Method Name: openEditModal
     *  Description:  method to set flag and data for edit popup
     *  Developer Name: Edwin Antony
     *  Created Date:   23-July-2021 
     */
    openEditModal(event) {
        this.openEditModalFlag = true;
        const itemIndex = event.currentTarget.dataset.index

        console.log('payment Amount >>> ',this.lstPaymentsOTP[itemIndex].ChargentOrders__Charge_Amount__c);

        this.financeAccData = {
            paymentSourceId: this.lstPaymentsOTP[itemIndex].Payment_Source_Nickname__c,
            paymentAmount: this.lstPaymentsOTP[itemIndex].ChargentOrders__Charge_Amount__c,
            paymentDate: this.lstPaymentsOTP[itemIndex].ChargentOrders__Payment_Start_Date__c,
            paymentRecId: this.lstPaymentsOTP[itemIndex].Id,
            paymentType: this.lstPaymentsOTP[itemIndex].Payment_Type__c,
            financeAccNum: this.lstPaymentsOTP[itemIndex].Finance_Account_Number__c
        };
        window.scrollTo(0, 450); //adjusted the scroll aspart of bug fix 20275
        if (this.flags.openEditModalFlag) {
            this.template.querySelector("c-a-h-f-c_edit-payment-pop-up").setFieldValues(this.financeAccData);
        }
    }

    /** Method Name: openCancelModal
     *  Description:  method to set flag and data for cancel popup
     *  Developer Name: Edwin Antony
     *  Created Date:   24-July-2021 
     */
    openCancelModal(event) {
        this.openCancelModalFlag = true;
        const itemIndex = event.currentTarget.dataset.index
        this.financeAccData = {
            paymentSourceId: this.lstPaymentsOTP[itemIndex].Payment_Source_Nickname__c,
            paymentAmount: this.lstPaymentsOTP[itemIndex].ChargentOrders__Charge_Amount__c,
            paymentDate: this.lstPaymentsOTP[itemIndex].ChargentOrders__Payment_Start_Date__c,
            paymentRecId: this.lstPaymentsOTP[itemIndex].Id,
            paymentType: this.lstPaymentsOTP[itemIndex].Payment_Type__c,
            financeAccNum: this.lstPaymentsOTP[itemIndex].Finance_Account_Number__c,
            source: this.lstPaymentsOTP[itemIndex].Source,
            last4: this.lstPaymentsOTP[itemIndex].Last4
        };
        if (this.flags.openEditModalFlag) {
            this.template.querySelector("c-a-h-f-c_cancel-payment-pop-up").setFieldValues(this.financeAccData);
        }
    }

    /** Method Name: onEditModalSave
     *  Description:  this method is invoked on save of edit popup
     *  Developer Name: Edwin Antony
     *  Created Date:   24-July-2021 
     */
    onEditModalSave(event) {
        this.successmessage = event.detail.successMsg;

        if (!this.successmessage == '') {
            this.successSaveMsg = this.successmessage;
            this.openEditModalFlag = false;
            this.boolShowSuccessMsg = true;
            this.toastType = "Success";
            this.schPaymentBoolean(this.jsonData);
            this.schPaymentDetails(this.jsonData);

        }
    }

    onEditModalClose(event) {
        this.openEditModalFlag = false;
    }


    onCancelModalClose(event) {
        this.openCancelModalFlag = event.detail.closemodalflag;
        this.successmessage = event.detail.successmessagevalue;

        if (!this.successmessage == '') {
            this.successSaveMsg = this.successmessage;
            this.openModalFlag = false;
            this.successMessageUpdateCancel = true;
            this.boolShowSuccessMsg = true;
            this.toastType = "Success";
            this.schPaymentBoolean(this.jsonData);
            this.schPaymentDetails(this.jsonData);

        }


    }
    formatCurrency(curNumber) {
        var formatter = new Intl.NumberFormat("en-US", {
            style: "currency",
            currency: "USD",
            maximumFractionDigits: 2
        });
        return formatter.format(curNumber);
    }

    //US:3793 by edwin ends here

    navigateToContactUs() {
        //navigate to scheduled payment page
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-post-login'
            }
        });

    }

}