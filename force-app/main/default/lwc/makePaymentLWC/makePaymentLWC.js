/* Apex Class Name       :    MakePaymentLWC
* Description        :    This Component is used to display make a payment page
* Modification Log   :    Modified by Aakash Solanki and added a new method validateStdPaymentAmount as part of US 3693 for sprint 3
* Modification Log   :    Modified by Sagar Ghadigaonkar and added a new method navigateToMangePaymentSourcePage as part of US 10994 for sprint 6
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------

* Satish                     14/05/2021              Created
* Akash                      14-June-2021            Modified
* Aswin                      25-06-2021              Modified
* vishnu                     30-06-2021              Modified for US# 4531
* satish                     30-07-2021              Modified for US# 4682 and 8897
* Sagar                      13-08-2021              Modified for US# 10994
* satish                     17-08-2021              Modified for US# 10408
* Sagar Ghadigaonkar         27-10-2021              Modified for Bug Fix 20450,20442,15499
* Sagar Ghadigaonkar         03-11-2021              Modified for bug Fix : 20440
* Sagar Ghadigaonkar         11-09-2021              Modified for bug Fix : 21920
* Aniket Pharakate           03-01-2022              added below code to remove auto populate functionlity
Line NUmber 2302 - this.decStdPaymentAmount=null; 
Line Number 1078 - commented code     
********************************************************************************************/
import {
    LightningElement,
    track,
    wire,
    api
} from "lwc";
import {
    CurrentPageReference,
    NavigationMixin
} from "lightning/navigation";
import {
    loadStyle
} from "lightning/platformResourceLoader";
import {
    getConstants
} from "c/ahfcConstantUtil";
import {
    getMakeAPaymentConstants
} from "c/aHFC_makeAPaymentUtil"
import {
    label
} from "c/aHFC_makeAPaymentUtil";
import FORM_FACTOR from "@salesforce/client/formFactor";

import AHFC_CutOffTime from "@salesforce/label/c.AHFC_CutOffTime";

import getPaymentSources from "@salesforce/apex/AHFC_AddPaymentSourceClass.getPaymentSources";
import managePayOff from "@salesforce/apex/AHFC_AddPaymentSourceClass.managePayOff";
import getPayoffDetails from "@salesforce/apex/AHFC_Payment.payoffPaymentDetail";
//import getOrgDetail from "@salesforce/apex/AHFC_Payment.getOrgdetail";
import getNumberOfPayments from "@salesforce/apex/AHFC_ReviewPaymentDetails.getNumberOfPaymentsAlreadyCreated";


import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import HondaLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import acuraLogo from "@salesforce/resourceUrl/AHFC_Acura_Header_Logo";
import carSvg from "@salesforce/resourceUrl/AHFC_Honda_Header_Car";

//import Custom Labels
import AHFC_Header_AccountNumber from "@salesforce/label/c.AHFC_Header_AccountNumber";
import AHFC_One_Time_Payment_Message from "@salesforce/label/c.AHFC_One_Time_Payment_Message";
import AHFC_PayOff_Payment_Message from "@salesforce/label/c.AHFC_PayOff_Payment_Message";
import AHFC_EasyPay_Payment_Message from "@salesforce/label/c.AHFC_EasyPay_Payment_Message";
import AHFC_Agent_Profile from "@salesforce/label/c.AHFC_Agent_Profile";
import AHFC_EasyPay_Help_Text from "@salesforce/label/c.AHFC_EasyPay_Help_Text";
import AHFC_PayAmt_Help_Text from "@salesforce/label/c.AHFC_PayAmt_Help_Text";
import AHFC_Sch_Help_Text from "@salesforce/label/c.AHFC_Sch_Help_Text";
import AHFC_PrincipalAmount_Help_Text from "@salesforce/label/c.AHFC_PrincipalAmount_Help_Text";
import AHFC_Record_Type_Lease from "@salesforce/label/c.AHFC_Record_Type_Lease";
import AHFC_Record_Type_Retail from "@salesforce/label/c.AHFC_Record_Type_Retail";
import AHFC_Account_Type_Balloon from "@salesforce/label/c.AHFC_Account_Type_Balloon";
import AHFC_makeAPayment_DayRemaining from "@salesforce/label/c.AHFC_makeAPayment_DayRemaining";
import AHFC_makeAPayment_DaysRemaining from "@salesforce/label/c.AHFC_makeAPayment_DaysRemaining";
import PaymentAmount from "@salesforce/label/c.PaymentAmount";
import AHFC_Community_Named_Dashboard from "@salesforce/label/c.AHFC_Community_Named_Dashboard";
import AHFC_Manage_Payment_Source_Added_Message from "@salesforce/label/c.AHFC_Manage_Payment_Source_Added_Message";
import AHFC_Payment_Source_Creation_Error_Message from "@salesforce/label/c.AHFC_Payment_Source_Creation_Error_Message";

// Below labels are part of US 3693 & US 3694
import AHFC_PaymentErrorForBlankAmount from "@salesforce/label/c.AHFC_PaymentErrorForBlankAmount";
import AHFC_PaymentErrorAmountLessThanOne from "@salesforce/label/c.AHFC_PaymentErrorAmountLessThanOne";
import AHFC_AmountExceedsDueAmt from "@salesforce/label/c.AHFC_AmountExceedsDueAmt";
import AHFC_AmountLessThanDueAmt from "@salesforce/label/c.AHFC_AmountLessThanDueAmt";
import AHFC_PaymentGreaterThanPayOff from "@salesforce/label/c.AHFC_PaymentGreaterThanPayOff";
import AHFC_PayAmtGrtrThanPurchaseAmt from "@salesforce/label/c.AHFC_PayAmtGrtrThanPurchaseAmt";
import AHFC_PayAmtGrtrThanPrincipal from "@salesforce/label/c.AHFC_PayAmtGrtrThanPrincipal";
import AHFCPaymentStatusPending from "@salesforce/label/c.AHFCPaymentStatusPending";
import AHFCPaymentStatusProcessing from "@salesforce/label/c.AHFCPaymentStatusProcessing";
import AHFC_SchdPaymtLinkToast from "@salesforce/label/c.AHFC_SchdPaymtLinkToast";
import AHFCPaymentExistsAlready from "@salesforce/label/c.AHFCPaymentExistsAlready";
import spinnerWheelMessage from "@salesforce/label/c.Spinner_Wheel_Message";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import AHFC_Topic_Id_PayoffPurchase from "@salesforce/label/c.AHFC_Topic_Id_PayoffPurchase";


import { fireEvent } from 'c/pubsub';
import {
    labels
} from "c/aHFC_dashboardConstantsUtil"; //US 4710

/*Start US-10994 importing a cuatom label for button Manage Payment Sources */
import AHFC_MakeAPayment_Manage_Payment_Sources from "@salesforce/label/c.AHFC_MakeAPayment_Manage_Payment_Sources";
/*End US-10994 */

import allTnC from "@salesforce/resourceUrl/AHFC_Terms_and_Conditions_pdf"; //US 3738
//assign the values returned from the getConstants method from util class
const CONSTANTS = getConstants();
const CONSTANTSMAKEAPAY = getMakeAPaymentConstants();
import {
    registerListener,
    unregisterAllListeners
} from 'c/pubsub'; 
export default class makePaymentLWC extends NavigationMixin(LightningElement) {
    @track isPayoffPurchaseButtonSectionHandle = false;
    @track paymentSourcePayoff;
    @track isPayoffAccountToggle = false;
    @track isEditReviewPayment = false;
    @track payOffPurchaseMessage = '';
    @track paymentAuthTnCUrl = allTnC + "/Payment_Withdrawal_Authorization.pdf";
    @track showpaymentEligibilityErrorMsg = false; //US: 3686
    @track easyPayLabel = labels; // US 4710
    @api sacRecordId;
    @track labels = label;
    @track paymentwithoutdollar;
    @track isReviewPayoffEdit = false;
    @track purchasereviewdate;
    @track paymentActivityLink;
    @track payTypeChanged =false;
    @track accRecIdFromReviewPayment = null; //added by sagar for Bug Fix 20450
    @track selPayScrFromReviewPayment = null; //added by sagar 
    @track userInfoResult = {
        dblTotalAmountDue: ""
    };
    @track alerts = {};
    @track showPayoffMsg = false;

    @track flags = {
        showErrorMessageAlert: false,
        isModalOpen: false,
        payoffEligible: false,
        payOffEligibleAgent: false,
        otpEligible: false,
        boolOtpEligibleAgent: false,
        recurringpayment: false,
        showPrinicipalAmount: false,
        showOneTimePayment: false,
        showEasyPay: false,
        showPayOff: false,
        showOtpWarning: false,
        showAmountDetails: false,
        recurringpaymentagent: false,
        boolFutureOtpEligible: false,
        boolFutureOtpEligibleAgent: false,
        boolShowStdPaymentAmountMsg: false,
        boolShowAddnlPrincAmountMsg: false,
        boolShowScheduleOnMsg: false,
        showPrinicipalAmountfield: false,
        boolAutomaticPaymentDisabled: false,
        boolShowMonthlyPaymentAmountMsg: false,
        boolRefinanced: false,
        showReviewPayment: false,
        showReviewPayoffPurchasePayment: false,
        showWithdrawalhelptext: false,
        showpastAmountDue: false,
        showfeeDues: false,
        showCurrentAmount: false,
        showScheduledEasypay: false,
        showScheduledOTP: false,
        showScheduledPayments: false,
        showEasypayPopover: false,
        showPaymentHelpPopover: false,
        showSchHelpPopover: false,
        showPrincipalAmtHelpPopover: false,
        showtotalamountlabel: true,
        validatedpayment: true,
        Easypayvalidated: true,
        OTPvalidated: true,
        boolOtpOneTime: true,
        showPaySources: false,
        boolShowSuccessMsg: false,
        isCancelModalOpen: false,
        pastDueStatusFlag: false, //added as part of US 3693 and 3694
        boolViewPaymentActivity: false, //added as part of US 3697
        alreadyScheduleOnMsgShow: false
    }
    @track OTPScheduledpayments = {
        ChargentOrders__Charge_Amount__c: "",
        ChargentOrders__Payment_Start_Date__c: "",
        Next_Withdrawal_Date__c: "",
        isOTP: false,
        isEP: false,
    };
    @track messages = {
        strStdPaymentAmountMsg: "",
        strAddnlPrincAmountMsg: "",
        strScheduleOnMsg: "",
        strMonthlyPaymentAmountMsg: "",
        withdrawalhelptext: "",
        strScheduleOnWarningMsg: "",
        alreadyScheduleOnMsg: ""
    };
    @track userAccountInfo = {};
    @track showPreferredPaymentSource = true;
    @track error;
    @track paymentSourcesList = [];
    @track userprofiletype = "";
    @track decStdPaymentAmount;
    @track decAddnlPricipalAmount;
    @track decAddnlPricipalAmountFromMakeAPayment;
    @track datScheduleOn;
    @track datScheduleOnPayoff;
    @track decMonthlyPaymentAmount;
    @track decRegularMonthlyPayment;
    @track decPayoffAmount = 0.0;
    @track dueAmount;
    @track paymentType;
    @track selPaymentSource;
    @track easypayScheduledDate;
    @track serviceAccountId;
    @track selPaymentSourceId = "";
    @track isAdditionalPrinicipalAmount = false;
    @track strAccountType = "";
    @track strAccountOwner = "";
    @track strLast4AccNumber;
    @track paySourceToLast4AccNumMap = new Map();
    @track datSystemDate;
    @track dbRemainingAmountDue = 0;
    @track isPayOffEligible;
    @track monthlyamount;
    @track showReEnterBankAccNum;
    @track strRemainingAmountDue;
    @track strTotalAmountDue;
    @track strTotalSchedludedAmount;
    @track strPayoffAmount = 0.0;
    @track strMonthlyPaymentAmount;
    @track nextWithdrawldate;
    @track dueOnDay = "";
    @track options = [];
    @track serviceAccountList = [];
    @track listData = CONSTANTS.listData;
    @track chargeDaySelected;
    @track toastType;
    @track toastLabel;
    currentPageReference = null;
    urlStateParameters = null;
    @track accNo;
    @track servAccName;
    @track paymentDisplayStatus = ''; //added as part of US 3693 and 3694
    @track linkonToast = ''; //added as part of US 3693 and 3694
    @track linkonToastWarning = '';
    @track enrolledInEasyPayFlag = false;
    @track showezpay;
    @track isValidationError;
    @track isValidscheduleDate = true;
    @track sixOtpError = false;
    @track sixOtpEZPError = false;
    @track showPayOTPCountGreaterThanSixError = false;
    @track otpWarningFlag = false; //narain bug 20025
    // PayOff/ Purchase start
    @track payoffamt;
    @track confirmationNumber;
    @track authorizedOn;
    @track paymentSourceNickname;
    @track payoffBankAccountNo;
    @track payOffData;
    @track isnewPayment = true;
    @track isvalidatePayoff = false;
    @track isButtonSection = true;
    @track ispaymentSourceCountExceeds;
    // PayOff/ Purchase end
    @track displayPaySourceError = false;
    @track pageRef;
    @track jsonData;
    @track isPaymentNotification = false;
    @track easypayWarning = false;
    @track payoffWarning = false;
    brandName = '';
    @track showDueDate = true;//Bug fix 15476
    @track accntTypeForPurchase = false;
    @track oneTimeAlertMsg;

    //EASY PAY vARIABLES	
    isPayOff = false; // if false record is of pay off else is of purchase	
    showEasyPayReviewPayment = false;
    easyPaymentInfo = {};
    financeAccData = {};
    showDueInEligibilityErrorMsg = false;
    @track enrolledInEasyPayAndSuspended; //added by edwin US 10147 suspended easypay
    // Expose the labels to use in the template.
    label = {
        AHFC_PayOff_Payment_Message,
        AHFC_EasyPay_Payment_Message,
        AHFC_One_Time_Payment_Message,
        AHFC_EasyPay_Help_Text,
        AHFC_Header_AccountNumber,
        PaymentAmount,
        AHFC_PayAmt_Help_Text,
        AHFC_Sch_Help_Text,
        AHFC_PrincipalAmount_Help_Text,
        AHFC_MakeAPayment_Manage_Payment_Sources // Start US-10994 button label (Manage Payment Sources)
    };

    /* Start US-10994 create paymentSourceCountExceeds flag with default value false */
    @track paymentSourceCountExceeds = false;
    /* End US-10994 */
    @track dataValueChanged = false;
    @track showdesktop;
    @track showmobile;
    @track isValidated = true;

    @track easyPayPaymentAmount;
    @track easyPayPaymentDate;
    @track isFromEasyPayReviewPage = false;
    @track validateOTPscheduleDate = false;
    @track spinnerMessage = spinnerWheelMessage;
    @track loadingspinner = true;

    //Added by Aswin Jose for Bug fix : 15544
    @track isOtpEditPayment = false;
    @track otpPaymentAmountFromEditPayment;
    @track otpScheduledOnDateFromEditPayment;
    @track otpPaymentSourceSelectedFromEditPayment;
    @track otpPaymentSrcId;
    @track isOTPReviewEditPaymentFlag = false;
    @track cutOffTime = AHFC_CutOffTime;
    get hondaLogoUrl() {

        return HondaLogo;
    }

    get acuraLogoUrl() {

        return acuraLogo;
    }

    get carImage() {

        return carSvg;
    }
    get confirmationMessage() {
        // var cutOffTime = (AHFC_CutOffTime % 12) || 12;
        if (this.flags.showOneTimePayment) {
            var otpMsg = this.label.AHFC_One_Time_Payment_Message + ' ' + this.cutOffTime + ".";
            return otpMsg;
        }
        if (this.flags.showEasyPay) {
            var EZPContent = "EasyPay payments scheduled for Sunday will process on Monday and be credited to your account as of the payment date. Cancellations by " + this.cutOffTime + " on the payment date will be effective immediately.";
            return EZPContent;
        }
        /* Prabu commented as its not required that confirmationMessage is eligble only if showPayoff is false
        if(this.flags.showPayOff)
         {
             var payOffPaymentMessage = "Your payoff payment will be credited to your account within 2 business days of your scheduled Payoff Date. Payoffs made after " + this.cutOffTime + " cannot be edited or cancelled.";
             return payOffPaymentMessage;
         } */
    }

    /*get purchaseMessage() {

    var purchaseMessageValue = "Your purchase payment will be credited to your account within 2 business days of your scheduled Purchase Date. Purchases made after " + this.cutOffTime + " cannot be edited or cancelled.";

    return purchaseMessageValue;
    } */



    get minDate() {
        return this.datSystemDate;
    }
    get dueDate() {
        if (this.userAccountInfo) {
            const months = CONSTANTS.MONTHS_LC;
            let duedate = new Date(this.userAccountInfo.Next_Due_Date__c);
            duedate = new Date(duedate.getTime() + duedate.getTimezoneOffset() * 60 * 1000);
            return (duedate != CONSTANTS.INVALID_DATE) ? `${months[duedate.getMonth()]} ${duedate.getDate()}, ${duedate.getFullYear()}` : "";
        }
    }
    get daysRemaining() {
        return this.userInfoResult.intDaysUntilDueDate;
    }
    get boolShowDaysRemaining() {
        return this.userInfoResult.intDaysUntilDueDate >= 0 && this.userInfoResult.intDaysUntilDueDate <= 10 ? true : false;
    }
    get labelDaysRemaining() {
        return this.userInfoResult.intDaysUntilDueDate == 1 ? AHFC_makeAPayment_DayRemaining : AHFC_makeAPayment_DaysRemaining;
    }
    get principalBalAmount() {
        if (this.userAccountInfo) {
            return (this.userAccountInfo.Principal_Balance_Amount__c) ? this.formatCurrency(this.userAccountInfo.Principal_Balance_Amount__c) : 0;
        }
    }
    get additionalPaymentAmount() {
        if (this.userAccountInfo) {
            return (this.userAccountInfo.Principal_Balance_Amount__c) ? `Up to ${this.formatCurrency(this.userAccountInfo.Principal_Balance_Amount__c)}` : 0;
        }
    }

    renderedCallback() {
        let firstClass = this.template.querySelector(".main-content");
        fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
        console.log('firstClass.getAttribute-----> ', firstClass.getAttribute('id'));
    }

    connectedCallback() {
        try { 
            // this.manageCutOff(); commented by narain
            loadStyle(this, ahfctheme + "/theme.css").then(() => { });
            if (FORM_FACTOR == this.easyPayLabel.LargeLabel) {
                this.showdesktop = true;
                this.showmobile = false;
            } else if (FORM_FACTOR == this.easyPayLabel.MediumLabel) {
                this.showdesktop = true;
                this.showmobile = false;
            } else {
                this.showdesktop = false;
                this.showmobile = true;
            }
            registerListener('AHFC_Account_Selected', this.getDataFromPubsubEvent, this);
        } catch (error) {
            console.log('error', error)
        }

    }
    disconnectedCallback() {
        unregisterAllListeners(this);
    }
    //pubsub function
    /* Commented by Narain Us 14480
    manageCutOff() {
        getOrgDetail().then((result) => {
            if (result)
                this.cutOffTime = '12:00 PM';
            else
                this.cutOffTime = '2:00 PM';

        }).catch((error) => {});
    } */
    navigateToRieviewPayment() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "review-paymentpage"
            },
        });
    }


    reiviewEditButtonClicked() {
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Make a Payment:Button:Edit Payment",
            "Event_Metadata.action_category": "Payment Review",
            "Page.page_name": "Make a Payment - Setup",
            "Page.site_section": "Make a Payment - Review",
            "Page.brand_name": this.brandName
        };
        fireAdobeEvent(adobedata, 'click-event');
    }

    openmodal() {
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Make a Payment:Button:Add New Payment Source",
            "Event_Metadata.action_category": "Payment Source",
            "Page.page_name": "Make a Payment - Setup",
            "Page.brand_name": this.brandName
        };
        fireAdobeEvent(adobedata, 'click-event');
        this.validateNoOfPaySources();
        this.showReEnterBankAccNum = this.userprofiletype !== AHFC_Agent_Profile ? true : false;

        this.flags.isModalOpen = true;
        const scrollOptions = {
            left: 0,
            top: 0,
            behavior: "smooth"
        };
        window.scrollTo(scrollOptions);
        this.updatePaymentSourceList();

    }
    // Update Payment Sources after modifying
    updatePaymentSourceList() {
        getPaymentSources({
            IdSACRecordVar: this.sacRecordId
        })
            .then((result) => {
                this.showPreferredPaymentSource = (result.length > 0) ? true : false;
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
    }

    // Validating Payment Sources
    validateNoOfPaySources() {
        this.getPaymentSourcesList();
    }

    onCloseToast() {
        this.flags.boolShowSuccessMsg = false;
    }
    formatCurrency(curNumber) {
        var formatter = new Intl.NumberFormat("en-US", {
            style: "currency",
            currency: "USD",
            maximumFractionDigits: 2
        });
        return formatter.format(curNumber);
    }
    formatdecimal(number) {
        if (typeof number != CONSTANTS.UNDEFINED && number !== "" && number !== 0) {
            let decimalcount = 0;
            if (number % 1 !== 0) {
                decimalcount = number.toString().split(".")[1].length || 0;
            }
            if (decimalcount < 2) {
                return parseFloat(number).toFixed(2);
            } else {
                return number;
            }
        } else if (number === 0) {
            return 0.0;
        } else {
            return "";
        }
    }
    formatnumber(number) {
        if (typeof number != CONSTANTS.UNDEFINED && number !== "" && number !== 0) {
            return number.toLocaleString("en-US", {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2 // added by sagar for bug fix 21920
            });
        } else if (number === 0) {
            return "0.00";
        } else {
            return "";
        }
    }

    //Set Payment Source
    checkPaymentSource(event) {
        this.setNotificationOnValuesChanged();
        this.selPaymentSource = event.target.label;
        this.selPaymentSourceId = event.target.getAttribute("data-id");
     //   sessionStorage.setItem('selpaysourceid',this.selPaymentSourceId);
        this.strLast4AccNumber = this.paySourceToLast4AccNumMap.get(this.selPaymentSourceId);
    }


    onNewPaymentModalClose(event) {
        this.flags.isModalOpen = event.detail;
        this.flags.isCancelModalOpen = true;
    }

    formatDate(dt) {
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
    }


    navigateBackToDashboard() {
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Make a Payment:Button:Cancel",
            "Event_Metadata.action_category": "Payment Setup",
            "Page.page_name": "Make a Payment - Setup",
            "Page.brand_name": this.brandName
        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: AHFC_Community_Named_Dashboard
            }
        });
    }
    getDataFromPubsubEvent(data) {
      //  this.selPaymentSourceId = ''; commentd by sagar
        
        if(this.sacRecordId != this.accRecIdFromReviewPayment)
        {
            this.selPayScrFromReviewPayment=null; // added by sagar
        }
        
        this.showDueDate = true;//Bug fix 15476
        this.isPayoffAccountToggle = true;
        let dataValue = JSON.parse(data);
        console.log('data --> 123', JSON.parse(data));
        let accntType =dataValue.serAccRec.Account_Type__c;
        let refiflag = dataValue.serAccRec.Fl_Refinanced__c;
        if((accntType != undefined) && ((accntType =='Lease') || ((accntType == 'Balloon') && ((refiflag == false)))))
        {
            this.accntTypeForPurchase = true;
            this.oneTimeAlertMsg ='You already have a scheduled Purchase payment on this finance account. The payment can be edited until 12:00 p.m. PT.'
        }
        else
        {
            this.accntTypeForPurchase = false;
            this.oneTimeAlertMsg='Attention: You already have a scheduled Payoff payment on this finance account. The payment can be edited until 12:00 p.m. PT.'
        }
        console.log('accntTypeForPurchase------>', this.accntTypeForPurchase);
        this.brandName = dataValue.serAccRec.Honda_Brand__c ? dataValue.serAccRec.Honda_Brand__c : '';
        console.log('data --> 123', this.brandName);
        let adobedata = {
            "Page.page_name": "Make a Payment - Setup",
            "Page.site_section": "Make a Payment - Setup",
            "Page.referrer_url": document.referrer,
            "Page.brand_name": this.brandName
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        if (!this.flags.showReviewPayment) {
            console.log('getDataFromPubsubEvent>>>>>>>>>>>>');
            if (!this.isEasyPayEditpayment) {
                this.displayPaySourceError = false;
                this.jsonData = JSON.parse(data);
                this.sacRecordId = this.jsonData.serAccRec.Id;
                sessionStorage.setItem('salesforce_id', this.sacRecordId);
                this.clearNotificationOnVehicleSwitcherSwitches();

            }

            
            this.limitPaymentBasedOnNumberOfScheduledPayments(); // Added By aswin for bug fix : 15011

           
            if (!this.isOTPReviewEditPaymentFlag && !this.isEasyPayEditpayment && !this.isEditPayoffPurchase) { //bug id 21693
                this.getManagePayoff();

            }
            this.isEditPayoffPurchase = false;
            this.isEasyPayEditpayment = false;
            this.isOTPReviewEditPaymentFlag = false;
        }

        /*Start Added by Sagar for Bug Fix :20442 */
        let paymentAmtInput = this.template.querySelector(".ahfc-input");
        paymentAmtInput.setCustomValidity("");
        paymentAmtInput.reportValidity();

        let schDateInput = this.template.querySelector(".schedule-input");
        schDateInput.setCustomValidity("");
        schDateInput.reportValidity();

        let principalAmtInput = this.template.querySelector(".principal-input");
        principalAmtInput.setCustomValidity("");
        principalAmtInput.reportValidity();

        /*End  for Bug Fix :20442 */

    }
    // Fetching the data from previous pages
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.pageRef = currentPageReference;
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            if (typeof currentPageReference.state.sacRecordId != CONSTANTS.UNDEFINED) {
                // this.sacRecordId = currentPageReference.state.sacRecordId;
            }
            if (typeof currentPageReference.state.showeasypay != CONSTANTS.UNDEFINED && currentPageReference.state.showeasypay) {
                this.flags.showEasyPay = true;
            }
            if (typeof currentPageReference.state.showOTPDefault != CONSTANTS.UNDEFINED && currentPageReference.state.showOTPDefault) {
                this.flags.showOneTimePayment = true;
            }
            if (currentPageReference.state.payOff) {
                console.log('payoffentry');
                this.flags.showPaySources = true;
                this.paymentType = CONSTANTS.PAYOFF_LC;
                this.flags.showPayOff = currentPageReference.state.payOff;
                this.flags.showOneTimePayment = false;
                this.flags.showEasyPay = false;
                this.getPaymentSourcesList();
            }

        }
    }

    handleContinuePaymentActivity() {
        window.location.reload();
    }

    setFinanceAccData(recData) {
        if (!recData.serAccRec.hasOwnProperty('Regular_Monthly_Payment__c')) {
            recData.serAccRec.Regular_Monthly_Payment__c = 0;
        }
        //bug fix 14149 edwin        
        if (this.isFromEasyPayReviewPage) {
            recData.serAccRec.Regular_Monthly_Payment__c = sessionStorage.getItem('easyPayPaymentAmount');
        }

        console.log('easy pay amt >>> ',recData.serAccRec.Regular_Monthly_Payment__c);

        let decEazyPayAmt=this.formatdecimal(recData.serAccRec.Regular_Monthly_Payment__c);

        console.log('decEazyPayAmt >>> ',decEazyPayAmt);

        this.financeAccData = {
            sacRecordId: this.sacRecordId,
            Regular_Monthly_Payment__c: decEazyPayAmt,//recData.serAccRec.Regular_Monthly_Payment__c, //decEazyPayAmt added by sagar for bug fix 21692
            Payoff_Amount__c: recData.decPayoffAmount,
            isPayOff: this.isPayOff,
            Region_Code__c: recData.serAccRec.Region_Code__c,
            dueDate: recData.serAccRec.Next_Due_Date__c,
            nextWithDrawalDate: recData.serAccRec.FA_Next_Withdrawal_Date__c,
            paidToDate: recData.serAccRec.Paid_to_Date__c,
            ChargentOrders__Payment_End_Date__c: recData.serAccRec.Final_Due_Date__c,
            firstDueDate: recData.serAccRec.First_Due_Date__c, // added as part of 20276
            isEditPayment : false

        }; 


        if (this.flags.showEasyPay) {
            if (this.template.querySelector("c-a-h-f-c_make-payment-easy-pay-l-w-c") != null) {
                console.log('fin acc data >>> ',this.financeAccData);
                this.template.querySelector("c-a-h-f-c_make-payment-easy-pay-l-w-c").setAutomaticPaymentAmount(this.financeAccData);
            }
        }
        let nextDuedate = this.userAccountInfo.Next_Due_Date__c;
        let nextWithdrawlDate = this.userAccountInfo.FA_Next_Withdrawal_Date__c;
        let paidToDate = this.userAccountInfo.Paid_to_Date__c;
        console.log(this.financeAccData, 'this.financeAccData');

        // Payoff/Purchase payment US:6061/4535 start   
        getPayoffDetails({
            finAccId: this.sacRecordId
        }).then((result) => {
            if (result) {

                console.log('getPayoffDetails-->', this.showProcessingPayment);
                this.isnewPayment = false;
                if (this.isPayoffPurchaseButtonSectionHandle) {
                    this.isButtonSection = false;
                }
                this.payOffData = result;
                this.payoffamt = this.formatCurrency(this.payOffData.ChargentOrders__Charge_Amount__c);
                this.confirmationNumber = this.payOffData.Confirmation_Number__c;
                this.payoffScheduledOn = this.payOffData.ChargentOrders__Payment_Start_Date__c;
                this.authorizedOn = this.payOffData.PaymentAuthorizedOn__c;
                this.paymentSourceNickname = this.payOffData.Payment_Source_Nickname__r.Payment_Source_Nickname__c;
                this.payoffBankAccountNo = this.payOffData.Payment_Source_Nickname__r.Last_4__c;
                this.flags.boolShowScheduleOnMsg = true;
                this.showPayoffMsg = true;
                this.linkonToast = '';
                this.messages.strScheduleOnMsg = "You already have a scheduled " + this.labels.RadioPayoff + " payment on this finance account. The payment can be edited until " + this.cutOffTime + ".";

                //Added by Narain for bug 20255
                if (this.showProcessingPayment) {
                    console.log('inside boolShowScheduleOnMsg if Tet');
                    this.easypayWarning = true;
                    this.payoffWarning = true;
                    this.linkonToastWarning = AHFC_SchdPaymtLinkToast;
                    this.messages.strScheduleOnWarningMsg = "You already have one or more payment(s) scheduled for this account. ";
                }

            } else {
                console.log('ElseCondition');
                this.isnewPayment = true;
                this.flags.boolShowScheduleOnMsg = this.showProcessingPayment;
                this.payoffamt = this.formatCurrency(recData.serAccRec.Payoff_Amount__c);
                this.paymentwithoutdollar = recData.serAccRec.Payoff_Amount__c;
                this.purchasereviewdate = recData.serAccRec.Good_Through_Date__c;
                this.payoffScheduledOn = this.datScheduleOn;
                if (this.flags.boolShowScheduleOnMsg) {
                    console.log('inside boolShowScheduleOnMsg Tet');
                    this.easypayWarning = true;
                    this.payoffWarning = true;
                    this.linkonToastWarning = AHFC_SchdPaymtLinkToast;
                    this.messages.strScheduleOnWarningMsg = "You already have one or more payment(s) scheduled for this account. ";
                }
                console.log('PayAccToggle', this.isPayoffAccountToggle);
                if (this.isPayoffAccountToggle) {
                    if (this.flags.showPayOff) {
                        if (this.labels.RadioPayoff === 'Payoff') {
                            this.isButtonSection = true;
                            this.onPaymentTypeSelection("Payoff");

                        } else {
                            this.isPayoffPurchaseToggle = true;
                            this.isButtonSection = true;
                            this.onPaymentTypeSelection("Purchase");
                        }
                    }
                }
                this.validatePayoffAmount();
            }
        })
            .catch((error) => {
                console.log('Errorrrr--445>>>', error);
            });
        // Payoff/Purchase payment US:6061/4535 end
    }
    get payoffauthorized() {
        return this.dateFormater(this.authorizedOn);
    }

    get payoffDate() {
        return this.dateFormater(this.payoffScheduledOn);
    }
    dateFormater(selectedDate) {
        const months = CONSTANTS.MONTHS_LC;
        let duedate = new Date(selectedDate);
        duedate = new Date(duedate.getTime() + duedate.getTimezoneOffset() * 60 * 1000);
        return (duedate != CONSTANTS.INVALID_DATE) ? `${months[duedate.getMonth()]} ${duedate.getDate()}, ${duedate.getFullYear()}` : "";
    }

    /* method to clears varibles when we navigate with vehicle switcher*/


    clearVariables() {
        console.log('ClearVariablesInside-->');

        //Added by Narain 20255
        this.showPayoffMsg = false;
        this.easypayWarning = false;
        this.payoffWarning = false;
        this.isPayoffPurchaseButtonSectionHandle = false;
        //this.labels.RadioPayoff = '';
        this.dataValueChanged = false;
        this.showDueInEligibilityErrorMsg = false;
        this.showpaymentEligibilityErrorMsg = false;
        this.flags.boolShowStdPaymentAmountMsg = false;
        this.flags.boolViewPaymentActivity = false;
        this.messages.strStdPaymentAmountMsg = '';
        this.linkonToast = '';
        this.datSystemDate = undefined;
        //this.datScheduleOn = undefined;
        this.datScheduleOn = null; //Added by bug 15444 by Narain
        this.datScheduleOnPayoff = undefined;
        this.userAccountInfo = {};
        this.userInfoResult = {
            dblTotalAmountDue: ""
        };
        this.flags.showScheduledOTP = false;
        this.strAccountType = "";
        this.strAccountOwner = "";
        this.flags.otpEligible = false;
        this.isPayOff = false; //Added by Prabu
        // this.flags.showEasyPay = false;
        this.flags.boolOtpEligibleAgent = false;
        this.dueOnDay = "";
        this.flags.boolRefinanced = false; // added as part of US 3693 & 3694
        this.flags.pastDueStatusFlag = false; // added as part of US 3693 & 3694
        this.flags.boolShowScheduleOnMsg = false;
        this.enrolledInEasyPayFlag = false; // added as part of US 3693 & 3694
        this.dbRemainingAmountDue = 0;
        // this.isPayOff = false;        
        this.payOffData = undefined;
        //  this.payoffamt = undefined;
        this.confirmationNumber = undefined;
        //this.payoffScheduledOn = undefined;
        this.authorizedOn = undefined;
        this.paymentSourceNickname = undefined;
        this.payoffBankAccountNo = undefined;
        //  this.flags.showOneTimePayment = false;
        this.linkonToast = '';
        this.messages.strScheduleOnMsg = '';
        this.paymentwithoutdollar = undefined;
        this.purchasereviewdate = undefined;
        this.decPayoffAmount = 0.0;
        this.strPayoffAmount = 0.0;
        this.strRemainingAmountDue = 0;
        // this.flags.showPaySources = false;
        //  this.paymentType = undefined ;        
        //   this.flags.showOneTimePayment = false;
        //   this.flags.showEasyPay = false;
        //   this.flags.showPayOff = false;   
        //START - Prabu added the code for resolving the bug - 15546
        if (this.isReviewPayoffEdit === false && this.isEditReviewPayment === true) {
            console.log('ReviewInside');
            this.payoffamt = undefined;
            this.payoffScheduledOn = undefined;
            this.isButtonSection = false;
            this.isnewPayment = false;
            this.flags.showPaySources = false;
        }
        //END - Prabu added the code for resolving the bug - 15546
        this.paymentSourceCountExceeds = false;
        //Added by Aswin start - for clearing the flags
        this.showPayOTPCountGreaterThanSixError = false;
        this.showErrorOTPPaymentRecordCount = false;
        //Added by Aswin end - for clearing the flags


        // Added by sagar clear values based on condition bug Id : 15499
        if (this.sacRecordId != this.accRecIdFromReviewPayment) {
            this.decStdPaymentAmount = null;
            this.decAddnlPricipalAmount = null;


        }
        this.decStdPaymentAmount = 0;
        //Added by sagar end - for clearing values


    }


    @track isLoaded = true;
    //Fetching Payment Data
    getManagePayoff() {

        this.clearVariables();
        this.isLoaded = true;
        managePayOff({
            sacRecID: this.sacRecordId
        })
            .then((result) => {
                console.log('Inside managePayoff',JSON.stringify(result));
                //let ScheduledAmount = 0;
                if (result.datToday) {
                    this.datSystemDate = result.datToday;
                    this.datScheduleOn = result.datToday;
                    this.isValidscheduleDate = true; // added by sagar for bug fix 20442
                    this.datScheduleOnPayoff = this.formatDate(result.datToday);
                    console.log('this.datScheduleOn>>>>>>', this.datScheduleOn);
                }

                this.userInfoResult = result;
                console.log('this.userInfoResult>>>>>>',JSON.parse(JSON.stringify(this.userInfoResult.serAccRec)));
                this.userAccountInfo = result.serAccRec;
                /*Bug fix 15476 Starts*/
                let duedate = new Date(this.userAccountInfo.Next_Due_Date__c);
                duedate = new Date(duedate.getTime() + duedate.getTimezoneOffset() * 60 * 1000);
                this.showDueDate = true;
                if(duedate.getMonth() == 11 && duedate.getFullYear() == 4000 && duedate.getDate() == 31){
                this.showDueDate = false;
                }
                /*Bug fix 15476 Ends*/
                console.log('UserInfoPurchase', this.userAccountInfo.Account_Type__c);
                // Payoff/Purchase payment US:6061/4535 start
                /*  if(this.userAccountInfo.Account_Type__c === 'Lease' || this.userAccountInfo.Account_Type__c === 'Balloon'){
                    this.labels.RadioPayoff = 'Purchase'; 
                    }else{
                    this.labels.RadioPayoff = 'Payoff';
                    } */

                if ((this.userAccountInfo.Account_Type__c === 'Balloon' && this.userAccountInfo.Fl_Refinanced__c === true) ||
                    this.userAccountInfo.Account_Type__c === 'Retail') {
                    console.log('Payoffff');
                    this.labels.RadioPayoff = 'Payoff';
                    this.payOffPurchaseMessage = "Your payoff payment will be credited to your account within 2 business days of your scheduled Payoff Date. Payoffs made after " + this.cutOffTime + " cannot be edited or cancelled.";
                } else {
                    console.log('Purchasee');
                    this.labels.RadioPayoff = 'Purchase';
                    this.payOffPurchaseMessage = "Your purchase payment will be credited to your account within 2 business days of your scheduled Purchase Date. Purchases made after " + this.cutOffTime + " cannot be edited or cancelled.";
                }
                this.accNo = this.userAccountInfo.Finance_Account_Number__c;
                this.servAccName = this.userAccountInfo.AHFC_Product_Nickname__c;
                this.scheduledPaymentDate = result.paymentDate;
                this.strAccountType = result.strAccountType;
                this.strAccountOwner = result.strAccountOwner;
                this.flags.otpEligible = result.boolOtpEligible;
                this.flags.boolOtpEligibleAgent = result.boolOtpEligibleAgent;
                this.dueOnDay = result.dueOnDay;
                this.flags.boolRefinanced = result.boolRefinanced; // added as part of US 3693 & 3694
                this.flags.pastDueStatusFlag = result.pastDueStatus; // added as part of US 3693 & 3694
                //sai changes
                //this.enrolledInEasyPayFlag = result.enrolledInEasyPay; // added as part of US 3693 & 3694
                this.showProcessingPayment = result.pendingOrProcessingFlag; // added as part of US 6061 
                this.enrolledInEasyPayAndSuspended = result.enrolledInEasyPayAndSuspended; //added by edwin US 10147 suspended easypay

                // Payoff/Purchase payment US:6061/4535 End
                //US# 10408 -start
                /* 10408 bug fixes starts */
                let ScheduledAmount = 0;
                let easyPayScheduledAmount = 0;
                /* 10408 bug fixes ends */
                this.OTPScheduledpayments = (result.lstOtpPayments) ? result.lstOtpPayments : "";
                if (result.lstOtpPayments) {
                    for (var i = 0; i < result.lstOtpPayments.length; i++) {
                        if (typeof this.OTPScheduledpayments[i] !== CONSTANTS.UNDEFINED) {
                            if ((this.OTPScheduledpayments[i].RecordType.Name === "Standard One-Time Payment" || this.OTPScheduledpayments[i].RecordType.Name === "Principal One-Time Payment") && (this.OTPScheduledpayments[i].Payment_Display_Status__c === "Pending" || this.OTPScheduledpayments[i].Payment_Display_Status__c === "Processing") && this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c > 0) {
                                if (typeof this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c !== CONSTANTS.UNDEFINED)
                                    if (this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c <= this.userAccountInfo.Next_Due_Date__c) {
                                        this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c = this.formatDate(this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c);
                                        ScheduledAmount += this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c; //10408 bug fix
                                        this.OTPScheduledpayments[i].isOTP = true;
                                        this.OTPScheduledpayments[i].isEP = false;
                                        if (typeof this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c !== CONSTANTS.UNDEFINED)
                                            this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c = this.formatnumber(this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c);
                                    }
                            } else if (this.enrolledInEasyPayFlag && this.OTPScheduledpayments[i].RecordType.Name === "Recurring Payment" && (this.OTPScheduledpayments[i].Payment_Display_Status__c === "Pending" /*|| this.OTPScheduledpayments[i].Payment_Display_Status__c === "Processing"*/) && this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c > 0) { //added suspended status as part of US 10147 by edwin 

                                if (typeof this.OTPScheduledpayments[i].Next_Withdrawal_Date__c !== CONSTANTS.UNDEFINED) {
                                    if (this.OTPScheduledpayments[i].Next_Withdrawal_Date__c <= this.userAccountInfo.Next_Due_Date__c) {

                                        this.OTPScheduledpayments[i].isEP = true;
                                        this.OTPScheduledpayments[i].isOTP = false;
                                        easyPayScheduledAmount += this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c; //10408 bug fix
                                        if (typeof this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c !== CONSTANTS.UNDEFINED)
                                            this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c = this.formatnumber(this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c);
                                    }

                                }
                                //this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c = this.formatDate(this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c);
                                //Added by Aswin Jose for Bug fix : 15491 - Start 
                                console.log('WITHDRAW:' + this.OTPScheduledpayments[i].Next_Withdrawal_Date__c);
                                if (typeof this.OTPScheduledpayments[i].Next_Withdrawal_Date__c !== CONSTANTS.UNDEFINED) {
                                    this.OTPScheduledpayments[i].Next_Withdrawal_Date__c = this.formatDate(this.OTPScheduledpayments[i].Next_Withdrawal_Date__c);
                                }
                                //Added by Aswin Jose for Bug fix : 15491 - End
                            }

                        }
                        console.log('ShowwwwPayofffsss895', this.flags.showPayOff);
                        if (this.enrolledInEasyPayFlag && !this.isReviewPayoffEdit && this.flags.showPayOff === false) {
                            this.flags.showOneTimePayment = true;
                            this.flags.showEasyPay = false;
                        }
                        this.flags.showScheduledOTP = true;
                    }
                }
                //US# 10408 -start


                //checking Payoff or Purchase - 4531	
                this.isPayOff = false;
                console.log('Acc type' + this.strAccountType + '**' + CONSTANTS.ACCOUNT_TYPE_RETAIL);
                if ((this.strAccountType === CONSTANTS.ACCOUNT_TYPE_BALOON && this.flags.boolRefinanced) || this.strAccountType === CONSTANTS.ACCOUNT_TYPE_RETAIL) {
                    this.isPayOff = true;
                }
                console.log('qqq',this.userInfoResult);
                this.setFinanceAccData(this.userInfoResult);
                sessionStorage.setItem('regularPaymentAmount', this.userInfoResult.serAccRec.Regular_Monthly_Payment__c);  
                console.log('this.enrolledInEasyPayFlag>>>>>>>>>>', this.enrolledInEasyPayFlag);
                if (typeof result.dblTotalAmountDue !== CONSTANTS.UNDEFINED && typeof result.dbTotalSchedludedAmount !== CONSTANTS.UNDEFINED) {
                    this.dbRemainingAmountDue = result.dblTotalAmountDue - result.dbTotalSchedludedAmount;
                }
                console.log('result.dblTotalAmountDue>>>>>>> ', result.dblTotalAmountDue);
                console.log('result.dbTotalSchedludedAmount>>>>>>> ', result.dbTotalSchedludedAmount);
                console.log('result.dbRemainingAmountDue>>>>>>> ', this.dbRemainingAmountDue);
                //for payoff amount
                if (typeof result.decPayoffAmount !== CONSTANTS.UNDEFINED) {
                    this.decPayoffAmount = result.decPayoffAmount;
                    console.log('this.decPayoffAmount>>>>>>>>>> ', Number(this.decPayoffAmount));
                    this.decPayoffAmount = this.formatdecimal(this.decPayoffAmount);
                    this.strPayoffAmount = this.formatnumber(result.decPayoffAmount); // added as part of US 3693 & 3694
                }
                /* 10408 bug fixes starts*/
                if (typeof this.userInfoResult.dblTotalAmountDue === CONSTANTS.UNDEFINED) {
                    this.userInfoResult.dblTotalAmountDue = 0;
                }
                let schAmt = ScheduledAmount + easyPayScheduledAmount;
                this.strTotalSchedludedAmount = this.formatdecimal(schAmt);

                console.log('1063>>',this.formatdecimal(this.userInfoResult.dblTotalAmountDue));
                console.log('1064>>',this.userInfoResult.dblTotalAmountDue);
                console.log('1065>>',this.strTotalSchedludedAmount);

                this.strTotalSchedludedAmount =  8.05;
                this.userInfoResult.dblTotalAmountDue = 10.58
                this.strRemainingAmountDue = ((this.formatdecimal(this.userInfoResult.dblTotalAmountDue) * 100) - (Number(this.strTotalSchedludedAmount) * 100) ) / 100;
                //this.strRemainingAmountDue = Number(((this.formatdecimal(this.userInfoResult.dblTotalAmountDue))  - (Number(this.strTotalSchedludedAmount))).toFixed(2));

                console.log('xxx>>', this.strRemainingAmountDue);
                if (this.strRemainingAmountDue < 0) {    
                    this.strRemainingAmountDue = 0
                }  
                console.log('yyy>>', this.strRemainingAmountDue);
                if(this.strRemainingAmountDue != undefined || this.strRemainingAmountDue != ''){
                    this.decStdPaymentAmount = Number(this.formatnumber(this.strRemainingAmountDue).replace(',',''));
                     console.log('qaaa>>',this.decStdPaymentAmount);
                }
               
                
                this.strTotalSchedludedAmount = this.formatnumber(this.strTotalSchedludedAmount); //added by sagar for bug fix 21920 

                console.log('this.strTotalSchedludedAmount  1 >>>> ',this.decStdPaymentAmount);

                /* 10408 bug fixes ends */
                
                if (typeof this.userInfoResult.dblTotalAmountDue !== CONSTANTS.UNDEFINED) {
                    this.strTotalAmountDue = this.userInfoResult.dblTotalAmountDue;
                    this.userInfoResult.dblTotalAmountDue = this.formatdecimal(this.userInfoResult.dblTotalAmountDue);
                    this.strTotalAmountDue = this.formatnumber(this.strTotalAmountDue);
                }



                if (typeof this.userInfoResult.dbTotalSchedludedAmount !== CONSTANTS.UNDEFINED) {
                    // this.strTotalSchedludedAmount = this.userInfoResult.dbTotalSchedludedAmount;//removed as 10408 bug fix
                    this.userInfoResult.dbTotalSchedludedAmount = this.formatdecimal(this.userInfoResult.dbTotalSchedludedAmount);
                    // this.strTotalSchedludedAmount = this.formatnumber(this.strTotalSchedludedAmount);// removed as 10408 bug fix
                }
                if (typeof this.dbRemainingAmountDue !== CONSTANTS.UNDEFINED) {
                    /* 10408 bug fixes starts*/

                    /* 10408 bug fixes ends */
                    //this.strRemainingAmountDue = this.dbRemainingAmountDue;//removed as per 10408 bug fix
                    this.dbRemainingAmountDue = this.formatdecimal(this.dbRemainingAmountDue);
                    this.strRemainingAmountDue = this.formatnumber(this.strRemainingAmountDue);
                }
                if (this.userAccountInfo.Past_Amount_Due__c !== null &&
                    typeof this.userAccountInfo.Past_Amount_Due__c !== CONSTANTS.UNDEFINED &&
                    this.userAccountInfo.Past_Amount_Due__c > 0) {
                    this.flags.showpastAmountDue = true;
                    this.userAccountInfo.Past_Amount_Due__c = this.formatnumber(this.userAccountInfo.Past_Amount_Due__c);
                } else {
                    this.flags.showpastAmountDue = false;
                }
                if (this.userAccountInfo.Total_Fees_Due__c !== null &&
                    typeof this.userAccountInfo.Total_Fees_Due__c !== CONSTANTS.UNDEFINED &&
                    this.userAccountInfo.Total_Fees_Due__c > 0) {
                    this.flags.showfeeDues = true;
                    this.userAccountInfo.Total_Fees_Due__c = this.formatnumber(this.userAccountInfo.Total_Fees_Due__c);
                } else {
                    this.flags.showfeeDues = false;
                }
                if (this.userAccountInfo.Current_Amount_Due__c !== null &&
                    typeof this.userAccountInfo.Current_Amount_Due__c !== CONSTANTS.UNDEFINED &&
                    this.userAccountInfo.Current_Amount_Due__c > 0) {
                    this.flags.showCurrentAmount = true;
                    this.userAccountInfo.Current_Amount_Due__c = this.formatnumber(this.userAccountInfo.Current_Amount_Due__c);
                } else {
                    this.flags.showCurrentAmount = false;
                }
                if (result.dbEasypayAmount !== null && typeof result.dbEasypayAmount !== CONSTANTS.UNDEFINED && result.dbEasypayAmount !== 0.0) {
                    this.flags.showScheduledEasypay = true;
                    this.userInfoResult.dbEasypayAmount = this.formatnumber(this.userInfoResult.dbEasypayAmount);
                }
                this.flags.showScheduledPayments = result.dbTotalSchedludedAmount > 0 ? true : false;

                this.easypayScheduledDate = this.flags.showScheduledEasypay === true ? typeof result.dtScheduledDate !== CONSTANTS.UNDEFINED ? this.formatDate(this.userInfoResult.dtScheduledDate) : "" : "";

                this.error = undefined;
                if (this.isPayoffAccountToggle === false) {
                    this.getPaymentSourcesList();
                }
                console.log('BeforeOneTimeFlagsss');
                if (this.flags.showEasyPay) { // US : 3728(Added enroll flag) - Added by vishnu mohan
                    this.onPaymentTypeSelection("Enroll in EasyPay");
                }
                console.log('ShowwwwPayofffsss', this.flags.showPayOff);
                console.log('www>>',this.decStdPaymentAmount);
                if (this.flags.showOneTimePayment && this.flags.showPayOff === false) { // US : 8396 - Added by Aswin Jose
                    console.log('line#1000');
                   this.onPaymentTypeSelection("One-Time");
                }
                //  this.limitPaymentBasedOnNumberOfScheduledPayments();  //Commented by Aswin for bug fix : 15011
                if (this.isPayoffAccountToggle) {
                    if (this.flags.showPayOff) {
                        if (this.labels.RadioPayoff === 'Payoff') {
                            this.isPayoffPurchaseButtonSectionHandle = true;

                        } else if (this.labels.RadioPayoff === 'Purchase') {
                            this.isPayoffPurchaseButtonSectionHandle = true;
                        } else {
                            this.isPayoffPurchaseButtonSectionHandle = false;
                        }
                    }
                }
                if (this.showProcessingPayment && this.flags.showOneTimePayment) {
                    console.log('line#1020');
                    console.log('AHFC_SchdPaymtLinkToast>>>>', AHFC_SchdPaymtLinkToast);
                    this.flags.alreadyScheduleOnMsgShow = true;
                    this.paymentActivityLink = AHFC_SchdPaymtLinkToast;
                    this.messages.alreadyScheduleOnMsg = "You already have one or more payment(s) scheduled for this account. ";
                } else {
                    this.flags.alreadyScheduleOnMsgShow = false;
                }


                this.isLoaded = false;
                console.log('qqq>>',this.decStdPaymentAmount);
            })
            .catch((error) => {
                //Record access check exception handling - Supriya Chakraborty 11-Nov-2021
                if(error.body.message == 'invalid access'){
                    this[NavigationMixin.Navigate]({
                        type: "comm__namedPage",
                        attributes: {
                            pageName: "dashboard"
                        }
                    });
                }
                this.error = error;
                console.log('error', error);
                this.isLoaded = false;
            });

    }


    /** Method Name: validateStdPaymentAmount
     *  Description:    Validate the inputs of Payment Amount on UI against backend information associated with Finance Account
     *  Developer Name: Akash Solanki
     *  Created Date:   14-June-2021 
     *  User Story :    3693
     */
    validatePayoffAmount() {
        console.log('save>>>>', this.userAccountInfo.Payoff_Amount__c);
        if (this.userAccountInfo.Payoff_Amount__c <= 0) {
            this.isvalidatePayoff = true;
        } else {
            this.isvalidatePayoff = false;
        }
        console.log('save>>>>', this.userAccountInfo.Payoff_Amount__c);
    }

    validateStdPaymentAmount(event) {
        this.setNotificationOnValuesChanged();
        let targetPart = this.template.querySelector(".ahfc-input");
        let principalAmtTargetPart = this.template.querySelector(".principal-input");

        
        this.decStdPaymentAmount = event.detail.value;

        console.log('this.decStdPaymentAmount ' , this.decStdPaymentAmount);
        console.log('this.decAddnlPricipalAmount ' , this.decAddnlPricipalAmount);

        console.log('!this.decStdPaymentAmount ',!this.decStdPaymentAmount);
        console.log('!this.decAddnlPricipalAmount ',!this.decAddnlPricipalAmount);

        

        if (!this.decStdPaymentAmount  && this.flags.showPrinicipalAmount == false) {
            targetPart.setCustomValidity(AHFC_PaymentErrorForBlankAmount);
            this.flags.boolShowStdPaymentAmountMsg = false;
            this.isValidated = false;
            
        } else if (this.decStdPaymentAmount < 1 && this.flags.showPrinicipalAmount == false) { 
            targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            this.flags.boolShowStdPaymentAmountMsg = false;
            this.isValidated = false;
        } 
        /*Start Added by Sagar Bug Fix 20450 adding new conditions */
        else if (this.flags.showPrinicipalAmount == true && !this.decStdPaymentAmount==true && this.decAddnlPricipalAmount<1) {//&& !this.decAddnlPricipalAmount==true
            targetPart.setCustomValidity(AHFC_PaymentErrorForBlankAmount);
            this.flags.boolShowStdPaymentAmountMsg = false;
            this.isValidated = false;
            console.log('1 validate std payment amount');
        } else if (this.flags.showPrinicipalAmount == true && this.decStdPaymentAmount < 1 && !this.decStdPaymentAmount==false && !this.decAddnlPricipalAmount==true) {
            targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            this.flags.boolShowStdPaymentAmountMsg = false;
            this.isValidated = false;
            console.log('2 validate std payment amount');
        }else if(this.flags.showPrinicipalAmount == true && this.decAddnlPricipalAmount < 1 && !this.decAddnlPricipalAmount==false && !this.decStdPaymentAmount==true)
        {
            principalAmtTargetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            this.flags.boolShowStdPaymentAmountMsg = false;
            this.isValidated = false;
            console.log('3 validate std payment amount');
        }else if(this.flags.showPrinicipalAmount == true && !this.decStdPaymentAmount==false && this.decStdPaymentAmount < 1 && !this.decAddnlPricipalAmount==false && this.decAddnlPricipalAmount < 1) 
        {
            targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            principalAmtTargetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            this.flags.boolShowStdPaymentAmountMsg = false;
            this.isValidated = false;
            console.log('4 validate std payment amount');
        }else if(this.flags.showPrinicipalAmount == true  && this.decAddnlPricipalAmount>=1 && !this.decStdPaymentAmount==false && this.decStdPaymentAmount<1)
        {
            targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            principalAmtTargetPart.setCustomValidity("");
            this.flags.boolShowStdPaymentAmountMsg = false;
            this.isValidated = false;
            console.log('5 validate std payment amount');
        }else if(this.flags.showPrinicipalAmount == true && this.decStdPaymentAmount>=1 && !this.decAddnlPricipalAmount==false && this.decAddnlPricipalAmount<1)
        {
            targetPart.setCustomValidity("");
            principalAmtTargetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            this.flags.boolShowStdPaymentAmountMsg = false;
            this.isValidated = false;
            console.log('6 validate std payment amount');
        } 
        /* End Added by Sagar Bug Fix 20450 adding new conditions */
        

        else if (this.decStdPaymentAmount >= 1 && this.decStdPaymentAmount < Number(this.dbRemainingAmountDue)) {
            console.log('Inside Lesser !!!!!', Number(this.dbRemainingAmountDue));
            this.flags.boolShowStdPaymentAmountMsg = true;
            this.linkonToast = '';
            this.messages.strStdPaymentAmountMsg = AHFC_AmountLessThanDueAmt;
            this.isValidated = true;
            targetPart.setCustomValidity("");
            
            if(principalAmtTargetPart!==null)
            {
                principalAmtTargetPart.setCustomValidity("");
            }
            
        } else if (this.decStdPaymentAmount >= 1 && this.decStdPaymentAmount <= Number(this.decPayoffAmount) && this.decStdPaymentAmount > Number(this.dbRemainingAmountDue)) {
            console.log('Inside greater !!!!!', Number(this.dbRemainingAmountDue));
            console.log('Inside greater 2!!!', Number(this.decPayoffAmount));
            this.flags.boolShowStdPaymentAmountMsg = true;
            this.linkonToast = '';
            this.messages.strStdPaymentAmountMsg = AHFC_AmountExceedsDueAmt;
            this.isValidated = true;
            targetPart.setCustomValidity("");
            if(principalAmtTargetPart!==null)
            {
                principalAmtTargetPart.setCustomValidity("");
            }
            
        } else {
            this.flags.boolShowStdPaymentAmountMsg = false;
            this.isValidated = true;
            targetPart.setCustomValidity("");
            if(principalAmtTargetPart!==null)
            {
                principalAmtTargetPart.setCustomValidity("");
            }
            this.linkonToast = '';
            console.log('Inside Else 1!!!!!!');
            
        }

        console.log('this.decStdPaymentAmount >>> ',this.decStdPaymentAmount);
        console.log('this.decPayoffAmount >>> ',this.decPayoffAmount);

        if (this.decStdPaymentAmount >= 1 && this.decStdPaymentAmount >= Number(this.decPayoffAmount)) {
            console.log('decPayoffAmount>>>>>>>>>>>>> greater', this.decStdPaymentAmount);
            if ((this.strAccountType === 'Balloon' && this.userAccountInfo.Fl_Refinanced__c) || this.strAccountType === 'Retail') { //payoff
                this.flags.boolShowStdPaymentAmountMsg = false;
                targetPart.setCustomValidity(AHFC_PaymentGreaterThanPayOff);
                this.isValidated = false;
                console.log('decPayoffAmount>>>>>>>>>>>>> greaterPayoff', this.decStdPaymentAmount);
            } else if (this.strAccountType === 'Lease' || this.strAccountType === 'Balloon') { //purchase
                this.flags.boolShowStdPaymentAmountMsg = false;
                targetPart.setCustomValidity(AHFC_PayAmtGrtrThanPurchaseAmt);
                this.isValidated = false;
                console.log('decPayoffAmount>>>>>>>>>>>>> greaterPurchase', this.decStdPaymentAmount);
            } else {
                this.flags.boolShowStdPaymentAmountMsg = false;
                targetPart.setCustomValidity("");
                if(principalAmtTargetPart!==null)
                {
                  principalAmtTargetPart.setCustomValidity("");
                }
                this.isValidated = true;
                console.log('Inside Else 2!!!!!!');
            }
        }

        // Added by sagar Bug Fix 20440 validate Principal amount on change of std payment amount , if it is invaid amount set custom validity

        if (this.decAddnlPricipalAmount>=1 && this.decAddnlPricipalAmount > this.userAccountInfo.Principal_Balance_Amount__c) {
            if(principalAmtTargetPart!==null)
            {
                principalAmtTargetPart.setCustomValidity(AHFC_PayAmtGrtrThanPrincipal);
                this.isValidated = false;
            }

        }

        // Added by Sagar Bug fix 21920

        if(this.decStdPaymentAmount >= 1 && targetPart.checkValidity()==false)
        {
            this.isValidated = false;  
        }

        if(this.decAddnlPricipalAmount>=1 && principalAmtTargetPart!==null && principalAmtTargetPart.checkValidity()==false)
        {
            this.isValidated = false;  
        }

        // Added by sagar Bug Fix 20440 validate schedule date based on amount and  showPrinicipalAmount flag
        if(this.flags.showPrinicipalAmount == true && !this.decStdPaymentAmount==true && this.decAddnlPricipalAmount>=1)
        {
            this.validateSchDateForAdditionalPrincipalAmt();
        }else{
            this.validateScheduleOnLogic();
        }

        console.log('this.isValidated >>>> ',this.isValidated)
        targetPart.reportValidity();
        principalAmtTargetPart.reportValidity();
    }
    
    /** End of Method validateStdPaymentAmount by Akash Solanki */

    /** Method Name: validateAddnlPricipalAmount
     *  Description:    Valid the inputs of Additional Principal Amount on UI against backend information associated with Finance Account
     *  Developer Name: Akash Solanki
     *  Created Date:   14-June-2021 
     *  User Story :    3694
     */
    validateAddnlPricipalAmount(event) {
        this.setNotificationOnValuesChanged();
        this.decAddnlPricipalAmount = event.detail.value;
        let principalAmtTargetPart = this.template.querySelector(".principal-input");
        let targetPart = this.template.querySelector(".ahfc-input");

        console.log('this.decStdPaymentAmount ' , this.decStdPaymentAmount);
        console.log('this.decAddnlPricipalAmount ' , this.decAddnlPricipalAmount);

        console.log('!this.decStdPaymentAmount ',!this.decStdPaymentAmount);
        console.log('!this.decAddnlPricipalAmount ',!this.decAddnlPricipalAmount);


        /*Start Added by Sagar Bug Fix 20450 adding new conditions */
        if (this.flags.showPrinicipalAmount == true  && !this.decAddnlPricipalAmount==true && this.decStdPaymentAmount<1) { //&& !this.decStdPaymentAmount==true
            targetPart.setCustomValidity(AHFC_PaymentErrorForBlankAmount);
            this.isValidated = false;
            console.log('1 : validate additional principal amount');
        } else if (this.flags.showPrinicipalAmount == true && this.decStdPaymentAmount < 1 && !this.decStdPaymentAmount==false && !this.decAddnlPricipalAmount==true) {
            targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            this.isValidated = false;
            console.log('2 : validate additional principal amount');
        }else if(this.flags.showPrinicipalAmount == true && this.decAddnlPricipalAmount < 1 && !this.decAddnlPricipalAmount==false && !this.decStdPaymentAmount==true)
        {
            principalAmtTargetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            this.isValidated = false;
            console.log('3 : validate additional principal amount');
        }else if(this.flags.showPrinicipalAmount == true && !this.decStdPaymentAmount==false && this.decStdPaymentAmount < 1 && !this.decAddnlPricipalAmount==false && this.decAddnlPricipalAmount < 1) 
        {
            targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            principalAmtTargetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            this.isValidated = false;
            console.log('4 : validate additional principal amount');
        }else if(this.flags.showPrinicipalAmount == true  && this.decAddnlPricipalAmount>=1 && !this.decStdPaymentAmount==false && this.decStdPaymentAmount<1)
        {
            targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            principalAmtTargetPart.setCustomValidity("");
            this.isValidated = false;
            console.log('5 : validate additional principal amount');
        }else if(this.flags.showPrinicipalAmount == true && this.decStdPaymentAmount>=1 && !this.decAddnlPricipalAmount==false && this.decAddnlPricipalAmount<1)
        {
            targetPart.setCustomValidity("");
            principalAmtTargetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            this.isValidated = false;
            console.log('6 : validate additional principal amount');
        }else if (this.decStdPaymentAmount >= 1 && this.decStdPaymentAmount >= Number(this.decPayoffAmount) && ((this.strAccountType === 'Balloon' && this.userAccountInfo.Fl_Refinanced__c) || this.strAccountType === 'Retail' )) {

            targetPart.setCustomValidity(AHFC_PaymentGreaterThanPayOff);
        }else if (this.decStdPaymentAmount >= 1 && this.decStdPaymentAmount >= Number(this.decPayoffAmount) && (this.strAccountType === 'Lease' || this.strAccountType === 'Balloon')) 
        {
            targetPart.setCustomValidity(AHFC_PayAmtGrtrThanPurchaseAmt);  
        } 
        /* End Added by Sagar Bug Fix 20450 adding new conditions */
         else if (this.decAddnlPricipalAmount > this.userAccountInfo.Principal_Balance_Amount__c) {
            principalAmtTargetPart.setCustomValidity(AHFC_PayAmtGrtrThanPrincipal);
            this.isValidated = false;
        } else {
            targetPart.setCustomValidity("");
            principalAmtTargetPart.setCustomValidity("");
            this.isValidated = true;
            console.log('no error');
        }

         // Added by Sagar Bug fix 21920 
        
        if(this.decAddnlPricipalAmount >= 1 && principalAmtTargetPart!==null && principalAmtTargetPart.checkValidity()==false)
        {
            this.isValidated = false;  
        }

        if(this.decStdPaymentAmount >= 1 && targetPart.checkValidity()==false)
        {
            this.isValidated = false;  
        }

        targetPart.reportValidity();
        principalAmtTargetPart.reportValidity();
    }


    /** End of Method validateStdPaymentAmount by Akash Solanki */

    /** Method Name:    validateScheduledWithAnyOtherPayType
     *  Description:    This method will check if finance account already has a due payment with any other options like payoff, EasyPay and OTP
     *  Developer Name: Akash Solanki
     *  Created Date:   15-June-2021 
     *  User Story :    3693 & 3694
     */
    validateScheduledWithAnyOtherPayType() {
        if (this.paymentDisplayStatus === AHFCPaymentStatusPending || this.paymentDisplayStatus === AHFCPaymentStatusProcessing) {
            this.flags.boolShowStdPaymentAmountMsg = true;
            this.flags.boolViewPaymentActivity = true;
            this.messages.strStdPaymentAmountMsg = AHFCPaymentExistsAlready;
            this.linkonToast = AHFC_SchdPaymtLinkToast;
            console.log('Inside linktoast method!!!!! ' + this.linkonToast);
        }
    }

    /** Method Name:    onToastLinkClicked
     *  Description:    This method will take customer to user once they click on view scheduled payment on attention warning.
     *  Developer Name: Akash Solanki
     *  Created Date:   15-June-2021 
     *  User Story :    3693 & 3694
     */

    onToastLinkClicked() {
        //navigate to scheduled payment page
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'manage-payment'
            },
            state: {
                sacRecordId: this.sacRecordId
            }
        });
    }

    /** Method Name:    handleReviewPayment
     *  Description:    This method will check all the input validations on click of review button.
     *  Developer Name: Akash Solanki
     *  Created Date:   15-June-2021 
     *  User Story :    3693 & 3694
     */
    handleReviewPayment(event) {

        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Make a Payment:Button:Review Payment",
            "Event_Metadata.action_category": "Payment Setup",
            "Page.page_name": "Make a Payment - Setup",
            "Page.site_section": "Make a Payment - Review",
            "Page.brand_name": this.brandName
        };
        fireAdobeEvent(adobedata, 'click-event');
        this.displayPaySourceError = true;
        
        //check whether any payment source is selected or not
        if (this.selPaymentSourceId) {
            this.displayPaySourceError = false;
        }
        if (this.flags.showEasyPay) {
            //US 4531 easy pay senerio done here by vishnu
            this.getEasyPayValues();

        } else if (this.flags.showPayOff) {
            console.log('validatePayoff3333');
            this.validatePayoffAmount();
            if (!this.isvalidatePayoff && !this.displayPaySourceError) {
                this.flags.showReviewPayment = true;
                document.body.scrollTop = document.documentElement.scrollTop = 0;
            }
        } else {
            const topDiv = this.template.querySelector('[data-id="stdpaymentAmount"]');
            topDiv.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
            let targetPart = this.template.querySelector(".ahfc-input");
            let principalAmtTargetPart = this.template.querySelector(".principal-input");
            console.log('this.isValidscheduleDate>>>>', this.isValidscheduleDate);
            console.log('<<<<displayPaySourceError flag>>>>', this.displayPaySourceError);
            console.log('<<<<datScheduleOn>>>>', this.datScheduleOn);
            console.log('<<<<isValidated>>>>', this.isValidated);

            if (this.flags.showOneTimePayment && this.isValidated && (this.datScheduleOn != null)) {

                console.log('<<<<inside review payment submit if loop >>>>');

                if (!this.decStdPaymentAmount  && this.flags.showPrinicipalAmount == false) {
                    targetPart.setCustomValidity(AHFC_PaymentErrorForBlankAmount);
                    
                } else if (this.decStdPaymentAmount < 1 && this.flags.showPrinicipalAmount == false) { 
                    targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
        
                } 
                /*Start Added by Sagar Bug Fix 20450 adding new conditions */
                else if (this.flags.showPrinicipalAmount == true && !this.decStdPaymentAmount==true && this.decAddnlPricipalAmount<1) {//&& !this.decAddnlPricipalAmount==true
                    targetPart.setCustomValidity(AHFC_PaymentErrorForBlankAmount);
        
                } else if (this.flags.showPrinicipalAmount == true && this.decStdPaymentAmount < 1 && !this.decStdPaymentAmount==false && !this.decAddnlPricipalAmount==true) {
                    targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
                   
                }else if(this.flags.showPrinicipalAmount == true && this.decAddnlPricipalAmount < 1 && !this.decAddnlPricipalAmount==false && !this.decStdPaymentAmount==true)
                {
                    principalAmtTargetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
                    
                }else if(this.flags.showPrinicipalAmount == true && !this.decStdPaymentAmount==false && this.decStdPaymentAmount < 1 && !this.decAddnlPricipalAmount==false && this.decAddnlPricipalAmount < 1) 
                {
                    targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
                    principalAmtTargetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
        
                }else if(this.flags.showPrinicipalAmount == true  && this.decAddnlPricipalAmount>=1 && !this.decStdPaymentAmount==false && this.decStdPaymentAmount<1)
                {
                    targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
                    principalAmtTargetPart.setCustomValidity("");
                    
                }else if(this.flags.showPrinicipalAmount == true && this.decStdPaymentAmount>=1 && !this.decAddnlPricipalAmount==false && this.decAddnlPricipalAmount<1)
                {
                    targetPart.setCustomValidity("");
                    principalAmtTargetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
                    
                }else if (this.decStdPaymentAmount >= 1 && this.decStdPaymentAmount >= Number(this.decPayoffAmount) && ((this.strAccountType === 'Balloon' && this.userAccountInfo.Fl_Refinanced__c) || this.strAccountType === 'Retail' )) {

                    targetPart.setCustomValidity(AHFC_PaymentGreaterThanPayOff);
                }else if (this.decStdPaymentAmount >= 1 && this.decStdPaymentAmount >= Number(this.decPayoffAmount) && (this.strAccountType === 'Lease' || this.strAccountType === 'Balloon')) 
                {
                    targetPart.setCustomValidity(AHFC_PayAmtGrtrThanPurchaseAmt);  
                } 
                /* End Added by Sagar Bug Fix 20450 adding new conditions */
                else if (this.flags.showPrinicipalAmount && !this.decStdPaymentAmount==true && !this.decAddnlPricipalAmount==false) { // conditions added by sagar 20450 and 20440
                    console.log('validate additional principl amount >>>>> ');
                    this.validatePrincipalAmountOnReviewClick();

                }else if (!this.displayPaySourceError && this.isValidscheduleDate) {
                    console.log('validate schedule date >>>>> ', this.validateOTPscheduleDate);
                    /*if (!this.validateOTPscheduleDate) {
                        console.log('call date validation function >>>> ');
                        this.validateScheduleOnLogic();
                    }*/

                    this.validateScheduleOnLogic();

                    if (this.isValidscheduleDate) {
                        console.log('<<<<line1120 isValidscheduleDate>>>>', this.isValidscheduleDate);
                        this.flags.boolShowStdPaymentAmountMsg = false;
                        targetPart.setCustomValidity("");
                        this.monthlyamount = this.decStdPaymentAmount;
                        this.flags.showReviewPayment = true;
                        document.body.scrollTop = document.documentElement.scrollTop = 0;
                        this.decAddnlPricipalAmountFromMakeAPayment = this.decAddnlPricipalAmount;

                        this.isOTPReviewEditPaymentFlag = true; //Added by Aswin Jose 15544

                    }
                }
                targetPart.reportValidity();
            }

        }
    }
    onChangeSCheduledate(event) {
        console.log('<<<<datScheduleOn>>>>', event.target.value);
        this.datScheduleOn = event.target.value;
    }

    //Setup Make Payment on coming back from Confirm Screen
    @track isEdit = false;

    handleEditPayment(event) {
        this.reiviewEditButtonClicked();
        this.flags.showReviewPayment = false;
        this.flags.showOneTimePayment = event.detail.showOneTimePayment;
        this.flags.showPayOff = event.detail.showPayOff;
        this.flags.showEasyPay = event.detail.showEasyPay;
        this.decStdPaymentAmount = event.detail.otpPaymentAmount; // added by sagar for bug Fix 20450
        this.accRecIdFromReviewPayment = event.detail.financeAccountRecId; // added by sagar for bug Fix 20450
        this.selPayScrFromReviewPayment=event.detail.otpPaymentSourceid;
        console.log('inside edit payment 1 >>>',event.detail.otpPaymentSourceid);
        console.log('inside edit payment 2 >>> ',this.selPayScrFromReviewPayment);
        this.retainSelectedPaymentSource();
        
    }
    @track isEditPayoffPurchase = false;
    //START - Prabu added the code for resolving the bug - 15546
    handlePayoffPurchaseEdit(event) {
        console.log('inside edit payment 1 >>>');
        this.flags.showReviewPayment = false;
        this.flags.showPayOff = true;
        this.isReviewPayoffEdit = true;
        this.isEditReviewPayment = true;
        this.isEditPayoffPurchase = true;
        this.paymentSourcePayoff = event.detail.paymentSource;
        this.selPayScrFromReviewPayment=event.detail.paymentSource;
        this.retainSelectedPaymentSource();
        
    }
    //END - Prabu added the code for resolving the bug - 15546
    //Setup Make Payment on coming back from Easy Pay Confirm Screen  --edwin
    @track isEasyPayEditpayment = false;
    @track paymentSourceId;
    handleEditEasyPayPayment(event) {
        console.log('inside edit payment 1 >>>');
        this.reiviewEditButtonClicked();
        console.log('Easy Pay values: ' + JSON.stringify(event.detail));
        this.isEasyPayEditpayment = true;
        this.flags.showReviewPayment = false;
        this.showEasyPayReviewPayment = false;
        this.flags.showEasyPay = true;
        this.flags.showOneTimePayment = event.detail.showOneTimePayment;
        this.flags.showPayOff = event.detail.showPayOff;

        this.paymentSourceId = event.detail.paymentSource;
        this.selPayScrFromReviewPayment=event.detail.paymentSource;
        this.easyPayPaymentAmount = event.detail.paymentAmount;
        this.easyPayPaymentDate = event.detail.paymentdate;
        sessionStorage.setItem('easyPayPaymentAmount', this.easyPayPaymentAmount);
        this.isFromEasyPayReviewPage = true;
        this.retainSelectedPaymentSource();


        this.financeAccData = {
            sacRecordId: this.sacRecordId,
            Regular_Monthly_Payment__c: this.easyPayPaymentAmount,
            isPayOff: this.isPayOff,
            nextWithDrawalDate: this.easyPayPaymentDate,
            isFromEasyPayReview: this.isFromEasyPayReviewPage,
            ChargentOrders__Payment_End_Date__c: this.userInfoResult.serAccRec.Final_Due_Date__c,
            dueDate: this.userInfoResult.serAccRec.Next_Due_Date__c,
            firstDueDate: this.userInfoResult.serAccRec.First_Due_Date__c ,
            Region_Code__c: this.userInfoResult.serAccRec.Region_Code__c,
            paidToDate: this.userInfoResult.serAccRec.Paid_to_Date__c,
            Payoff_Amount__c: this.userInfoResult.decPayoffAmount,
            isEditPayment : true
            
            
        };
        if (this.template.querySelector("c-a-h-f-c_make-payment-easy-pay-l-w-c") != null) {
            this.template.querySelector("c-a-h-f-c_make-payment-easy-pay-l-w-c").isEditPayment(this.financeAccData); //21693 Bug fix
            //this.template.querySelector("c-a-h-f-c_make-payment-easy-pay-l-w-c").setAutomaticPaymentAmount();//21693 Bug fix
        }



    }
    @track revieButtonEnabled = true;
    disableReviewButton(){
        this.revieButtonEnabled = false;
        console.log('revieButtonEnabled',this.revieButtonEnabled);
    }

    enableReviewButton(){
        this.revieButtonEnabled = true;
    }
    /** Method Name:    validatePrincipalAmountOnReviewClick
     *  Description:    This method will check all the input validations on click of review button for principal amount section.
     *  Developer Name: Akash Solanki
     *  Created Date:   15-June-2021 
     *  User Story :    3693 & 3694
     */
    validatePrincipalAmountOnReviewClick() {

        console.log('validatePayoff');
        let principalAmtTargetPart = this.template.querySelector(".principal-input");
        let targetPart= this.template.querySelector(".ahfc-input");

        /*Start Added by Sagar Bug Fix 20450 adding new conditions */
        if (this.flags.showPrinicipalAmount == true  && !this.decAddnlPricipalAmount==true && this.decStdPaymentAmount<1) { //&& !this.decStdPaymentAmount==true
            targetPart.setCustomValidity(AHFC_PaymentErrorForBlankAmount);
        } else if (this.flags.showPrinicipalAmount == true && this.decStdPaymentAmount < 1 && !this.decStdPaymentAmount==false && !this.decAddnlPricipalAmount==true) {
            targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
        }else if(this.flags.showPrinicipalAmount == true && this.decAddnlPricipalAmount < 1 && !this.decAddnlPricipalAmount==false && !this.decStdPaymentAmount==true)
        {
            principalAmtTargetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
        }else if(this.flags.showPrinicipalAmount == true && !this.decStdPaymentAmount==false && this.decStdPaymentAmount < 1 && !this.decAddnlPricipalAmount==false && this.decAddnlPricipalAmount < 1) 
        {
            targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            principalAmtTargetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
        }else if(this.flags.showPrinicipalAmount == true  && this.decAddnlPricipalAmount>=1 && !this.decStdPaymentAmount==false && this.decStdPaymentAmount<1)
        {
            targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            principalAmtTargetPart.setCustomValidity("");
        }else if(this.flags.showPrinicipalAmount == true && this.decStdPaymentAmount>=1 && !this.decAddnlPricipalAmount==false && this.decAddnlPricipalAmount<1)
        {
            targetPart.setCustomValidity("");
            principalAmtTargetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
        } 
        /* End Added by Sagar Bug Fix 20450 adding new conditions */
        else if (this.decAddnlPricipalAmount > this.userAccountInfo.Principal_Balance_Amount__c) {
            principalAmtTargetPart.setCustomValidity(AHFC_PayAmtGrtrThanPrincipal);
        } else if (!this.displayPaySourceError && this.isValidscheduleDate) {
            console.log('validatePayoff222');
            if (!this.validateOTPscheduleDate) {
                this.validateSchDateForAdditionalPrincipalAmt();
            }
            if (this.isValidscheduleDate) {
                this.flags.boolShowStdPaymentAmountMsg = false;
                targetPart.setCustomValidity("");
                principalAmtTargetPart.setCustomValidity("");
                this.flags.showReviewPayment = true;
                this.monthlyamount = this.decStdPaymentAmount;
                this.decAddnlPricipalAmountFromMakeAPayment = this.decAddnlPricipalAmount;
                document.body.scrollTop = document.documentElement.scrollTop = 0;
                this.isOTPReviewEditPaymentFlag = true;
            }

            console.log('<<<<makeapayment>>>>', this.monthlyamount);
            console.log('<<<<makeapaymentPrincipal>>>>', this.decAddnlPricipalAmountFromMakeAPayment);
        }
        targetPart.reportValidity();
    }

    // Show Deatiled Amount Structure
    displayAmountInfo() {
        this.flags.showAmountDetails = !this.flags.showAmountDetails;
    }
    //Set Up the Type of Payment on Selection of Radio
    checkPaymentType(event) {
        this.payTypeChanged=true;
        this.selPayScrFromReviewPayment=null;
        if (event.target.label == 'One-Time') {
            let adobedata = {
                'Event_Metadata.action_type': 'Radio Button',
                "Event_Metadata.action_label": "Make a Payment:Radio Button:One-Time",
                "Event_Metadata.action_category": "Payment Type",
                "Page.page_name": "Make a Payment - Setup",
                "Page.brand_name": this.brandName
            };
            fireAdobeEvent(adobedata, 'click-event');
        } else if (event.target.label == 'Enroll in EasyPay') {
            let adobedata = {
                'Event_Metadata.action_type': 'Radio Button',
                "Event_Metadata.action_label": "Make a Payment:Radio Button:Enroll in EasyPay",
                "Event_Metadata.action_category": "Payment Type",
                "Page.page_name": "Make a Payment - Setup",
                "Page.brand_name": this.brandName
            };
            fireAdobeEvent(adobedata, 'click-event');
        } else if (event.target.label == 'Payoff') {
            let adobedata = {
                'Event_Metadata.action_type': 'Radio Button',
                "Event_Metadata.action_label": "Make a Payment:Radio Button:Payoff",
                "Event_Metadata.action_category": "Payment Type",
                "Page.page_name": "Make a Payment - Setup",
                "Page.brand_name": this.brandName
            };
            fireAdobeEvent(adobedata, 'click-event');
        } else if (event.target.label == 'Purchase') {
            let adobedata = {
                'Event_Metadata.action_type': 'Radio Button',
                "Event_Metadata.action_label": "Make a Payment:Radio Button:Purchase",
                "Event_Metadata.action_category": "Payment Type",
                "Page.page_name": "Make a Payment - Setup",
                "Page.brand_name": this.brandName
            };
            fireAdobeEvent(adobedata, 'click-event');
        }

        this.onPaymentTypeSelection(event.target.label);

    }

    retainSelectedPaymentSource()
    {
        console.log('inside retainSelectedPaymentSource >>> '+this.selPayScrFromReviewPayment);
        if(this.selPayScrFromReviewPayment!==null)
                {
                    for(var paySource = 0; paySource < this.paymentSourcesList.length; paySource++)
                    {

                       this.paymentSourcesList[paySource].boolIsPreferredSource=(this.paymentSourcesList[paySource].strID==this.selPayScrFromReviewPayment)?true:false;
                       if (this.paymentSourcesList[paySource].boolIsPreferredSource) {
                           this.selPaymentSource = this.paymentSourcesList[paySource].strName;
                           this.selPaymentSourceId = this.paymentSourcesList[paySource].strID;
                           this.strLast4AccNumber = this.paymentSourcesList[paySource].strLast4AccNumber;
                        }
                    }
        
                }
    }

    getPaymentSourcesList() {
        let i;
        this.selPaymentSourceId = '';
        console.log('<<<---this.sacRecordIdsssss>>>>', this.sacRecordId);
        console.log('<<<--- this.flags.showPaySources>>>>', this.flags.showPaySources);
        this.isLoaded = true;
        getPaymentSources({
            IdSACRecordVar: this.sacRecordId
        })
            .then((result) => {
                console.log('<<<<listsssss>>>', result);

                console.log('OTP PAYSOUR' + this.isOTPReviewEditPaymentFlag);

                this.paymentSourcesList = JSON.parse(JSON.stringify(result));

                /*Start  US 10994 :paymentSourceCountExceeds set to true */
                if (this.paymentSourcesList.length >= 4) {
                    this.ispaymentSourceCountExceeds = true;
                    this.paymentSourceCountExceeds = true;
                } else {
                    this.ispaymentSourceCountExceeds = true;

                    this.paymentSourceCountExceeds = false;
                }
                /*End  US 10994 */

                for (i = 0; i < this.paymentSourcesList.length; i++) {
                    this.paymentSourcesList[i].maskedAccNumber = (new Array(10)).join('•') + this.paymentSourcesList[i].strLast4AccNumber;
                    console.log('this.paymentSourcesList[i].maskedAccNumber>>>>>>> ' + this.paymentSourcesList[i].maskedAccNumber);
                    this.paySourceToLast4AccNumMap.set(this.paymentSourcesList[i].strID, this.paymentSourcesList[i].strLast4AccNumber);
                    const theDiv = this.template.querySelector('[data-id="' +this.paymentSourcesList[i].strID+ '"]');
                  //  console.log('pay source >>> ',this.paymentSourcesList[i]);
                  //  console.log('pay source theDiv >>> ',theDiv);
                    if (this.paymentSourcesList[i].boolIsPreferredSource ) {
                        this.selPaymentSource = this.paymentSourcesList[i].strName;
                        this.selPaymentSourceId = this.paymentSourcesList[i].strID;
                        this.strLast4AccNumber = this.paymentSourcesList[i].strLast4AccNumber;
                        if(theDiv!=null){
                        theDiv.checked = true;
                        }
                    }else{
                        this.paymentSourcesList[i].boolIsPreferredSource = false;
                        if(theDiv!=null){
                        theDiv.checked = false; 
                        }
                    }
                    console.log('00000000000000000boolIsPreferredSource',this.paymentSourcesList[i].boolIsPreferredSource);
                    console.log('00000000000000000strName',this.paymentSourcesList[i].strName);
                    console.log('00000000000000000strID',this.paymentSourcesList[i].strID);
                    console.log('00000000000000000strLast4AccNumber',this.paymentSourcesList[i].strLast4AccNumber);
                }


                
                //bug fix 14149 edwin
                
              /*  if (this.isFromEasyPayReviewPage || this.isOTPReviewEditPaymentFlag) {
                    console.log('check payment source selected ...');
                    for (var paySource = 0; paySource < this.paymentSourcesList.length; paySource++) {
                        console.log('check payment source selected ...');
                        console.log('check payment source selected ...');
                        this.paymentSourcesList[paySource].boolIsPreferredSource = (this.paymentSourcesList[paySource].strID === this.paymentSourceId) ? true : false;
                        console.log('Edit Payment 2');
                        if (this.paymentSourcesList[paySource].boolIsPreferredSource) {
                            console.log('Edit Payment 3');
                            this.selPaymentSource = this.paymentSourcesList[paySource].strName;
                            this.selPaymentSourceId = this.paymentSourcesList[paySource].strID;
                            this.strLast4AccNumber = this.paymentSourcesList[paySource].strLast4AccNumber;
                        }
                    }
                    this.isFromEasyPayReviewPage = false;
                }*/

                this.isLoaded = false;
                console.log('<<<<flags.boolShowScheduleOnMsg>>>', this.flags.boolShowScheduleOnMsg);

              
            })
            .catch((error) => {
                this.isLoaded = false;
                this.error = error;
                //Record access check exception handling - Supriya Chakraborty 16-Nov-2021               
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

    // Flag to Display Additional Amount Field
    displayPrincipalAmount() {
        this.flags.showPrinicipalAmount = true;
    }

    // Modified : line 761 and 762 added by Aakash as part of US 3694
    displayPrincipalAmountfield() {
        console.log('Fl_OneTime_Payment_Eligible_Web__c>>> ', this.userAccountInfo.Fl_OneTime_Payment_Eligible_Web__c);
        console.log('RecordType>>> ', this.userAccountInfo.RecordType.Name);
        console.log('strAccountType>>> ', this.strAccountType);
        console.log('boolRefinanced>>> ', this.flags.boolRefinanced);
        console.log('pastDueStatusFlag>>> ', this.flags.pastDueStatusFlag);
        if (this.userAccountInfo != null) {
            if (this.userAccountInfo.Fl_OneTime_Payment_Eligible_Web__c &&
                ((this.strAccountType === 'Balloon' && this.flags.boolRefinanced) || this.strAccountType === 'Retail') &&
                this.flags.pastDueStatusFlag === false) { //added by Aakash as part of US 3694
                this.flags.showPrinicipalAmountfield = true;
                /* Start Added by sager  ,set showPrinicipalAmount flage based on decAddnlPricipalAmount. Bug fix-15499 */
                if (this.decAddnlPricipalAmount > 0) {
                    this.flags.showPrinicipalAmount = true;
                } else {
                    this.flags.showPrinicipalAmount = false;
                }

            } else if (
                (this.userAccountInfo.RecordType.Name === AHFC_Record_Type_Retail &&
                    this.strAccountType === AHFC_Account_Type_Balloon) || this.userAccountInfo.RecordType.Name === AHFC_Record_Type_Lease ||
                !this.userAccountInfo.Fl_OneTime_Payment_Eligible_Web__c) {
                this.flags.showPrinicipalAmountfield = false;
            } else if (this.userAccountInfo.RecordType.Name === AHFC_Record_Type_Retail &&
                this.userAccountInfo.Fl_OneTime_Payment_Eligible_Web__c

            ) {
                this.flags.showPrinicipalAmountfield = false;
            }
        }
    }

    /** Method Name: validateScheduleOn
     *  Description:    Valid the inputs of Scheduled On Date on UI against backend information associated with Finance Account
     *  Developer Name: Surendra Kamma
     *  Created Date:   18-June-2021 
     *  User Story :    #3697
     *  Modified By : Aswin Deepak Jose
     */

    validateScheduleOn(event) {
        this.datScheduleOn = event.detail.value;

        /* added by sagar for Bug Fix :20450 and 20440,  if only additional principal amount is 
        paying call validateSchDateForAdditionalPrincipalAmt otherwise  validateScheduleOnLogic*/

        if(!this.decStdPaymentAmount==true && !this.decAddnlPricipalAmount==false)
		{
           this.validateSchDateForAdditionalPrincipalAmt();
        }else{
            this.validateScheduleOnLogic();
		}
       
    }


    setNotificationOnValuesChanged(event) {
        this.dataValueChanged = true;
        console.log('qewqewq', this.isPaymentNotification);
        if (!this.isPaymentNotification) {
            if (this.template.querySelector('c-a-h-f-c_page-title') != null) {
                this.template.querySelector('c-a-h-f-c_page-title').setValueOnChange();
                this.isPaymentNotification = true;
            }
        }
    }

    clearNotificationOnVehicleSwitcherSwitches() {
        this.dataValueChanged = false;
        if (this.template.querySelector('c-a-h-f-c_page-title') != null) {
            this.template.querySelector('c-a-h-f-c_page-title').clearVariables();
            this.isPaymentNotification = false;
        }
    }

    /* Added by sagar for bug fix 20440 validations for schedule date 
     if user paying only additional principal amount  */

    validateSchDateForAdditionalPrincipalAmt()
    {
        console.log('this.datScheduleOn: ' + this.datScheduleOn);
        console.log('this.userAccountInfo.Maturity_Date__c: ' + this.userAccountInfo.Maturity_Date__c);

        let targetPart = this.template.querySelector(".schedule-input");
        if (targetPart == null) {
            return;
        }

        this.validateOTPscheduleDate = true;

        if (!this.datScheduleOn && (this.datScheduleOn == null || this.datScheduleOn == '' || this.datScheduleOn == undefined)) { // addin new conditons for Bug Fix 20442 this.datScheduleOn == '', this.datScheduleOn == undefined
            console.log('1 Entered Empty Schedule Date');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Select a payment date.");

        } else if (this.datScheduleOn < this.datSystemDate) {
            console.log('2 Entered Past Schedule Date');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be in the past.");
        }else if (this.datScheduleOn > this.userAccountInfo.Maturity_Date__c) {
            console.log('3 Entered  Schedule Date beyond Maturity Date ');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond the Maturity Date of " + this.dateFormater(this.userAccountInfo.Maturity_Date__c));
        }else {
            console.log('no error');
            this.flags.boolShowScheduleOnMsg = true;
            targetPart.setCustomValidity("");
        }

        this.isValidscheduleDate = this.flags.boolShowScheduleOnMsg;
        targetPart.reportValidity();

    }

    validateScheduleOnLogic() {
        console.log('this.datScheduleOn: ' + this.datScheduleOn);
        console.log('this.flags.pastDueStatusFlag: ' + this.flags.pastDueStatusFlag);
        console.log('this.userAccountInfo.Maturity_Date__c: ' + this.userAccountInfo.Maturity_Date__c);
        console.log('this.datSystemDate: ' + this.datSystemDate);
        console.log('this.userAccountInfo.Next_Due_Date__c: ' + this.userAccountInfo.Next_Due_Date__c);

        let targetPart = this.template.querySelector(".schedule-input");
        this.flags.showOtpWarning = false;
        this.validateOTPscheduleDate = true;
        if (targetPart == null) {
            return;
        }
        let dueDate = this.userAccountInfo.Next_Due_Date__c;
        let dueDateForSchDate = this.dateFormater(dueDate);

        let dueDate2 = new Date(this.userAccountInfo.Next_Due_Date__c);
        let schDate = new Date(this.datScheduleOn);
        let todayDate = new Date(this.datSystemDate);
        let paidToDate = this.userAccountInfo.Paid_to_Date__c;
        let paidToDateFormat = new Date(paidToDate);

        console.log('dueDate2--------> ', dueDate2);
        console.log('schDate>>>>>', schDate);
        console.log('paidToDateFormat >>>>>', paidToDateFormat);
        console.log('paidToDate  date diff >>>>>', this.getDPD(new Date(paidToDate), todayDate));


        //let daysPastDue = this.userAccountInfo.AHFC_Total_days_past_due__c;
        let daysPastDue = this.getDPD(new Date(paidToDate), todayDate);
        console.log('daysPastDue >>>>>', daysPastDue);


        let totalDueAmount = this.userInfoResult.dblTotalAmountDue;
        let totalScheduledAmount = this.strTotalSchedludedAmount;

        let remainingAmountDue = this.formatdecimal(totalDueAmount) - totalScheduledAmount;

        if (remainingAmountDue < 0) {
            remainingAmountDue = 0;
        }

        console.log('remainingAmountDue >>>>>', remainingAmountDue);
        console.log('totalDueAmount >>>>>', totalDueAmount);
        console.log('totalScheduledAmount >>>>>', totalScheduledAmount);
        console.log('diff between payment date and due date >>>>> ', this.getDPD(schDate, dueDate2));
        console.log('diff between today date and payment date ', this.getDPD(todayDate, schDate));

        let dueDatePlus10 = new Date(this.userAccountInfo.Next_Due_Date__c);
        dueDatePlus10 = dueDatePlus10.setDate(dueDatePlus10.getDate() + 10);


        console.log('dueDatePlus10 >>>> ', dueDatePlus10);
        console.log('!this.datScheduleOn >>> ', !this.datScheduleOn);


        if (schDate > todayDate && schDate > dueDate2 && remainingAmountDue > 0) {
            console.log('Entered Futured Schedule Date greater than payment due date');
            this.flags.boolShowScheduleOnMsg = true;
            this.flags.showOtpWarning = true;
            this.messages.strScheduleOnMsg = "You are scheduling a payment after your Payment Due Date of " + dueDateForSchDate + ". Please make a payment on or before your Payment Due Date to avoid any additional fees and/or interest.";
            targetPart.setCustomValidity("");
        }
        if (!this.datScheduleOn && (this.datScheduleOn == null || this.datScheduleOn == '' || this.datScheduleOn == undefined)) { // addin new conditons for Bug Fix 20442 this.datScheduleOn == '', this.datScheduleOn == undefined
            console.log('1 Entered Empty Schedule Date');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Select a payment date.");

        } else if (this.datScheduleOn < this.datSystemDate) {
            console.log('2 Entered Past Schedule Date');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be in the past.");
        } else if (this.flags.pastDueStatusFlag == false && this.userAccountInfo.Region_Code__c != "NRC" && this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == true &&
            schDate > dueDatePlus10 && remainingAmountDue > 0) {
            console.log('3 Current Finance non NRC Account- Futer OTP date selected due date+10');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond " + this.addDays(new Date(dueDate2), 10));
        } else if (this.flags.pastDueStatusFlag == false && this.userAccountInfo.Region_Code__c == "NRC" && this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == true &&
            schDate > dueDatePlus10 && remainingAmountDue > 0) {
            console.log('4 Current Finance  NRC Account- Futer OTP date selected due date+10');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond " + this.addDays(new Date(dueDate2), 10));
        } else if (this.flags.pastDueStatusFlag == true && daysPastDue >= 11 && daysPastDue <= 59 && schDate > new Date(this.datSystemDate)) {
            console.log('5 past due account- daysPastDue > 10 with ');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond " + this.dateFormater(this.datSystemDate));
        } else if (this.flags.pastDueStatusFlag == true && this.userAccountInfo.Region_Code__c != "NRC" && this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == true &&
            new Date(paidToDate) < new Date(this.datSystemDate) && daysPastDue <= 10 && schDate > paidToDateFormat.setDate(paidToDateFormat.getDate() + 10) && remainingAmountDue > 0) {
            console.log('6 Current Finance non  NRC Account- Futer OTP date selected paid to date +10');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond " + this.addDays(new Date(paidToDate), 10));
        } else if (this.flags.pastDueStatusFlag == true && this.userAccountInfo.Region_Code__c == "NRC" && this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == true &&
            new Date(paidToDate) < new Date(this.datSystemDate) && daysPastDue <= 10 && schDate > paidToDateFormat.setDate(paidToDateFormat.getDate() + 10) && remainingAmountDue > 0) {
            console.log('7 Current Finance   NRC Account- Futer OTP date selected paid to date +10');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond " + this.addDays(new Date(paidToDate), 10));
        } else if (this.flags.pastDueStatusFlag == false && this.userAccountInfo.Region_Code__c != "NRC" && this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == true &&
            this.datScheduleOn <= this.userAccountInfo.Maturity_Date__c && this.getDPD(todayDate, schDate) > 182 && remainingAmountDue == 0) {
            console.log('8 Current Finance  non NRC Account-  + Sch Payments+ 182 from Today Criteria');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond " + this.addDays(todayDate, 182));
        } else if (this.flags.pastDueStatusFlag == true && this.userAccountInfo.Region_Code__c != "NRC" && this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == true &&
            this.datScheduleOn <= this.userAccountInfo.Maturity_Date__c && paidToDateFormat < todayDate && daysPastDue <= 10 && this.getDPD(todayDate, schDate) > 182 && remainingAmountDue == 0) {
            console.log('9 past due account +10 DPD before Maturity + non NRC + Sch Payments+ 182 from Today Criteria');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond " + this.addDays(todayDate, 182));
        } else if (this.userAccountInfo.Region_Code__c != "NRC" && this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == true &&
            (this.datScheduleOn > this.userAccountInfo.Maturity_Date__c)) {
            console.log('10 Schedule Date > Maturity + !NRC Criteria');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond the Maturity Date of " + this.dateFormater(this.userAccountInfo.Maturity_Date__c));
        } else if (this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == false && schDate > new Date(this.datSystemDate)) {
            console.log('11 Fl_Future_OneTime_Payment_Eligible_Web__c is false');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Payment date cannot be beyond " + this.dateFormater(this.datSystemDate));
        } else {
            console.log('no error');
            this.flags.boolShowScheduleOnMsg = true;
            targetPart.setCustomValidity("");
        }

        this.isValidscheduleDate = this.flags.boolShowScheduleOnMsg;
        targetPart.reportValidity();

    }


    getDPD(startDate, endDate) {
        const diffTime = endDate - startDate;
        const diffDays = diffTime / (1000 * 60 * 60 * 24);
        return diffDays;
    }

    addDays(date, days) {
        const months = CONSTANTS.MONTHS_LC;
        var result = new Date(date.getTime() + date.getTimezoneOffset() * 60 * 1000);
        result.setDate(result.getDate() + days);
        return (result != CONSTANTS.INVALID_DATE) ? `${months[result.getMonth()]} ${result.getDate()}, ${result.getFullYear()}` : "";
    }

    /** Method Name:    getEasyPayValues
     *  Description:    This method is to validate easyPay and throw error if any.
     *  Developer Name: vishnu
     *  Created Date:   12-july-2021 
     *  User Story :    3728
     **/
    validateEasyPayLogic() {
        console.log('Inside validateEasyPayLogic>>>>>>>>>>>>>>>>>>>>>');
        this.showDueInEligibilityErrorMsg = false;
        this.showpaymentEligibilityErrorMsg = false;
        let dueDate2 = new Date(this.userAccountInfo.Next_Due_Date__c);
        let todayDate = new Date(this.datSystemDate);
        console.log('this.getDPD(dueDate2, todayDate)>>>>>>>>>>>>>>>>>>>>>' + this.getDPD(dueDate2, todayDate));
        console.log('this.flags.pastDueStatusFlag>>>>>>>>>>>>>>>>>>>>>' + this.flags.pastDueStatusFlag);

        if (this.flags.pastDueStatusFlag) {
            this.showpaymentEligibilityErrorMsg = true;
            this.showDueInEligibilityErrorMsg = true;
            if (this.template.querySelector("c-a-h-f-c_make-payment-not-eligible-message-l-w-c") != null) {
                this.template.querySelector("c-a-h-f-c_make-payment-not-eligible-message-l-w-c").updatePaymentType(this.paymentType);
            }
        }
        /* else if (this.getDPD(dueDate2, todayDate) > 59) {
                    this.showpaymentEligibilityErrorMsg = true;
                    if (this.template.querySelector("c-a-h-f-c_make-payment-not-eligible-message-l-w-c") != null) {
                        this.template.querySelector("c-a-h-f-c_make-payment-not-eligible-message-l-w-c").updatePaymentType(this.paymentType);
                    }
                }
                console.log('showpaymentEligibilityErrorMsg>>>>>>>>>>>>>>>>>>>>>' + this.showpaymentEligibilityErrorMsg);*/
                //sai changes
                this.showpaymentEligibilityErrorMsg = true;
    }

    //Added by Aswin Jose for US 3686
    checkPaymentEligibility() {
        this.showpaymentEligibilityErrorMsg = false;
        if ((!this.userAccountInfo.Fl_OneTime_Payment_Eligible_Web__c && this.flags.showOneTimePayment) || (!this.userAccountInfo.Fl_Recurring_Payment_Eligible_Web__c && this.flags.showEasyPay) ||
            (!this.userAccountInfo.Fl_Payoff_Payment_Eligible_Web__c && this.flags.showPayOff)) {
            console.log('showErrorMessage222-->');
            this.showpaymentEligibilityErrorMsg = true;
            if (this.template.querySelector("c-a-h-f-c_make-payment-not-eligible-message-l-w-c") != null) {
                this.template.querySelector("c-a-h-f-c_make-payment-not-eligible-message-l-w-c").updatePaymentType(this.paymentType);
            }
        } else if (this.userAccountInfo.Fl_Recurring_Payment_Eligible_Web__c && this.flags.showEasyPay) {
            this.validateEasyPayLogic();
        } else if (this.userAccountInfo.Fl_OneTime_Payment_Eligible_Web__c && this.flags.showOneTimePayment) {
            console.log('showPayOTPCountGreaterThanSixError flag ** 1' + this.showPayOTPCountGreaterThanSixError);
            if (this.showPayOTPCountGreaterThanSixError) {
                this.showErrorOTPPaymentRecordCount = true;
                this.showpaymentEligibilityErrorMsg = true;
                if (this.template.querySelector("c-a-h-f-c_make-payment-not-eligible-message-l-w-c") != null) {
                    this.template.querySelector("c-a-h-f-c_make-payment-not-eligible-message-l-w-c").updatePaymentType(this.paymentType);
                }
            }
        }

        //sai changes
        this.showpaymentEligibilityErrorMsg = false;
    }

    //US: 4017 added by edwin antony
    navigatetoPaymentActivityPage() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "manage-payment"
            }
        });
    }

    savePaymentSource(event) {
        if (event.detail.personName || event.detail.paymentAddedStatus) {
            this.successSaveMsg = `\'${event.detail.personName}' ${AHFC_Manage_Payment_Source_Added_Message}`;
            this.flags.boolShowSuccessMsg = true;
            this.toastType = "success";
            this.toastLabel = "Success";
            this.getPaymentSourcesList();
            this.displayPaySourceError = false;
        } else {
            this.flags.isModalOpen = false;
            this.flags.boolShowSuccessMsg = true;
            this.successSaveMsg = `${AHFC_Payment_Source_Creation_Error_Message}`;
            this.toastType = "error";
            this.toastLabel = "Error";
        }
    }

    onPaymentTypeSelection(paymentTypeLabel) {

        window.console.log('Inside onPaymentTypeSelection:' + paymentTypeLabel);
        window.console.log('Inside this.flags.showPaySources:' + this.flags.showPaySources);

        this.flags.showPaySources = true;
        this.paymentType = paymentTypeLabel;
        const type = paymentTypeLabel;
        window.console.log('Inside this.flags.showPaySources23:' + this.flags.showPaySources);
        //this.decStdPaymentAmount=null;
        switch (type) {
            case "One-Time":
                this.flags.showOneTimePayment = true;
                this.flags.showEasyPay = false;
                this.flags.showPayOff = false;
                this.isButtonSection = true;
                this.validateScheduledWithAnyOtherPayType();
                this.getPaymentSourcesList();
                this.displayPrincipalAmountfield();
                this.otpWarning();
                break;
            case "Enroll in EasyPay":
                this.decStdPaymentAmount=null;
                this.flags.showOneTimePayment = false;
                this.flags.showPayOff = false;
                this.isButtonSection = true;
                //calling this existing method as part of 4531 funtionality
                this.validateScheduledWithAnyOtherPayType();
                this.getPaymentSourcesList(); // Added by Narain Bug 20255
                this.flags.showEasyPay = true;
                break;
            case "Payoff": // payoff US:4535
                this.decStdPaymentAmount=null;
                console.log('PayoffNewPayment', this.isnewPayment)
                this.flags.showPayOff = true;
                this.flags.showOneTimePayment = false;
                this.flags.showEasyPay = false;
                if (!this.isnewPayment) {
                    console.log('NotanNewPayment');
                    this.isButtonSection = false;
                } else {
                    console.log('ItsaNewPayment');
                    this.getPaymentSourcesList();
                }
                break;
            case "Purchase": // purchase US:6061 
                this.decStdPaymentAmount=null;
                console.log('NewwwwPaymentsss', this.isnewPayment);
                this.flags.showPayOff = true;
                this.flags.showOneTimePayment = false;
                this.flags.showEasyPay = false;
                if (!this.isnewPayment) {
                    this.isButtonSection = false;
                } else {
                    this.getPaymentSourcesList();
                }
                break;

        }
        this.checkPaymentEligibility(); //to check the payment type is eligible or not. US : 3696
        if (!this.flags.showPayOff) { }
        if (this.decStdPaymentAmount === 0) {
            this.decStdPaymentAmount = 0.00;
        }
    }


    //Narain bug 20025
    otpWarning() {
        if (this.showProcessingPayment && this.flags.showOneTimePayment) { //added by sagar  bug fix for 22762 
            console.log('inside boolShowScheduleOnMsg');
            this.flags.alreadyScheduleOnMsgShow = true;
            this.paymentActivityLink = AHFC_SchdPaymtLinkToast;
            this.messages.alreadyScheduleOnMsg = "You already have one or more payment(s) scheduled for this account. ";
        }else{
            this.flags.alreadyScheduleOnMsgShow = false;
        }
    }

    /** Method Name:    getEasyPayValues
     *  Description:    This method will call method of child component for geting th values.
     *  Developer Name: vishnu
     *  Created Date:   01-july-2021 
     *  User Story :    4531
     **/
    getEasyPayValues() {
        console.log('Error is visible : ' + this.template.querySelector("c-a-h-f-c_make-payment-easy-pay-l-w-c").boolShowAutoPayAmtMsg);
        this.isValidationError = this.template.querySelector("c-a-h-f-c_make-payment-easy-pay-l-w-c").boolShowAutoPayAmtMsg;

        if (!this.isValidationError && !this.displayPaySourceError) {
            this.template.querySelector("c-a-h-f-c_make-payment-easy-pay-l-w-c").sendEasyPayValues();
            //validation Success 
        }
    }

    /** Method Name:    setEasyPayValues
     *  Description:    gets the values from child component and pass to review child component
     *  Developer Name: vishnu
     *  Created Date:   01-july-2021 
     *  User Story :    4531
     **/
    setEasyPayValues(event) {
        let decEazyPayAmt=this.formatdecimal(event.detail.automaticPaymentAmount);
        console.log('setEasyPayValues >>>>> ',decEazyPayAmt);
        console.log('setEasyPayValues automatic pay amt >>>> ',event.detail.automaticPaymentAmount);
        this.easyPaymentInfo.strAutoPaymentAmt =decEazyPayAmt; // modified by sagar for bug id 21692
        this.easyPaymentInfo.strNextWithdrawlDate = event.detail.setEasyPayDate;
        this.easyPaymentInfo.strpaymentSource = this.selPaymentSource;
        this.easyPaymentInfo.strpaymentSourceId = this.selPaymentSourceId;
        this.easyPaymentInfo.last4accnumofselpaysource = this.strLast4AccNumber;
        this.easyPaymentInfo.sacRecordId = this.sacRecordId;
        this.easyPaymentInfo.chargeDate = event.detail.chargeDate;
        this.showEasyPayReviewPayment = true;
        document.body.scrollTop = document.documentElement.scrollTop = 0;
        this.flags.showReviewPayment = true;
    }

    /** Method Name:    limitPaymentBasedOnNumberOfScheduledPayments
     *  description:    check the number of payments scheduled and restrict user from creating new payments
     *  developer Name: Aswin Jose
     *  created Date:   12-july-2021 
     *  user Story :    3692
     **/

    limitPaymentBasedOnNumberOfScheduledPayments() {
        console.log('LinitNoOfPayments');
        this.showPayOTPCountGreaterThanSixError = false;
        getNumberOfPayments({
            finAccId: this.sacRecordId
        }).then((result) => {
            console.log('<<<<Result check 2>>>', JSON.stringify(result));
            if (result != null && result != "") {
                if (result.sixOtpError || result.sixOtpAndEZPError) {
                    this.showPayOTPCountGreaterThanSixError = true;
                }

                if (this.enrolledInEasyPayFlag) { // US : 4710(Added enroll flag) - Added by Edwin Antony
                    console.log('line#1836');
                    this.flags.showOneTimePayment = true;
                    this.onPaymentTypeSelection("One-Time");
                }
            }
        }).catch((error) => {
            console.log('error Limit', error);
        });
    }


    /** Method Name:    navigateToMangePaymentSourcePage 
     *  Description:    navigate to payment source page 
     *  Developer Name: Sagar
     *  Created Date:   13-Aug-2021 
     *  User Story :    10994
     **/

    navigateToMangePaymentSourcePage() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "payment-source"
            },
            state: {
                sacRecordId: this.sacRecordId
            }
        });
    }

    navigatetoContactUs() {
        console.log("Unknown error");
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "contact-us-post-login"
            }
        });
    }
    navigatetoPurchaseFAQ(){
        let origin = window.location.origin;
        let URLpart1 = origin+'/s/';
        let URLTORedirect = URLpart1+AHFC_Topic_Id_PayoffPurchase;
        window.location.href = URLTORedirect ;
       /* console.log('Origin : '+window.location.origin);
        var origin = window.location.origin;
        var URLpart1 = origin+'/s/'+AHFC_Topic_Id_PayoffPurchase;
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: URLpart1
            }
        }); */
    }

}