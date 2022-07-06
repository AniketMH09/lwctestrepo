/*  * LWC                :    AHFC_reviewPayment
    * Description        :    This Component is used to display review payment page and confirmation screens
    * Modification Log   :    Modified by Aakash Solanki as part of 4528, 4529, 4587 to develop the confirmation screens of payments.
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Kanagaraj                                          Created
    * Akash                      18-JUNE-2021            Modified
    * Sagar                      27-October-2021         Mo dified for Bug Fix 20450  
    * Edwin                      28-October-2021         Modified for Bug Fix 20427: Added new method 'formatDateWithoutOffset' for handling date offset issue 
***************************************************************************************/
import { LightningElement, api, track, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import easypay from "@salesforce/resourceUrl/AHFC_Easypay";
//import Custom Labels
import AHFC_One_Time_Payment_Message from "@salesforce/label/c.AHFC_One_Time_Payment_Message";
import EasyPay_T_C_1 from "@salesforce/label/c.EasyPay_T_C_1";
import T_C_Message_1 from "@salesforce/label/c.T_C_Message_1";
import AHFC_Payoff_T_C_Message from "@salesforce/label/c.AHFC_Payoff_T_C_Message";
import T_C_Message_2 from "@salesforce/label/c.T_C_Message_2";
import AHFC_PayOff_Payment_Message from "@salesforce/label/c.AHFC_PayOff_Payment_Message";
import AHFC_Payment_Error_Message from "@salesforce/label/c.AHFC_Payment_Error_Message";
import AHFC_EasyPay_Payment_Message from "@salesforce/label/c.AHFC_EasyPay_Payment_Message";
import AHFC_Honda_Contact_Us_URL from "@salesforce/label/c.AHFC_Honda_Contact_Us_URL";
import AHFC_OTP_EZP_Limit from "@salesforce/label/c.AHFC_OTP_EZP_Limit";
import spinnerWheelMessage from "@salesforce/label/c.Spinner_Wheel_Message";
//import apex methods here
import insertPayments from "@salesforce/apex/AHFC_Payment.insertPayments";
import communicationPreference from "@salesforce/apex/AHFC_ReviewPaymentDetails.commPrefDetailForOTP";
//import getOrgDetail from "@salesforce/apex/AHFC_Payment.getOrgdetail"; Commented by Narain US 14480
import AHFC_Agent_Profile from "@salesforce/label/c.AHFC_Agent_Profile";
import AHFC_CutOffTime from "@salesforce/label/c.AHFC_CutOffTime";
import { getConstants } from "c/ahfcConstantUtil";
import { NavigationMixin } from "lightning/navigation";
import { fireEvent } from 'c/pubsub';
import { CurrentPageReference } from "lightning/navigation";
import CreatedDate from "@salesforce/schema/Account.CreatedDate";
import SystemModstamp from "@salesforce/schema/Account.SystemModstamp";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import getNumberOfPayments from "@salesforce/apex/AHFC_ReviewPaymentDetails.getNumberOfPaymentsAlreadyCreated";
import allTnC from "@salesforce/resourceUrl/AHFC_Terms_and_Conditions_pdf"; //US 3738

//assign the values returned from the getConstants method from util class
const CONSTANTS = getConstants();
export default class AHFC_reviewPayment extends NavigationMixin(LightningElement) {
    @track paymentAuthTnCUrl = allTnC + "/Payment_Withdrawal_Authorization.pdf";
    @api isboolenrolled;
    @api monthlyamount;
    @api scheduleon;
    @api easypaydate;
    @api easypaydateVar;
    @api selectedpaymentsource;
    @api paytype;
    @api additionalprincipalamount;
    @api selectedpaymentsourceid;
    @api serviceaccountid;
    @api isadditionalprinicipalamount;
    @api automaticpaymentamount;
    @api scheduledpaymentdate;
    @api nextwithdrawldate;
    @api chargeday;
    @api brandName = '';
    @track strNextWithdrawlDate;
    @track showOneTimePayment = false;
    @track showPayOff = false;
    @track showEasyPay = false;
    @track paymentType;
    @track strmonthlyamount;
    @track stradditionalprincipalamount;
    @track isPaymentSuccess = false;
    @track isPaymentSuccessOTP = false;
    @track paymentList = [];
    @track paymentListforAgent = [];
    @track monthlyConfirmationNumber;
    @track pricipleConfirmationNumber;
    @api last4accnumofselpaysource;
    @track paymentAuthorizedOn;
    @track hideConfBanner = false;
    @track paymentDate;
    @track userprofiletype = "";
    @track error = "";
    @track agentEligible = true;
    @track showMonthlyAmount = true;
    @track showAdditionalPrincipalAmount = true;
    @track selectedpaymentsourceTrimed;
    @track paymentLabel;
    @track Payment_Confirmations_via_Email = false;
    @track Payment_Confirmations_via_Text = false;
    @track commprefemail;
    @track commprefphone;
    @track isSandbox;
    @track isStandardOTP = false;
    @track pageRef;
    @track routingSpinner = false;
    @track spinnerMessage = spinnerWheelMessage;
    @track cutOffTime = AHFC_CutOffTime;
    @track authorizedDate;


    //@track boolDisplayPaymentErrorMessage = false;
    //@track paymentErrorMessage;
    // Expose the labels to use in the template.
    label = {
        AHFC_PayOff_Payment_Message,
        AHFC_EasyPay_Payment_Message,
        AHFC_One_Time_Payment_Message,
        EasyPay_T_C_1,
        T_C_Message_1,
        T_C_Message_2,
        AHFC_Payoff_T_C_Message,
        AHFC_Honda_Contact_Us_URL
    };

    get easypayImg() {
        return easypay;
    }
    //@track tempVar=0;
    connectedCallback() {
        //set cut-off time
        console.log('<<<<reviewpage>>>>', this.monthlyamount);
        //  alert('reviewpage , this.monthlyamount >>> '+this.monthlyamount);
        console.log(
            //   "last4accnumofselpaysource-->" + this.last4accnumofselpaysource
        );
        this.strmonthlyamount = Number(this.monthlyamount);
        this.strmonthlyamount = this.formatnumber(this.strmonthlyamount);
        if (this.paytype === CONSTANTS.ENROLL_EASYPAY) {
            this.paymentType = CONSTANTS.EASYPAY;
            this.showOneTimePayment = false;
            this.showPayOff = false;
            this.showEasyPay = true;
            this.hideConfBanner = false;
            this.isadditionalprinicipalamount = false;
            this.strNextWithdrawlDate = this.formatDate(new Date(this.nextwithdrawldate));
        } else if (this.paytype === CONSTANTS.ONE_TIME) {
            this.paymentType = CONSTANTS.ONE_TIME_PAYMENT;
            this.showOneTimePayment = true;
            this.showPayOff = false;
            this.showEasyPay = false;
            this.hideConfBanner = false;
            this.showMonthlyAmount = this.monthlyamount > 0 ? true : false;
            this.showAdditionalPrincipalAmount = this.additionalprincipalamount > 0 ? true : false;
            if (this.additionalprincipalamount > 0) {
                this.isadditionalprinicipalamount = true;
                this.stradditionalprincipalamount = Number(
                    this.additionalprincipalamount
                );
                this.stradditionalprincipalamount = this.formatnumber(
                    this.stradditionalprincipalamount
                );
                console.log('additional amount', this.stradditionalprincipalamount);
            }
            if (this.showMonthlyAmount) {
                this.paymentLabel = "PAYMENT AMOUNT";
            } else if (this.showAdditionalPrincipalAmount) {
                this.paymentLabel = "ADDITIONAL PRINCIPAL AMOUNT";
            }
        } else if (this.paytype === CONSTANTS.PAYOFF_LC) {
            this.paymentType = CONSTANTS.PAYOFF_UC;
            this.showOneTimePayment = false;
            this.showPayOff = true;
            this.showEasyPay = false;
            this.hideConfBanner = false;
            this.isadditionalprinicipalamount = false;
        }
        if (this.additionalprincipalamount > 0 && this.monthlyamount > 0) {
            this.isadditionalprinicipalamount = true;
        } else {
            this.isadditionalprinicipalamount = false;
        }


        //this.checkAgentEligibility();
        this.getCommPrefDetail();

        //  alert('reviewpage , this.monthlyamount 1 >>> '+this.monthlyamount);
    }


    getCommPrefDetail() {
        console.log('<<<<compfre>>>>');
        console.log('<<<<this.monthlyamount>>>>' + this.monthlyamount);
        console.log('<<<<this.additionalprincipalamount>>>>' + this.additionalprincipalamount);
        //fix added for 15496
        if (this.monthlyamount != '' || this.additionalprincipalamount != '')
            this.isStandardOTP = true;
        else
            this.isStandardOTP = false;
        console.log('<<<<this.isStandardOTP>>>>' + this.isStandardOTP);

        if (this.isStandardOTP) {
            communicationPreference({
                finid: this.serviceaccountid
            }).then((result) => {
                // console.log("result COmperf ", JSON.parse(result));
                if (result.Payment_Confirmations_via_Email__c || result.Payment_Confirmations_via_Text__c) {
                    this.Payment_Confirmations_via_Email = result.Payment_Confirmations_via_Email__c;
                    this.Payment_Confirmations_via_Text = result.Payment_Confirmations_via_Text__c;
                    this.commprefemail = result.Email_Address__c;
                    var cleaned = ('' + result.Text_Number__c).replace(/\D/g, '');
                    var match = cleaned.match(/^(1|)?(\d{3})(\d{3})(\d{4})$/);
                    if (match) {
                        var intlCode = (match[1] ? '+1 ' : '');
                        this.commprefphone = [intlCode, '(', match[2], ') ', match[3], '-', match[4]].join('');
                    }
                    if (this.Payment_Confirmations_via_Email && this.commprefemail == undefined) {
                        this.Payment_Confirmations_via_Email = false;
                    }
                    if (this.Payment_Confirmations_via_Text && this.commprefphone == undefined) {
                        this.Payment_Confirmations_via_Text = false;
                    }
                    if (!this.Payment_Confirmations_via_Email && !this.Payment_Confirmations_via_Text) {
                        this.isStandardOTP = false;
                    }

                } else {
                    this.isStandardOTP = false;
                }
            })
                .catch((error) => {
                    this.isStandardOTP = false;
                    console.log("error ", error);
                });
        }
    }

    get monthlyPaymentAmt() {
        var monthlyAmt = parseFloat(this.monthlyamount);
        var additionVar = 0;
        if (
            this.additionalprincipalamount > 0 &&
            this.paytype === CONSTANTS.ONE_TIME
        ) {
            additionVar = monthlyAmt + Number(this.additionalprincipalamount);
        } else {
            additionVar = monthlyAmt;
        }
        return this.formatCurrency(additionVar);
    }

    /*get authorizedDate() {

        var CreatedDate = new Date();
        var formattedDate = this.formatDateWithoutOffset(CreatedDate);
        /*const months = [
          "JAN",
          "FEB",
          "MAR",
          "APR",
          "MAY",
          "JUN",
          "JUL",
          "AUG",
          "SEP",
          "OCT",
          "NOV",
          "DEC"
        ];
        const duedate = new Date();
        return (
          months[duedate.getMonth()] +
          " " +
          duedate.getDate() +
          ", " +
          duedate.getFullYear()
        ); 
        return formattedDate;
    }*/

    get easyPayDate() {
        const months = [
            "JAN",
            "FEB",
            "MAR",
            "APR",
            "MAY",
            "JUN",
            "JUL",
            "AUG",
            "SEP",
            "OCT",
            "NOV",
            "DEC"
        ];
        this.easypaydateVar = this.easypaydate;
        const duedate = new Date(this.easypaydate);
        return (
            months[duedate.getMonth()] +
            " " +
            duedate.getDate() +
            ", " +
            duedate.getFullYear()
        );
    }
    get dueDate() {
        const months = [
            "JAN",
            "FEB",
            "MAR",
            "APR",
            "MAY",
            "JUN",
            "JUL",
            "AUG",
            "SEP",
            "OCT",
            "NOV",
            "DEC"
        ];

        let duedate = new Date();
        duedate = new Date(
            duedate.getTime() + duedate.getTimezoneOffset() * 60 * 1000
        );
        return (
            months[duedate.getMonth()] +
            " " +
            duedate.getDate() +
            ", " +
            duedate.getFullYear()
        );
    }

    get otpDueDate() {
        const months = [
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec"
        ];
        console.log("Due Date-?" + this.scheduleon);

        let duedate = new Date(this.scheduleon);
        duedate = new Date(
            duedate.getTime() + duedate.getTimezoneOffset() * 60 * 1000
        );
        return (
            months[duedate.getMonth()] +
            " " +
            duedate.getDate() +
            ", " +
            duedate.getFullYear()
        );
    }

    formatCurrency(curNumber) {
        var formatter = new Intl.NumberFormat("en-US", {
            style: "currency",
            currency: "USD",
            maximumFractionDigits: 2
        });
        return formatter.format(curNumber);
    }
    editPayment() {
        //fire an event to set boolean variable in Parent comp
        window.scrollTo(0, 0);
        //  alert('strmonthlyamount >> ',this.strmonthlyamount);

        const selectedEvent = new CustomEvent("editpayment", {
            detail: {
                showOneTimePayment: this.showOneTimePayment,
                showPayOff: this.showPayOff,
                showEasyPay: this.showEasyPay,
                otpPaymentAmount: this.monthlyamount,
                otpPaymentdate: this.scheduleon,
                otpPaymentSource: this.selectedpaymentsource,
                otpShowPrincipalAmtField: this.showAdditionalPrincipalAmount, // added by sagar for Bug Fix 20450
                financeAccountRecId: this.serviceaccountid, // added by sagar for Bug Fix 20450
                otpPaymentSourceid: this.selectedpaymentsourceid //Added by Aswin Jose for bug fix : 15544  //Added by Aswin Jose for bug fix : 15544

            }
        });
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }

    //confirmation screen formatting date to MM/DD/YYYY
    formatDat(formatDate) {
        this.paymentDate = formatDate;
        console.log('this.paymentDate>>>>>>>> ' + this.paymentDate);
    }
    navigateToDashboard() {
        this.continueNavButtonClicked();
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "dashboard"
            }
        });
    }
    formatDate(dt) {
        var formatdate = new Date(dt);
        formatdate = new Date(
            formatdate.getTime() + formatdate.getTimezoneOffset() * 60 * 1000
        );
        if (formatdate != CONSTANTS.INVALID_DATE) {
            const options = { year: "numeric", month: "short", day: "numeric" };
            console.log('locale:' + formatdate.toLocaleDateString("en-US", options));
            return formatdate.toLocaleDateString("en-US", options);
        } else {
            return "";
        }
    }
    //added as pert og bug fix 20427
    formatDateWithoutOffset(dt) {
        var formatdate = new Date(dt);
        formatdate = new Date(
            formatdate.getTime()
        );
        if (formatdate != CONSTANTS.INVALID_DATE) {
            const options = { year: "numeric", month: "short", day: "numeric" };
            console.log('locale:' + formatdate.toLocaleDateString("en-US", options));
            return formatdate.toLocaleDateString("en-US", options);
        } else {
            return "";
        }
    }

    //formatting number to string
    formatnumber(number) {
        return number.toLocaleString("en-US", { minimumFractionDigits: 2 });
    }
  
    handleSubmitPayment() {
        window.scrollTo(0, 0);
        this.routingSpinner = true;
        console.log('12321321321');
        this.reiviewSubmitButtonClicked();
        console.log('12321321321');
        var payoffDate;
        var paymentDateTemp;
        var paymentAmt = 0;
        var principalAmt = 0;
        if (this.monthlyamount != undefined && this.monthlyamount != '')
            paymentAmt = this.monthlyamount;
        if (this.additionalprincipalamount != undefined && this.additionalprincipalamount != '')
            principalAmt = this.additionalprincipalamount;

        console.log("finAccId>>>>", this.serviceaccountid);
        getNumberOfPayments({
            finAccId: this.serviceaccountid
        }).then((result) => {
            console.log('<<<<Result check 2>>>', JSON.stringify(result));
            if (result != null && result != "") {
                if (result.sixOtpError || result.sixOtpAndEZPError) {
                    this.showPayOTPCountGreaterThanSixError = true;
                    console.log('456');
                } else {
                    insertPayments({
                        finAccId: this.serviceaccountid,
                        idPaymentSource: this.selectedpaymentsourceid,
                        decPaymentAmount: paymentAmt,
                        decAdditionalPayment: principalAmt,
                        dtScheduleOn: this.scheduleon
                    }) //US 4528, 4529, 4587 - For confirmation number on the confirmation screen starts from here - Akash Solanki
                        .then((result) => {
                            console.log('result000000000000000000000', result);
                            if (result != null && result != "") {
                                this.routingSpinner = false;
                                this.isPaymentSuccess = true;
                                this.isPaymentSuccessOTP = true;
                                this.paymentList = result;
                                let payCount;
                                if (result.length) {
                                    this.authorizedDate = this.formatDate(result[0].PaymentAuthorizedOn__c);
                                }
                                for (payCount = 0; payCount < this.paymentList.length; payCount++) {
                                    if (
                                        this.paymentList[payCount].Payment_Type__c == 'O'
                                    ) {
                                        this.pricipleConfirmationNumber = this.paymentList[
                                            payCount
                                        ].Confirmation_Number__c;
                                    } else {
                                        this.monthlyConfirmationNumber = this.paymentList[
                                            payCount
                                        ].Confirmation_Number__c;
                                    }
                                }
                            } else {
                                this.paymentCreationError();
                                this.isPaymentSuccess = false;
                                this.routingSpinner = false;
                            }
                        })
                        .catch((error) => {
                            console.log("error>>>", error);
                            this.error = error;
                            this.routingSpinner = false;
                            this.paymentCreationError();
                        });
                }


            }
        }).catch((error) => {
            console.log('error Limit', error);
        });

        // insertPayments({
        //         finAccId: this.serviceaccountid,
        //         idPaymentSource: this.selectedpaymentsourceid,
        //         decPaymentAmount: paymentAmt,
        //         decAdditionalPayment: principalAmt,
        //         dtScheduleOn: this.scheduleon
        //     }) //US 4528, 4529, 4587 - For confirmation number on the confirmation screen starts from here - Akash Solanki
        //     .then((result) => { 
        //         console.log('result000000000000000000000',result);
        //         if (result != null && result != "") {
        //             this.routingSpinner = false;
        //             this.isPaymentSuccess = true;
        //             this.isPaymentSuccessOTP = true;
        //             this.paymentList = result;
        //             let payCount;
        //             if(result.length){
        //                 this.authorizedDate = this.formatDate(result[0].PaymentAuthorizedOn__c);
        //             }
        //             for (payCount = 0; payCount < this.paymentList.length; payCount++) {
        //                 if (
        //                     this.paymentList[payCount].Payment_Type__c == 'O'
        //                 ) {
        //                     this.pricipleConfirmationNumber = this.paymentList[
        //                         payCount
        //                     ].Confirmation_Number__c;
        //                 } else {
        //                     this.monthlyConfirmationNumber = this.paymentList[
        //                         payCount
        //                     ].Confirmation_Number__c;
        //                 }
        //             }
        //         } else {
        //             this.paymentCreationError();
        //             this.isPaymentSuccess = false;
        //             this.routingSpinner = false;
        //         }
        //     })
        //     .catch((error) => {
        //         console.log("error>>>", error);
        //         this.error = error;
        //         this.routingSpinner = false;
        //         this.paymentCreationError();
        //     });
        //US 4528, 4529, 4587 - For confirmation number on the confirmation screen Ends here - Akash Solanki
    }

    paymentCreationError() {
        const event = new ShowToastEvent({
            title: "Error",
            message: AHFC_Payment_Error_Message,
            variant: "error",
            mode: "dismissable"
        });
        this.dispatchEvent(event);
    }
    reiviewSubmitButtonClicked() {
        window.scrollTo(0, 0);
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Make a Payment:Button:Submit",
            "Event_Metadata.action_category": "Payment Review",
            "Page.page_name": "Make a Payment - Setup",
            "Page.site_section": "Make a Payment - Review",
            "Page.brand_name": this.brandName
        };
        fireAdobeEvent(adobedata, 'click-event');
    }
    continueNavButtonClicked() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Make a Payment:Hyperlink:Continue To Dashboard",
            "Event_Metadata.action_category": "Payment Success",
            "Page.page_name": "Make a Payment - Setup",
            "Page.site_section": "Make a Payment - Success",
            "Page.brand_name": this.brandName
        };
        fireAdobeEvent(adobedata, 'click-event');
    }
    enrollEasyPayButtonClicked() {
        window.scrollTo(0, 0);
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Make a Payment:Hyperlink:Enroll in EasyPay",
            "Event_Metadata.action_category": "Payment Success",
            "Page.page_name": "Make a Payment - Setup",
            "Page.site_section": "Make a Payment - Success",
            "Page.brand_name": this.brandName
        };
        fireAdobeEvent(adobedata, 'click-event');
    }
    enrollEasyPay() {
        this.enrollEasyPayButtonClicked();
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },
            state: {
                sacRecordId: this.serviceaccountid,
                showeasypay: true
            }
        });
    }

    navigatetoPaymentActivityPage() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "manage-payment"
            }
        });
    }

    oncontactus() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-post-login'
            }
        });
    }

    onCloseModalSuccess() {
        this.isPaymentSuccessOTP = false;
    }

    //Changes by Narain For bug 20025
    get confirmationMessage() {

        var EZPMessage = "EasyPay payments scheduled for Sunday will process on Monday and be credited to your account as of the payment date. Cancellations by " + this.cutOffTime + " on the payment date will be effective immediately.";

        var payOffPaymentMessage = "Your payoff payment will be credited to your account within 2 business days of your scheduled Payoff Date. Payoffs made after " + this.cutOffTime + " cannot be edited or cancelled.";

        return (this.showPayOff) ? payOffPaymentMessage : (this.showEasyPay) ? EZPMessage : "";
    }

}