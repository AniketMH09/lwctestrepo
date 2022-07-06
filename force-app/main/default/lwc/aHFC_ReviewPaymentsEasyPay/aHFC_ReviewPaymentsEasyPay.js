/*  * lWC                :    AHFC_ReviewPaymentsEasyPay
 * description        :    This Component is used to display review payment page of EasyPay
 * modification Log   :    Modified by 
 * ---------------------------------------------------------------------------
 * developer                   Date                   Description
 * ---------------------------------------------------------------------------
 * Aswin Deepak Jose         24-JUNE-2021               Created
 * Edwin Antony              25-JUNE-2021               Modified
 *********************************************************************************/
import { LightningElement, api, track, wire } from "lwc";
import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import easypay from "@salesforce/resourceUrl/AHFC_Easypay";
//import Custom Labels
import AHFC_Payment_Error_Message from "@salesforce/label/c.AHFC_Payment_Error_Message";
import Label_EASYPAY from "@salesforce/label/c.AHFC_ReviewEZP_EASYPAY";
import Label_MonthlyPayAmt from "@salesforce/label/c.AHFC_ReviewEZP_MonthlyPayAmt";
import Label_PaySource from "@salesforce/label/c.AHFC_ReviewEZP_PaySource";
import Label_PaySuccess from "@salesforce/label/c.AHFC_ReviewEZP_PaySuccess";
import Label_ReceiveNotifications from "@salesforce/label/c.AHFC_ReviewEZP_ReceiveNotifications";
import Label_ReviewPaymentLabel from "@salesforce/label/c.AHFC_ReviewEZP_ReviewPaymentLabel";
import Label_WithdrawPayBy from "@salesforce/label/c.AHFC_ReviewEZP_WithdrawPayBy";
import Label_ContinueToDashboard from "@salesforce/label/c.AHFC_ReviewEZP_ContinueToDashboard";

//import apex methods here
import insertPayments from "@salesforce/apex/AHFC_ReviewPaymentDetails.insertEasyPayPayments";
import AHFC_CutOffTime from "@salesforce/label/c.AHFC_CutOffTime";

import spinnerWheelMessage from"@salesforce/label/c.Spinner_Wheel_Message";

//Import static resources
import hondaHeadLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import hondaVehImg from "@salesforce/resourceUrl/AHFC_Honda_Header_Car";
import commPrefDetail from "@salesforce/apex/AHFC_ReviewPaymentDetails.commPrefDetailForEasyPay";
import { getConstants } from "c/ahfcConstantUtil";
import { NavigationMixin, CurrentPageReference } from "lightning/navigation";
import successIcon from "@salesforce/resourceUrl/AHFC_SuccessIcon";
import paymentWithdrawalTnC from "@salesforce/resourceUrl/AHFC_Terms_and_Conditions_pdf";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
//assign the values returned from the getConstants method from util class
const CONSTANTS = getConstants();
export default class AHFC_ReviewPaymentsEasyPay extends NavigationMixin(LightningElement) {
    @track paymentWithdrawalTnCUrl = paymentWithdrawalTnC + "/EasyPay_Terms_and_Conditions.pdf";
    @track isPaymentSuccess = false;
    @api easyPaymentDetails;
    @api strAutoPaymentAmt;
    @api strNextWithdrawlDate;
    @api strPaymentSource;
    @api strpaymentSourceId;
    @api last4accnumofselpaysource;
    @api sacRecordId;
    @api brandName = '';
    @track strCommunicationEmail;
    @track strCommunicationPhone;
    @track CommunicationPreferences = false;
    successIcon = successIcon;
    currentPageReference = null;

    @track Payment_Confirmations_via_Email = false;
    @track Payment_Confirmations_via_Text = false;

    //Aswin
    @track openModalFlag = false;
    @track successMessageUpdateCancel;
    @track showSuccessMessage;
    @track showEasyPaySuccessMsg = false;
    @track paymentAuthorizedOn;

    @track routingSpinner = false;
    @track spinnerMessage = spinnerWheelMessage;
    @track chargeDate;

    //Narain for Us 14480
    @track cutOffTime = AHFC_CutOffTime;


    //To use custom labels in HTML
    label = {
        Label_EASYPAY,
        Label_MonthlyPayAmt,
        Label_PaySource,
        Label_PaySuccess,
        Label_ReceiveNotifications,
        Label_ReviewPaymentLabel,
        Label_WithdrawPayBy,
        Label_ContinueToDashboard
    };

    /** Method Name: connectedCallback
     *  Description:   On Load get data and display details on UI
     *  Developer Name: Edwin Antony
     *  Created Date:   24-June-2021 
     *  User Story :    #4533,4534
     *  Modified By : Aswin Jose
     */

    connectedCallback() {

        this.strAutoPaymentAmt = this.easyPaymentDetails.strAutoPaymentAmt;
        this.strNextWithdrawlDate = new Date(this.easyPaymentDetails.strNextWithdrawlDate.getTime() + this.easyPaymentDetails.strNextWithdrawlDate.getTimezoneOffset() * 60 * 1000);
        console.log('this.strNextWithdrawlDate',this.strNextWithdrawlDate);
        console.log('this.strNextWithdrawlDate',this.easyPaymentDetails.strNextWithdrawlDate);
        this.strpaymentSourceId = this.easyPaymentDetails.strpaymentSourceId;
        this.strPaymentSource = this.easyPaymentDetails.strpaymentSource;
        this.last4accnumofselpaysource = this.easyPaymentDetails.last4accnumofselpaysource;
        this.sacRecordId = this.easyPaymentDetails.sacRecordId;
        this.chargeDate = this.easyPaymentDetails.chargeDate;
        //console.log('this.chargeDate',this.chargeDate);
        //this.cutOffTime = AHFC_CutOffTime ; Narain 
        console.log('this.sacRecordId-->' + this.sacRecordId);
        loadStyle(this, ahfctheme + "/theme.css").then(() => {});

        commPrefDetail({
                finid: this.sacRecordId
            }).then((result) => {
                console.log("commPrefDetail Response", result);
                if (result != null) {
                    if ((result.Email_Address__c != '' || result.Email_Address__c != null) || (result.Text_Number__c != '' || result.Text_Number__c != null)) {
                        this.CommunicationPreferences = true;
                    }

                    this.Payment_Confirmations_via_Email = result.EasyPay_Communications_via_Email__c;
                    this.Payment_Confirmations_via_Text = result.EasyPay_Communications_via_Text__c;
                    this.strCommunicationEmail = result.Email_Address__c;
                    var cleaned = ('' + result.Text_Number__c).replace(/\D/g, '');
                    var match = cleaned.match(/^(1|)?(\d{3})(\d{3})(\d{4})$/);
                    if (match) {
                        var intlCode = (match[1] ? '+1 ' : '');
                        this.strCommunicationPhone = [intlCode, '(', match[2], ') ', match[3], '-', match[4]].join('');
                    }
                } else {
                    this.CommunicationPreferences = false;
                }
            })
            .catch((error) => {
                console.log("error ", error);
                //Record access check exception handling - Supriya Chakraborty 17-Nov-2021
                if(error.body.message == 'invalid access'){
                    this[NavigationMixin.Navigate]({
                        type: "comm__namedPage",
                        attributes: {
                            pageName: "dashboard"
                        }
                    });
                }
            });
    };

    get hondaheadLogoUrl() {
        return hondaHeadLogo;
    }

    get hondaVehImgUrl() {
        return hondaVehImg;
    }

    //redirect to Make A payment screen on Edit Payment button click
    editPayment123() {
        //edit payment link redirect
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },
            state: {
                sacRecordId: this.sacRecordId
            }
        });
    }

    //bug fix edwin

    editPayment() {
        window.scrollTo(0, 0);
        //fire an event to set boolean variable in Parent comp
        const selectedEvent = new CustomEvent("editeasypaypayment", {
            detail: {
                showOneTimePayment: false,
                showPayOff: false,
                showEasyPay: true,
                paymentAmount: this.strAutoPaymentAmt,
                paymentdate: this.strNextWithdrawlDate,
                paymentSource: this.strpaymentSourceId
            }
        });
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }

    //Navigate to dashboard screen on clicking Continue to Dashboard button
    navigateToDashboard() {
        this.continueNavButtonClicked();
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "dashboard"
            }
        });
    }

    //Navigate to dashboard screen on clicking Continue to Dashboard button
    navigatetoPaymentActivityPage() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "manage-payment"
            }
        });
    }


    /** Method Name: handleSubmitPayment
     *  Description:   To insert the payment details to Payment Object
     *  Developer Name: Aswin Jose
     *  Created Date:   24-June-2021 
     *  User Story :    #4533
     *  Modified By : Aswin Jose
     */
    handleSubmitPayment() {
        window.scrollTo(0, 0);
        this.reiviewSubmitButtonClicked();
        // this.isPaymentSuccess = true;
        //this.showEasyPaySuccessMsg =true;
        this.routingSpinner =true;
        var paymentAmt = 0;
        if (this.strAutoPaymentAmt != undefined && this.strAutoPaymentAmt != '')
            paymentAmt = this.strAutoPaymentAmt;
        console.log("finAccId>>>>", this.sacRecordId);
        console.log("this.strpaymentSourceId>>>>", this.strpaymentSourceId);
        console.log("paymentAmt>>>>", paymentAmt);
        console.log("strNextWithdrawlDate>>>>", this.strNextWithdrawlDate);
        console.log("chargeDate>>>>", this.chargeDate);
        console.log('dtScheduleOn      ssssssssss');
        let strNextWithdrawlDateMonth = this.strNextWithdrawlDate.getMonth()+1;
        let dtScheduleOn = this.strNextWithdrawlDate.getFullYear()+'-'+strNextWithdrawlDateMonth+'-'+this.strNextWithdrawlDate.getDate();
        console.log('dtScheduleOn      ssssssssss',dtScheduleOn);
        insertPayments({
                finAccId: this.sacRecordId,
                idPaymentSource: this.strpaymentSourceId,
                decPaymentAmount: paymentAmt,
                dtScheduleOn:  dtScheduleOn,
                chargeDate: this.chargeDate
            }).then((result) => {
                console.log('Payment After Insert' + JSON.stringify(result));
                if (result != null && result != "") {
                    this.routingSpinner =false;
                    this.isPaymentSuccess = true;
                    this.showEasyPaySuccessMsg = true;
                    this.paymentList = result;
                    if(result.length){
                    this.paymentAuthorizedOn = this.formatDate(result[0].PaymentAuthorizedOn__c);
                    }
                    
                } else {
                    this.paymentCreationError();
                    this.isPaymentSuccess = false;
                    this.routingSpinner =false;

                }
            })
            .catch((error) => {
                console.log("error>>>", error);
                //Record access check exception handling - Supriya Chakraborty 17-Nov-2021
                if(error.body.message == 'invalid access'){
                    this[NavigationMixin.Navigate]({
                        type: "comm__namedPage",
                        attributes: {
                            pageName: "dashboard"
                        }
                    });
                }
                this.error = error;
                this.routingSpinner =false;
                this.paymentCreationError();
            });
    }
    reiviewSubmitButtonClicked() {
        
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
    paymentCreationError() {
        const event = new ShowToastEvent({
            title: "Error",
            message: "There was an error saving your information", //AHFC_Payment_Error_Message,
            variant: "error",
            mode: "dismissable"
        });
        this.dispatchEvent(event);
    }

    /*

          //For US:3797 Aswin Jose Test
          openModalMethod(){
            this.openModalFlag = true;
            this.successMessageUpdateCancel = false;
          }

          closePopUp(event){
            //access object parameters and assign the value
            this.openModalFlag= event.detail.closemodalflag;
            this.successmessage= event.detail.successmessagevalue;
            console.log('from child'+this.successmessage+ '' +this.openModalFlag);

            if(!this.successmessage ==''){
              this.showSuccessMessage = this.successmessage;
              this.openModalFlag = false;
              this.successMessageUpdateCancel = true;
            }
          }
         //For US:3797 Aswin Jose Test
    */
    onCloseToast() {
        console.log('close');
        this.showEasyPaySuccessMsg = false;
        // this.successMessageUpdateCancel = false;
    }


    /** Method Name:    formatDate
     *  Description:    format the date in Aug 3, 2021
     *  Developer Name: Edwin
     *  Created Date:   20-july-2021 
     *  User Story :    4534
     **/
    formatDate(dt) {
        try {
            let formatdate = new Date(dt);
            formatdate = new Date(formatdate.getTime() + formatdate.getTimezoneOffset() * 60 * 1000);
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
        } catch (e) {
            console.log('Exception format date:' + e);
        }
    }

    //navigate to contact us page
    NavigateToContactUsPage() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-post-login'
            }
        });

    }
}