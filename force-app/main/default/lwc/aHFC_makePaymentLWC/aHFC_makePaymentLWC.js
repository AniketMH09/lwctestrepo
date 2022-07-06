/* Apex Class Name       :    MakePaymentLWC
    * Description        :    This Component is used to display make a payment page
    * Modification Log   :    Modified by Aakash Solanki and added a new method validateStdPaymentAmount as part of US 3693 for sprint 3
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Satish                     14/05/2021              Created
    * Akash                      14-June-2021            Modified
    * Aswin                      25-06-2021              Modified
    * vishnu                     30-06-2021              Modified
*********************************************************************************/
import { LightningElement,track,wire, api} from "lwc";
import {CurrentPageReference,NavigationMixin} from "lightning/navigation";
import {loadStyle} from "lightning/platformResourceLoader";
import {getConstants} from "c/ahfcConstantUtil";
import {getMakeAPaymentConstants} from "c/aHFC_makeAPaymentUtil"
import {label} from "c/aHFC_makeAPaymentUtil";

import AHFC_CutOffTime from "@salesforce/label/c.AHFC_CutOffTime";

import getPaymentSources from "@salesforce/apex/AHFC_AddPaymentSourceClass.getPaymentSources";
import managePayOff from "@salesforce/apex/AHFC_AddPaymentSourceClass.managePayOff";
import getPayoffDetails from "@salesforce/apex/AHFC_Payment.payoffPaymentDetail";

import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import HondaLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import acuraLogo from "@salesforce/resourceUrl/AHFC_Acura_Header_Logo";
import carSvg from "@salesforce/resourceUrl/AHFC_Honda_Header_Car";
import { fireAdobeEvent } from "c/aHFC_adobeServices";

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
import spinnerWheelMessage from "@salesforce/label/c.Spinner_Wheel_Message";
// Below labels are part of US 3693 & US 3694
import AHFC_PaymentErrorForBlankAmount  from "@salesforce/label/c.AHFC_PaymentErrorForBlankAmount";
import AHFC_PaymentErrorAmountLessThanOne from "@salesforce/label/c.AHFC_PaymentErrorAmountLessThanOne";
import AHFC_AmountExceedsDueAmt from "@salesforce/label/c.AHFC_AmountExceedsDueAmt";
import AHFC_AmountLessThanDueAmt from "@salesforce/label/c.AHFC_AmountLessThanDueAmt";
import AHFC_PaymentGreaterThanPayOff from "@salesforce/label/c.AHFC_PaymentGreaterThanPayOff";
import AHFC_PayAmtGrtrThanPurchaseAmt from "@salesforce/label/c.AHFC_PayAmtGrtrThanPurchaseAmt";
import AHFC_PayAmtGrtrThanPrincipal from "@salesforce/label/c.AHFC_PayAmtGrtrThanPrincipal";
import AHFCPaymentStatusPending from "@salesforce/label/c.AHFCPaymentStatusPending";
import AHFCPaymentStatusProcessing  from "@salesforce/label/c.AHFCPaymentStatusProcessing";
import AHFC_SchdPaymtLinkToast from "@salesforce/label/c.AHFC_SchdPaymtLinkToast";
import AHFCPaymentExistsAlready from "@salesforce/label/c.AHFCPaymentExistsAlready";
import { labels } from "c/aHFC_dashboardConstantsUtil"; //US 4710
//assign the values returned from the getConstants method from util class
const CONSTANTS = getConstants();
const CONSTANTSMAKEAPAY = getMakeAPaymentConstants();

export default class makePaymentLWC extends NavigationMixin(LightningElement) {
  @track showpaymentEligibilityErrorMsg = false; //US: 3686
  @track easyPayLabel = labels; // US 4710
  @api sacRecordId;
  @track labels = label;
  @track userInfoResult = {
    dblTotalAmountDue: ""
  };
  @track alerts = {};
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
    showAmountDetails: false,
    recurringpaymentagent: false,
    boolFutureOtpEligible: false,
    boolFutureOtpEligibleAgent: false,
    boolShowStdPaymentAmountMsg: false,
    boolShowAddnlPrincAmountMsg: false,
    boolShowScheduleOnMsg: false,
    showPrinicipalAmountfield: true,
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
    boolViewPaymentActivity:false, //added as part of US 3697
  
  }
  @track OTPScheduledpayments = {
    ChargentOrders__Charge_Amount__c: "",
    ChargentOrders__Payment_Start_Date__c: ""
  };
  @track messages = {
    strStdPaymentAmountMsg: "",
    strAddnlPrincAmountMsg: "",
    strScheduleOnMsg: "",
    strMonthlyPaymentAmountMsg: "",
    withdrawalhelptext: ""
  };
  @track userAccountInfo = {};
  @track showPreferredPaymentSource = true;
  @track error;
  @track paymentSourcesList = [];
  @track userprofiletype = "";
  @track decStdPaymentAmount = 0.0;
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
  currentPageReference = null;
  urlStateParameters = null;
  @track accNo;
  @track servAccName;
  @track paymentDisplayStatus = ''; //added as part of US 3693 and 3694
  @track linkonToast = ''; //added as part of US 3693 and 3694
  @track enrolledInEasyPayFlag = false;
  @track showezpay;
  @track isValidationError;
  @track spinnerMessage = spinnerWheelMessage;
  @track loadingspinner = true;
  // PayOff/ Purchase start
  @track payoffamt;
  @track confirmationNumber;
  @track authorizedOn;
  @track paymentSourceNickname;
  @track payoffBankAccountNo;
  @track payOffData;
  @track isnewPayment = true;
  @track isvalidatePayoff = false;
  // PayOff/ Purchase end

  //EASY PAY vARIABLES	
  isPayOff = false;// if false record is of pay off else is of purchase	
  showEasyPayReviewPayment = false;	
  easyPaymentInfo={};	
  financeAccData={};
  showDueInEligibilityErrorMsg=false;
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
    AHFC_PrincipalAmount_Help_Text
  };
  get hondaLogoUrl() {
    this.loadingspinner =false;
    return HondaLogo;
  }

  get acuraLogoUrl() {
    return acuraLogo;
  }

  get carImage() {
    return carSvg;
  }
  get confirmationMessage() {
    var cutOffTime = (AHFC_CutOffTime % 12) || 12;
    var EZPContent= "EasyPay payments scheduled for Sunday will process on Monday and be credited to your account as of the payment date. Cancellations by "+cutOffTime+":00 PM Pacific Time on the payment date will be effective immediately.";
    return (this.flags.showOneTimePayment) ? this.label.AHFC_One_Time_Payment_Message : (this.flags.showPayOff) ? this.label.AHFC_PayOff_Payment_Message : (this.flags.showEasyPay) ? EZPContent: "";
  }

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

  connectedCallback() {
    this.loadingspinner =false;
    loadStyle(this, ahfctheme + "/theme.css").then(() => {});
    let adobedata = {
      "Page.page_name": "Make a Payment"
     
  };
  fireAdobeEvent(adobedata, 'PageLoadReady');
  }
 
  navigateToRieviewPayment(){
    console.log('123');
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
          pageName: "review-paymentpage"
      },
    });
  }


  openmodal() {

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
      .catch((error) => {});
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
        minimumFractionDigits: 2
      });
    } else if (number === 0) {
      return "0.00";
    } else {
      return "";
    }
  }

  //Set Payment Source
  checkPaymentSource(event) {
    this.selPaymentSource = event.target.label;
    this.selPaymentSourceId = event.target.getAttribute("data-id");
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
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        pageName: AHFC_Community_Named_Dashboard
      }
    });
  }
  // Fetching the data from previous pages
  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
    if (currentPageReference) {
      this.urlStateParameters = currentPageReference.state;
      if (typeof currentPageReference.state.sacRecordId != CONSTANTS.UNDEFINED) {
        this.sacRecordId = currentPageReference.state.sacRecordId;
      }
      if (typeof currentPageReference.state.showeasypay != CONSTANTS.UNDEFINED && currentPageReference.state.showeasypay) {
        this.flags.showEasyPay = true;
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
      this.getManagePayoff();
    }
  }

  handleContinuePaymentActivity(){
    window.location.reload();
  }

  setFinanceAccData(recData){
    if(!recData.serAccRec.hasOwnProperty('Regular_Monthly_Payment__c')){
      recData.serAccRec.Regular_Monthly_Payment__c = 0;
    }
    this.financeAccData = {sacRecordId:this.sacRecordId,Regular_Monthly_Payment__c:recData.serAccRec.Regular_Monthly_Payment__c,Payoff_Amount__c:recData.decPayoffAmount,isPayOff:this.isPayOff,Region_Code__c:recData.serAccRec.Region_Code__c, dueDate:recData.serAccRec.Next_Due_Date__c, nextWithDrawalDate: recData.serAccRec.FA_Next_Withdrawal_Date__c, paidToDate: recData.serAccRec.Paid_to_Date__c};
    let nextDuedate = this.userAccountInfo.Next_Due_Date__c;
    let nextWithdrawlDate = this.userAccountInfo.FA_Next_Withdrawal_Date__c;
    let paidToDate =this.userAccountInfo.Paid_to_Date__c ;
    console.log(this.financeAccData,'this.financeAccData');

     // Payoff/Purchase payment US:6061/4535 start   
    getPayoffDetails ({
      finAccId:  this.sacRecordId
    }).then((result) => {
      if(result){
        this.isnewPayment = false;
        console.log('resulttttttttttt',JSON.parse(JSON.stringify(result)));
        this.payOffData = result;
        this.payoffamt =  this.formatCurrency(this.payOffData.ChargentOrders__Charge_Amount__c);
        this.confirmationNumber = this.payOffData.Confirmation_Number__c;
        this.payoffScheduledOn = this.payOffData.ChargentOrders__Payment_Start_Date__c;
        this.authorizedOn = this.payOffData.PaymentAuthorizedOn__c;
        this.paymentSourceNickname = this.payOffData.Payment_Source_Nickname__r.Payment_Source_Nickname__c;
        this.payoffBankAccountNo = this.payOffData.Payment_Source_Nickname__r.Last_4__c;
        this.flags.boolShowScheduleOnMsg = true;
        var cutOffTime = (AHFC_CutOffTime % 12) || 12;
        this.linkonToast = '';
        this.messages.strScheduleOnMsg = "You already have a scheduled "+this.labels.RadioPayoff+" payment on this finance account. The payment can be edited until "+cutOffTime+" PM Pacific Time";

      }else{
        this.isnewPayment = true;
        this.flags.boolShowScheduleOnMsg = this.showProcessingPayment;
        this.payoffamt = this.formatCurrency(recData.serAccRec.Payoff_Amount__c);
        this.payoffScheduledOn = recData.serAccRec.Good_Through_Date__c;
        if(this.flags.boolShowScheduleOnMsg){
          this.linkonToast = AHFC_SchdPaymtLinkToast;
          this.messages.strScheduleOnMsg = "You already have one or more payment(s) scheduled for this account. ";
        }
      }
    }) 
    .catch((error) => {
      console.log('Errorrrr--445>>>',error);
    });
    // Payoff/Purchase payment US:6061/4535 end
  }
  get payoffauthorized() {
    return this.dateFormater(this.authorizedOn);
  }

  get payoffDate() {
    return this.dateFormater(this.payoffScheduledOn);
  }
  dateFormater(selectedDate){
    const months = CONSTANTS.MONTHS_LC;
      let duedate = new Date(selectedDate);
      duedate = new Date(duedate.getTime() + duedate.getTimezoneOffset() * 60 * 1000);
      return (duedate != CONSTANTS.INVALID_DATE) ? `${months[duedate.getMonth()]} ${duedate.getDate()}, ${duedate.getFullYear()}` : "";
  }
  // Fetching Payment Data
  getManagePayoff() {
    this.setTheData();
    managePayOff({
        sacRecID: this.sacRecordId
      })
      .then((result) => {
            console.log('Inside managePayoff')
        let ScheduledAmount = 0;
        if (result.datToday) {
          this.datSystemDate = result.datToday;
          this.datScheduleOn = result.datToday;
          this.datScheduleOnPayoff = this.formatDate(result.datToday);
        }

        this.userInfoResult = result;
        console.log('this.userInfoResult>>>>>>',this.userInfoResult);
        this.userAccountInfo = result.serAccRec;
        console.log('UserInfoPurchase',this.userAccountInfo.Account_Type__c);
        // Payoff/Purchase payment US:6061/4535 start
        if(this.userAccountInfo.Account_Type__c === 'Lease' || this.userAccountInfo.Account_Type__c === 'Balloon'){
          this.labels.RadioPayoff = 'Purchase'; 
        }
        // Payoff/Purchase payment US:6061/4535 End
        this.OTPScheduledpayments = (result.lstOtpPayments) ? result.lstOtpPayments : "";
        this.accNo = this.userAccountInfo.Finance_Account_Number__c;
        this.servAccName = this.userAccountInfo.AHFC_Product_Nickname__c;
        for (var i = 0; i < result.lstOtpPayments.length; i++) {
          if (typeof this.OTPScheduledpayments[i] !== CONSTANTS.UNDEFINED) {
            if (this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c < this.userAccountInfo.Next_Due_Date__c)
              ScheduledAmount += this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c;
            if (typeof this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c !== CONSTANTS.UNDEFINED)
              this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c = this.formatnumber(this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c);
            if (typeof this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c !== CONSTANTS.UNDEFINED)
              this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c = this.formatDate(this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c);
              if (typeof this.OTPScheduledpayments[i].Payment_Display_Status__c !== CONSTANTS.UNDEFINED)
              this.paymentDisplayStatus = this.OTPScheduledpayments[i].Payment_Display_Status__c; // added as part of US 3693 & 3694
          }
          this.flags.showScheduledOTP = true;
        }

        if (this.userAccountInfo.FA_Next_Withdrawal_Date__c < this.userAccountInfo.Next_Due_Date__c) {
          ScheduledAmount += this.userAccountInfo.Scheduled_EasyPay_Amount__c;
        }
        this.scheduledPaymentDate = result.paymentDate;
        this.strAccountType = result.strAccountType; 
        this.strAccountOwner = result.strAccountOwner; 
        this.flags.otpEligible = result.boolOtpEligible; 
        this.flags.boolOtpEligibleAgent = result.boolOtpEligibleAgent; 
        this.dueOnDay = result.dueOnDay; 
        this.flags.boolRefinanced = result.boolRefinanced; // added as part of US 3693 & 3694
        this.flags.pastDueStatusFlag = result.pastDueStatus; // added as part of US 3693 & 3694
        this.enrolledInEasyPayFlag = result.enrolledInEasyPay; // added as part of US 3693 & 3694
        this.showProcessingPayment = result.pendingOrProcessingFlag; // added as part of US 6061 
        //checking Payoff or Purchase - 4531	
        this.isPayOff = false;
        console.log('Acc type'+this.strAccountType +'**'+ CONSTANTS.ACCOUNT_TYPE_RETAIL);
        if((this.strAccountType === CONSTANTS.ACCOUNT_TYPE_BALOON && this.flags.boolRefinanced) || this.strAccountType === CONSTANTS.ACCOUNT_TYPE_RETAIL){	
          this.isPayOff = true;	
        }
        this.setFinanceAccData(this.userInfoResult);

        console.log('this.enrolledInEasyPayFlag>>>>>>>>>>',this.enrolledInEasyPayFlag);
        if (typeof result.dblTotalAmountDue !== CONSTANTS.UNDEFINED && typeof result.dbTotalSchedludedAmount !== CONSTANTS.UNDEFINED) {
          this.dbRemainingAmountDue = result.dblTotalAmountDue - result.dbTotalSchedludedAmount;
        }
        console.log('result.dblTotalAmountDue>>>>>>> ',result.dblTotalAmountDue);
        console.log('result.dbTotalSchedludedAmount>>>>>>> ',result.dbTotalSchedludedAmount);
        console.log('result.dbRemainingAmountDue>>>>>>> ',this.dbRemainingAmountDue);
        //for payoff amount
        if (typeof result.decPayoffAmount !== CONSTANTS.UNDEFINED) {
          this.decPayoffAmount = result.decPayoffAmount;
          console.log('this.decPayoffAmount>>>>>>>>>> ',Number(this.decPayoffAmount));
          this.decPayoffAmount = this.formatdecimal(this.decPayoffAmount);
          this.strPayoffAmount = this.formatnumber(result.decPayoffAmount); // added as part of US 3693 & 3694
        }
        if (typeof this.userInfoResult.dblTotalAmountDue !== CONSTANTS.UNDEFINED) {
          this.strTotalAmountDue = this.userInfoResult.dblTotalAmountDue;
          this.userInfoResult.dblTotalAmountDue = this.formatdecimal(this.userInfoResult.dblTotalAmountDue);
          this.strTotalAmountDue = this.formatnumber(this.strTotalAmountDue);
        }
        if (typeof this.userInfoResult.dbTotalSchedludedAmount !== CONSTANTS.UNDEFINED) {
          this.strTotalSchedludedAmount = this.userInfoResult.dbTotalSchedludedAmount;
          this.userInfoResult.dbTotalSchedludedAmount = this.formatdecimal(this.userInfoResult.dbTotalSchedludedAmount);
          this.strTotalSchedludedAmount = this.formatnumber(this.strTotalSchedludedAmount);
        }
        if (typeof this.dbRemainingAmountDue !== CONSTANTS.UNDEFINED) {
          this.strRemainingAmountDue = this.dbRemainingAmountDue;
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

        
        this.easypayScheduledDate = this.flags.showScheduledEasypay === true ? this.formatDate(this.userInfoResult.dtScheduledDate) : "";
        

        this.error = undefined;

        this.getPaymentSourcesList();
        if(this.enrolledInEasyPayFlag){ // US : 4710(Added enroll flag) - Added by Edwin Antony
          this.flags.showOneTimePayment = true;
          this.onPaymentTypeSelection("One-Time");
        }
        if(this.flags.showEasyPay){ // US : 3728(Added enroll flag) - Added by vishnu mohan
          this.onPaymentTypeSelection("Enroll in EasyPay");
        }
      })
      .catch((error) => {
        this.error = error;
        console.log('error',error);
      });
      
  }

  /** Method Name: validateStdPaymentAmount
 *  Description:    Validate the inputs of Payment Amount on UI against backend information associated with Finance Account
 *  Developer Name: Akash Solanki
 *  Created Date:   14-June-2021 
 *  User Story :    3693
 */
  validatePayoffAmount(){
    console.log('save>>>>',this.userAccountInfo.Payoff_Amount__c);
    if(this.userAccountInfo.Payoff_Amount__c <= 0){
      this.isvalidatePayoff = true;
    }else{
      this.isvalidatePayoff = false;
    } 
    console.log('save>>>>',this.userAccountInfo.Payoff_Amount__c);
  }

  validateStdPaymentAmount(event){
    let targetPart = this.template.querySelector(".ahfc-input");
    this.decStdPaymentAmount = event.detail.value;
    window.console.log('this.decStdPaymentAmount '+this.decStdPaymentAmount );
    if(!this.decStdPaymentAmount)
    {
      targetPart.setCustomValidity(AHFC_PaymentErrorForBlankAmount);
      this.flags.boolShowStdPaymentAmountMsg=false;
      console.log('Inside No Amount!!!!!');
    }
    else if(this.decStdPaymentAmount < 1)
    {
      targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
      this.flags.boolShowStdPaymentAmountMsg=false;
      console.log('Inside Amount < 1!!!!!');
      
    }
    
    else if(this.decStdPaymentAmount < Number(this.dbRemainingAmountDue))
    {
      console.log('Inside Lesser !!!!!',Number(this.dbRemainingAmountDue));
      this.flags.boolShowStdPaymentAmountMsg=true;
      this.linkonToast = '';
      this.messages.strStdPaymentAmountMsg = AHFC_AmountLessThanDueAmt;
      targetPart.setCustomValidity("");
    }
    else if(this.decStdPaymentAmount <=Number(this.decPayoffAmount) && this.decStdPaymentAmount > Number(this.dbRemainingAmountDue))
    {
      console.log('Inside greater !!!!!',Number(this.dbRemainingAmountDue));
      console.log('Inside greater 2!!!', Number(this.decPayoffAmount));
      this.flags.boolShowStdPaymentAmountMsg=true;
      this.linkonToast = '';
      this.messages.strStdPaymentAmountMsg = AHFC_AmountExceedsDueAmt;
      targetPart.setCustomValidity("");
    }
    else
    {
      this.flags.boolShowStdPaymentAmountMsg = false;
      targetPart.setCustomValidity("");
      this.linkonToast = '';
      console.log('Inside Else 1!!!!!!');
    }
    if(this.decStdPaymentAmount >= Number(this.decPayoffAmount)){
      console.log('decPayoffAmount>>>>>>>>>>>>> greater',this.decStdPaymentAmount);
        if(this.userAccountInfo.RecordType.Name === 'Retail' && this.strAccountType === 'Balloon'){
          this.flags.boolShowStdPaymentAmountMsg = false;
          targetPart.setCustomValidity(AHFC_PaymentGreaterThanPayOff);
          console.log('decPayoffAmount>>>>>>>>>>>>> greaterPayoff',this.decStdPaymentAmount);
        }
        else if(this.userAccountInfo.RecordType.Name === 'Lease' && this.strAccountType === 'Balloon'){
          this.flags.boolShowStdPaymentAmountMsg = false;
          targetPart.setCustomValidity(AHFC_PayAmtGrtrThanPurchaseAmt);
          console.log('decPayoffAmount>>>>>>>>>>>>> greaterPurchase',this.decStdPaymentAmount);
        }
        else{
        this.flags.boolShowStdPaymentAmountMsg = false;
        targetPart.setCustomValidity("");
        console.log('Inside Else 2!!!!!!');
        }
    }
    targetPart.reportValidity();
  }
/** End of Method validateStdPaymentAmount by Akash Solanki */

  /** Method Name: validateAddnlPricipalAmount
 *  Description:    Valid the inputs of Additional Principal Amount on UI against backend information associated with Finance Account
 *  Developer Name: Akash Solanki
 *  Created Date:   14-June-2021 
 *  User Story :    3694
 */
validateAddnlPricipalAmount(event){
  this.decAddnlPricipalAmount = event.detail.value;
  let targetPart = this.template.querySelector(".principal-input");

  if(!this.decAddnlPricipalAmount)
  {
    targetPart.setCustomValidity(AHFC_PaymentErrorForBlankAmount);
  }
  else if(this.decAddnlPricipalAmount < 1)
  {
    targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
  }
  else if(this.decAddnlPricipalAmount > this.userAccountInfo.Principal_Balance_Amount__c)
  {
    targetPart.setCustomValidity(AHFC_PayAmtGrtrThanPrincipal);
  }
  else
  {
    targetPart.setCustomValidity("");
  }
  targetPart.reportValidity();
}


/** End of Method validateStdPaymentAmount by Akash Solanki */

/** Method Name:    validateScheduledWithAnyOtherPayType
 *  Description:    This method will check if finance account already has a due payment with any other options like payoff, EasyPay and OTP
 *  Developer Name: Akash Solanki
 *  Created Date:   15-June-2021 
 *  User Story :    3693 & 3694
 */
validateScheduledWithAnyOtherPayType(){
  if(this.paymentDisplayStatus === AHFCPaymentStatusPending || this.paymentDisplayStatus === AHFCPaymentStatusProcessing){
    this.flags.boolShowStdPaymentAmountMsg=true;
    this.flags.boolViewPaymentActivity = true;
    this.messages.strStdPaymentAmountMsg = AHFCPaymentExistsAlready;
    this.linkonToast = AHFC_SchdPaymtLinkToast;
    console.log('Inside linktoast method!!!!! '+this.linkonToast);
  }
}

/** Method Name:    onToastLinkClicked
 *  Description:    This method will take customer to user once they click on view scheduled payment on attention warning.
 *  Developer Name: Akash Solanki
 *  Created Date:   15-June-2021 
 *  User Story :    3693 & 3694
 */

onToastLinkClicked(){
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
handleReviewPayment(event){
  if(this.flags.showEasyPay){	
    //US 4531 easy pay senerio done here by vishnu
    this.getEasyPayValues();	
  }else if(this.flags.showPayOff){
    this.validatePayoffAmount();
    this.flags.showReviewPayment = true;
    
  }	
  else{
  let targetPart = this.template.querySelector(".ahfc-input");
  let targetPartPrincipalInput = this.template.querySelector(".principal-input");
     
        console.log('<<<<line615>>>>');
  if(this.flags.showOneTimePayment){ 
    if(!this.decStdPaymentAmount && !this.decAddnlPricipalAmount)
      {
        targetPart.setCustomValidity(AHFC_PaymentErrorForBlankAmount);
        this.flags.boolShowStdPaymentAmountMsg=false;
      }
      else if(this.decStdPaymentAmount < 1 && !this.decAddnlPricipalAmount)
      {
        targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
        this.flags.boolShowStdPaymentAmountMsg=false;
      }
      else if(this.decStdPaymentAmount >= Number(this.decPayoffAmount) && this.userAccountInfo.RecordType.Name === 'Retail' && this.strAccountType === 'Balloon')
      {
          this.flags.boolShowStdPaymentAmountMsg = false;
          targetPart.setCustomValidity(AHFC_PaymentGreaterThanPayOff);
      }
      else if(this.decStdPaymentAmount >= Number(this.decPayoffAmount) && this.userAccountInfo.RecordType.Name === 'Lease' && this.strAccountType === 'Balloon')
      {
          this.flags.boolShowStdPaymentAmountMsg = false;
          targetPart.setCustomValidity(AHFC_PayAmtGrtrThanPurchaseAmt);
      }
      else if(this.flags.showPrinicipalAmount)
      {
        this.validatePrincipalAmountOnReviewClick();
      }
      else
      {
        this.flags.boolShowStdPaymentAmountMsg = false;
        targetPart.setCustomValidity("");
        this.monthlyamount = this.decStdPaymentAmount;
        this.flags.showReviewPayment = true;
        this.decAddnlPricipalAmountFromMakeAPayment = this.decAddnlPricipalAmount;
        console.log('<<<<makeapayment>>>>',this.datScheduleOn);
        console.log('<<<<makeapaymentPrincipal>>>>',this.decAddnlPricipalAmountFromMakeAPayment);

      }
    targetPart.reportValidity();
 }

}  
}
onChangeSCheduledate(event){
  console.log('<<<<datScheduleOn>>>>',event.target.value);
  this.datScheduleOn = event.target.value;
}

//Setup Make Payment on coming back from Confirm Screen
handleEditPayment(event) {
  this.flags.showReviewPayment = false;
  this.flags.showOneTimePayment = event.detail.showOneTimePayment;
  this.flags.showPayOff = event.detail.showPayOff;
  this.flags.showEasyPay = event.detail.showEasyPay;
  let selSourceId = this.selPaymentSourceId; //retain selected payment sources
  for (var paySource = 0;paySource < this.paymentSourcesList.length;paySource++) {
    this.paymentSourcesList[paySource].boolIsPreferredSource = (this.paymentSourcesList[paySource].strID === selSourceId) ? true : false;
  }
}

/** Method Name:    validatePrincipalAmountOnReviewClick
 *  Description:    This method will check all the input validations on click of review button for principal amount section.
 *  Developer Name: Akash Solanki
 *  Created Date:   15-June-2021 
 *  User Story :    3693 & 3694
 */
validatePrincipalAmountOnReviewClick(){
  let targetPart = this.template.querySelector(".principal-input");

  if(!this.decAddnlPricipalAmount && !this.decStdPaymentAmount)
  {
    targetPart.setCustomValidity(AHFC_PaymentErrorForBlankAmount);
  }
  else if(this.decAddnlPricipalAmount < 1 && !this.decStdPaymentAmount)
  {
    targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
  }
  else if(this.decAddnlPricipalAmount > this.userAccountInfo.Principal_Balance_Amount__c)
  {
    targetPart.setCustomValidity(AHFC_PayAmtGrtrThanPrincipal);
  }
  else
  {
    targetPart.setCustomValidity("");
    this.monthlyamount = this.decStdPaymentAmount;
    this.flags.showReviewPayment = true;
    this.decAddnlPricipalAmountFromMakeAPayment = this.decAddnlPricipalAmount;
    console.log('<<<<makeapayment>>>>',this.monthlyamount);
    console.log('<<<<makeapaymentPrincipal>>>>',this.decAddnlPricipalAmountFromMakeAPayment);
  }
  targetPart.reportValidity();
}
  
  // Show Deatiled Amount Structure
  displayAmountInfo() {
    this.flags.showAmountDetails = !this.flags.showAmountDetails;
  }
  //Set Up the Type of Payment on Selection of Radio
  checkPaymentType(event) {

    this.onPaymentTypeSelection(event.target.label);
   
  }
  getPaymentSourcesList() {
    let i;
    console.log('<<<---this.sacRecordId>>>>',this.sacRecordId);
    getPaymentSources({
        IdSACRecordVar: this.sacRecordId
      })
      .then((result) => {
        console.log('<<<<list>>>',result);
        this.paymentSourcesList = JSON.parse(JSON.stringify(result));
        
        for (i = 0; i < this.paymentSourcesList.length; i++) {
          this.paymentSourcesList[i].maskedAccNumber = (new Array(10)).join('•') + this.paymentSourcesList[i].strLast4AccNumber;
          console.log('this.paymentSourcesList[i].maskedAccNumber>>>>>>> '+this.paymentSourcesList[i].maskedAccNumber);
          this.paySourceToLast4AccNumMap.set(this.paymentSourcesList[i].strID, this.paymentSourcesList[i].strLast4AccNumber);
          if (this.paymentSourcesList[i].boolIsPreferredSource) {
            this.selPaymentSource = this.paymentSourcesList[i].strName;
            this.selPaymentSourceId = this.paymentSourcesList[i].strID;
            this.strLast4AccNumber = this.paymentSourcesList[i].strLast4AccNumber;
          }
        }
        console.log('<<<<flags.boolShowScheduleOnMsg>>>',this.flags.boolShowScheduleOnMsg);
      })
      .catch((error) => {
        this.error = error;
      });

  }

  // Flag to Display Additional Amount Field
  displayPrincipalAmount() {
    this.flags.showPrinicipalAmount = true;
  }

  // Modified : line 761 and 762 added by Aakash as part of US 3694
  displayPrincipalAmountfield() {
    console.log('Fl_OneTime_Payment_Eligible_Web__c>>> ',this.userAccountInfo.Fl_OneTime_Payment_Eligible_Web__c);
    console.log('RecordType>>> ',this.userAccountInfo.RecordType.Name);
    console.log('strAccountType>>> ',this.strAccountType);
    console.log('boolRefinanced>>> ',this.flags.boolRefinanced);
    console.log('pastDueStatusFlag>>> ',this.flags.pastDueStatusFlag);
    if (this.userAccountInfo != null) {
      if (this.userAccountInfo.Fl_OneTime_Payment_Eligible_Web__c &&
        this.userAccountInfo.RecordType.Name === 'Retail' &&
        (this.strAccountType === 'Balloon' || this.strAccountType === 'Retail') && this.flags.boolRefinanced
        && this.flags.pastDueStatusFlag===false) { //added by Aakash as part of US 3694
        this.flags.showPrinicipalAmountfield = true;
        this.flags.showPrinicipalAmount = false;
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

 validateScheduleOn(event){
  this.datScheduleOn = event.detail.value;
  this.validateScheduleOnLogic();
}

validateScheduleOnLogic(){
  let targetPart = this.template.querySelector(".schedule-input");
  let dueDate=this.userAccountInfo.Next_Due_Date__c;
  let dueDate2=new Date(this.userAccountInfo.Next_Due_Date__c);
  let schDate=new Date(this.datScheduleOn);
  let todayDate=new Date(this.datSystemDate);

  if(!this.datScheduleOn)
  {
    console.log('1a-Entered Empty Schedule Date');
    this.flags.boolShowScheduleOnMsg=false;
    targetPart.setCustomValidity("Select a payment date.");
    
  }
  else if(this.datScheduleOn < this.datSystemDate){
    console.log('2 Entered Past Schedule Date');
    this.flags.boolShowScheduleOnMsg=false;
    targetPart.setCustomValidity("Scheduled Payment Date cannot be in the past.");
  }
  else if(this.flags.pastDueStatusFlag==false && this.getDPD(dueDate2,todayDate) <= 10 && (this.datScheduleOn < this.userAccountInfo.Maturity_Date__c) &&
  this.userAccountInfo.Region_Code__c != "NRC"  && this.flags.boolShowStdPaymentAmountMsg==true && this.getDPD(todayDate,schDate) > 182) {
   console.log('6 CFA +10 DPD before Maturity + !NRC + Sch Payments+ 182 from Today Criteria');
   this.flags.boolShowScheduleOnMsg=false;
   targetPart.setCustomValidity("Scheduled Payment Date cannot be beyond "+this.addDays(todayDate, 182));
 }
  else if(this.flags.pastDueStatusFlag==false && (this.datScheduleOn < this.userAccountInfo.Maturity_Date__c) && (this.userAccountInfo.Region_Code__c  != "NRC" || this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == false ) && this.getDPD(dueDate2,schDate) > 10){
    console.log('3 Current Finance Account with DPD > 10 Days Criteria');
    this.flags.boolShowScheduleOnMsg=false;
    targetPart.setCustomValidity("Scheduled Payment Date cannot be beyond "+this.addDays(dueDate2, 10));
  }
  else if( this.flags.pastDueStatusFlag==true && (this.datScheduleOn < this.userAccountInfo.Maturity_Date__c) && (this.userAccountInfo.Region_Code__c  != "NRC" || this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == false)  && this.getDPD(dueDate2,schDate) > 10){
    console.log('4 Past Due Finance Account with DPD > 10 Days Criteria');
    this.flags.boolShowScheduleOnMsg=false;
    targetPart.setCustomValidity("Scheduled Payment Date cannot be beyond "+this.addDays(dueDate2, 10));
  }
  else if( this.flags.pastDueStatusFlag==true && (this.getDPD(dueDate2,schDate) > 10 ||  this.datScheduleOn != this.datSystemDate)){
    console.log('5 Past Due Finance Account with DPD > 10 Days Criteria');
    this.flags.boolShowScheduleOnMsg=false;
    targetPart.setCustomValidity("Scheduled Payment date cannot be beyond "+this.datSystemDate);
  }
  else if( this.flags.pastDueStatusFlag==false && (this.datScheduleOn > this.userAccountInfo.Maturity_Date__c) &&  this.userAccountInfo.Region_Code__c != "NRC"  ) {
   console.log('7 Schedule Date > Maturity + !NRC Criteria');
   this.flags.boolShowScheduleOnMsg=false;
   targetPart.setCustomValidity("Scheduled Payment Date cannot be beyond the Maturity Date of "+this.userAccountInfo.Maturity_Date__c);
 }
  else if(this.datScheduleOn > dueDate){
    console.log('8 Entered Futured Schedule Date');
    this.flags.boolShowScheduleOnMsg=true;
    this.messages.strScheduleOnMsg = "You are scheduling a payment after your Payment Due Date of "+ dueDate+". Please make a payment on or before your Payment Due Date to avoid any additional fees and/ or interest.";
    targetPart.setCustomValidity("");
  }
  else if(this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == false && this.datScheduleOn > this.datSystemDate ){
    console.log('1 Entered Past Schedule Date');
    this.flags.boolShowScheduleOnMsg=false;
    targetPart.setCustomValidity("Payment date cannot be beyond "+this.datSystemDate);
  }
  else
  {
    this.flags.boolShowScheduleOnMsg=false;
    targetPart.setCustomValidity("");
  }
  targetPart.reportValidity();
}

getDPD(startDate,endDate){
  const diffTime = endDate - startDate;
  const diffDays = diffTime / (1000 * 60 * 60 * 24); 
  return diffDays;
} 

addDays(date, days){
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
validateEasyPayLogic(){
  this.showDueInEligibilityErrorMsg = false;
  this.showpaymentEligibilityErrorMsg = false;
  let dueDate2=new Date(this.userAccountInfo.Next_Due_Date__c);
  let todayDate=new Date(this.datSystemDate);
  this.getDPD(dueDate2,todayDate);
  
  if(this.getDPD(dueDate2,todayDate) <= 59 && this.flags.pastDueStatusFlag){
    this.showpaymentEligibilityErrorMsg = true;
    this.showDueInEligibilityErrorMsg = true;
    this.template.querySelector("c-a-h-f-c_make-payment-not-eligible-message-l-w-c").updatePaymentType(this.paymentType); 
  }else if(this.getDPD(dueDate2,todayDate) > 59){
    this.showpaymentEligibilityErrorMsg = true;
    this.template.querySelector("c-a-h-f-c_make-payment-not-eligible-message-l-w-c").updatePaymentType(this.paymentType); 
  }
}

//Added by Aswin Jose for US 3686
checkPaymentEligibility(){
    this.showpaymentEligibilityErrorMsg = false;
    
    if((!this.userAccountInfo.Fl_OneTime_Payment_Eligible_Web__c  && this.flags.showOneTimePayment) || (!this.userAccountInfo.Fl_Recurring_Payment_Eligible_Web__c && this.flags.showEasyPay)
    || (!this.userAccountInfo.Fl_Payoff_Payment_Eligible_Web__c && this.flags.showPayOff) ){
      this.showpaymentEligibilityErrorMsg = true;
      this.template.querySelector("c-a-h-f-c_make-payment-not-eligible-message-l-w-c").updatePaymentType(this.paymentType); 
    }else if(this.userAccountInfo.Fl_Recurring_Payment_Eligible_Web__c && this.flags.showEasyPay){
      this.validateEasyPayLogic();
      
    }
  }

  //US: 4017 added by edwin antony
  navigatetoPaymentActivityPage(){
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        pageName: "manage-payment"
      }
    });
  }

  onPaymentTypeSelection(paymentTypeLabel){    
    window.console.log('Inside onPaymentTypeSelection:'+paymentTypeLabel);
    this.flags.showPaySources = true;
    this.paymentType = paymentTypeLabel;
    const type = paymentTypeLabel;
    switch (type) {
      case "One-Time":
        this.flags.showOneTimePayment = true;
        this.flags.showEasyPay = false;
        this.flags.showPayOff = false;
        this.validateScheduledWithAnyOtherPayType();
        this.getPaymentSourcesList();
        this.displayPrincipalAmountfield();
        break;
      case "Enroll in EasyPay":
        this.flags.showOneTimePayment = false;
        this.flags.showPayOff = false;
        //calling this existing method as part of 4531 funtionality
        this.validateScheduledWithAnyOtherPayType();	
        this.flags.showEasyPay = true;
        break;
      case "Payoff":   // payoff US:4535
        this.flags.showPayOff = true;
        this.flags.showOneTimePayment = false;
        this.flags.showEasyPay = false;
        this.getPaymentSourcesList();
        break;
      case "Purchase":  // purchase US:6061
        this.flags.showPayOff = true;
        this.flags.showOneTimePayment = false;
        this.flags.showEasyPay = false;
        this.getPaymentSourcesList();
        break;
    }
    this.checkPaymentEligibility(); //to check the payment type is eligible or not. US : 3696
    if(!showPayOff){
      this.validateScheduleOnLogic();
    }
    if(this.decStdPaymentAmount === 0){
      this.decStdPaymentAmount = 0.00;
    }
  }




/** Method Name:    getEasyPayValues
 *  Description:    This method will call method of child component for geting th values.
 *  Developer Name: vishnu
 *  Created Date:   01-july-2021 
 *  User Story :    4531
**/ 	
  getEasyPayValues(){	
    console.log('Error is visible : '+this.template.querySelector("c-a-h-f-c_make-payment-easy-pay-l-w-c").boolShowAutoPayAmtMsg); 	
    this.isValidationError = this.template.querySelector("c-a-h-f-c_make-payment-easy-pay-l-w-c").boolShowAutoPayAmtMsg; 	

    if(!this.isValidationError){
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
  setEasyPayValues(event){	
    this.easyPaymentInfo.strAutoPaymentAmt = event.detail.automaticPaymentAmount;	
    this.easyPaymentInfo.strNextWithdrawlDate = event.detail.setEasyPayDate;	
    this.easyPaymentInfo.strpaymentSource = this.selPaymentSource ;	
    this.easyPaymentInfo.strpaymentSourceId = this.selPaymentSourceId ;	
    this.easyPaymentInfo.last4accnumofselpaysource = this.strLast4AccNumber;	
    this.easyPaymentInfo.sacRecordId = this.sacRecordId;	
    this.showEasyPayReviewPayment = true; 
    this.flags.showReviewPayment = true;	
  }	

  /* working on testing scenerios*/
  setTheData(){
     window.crypto.subtle.generateKey(
      {
        name: "RSA-OAEP",
        modulusLength: 4096,
        publicExponent: new Uint8Array([1, 0, 1]),
        hash: "SHA-256"
      },
      true,
      ["encrypt", "decrypt"]
    ).then((keyPair) => {
      console.log(keyPair);
      let ciphertext = this.encryptUrl(keyPair.publicKey,'testing123')
      console.log('00000000000000000000',ciphertext);
      this.decryptUrl(keyPair.privateKey,ciphertext);
    });
    
  }

    encryptUrl(key,value){
      let enc = new TextEncoder();
    let dataValue = enc.encode(value);
     
       console.log('keyPair',key);
    return window.crypto.subtle.encrypt(
      {
        name: "RSA-OAEP"
      },
      key,
      dataValue
    );
    
    }

    async decryptUrl(key,ciphertext){
      let decrypted = await window.crypto.subtle.decrypt(
        {
          name: "RSA-OAEP"
        },
        key,
        ciphertext
      );
      let dec = new TextDecoder();
      let decryptedValue = dec.decode(decrypted);
      console.log(decryptedValue);
    }
   /* working on testing scenerios*/

}