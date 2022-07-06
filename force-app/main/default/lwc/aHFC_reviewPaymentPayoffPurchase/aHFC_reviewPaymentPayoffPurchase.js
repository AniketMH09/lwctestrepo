/* Apex Class Name       :    aHFC_reviewPaymentPayoffPurchase
    * Description        :    This Component is used to display review payment page of Payoff/Purchase
    * ---------------------------------------------------------------------------
    * Developer                                Date                   Description
    * ---------------------------------------------------------------------------
    
    * Prabu Mohanasundaram                     09/07/2021              Created
    *********************************************************************************/

/* Kanagaraj                                09/27/2021            Modified for US_4594
   Sagar                                    19/11/2021            Modiied for bug fix 22731

 *********************************************************************************/
import { LightningElement, api, track } from 'lwc';
import AHFC_Honda_Contact_Us_URL from "@salesforce/label/c.AHFC_Honda_Contact_Us_URL";
import T_C_Message_1 from "@salesforce/label/c.T_C_Message_1";
import AHFC_Payoff_T_C_Message from "@salesforce/label/c.AHFC_Payoff_T_C_Message";
import T_C_Message_2 from "@salesforce/label/c.T_C_Message_2";
import allTnC from "@salesforce/resourceUrl/AHFC_Terms_and_Conditions_pdf"; //US 3738
import AHFC_PayOff_Payment_Message from "@salesforce/label/c.AHFC_PayOff_Payment_Message";
import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import commPrefDetail from "@salesforce/apex/AHFC_ReviewPaymentDetails.commPrefDetail";
//import getOrgDetail from "@salesforce/apex/AHFC_Payment.getOrgdetail"; Commented By Narain 14480 US
import AHFC_CutOffTime from "@salesforce/label/c.AHFC_CutOffTime";

import insertPayoffPurchasePayments from "@salesforce/apex/AHFC_Payment.insertPayoffPurchasePayments";
import successIcon from "@salesforce/resourceUrl/AHFC_SuccessIcon"; // Added by Kanagaraj for US_4594 start 
import { NavigationMixin } from "lightning/navigation";
//Added by Aswin Jose for bug #11657
import spinnerWheelMessage from "@salesforce/label/c.Spinner_Wheel_Message";
import AHFC_helpCenter_URL from "@salesforce/label/c.AHFC_helpCenter_URL";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import addressErrorMessage from "@salesforce/label/c.AHFC_ReviewPayment_AddressError";
import addressErrorMessageOnSave from "@salesforce/label/c.AHFC_ReviewPayment_AddressErrorOnSave";




//edwin
import getFinannceAccountHandler from "@salesforce/apex/AHFC_EditFinanceAccount.getFinannceAccountHandler";
import { getConstants } from "c/ahfcConstantUtil";

const CONSTANTS = getConstants();
export default class AHFC_reviewPaymentPayoffPurchase extends NavigationMixin(LightningElement) {
    @api paymenttype;
    @api payoffdate;
    @api paymentsourcenickname;
    @api selectedpaymentsourceid;
    @api paymentwithoutdollar;
    @api payoffbankaccno;
    @api payoffamt;
    @api finaccid;
    @api last4accnumofselpaysource;
    @api selectedpaymentsource;
    @api scheduledon;
    @api brandName = '';
    @track Payment_Confirmations_via_Email = false;
    @track Payment_Confirmations_via_Text = false;
    @track commprefemail;
    @track isPaymentSuccess = false;
    @track commprefphone;
    //@track isSandbox;
    addressErrorMsg = addressErrorMessage;
    addressErrorMsgOnSave = addressErrorMessageOnSave;
    @track isReceivedNotification = false;
    //Added by Aswin Jose for bug #11657
    @track spinnerMessage = spinnerWheelMessage;
    @track routingSpinner = false;
    @track showAddressErrorMessage = false;
    @track cutOffTime = AHFC_CutOffTime;
    @track paymentAuthTnCUrl = allTnC + "/Payment_Withdrawal_Authorization.pdf";

    @track showPayOff = false;
    @track showPurchase = false;

    //US:4595 by edwin starts here
    @track resultData = {
        otherDemographics: {
            lookupID: "",
            cellPhone: "",
            cellPhone2: "",
            homePhone: "",
            placeOfEmployment: "",
            workPhone: ""
        },
        garagingAddress: {
            addressLine1: "",
            addressLine2: "",
            addressType: "",
            city: "",
            state: "",
            zipCode: ""
        },
        billToAddress: {
            addressLine1: "",
            addressLine2: "",
            addressType: "",
            city: "",
            state: "",
            zipCode: "",
            isNullBillingAddress: false
        }
    };



    @track isAddressEditModalOpen = false;
    @track modalHeaderText = 'Edit Address';
    @track nickNameModal = false;
    @track contactInfoModal = false;
    @track garageAddressModal = false;
    @track billingAddressModal = true;
    @track stopFinanceModal = false;
    @track modalBtnSave = 'SAVE';
    @track modalBtnCancel = 'CANCEL';
    @track isUpdateSuccessfully = false;

    @track payoffAuthorizedOn;
    @track isPayOff = false;
    @track confirmationNumber;
    @track isPayoffSuccess = false;
    @track isPayoffSuccessMsg = false;
    @track isAddressUpdatedSucess = false;
    @track getFinanceAccountNum;
    @track addressUpdateFailed = false;
    // Added by Kanagaraj for US_4594 start
    @track successMessage;
    @track purchaseSuccess = false;
    successIcon = successIcon;
    @track addressSection = false;
    @track addressUpdateInQueue = false;
    @track nextStep = false;
    // Added by Kanagaraj for US_4594 end

    //US:4595 by edwin ends here

    label = {
        AHFC_PayOff_Payment_Message,
        T_C_Message_1,
        T_C_Message_2,
        AHFC_Payoff_T_C_Message,
        AHFC_Honda_Contact_Us_URL
    };
    // Added for 4536 - Start -

    /** Method Name: handleSubmitPayment
     *  Description:    handling the submit Payment in Review Payment Screen
     *  Developer Name: Prabu Mohanasundaram
     *  Created Date:   12-Jul-2021 
     *  User Story :    4536
     */
    handleSubmitPayment() {
            //  var paymentAmt = 0; 
            window.scrollTo(0, 0);
            this.reiviewSubmitButtonClicked();
            console.log('444444444444444444444444');
            this.routingSpinner = true;
            if (this.paymentwithoutdollar != undefined && this.paymentwithoutdollar != '' && this.paymentwithoutdollar >= 0)
                insertPayoffPurchasePayments({
                    finAccId: this.finaccid,
                    idPaymentSource: this.selectedpaymentsourceid,
                    decPaymentAmount: this.paymentwithoutdollar,
                    dtScheduleOn: this.scheduledon
                })
                .then((result) => {
                    if (result != null && result != "") {
                        // Added by Kanagaraj for US_4594 start
                        this.routingSpinner = false;
                        if (!this.isPayOff) {
                            this.purchaseSuccess = true;
                        }
                        // Added by Kanagaraj for US_4594 end
                        console.log('result.Finance_Account_Number__r', JSON.stringify(result[0].Finance_Account_Number__r));
                        this.isPayoffSuccess = true;
                        this.isPayoffSuccessMsg = true;
                        this.confirmationNumber = result[0].Confirmation_Number__c;
                        //US:4595 by edwin ,fetching adddress details from web service

                        this.getFinanceAccountNum = result[0].Finance_Account_Number__r.Finance_Account_Number__c;
                        this.getFinanceAccountDetails(result[0].Finance_Account_Number__r.Finance_Account_Number__c);

                        this.isPaymentSuccess = true;
                        this.paymentList = result;
                        if(result.length){
                            this.payoffAuthorizedOn = this.formatDate(result[0].PaymentAuthorizedOn__c);
                        }
                        
                    } else {
                        this.routingSpinner = false;
                        this.paymentCreationError();
                        if (isPayOff) { //US:4595 by edwin
                            isPayoffSuccess = false;
                        }
                    }
                })
                .catch((error) => {
                    //Record access check exception handling - Supriya Chakraborty 17-Nov-2021
                    if(error.body.message == 'invalid access'){
                        this[NavigationMixin.Navigate]({
                            type: "comm__namedPage",
                            attributes: {
                                pageName: "dashboard"
                            }
                        });
                    }
                    this.routingSpinner = false;
                    this.paymentCreationError();
                });
        }
        // Added for 4536 - End
        //Toast Error added for displaying in the UI when the result value is null
    paymentCreationError() {
        const event = new ShowToastEvent({
            title: "Error",
            message: "There was an error saving your information", //AHFC_Payment_Error_Message,
            variant: "error",
            mode: "dismissable"
        });
        this.dispatchEvent(event);
    }

    connectedCallback() {
        loadStyle(this, ahfctheme + "/theme.css").then(() => {});
        if (this.paymenttype === 'Payoff') { //US:4595 by edwin
            this.isPayOff = true;
            this.successMessage = 'Congratulations on submitting your payoff payment!';
            this.showPayOff = true;
        } else {
            this.showPurchase = true;
            this.successMessage = 'Congratulations on your purchase!';
        }

        console.log('####paymenttype:' + this.paymenttype);
        commPrefDetail({
                finid: this.finaccid
            }).then((result) => {
                console.log("commPrefDetail Response", result);
                if (result != null) {
                    this.Payment_Confirmations_via_Email = result.Payment_Confirmations_via_Email__c;
                    this.Payment_Confirmations_via_Text = result.Payment_Confirmations_via_Text__c;
                    this.strCommunicationEmail = result.Email_Address__c;
                    var cleaned = ('' + result.Text_Number__c).replace(/\D/g, '');
                    var match = cleaned.match(/^(1|)?(\d{3})(\d{3})(\d{4})$/);
                    if (match) {
                        var intlCode = (match[1] ? '+1 ' : '');
                        this.strCommunicationPhone = [intlCode, '(', match[2], ') ', match[3], '-', match[4]].join('');
                    }
                    // Added by Kanagaraj for US_4594 start - display the notification part
                    if (this.Payment_Confirmations_via_Email || this.Payment_Confirmations_via_Text) {
                        this.isReceivedNotification = true;
                    }
                    // Added by Kanagaraj for US_4594 end
                }
            })
            .catch((error) => {
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
        // this.OngetOrgDetail(); Commented By Narain US 14480

    };
    //redirect to Make A payment screen on Edit Payment button click
    editPayment() {
        //edit payment link redirect
        
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Make a Payment:Button:Edit Payment",
            "Event_Metadata.action_category": "Payment Review",
            "Page.page_name": "Make a Payment - Setup",
            "Page.site_section": "Make a Payment - Review",
            "Page.brand_name": this.brandName
        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },
            state: {
                sacRecordId: this.finaccid,
                payOff: true
            }

        });
    }
    editReviewPayment() {
        window.scrollTo(0, 0);
        console.log('OnEditReview');
        //fire an event to set boolean variable in Parent comp
        const selectedEvent = new CustomEvent("editreviewpayment", {
            detail: {
                showOneTimePayment: false,
                showPayOff: true,
                showEasyPay: false,
                isReviewPayment: true,
                paymentSource: this.selectedpaymentsourceid
            }
        });
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
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

    /* Commeneted by Narain US 14480 as we are using static values, we defined a custom label
      OngetOrgDetail() {
        getOrgDetail({})
          .then((result) => {
            if (result)
              this.isSandbox =  '12:00 PM';
            else
              this.isSandbox = '2:00 PM';
          })
          .catch((error) => { });
      }

    */
    // US:4595 by edwin starts here
    /** Method Name: getFinanceAccountDetails
     *  Description:   To fetch address details from web service
     *  Developer Name: Edwin Antony
     *  Created Date:   14-July-2021 
     *  User Story :    #4595
     */
    getFinanceAccountDetails(financeAccountNum) {
        this.addressSection = false;
        this.showAddressErrorMessage = false;;
        getFinannceAccountHandler({ financeAccNumber: financeAccountNum })
            .then((result) => {
                if (result !== null) {
                    this.addressSection = true;
                    this.showAddressErrorMessage = false;
                    this.resultData = result;
                    console.log('resultData' + JSON.stringify(result));
                } else {
                    this.addressSection = false;
                    this.showAddressErrorMessage = true;
                }

            })
            .catch((error) => {
                this.addressSection = false;
                this.showAddressErrorMessage = true;
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
    }


    editAddress() {
        this.isAddressEditModalOpen = true;
        window.scrollTo(0, 0); // added by sagar for bug fix 22731
    }


    onModalSave(event) {
        this.addressUpdateFailed = false;
        if (event.detail.modalName === "BillAddress") {
            this.isAddressEditModalOpen = event.detail.isModal;
            var isSussessCode = event.detail.isResponseCode;
            this.isUpdateSuccessfully = event.detail.isUpdateSuccessful;
            if (this.isUpdateSuccessfully == true) {
                this.resultData = JSON.parse(event.detail.resultData);
                if (isSussessCode === '200') {
                    this.isAddressUpdatedSucess = true;
                } else if (isSussessCode === '202') {
                    this.addressUpdateInQueue = true;
                } else {
                    this.addressUpdateFailed = true;
                    this.isAddressUpdatedSucess = false;
                    this.addressUpdateInQueue = false;
                }

            } else {
                this.addressUpdateFailed = true;
                this.isAddressUpdatedSucess = false;
                this.addressUpdateInQueue = false;
                // this.showErrorMessage('An error occurred. Please refresh the page');
            }
        }
    }
    navigateToNextstep() {
        this.nextStep = true;
        window.scrollTo(0, 0);
    }
    onCancelPopup() {
        this.nextStep = false;
    }

    showSuccessMessage(showSuccessMsg) {
        console.log("success message-->" + showSuccessMsg);
        const event = new ShowToastEvent({
            title: "success",
            message: showSuccessMsg,
            variant: "success",
            mode: "dismissable"
        });
        this.dispatchEvent(event);
    }

    showErrorMessage(showErrorMsg) {
        console.log("Erro message-->" + showErrorMsg);
        const event = new ShowToastEvent({
            title: "Error",
            message: showErrorMsg,
            variant: "error",
            mode: "dismissable"
        });
        this.dispatchEvent(event);
    }

    onModalClose(event) {
        this.isAddressEditModalOpen = false;
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

    navigateToContactUsPost() {
        sessionStorage.setItem('salesforce_id', this.finaccid);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-post-login'
            }
        });
    }

    /** Method Name:    formatDate
     *  Description:    format the date in Aug 3, 2021
     *  Developer Name: Edwin
     *  Created Date:   09-july-2021 
     *  User Story :    4988
     **/
    formatDate(dt) {
        try {
            console.log('##formatDate: ' + dt);
            var formatdate = new Date(dt);
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
    onCloseToast() {
        this.isPayoffSuccessMsg = false;
    }

    //Added by Aswin Jose for bug #11657
    navigateTohelpCenter() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'help-center'
            }

        });
    }

    //Changes by Narain For bug 20025
    get confirmationMessage() {


        var purchasePaymentMessage = "Your purchase payment will be credited to your account within 2 business days of your scheduled Purchase Date. Purchases made after " + this.cutOffTime + " cannot be edited or cancelled.";


        var payOffPaymentMessage = "Your payoff payment will be credited to your account within 2 business days of your scheduled Payoff Date. Payoffs made after " + this.cutOffTime + " cannot be edited or cancelled.";

        return (this.showPayOff) ? payOffPaymentMessage : (this.showPurchase) ? purchasePaymentMessage : "";
    }

}

// US:4595 ends here