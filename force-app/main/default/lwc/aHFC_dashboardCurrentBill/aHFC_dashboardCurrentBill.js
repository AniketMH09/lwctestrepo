/* Name               :    AHFC_dashboardCurrentBill
 * Description        :    This Component is used to display current bill tile on dashboard.
 * Modification Log   :
 * ---------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ---------------------------------------------------------------------------
 * prabu                                              created
 * Satish                     14/06/2021              Modified by satish US#: 6069 
 * Edwin                      12/08/2021              Modified by edwin  US#: 10147 enrolled in easypay flag will be enabled for suspended status also 
 * satish                     17-08-2021              Modified for US# 10408
 *********************************************************************************/
import {
    wire,
    LightningElement,
    api,
    track
} from "lwc";
import {
    getConstants
} from "c/ahfcConstantUtil";
import {
    NavigationMixin
} from "lightning/navigation";
import {
    labels
} from "c/aHFC_dashboardConstantsUtil";
import {
    label
} from "c/aHFC_makeAPaymentUtil";
import FORM_FACTOR from "@salesforce/client/formFactor";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import eligibiltyFlagRetrieve from "@salesforce/apex/AHFC_NeedHelpPaymentController.eligibiltyFlagRetrieve";
import { registerListener, unregisterAllListeners } from 'c/pubsub';
//assign the values returned from the getConstants method from util class
const CONSTANTS = getConstants();

export default class AHFC_dashboardCurrentBill extends NavigationMixin(
    LightningElement
) {
    @track isTotalPastPromise = false;
    @track finAccNo;
    @track labels = labels;
    @track pastDueAmt;
    @api selServiceAccountWrapper;
    @track serviceAccountWrapper;
    @track duedate;
    @track boolenrolled;
    @track IDSAC;
    @track showamountdue;
    @track showdays;
    @track showremainingdays;
    @track isNeedHelp = false;
    @track needHelpData;
    @track dueDateChange;
    @track leaseExtension;
    @track totalPastDue;
    @track showNeedHelp = false;
    @track showDueDate = true;
    @track accntTypeforViewDetail = false;


    //Added by satish -US# 6069 -Start 
    @track showdesktop;
    @track showmobile;
    @track strTotalSchedludedAmount;
    @track strRemainingAmount;
    @track isModalOpen = false;
    @track Clabel = label;
    @track flags = {
        showAmountDetails: false,
        showfeeDues: false,
        showCurrentAmount: false,
        showScheduledOTP: false,
        showScheduledPayments: false,
        showScheduledEasypay: false,
    };
    @track OTPScheduledpayments = {
        ChargentOrders__Charge_Amount__c: "",
        ChargentOrders__Payment_Start_Date__c: "",
        Next_Withdrawal_Date__c : "",
        isOTP: false,
        isEP: false,
    };
    displayAmountInfo() {
        this.flags.showAmountDetails = !this.flags.showAmountDetails;
    }
    openModal() {
        let adobedata = {
            'Event_Metadata.action_type': 'Expand',
            "Event_Metadata.action_label": "Dashboard:Expand:View More Details",
            "Event_Metadata.action_category": "Current Bill Tile",
            "Page.page_name": "Dashboard",
            "Page.brand_name": this.adobebrand
        };
        fireAdobeEvent(adobedata, 'click-event');
        this.isModalOpen = true;
    }
    closeModal() {

        this.isModalOpen = false;
    }
    //Added by satish -US# 6069 -END

   
    @track adobebrand = '';
    connectedCallback() {

        this.setdata(this.selServiceAccountWrapper);


        if (FORM_FACTOR == this.labels.LargeLabel) {

            this.showdesktop = true;
            this.showmobile = false;
        } else if (FORM_FACTOR == this.labels.MediumLabel) {

            this.showdesktop = true;
            this.showmobile = true;
        } else {

            this.showdesktop = false;
            this.showmobile = true;
        }

    }

    get pastDueInclude() {
        return `${this.labels.CurrentBillIncludes} ${this.formatCurrency(this.serviceAccountWrapper.serAccRec.Past_Amount_Due__c)} ${this.labels.CurrentBillPastDue}`;
    }

    get dayRemaining() {
        return (this.showdays) ? `${this.serviceAccountWrapper.intDaysUntilDueDate} ${this.labels.CurrentBillDays} ${this.labels.CurrentBillRemaining}` : `${this.serviceAccountWrapper.intDaysUntilDueDate} ${this.labels.CurrentBillDay} ${this.labels.CurrentBillRemaining}`;
    }

    setdata(wrapper) {
        this.showDueDate = true;//15476 Bug Fix
        this.serviceAccountWrapper = JSON.parse(wrapper);
        let accntType = this.serviceAccountWrapper.serAccRec.Account_Type__c;
        let refiflag = this.serviceAccountWrapper.serAccRec.Fl_Refinanced__c;
        if((accntType != undefined) && ((accntType =='Lease') || ((accntType == 'Balloon') && ((refiflag == false)))))
        {
            this.accntTypeforViewDetail = true;
        }
        else
        {
            this.accntTypeforViewDetail = false;
        }
        this.adobebrand = this.serviceAccountWrapper.serAccRec.Honda_Brand__c ? this.serviceAccountWrapper.serAccRec.Honda_Brand__c : '';
            console.log('Wrapper DATA' + JSON.stringify(this.serviceAccountWrapper));
        console.log('Aswin : ' + this.serviceAccountWrapper.boolenrolled);
        let totalamt = 0;
        if (
            typeof this.serviceAccountWrapper.serAccRec.Next_Due_Date__c !=
            "undefined"
        ){
            this.duedate = this.formatshortdate(
                this.serviceAccountWrapper.serAccRec.Next_Due_Date__c
            );
            let duedateWithOffset = new Date(this.serviceAccountWrapper.serAccRec.Next_Due_Date__c);
            let duedateWithoutOffset = new Date(
                duedateWithOffset.getTime() + duedateWithOffset.getTimezoneOffset() * 60 * 1000
            );
            /*Bug fix 15476 Starts*/
            if(duedateWithoutOffset.getMonth() == 11 && duedateWithoutOffset.getFullYear() == 4000 && duedateWithoutOffset.getDate() == 31){
                this.showDueDate = false;
            }
            /*Bug fix 15476 Ends*/
        }else{
            this.showDueDate = false;
        }
        
        if (
            typeof this.serviceAccountWrapper.serAccRec.Past_Amount_Due__c !=
            "undefined"
        ) {

            this.showamountdue =
                this.serviceAccountWrapper.serAccRec.Past_Amount_Due__c > 0 ?
                    true :
                    false;
            this.serviceAccountWrapper.serAccRec.Past_Amount_Due__c = this.formatnumber(
                this.serviceAccountWrapper.serAccRec.Past_Amount_Due__c
            );

            this.pastDueAmt = this.serviceAccountWrapper.serAccRec.Past_Amount_Due__c;



        } else {
            this.showamountdue = false;
        }
        this.showdays =
            this.serviceAccountWrapper.intDaysUntilDueDate == 1 ? false : true;
        this.showremainingdays =
            this.serviceAccountWrapper.intDaysUntilDueDate >= 0 &&
                this.serviceAccountWrapper.intDaysUntilDueDate <= 10 ?
                true :
                false;
        if (typeof this.serviceAccountWrapper.dblTotalAmountDue != "undefined") {
            totalamt = this.serviceAccountWrapper.dblTotalAmountDue;
            this.serviceAccountWrapper.dblTotalAmountDue = this.formatnumber(
                this.serviceAccountWrapper.dblTotalAmountDue
            );
        }

        this.boolenrolled = this.serviceAccountWrapper.boolenrolled;
        this.IDSAC = this.serviceAccountWrapper.serAccRec.Id;

        //Added by satish -US# 6069 -START

        let ScheduledAmount = 0;
        let easyPayScheduledAmount = 0;
        this.OTPScheduledpayments = (this.serviceAccountWrapper.lstOtpPayments) ? this.serviceAccountWrapper.lstOtpPayments : "";
        if (this.serviceAccountWrapper.lstOtpPayments) {

            for (var i = 0; i < this.serviceAccountWrapper.lstOtpPayments.length; i++) {

                if (typeof this.OTPScheduledpayments[i] !== CONSTANTS.UNDEFINED) {
                    if ((this.OTPScheduledpayments[i].RecordType.Name === "Standard One-Time Payment" || this.OTPScheduledpayments[i].RecordType.Name === "Principal One-Time Payment") && (this.OTPScheduledpayments[i].Payment_Display_Status__c === "Pending" || this.OTPScheduledpayments[i].Payment_Display_Status__c === "Processing") && this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c > 0) {

                        if (typeof this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c !== CONSTANTS.UNDEFINED)
                            if (this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c <= this.serviceAccountWrapper.serAccRec.Next_Due_Date__c) {
                                this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c = this.formatshortdate(this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c);
                                ScheduledAmount += this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c;
                                this.OTPScheduledpayments[i].isOTP = true;
                                this.OTPScheduledpayments[i].isEP = false;
                                if (typeof this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c !== CONSTANTS.UNDEFINED)
                                    this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c = this.formatnumber(this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c);
                            }
                    } else if (this.boolenrolled && this.OTPScheduledpayments[i].RecordType.Name === "Recurring Payment" && (this.OTPScheduledpayments[i].Payment_Display_Status__c === "Pending" /*|| this.OTPScheduledpayments[i].Payment_Display_Status__c === "Processing"*/) && this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c > 0) { //added suspended status as part of US 10147 by edwin 
                        if (typeof this.OTPScheduledpayments[i].Next_Withdrawal_Date__c !== CONSTANTS.UNDEFINED) {

                            if (this.OTPScheduledpayments[i].Next_Withdrawal_Date__c <= this.serviceAccountWrapper.serAccRec.Next_Due_Date__c) {

                                this.OTPScheduledpayments[i].isEP = true;
                                this.OTPScheduledpayments[i].isOTP = false;
                                easyPayScheduledAmount += this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c;
                                if (typeof this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c !== CONSTANTS.UNDEFINED)
                                    this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c = this.formatnumber(this.OTPScheduledpayments[i].ChargentOrders__Charge_Amount__c);
                            }
                            //this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c = this.formatshortdate(this.OTPScheduledpayments[i].ChargentOrders__Payment_Start_Date__c);
                            //Added by Aswin Jose for Bug fix : 15491 - Start 
                            if (typeof this.OTPScheduledpayments[i].Next_Withdrawal_Date__c !== CONSTANTS.UNDEFINED) {
                                this.OTPScheduledpayments[i].Next_Withdrawal_Date__c = this.formatshortdate(this.OTPScheduledpayments[i].Next_Withdrawal_Date__c);
                            }
                            //Added by Aswin Jose for Bug fix : 15491 - End
                        }
                    }

                }
                this.flags.showScheduledOTP = true;
            }
        }

        if (this.serviceAccountWrapper.serAccRec.Total_Fees_Due__c !== null &&
            typeof this.serviceAccountWrapper.serAccRec.Total_Fees_Due__c !== CONSTANTS.UNDEFINED &&
            this.serviceAccountWrapper.serAccRec.Total_Fees_Due__c > 0) {
            this.serviceAccountWrapper.serAccRec.Total_Fees_Due__c = this.formatnumber(
                this.serviceAccountWrapper.serAccRec.Total_Fees_Due__c
            );
            this.flags.showfeeDues = true;
        } else {
            this.flags.showfeeDues = false;
        }
        if (this.serviceAccountWrapper.serAccRec.Current_Amount_Due__c !== null &&
            typeof this.serviceAccountWrapper.serAccRec.Current_Amount_Due__c !== CONSTANTS.UNDEFINED &&
            this.serviceAccountWrapper.serAccRec.Current_Amount_Due__c > 0) {
            this.flags.showCurrentAmount = true;
            this.serviceAccountWrapper.serAccRec.Current_Amount_Due__c = this.formatnumber(
                this.serviceAccountWrapper.serAccRec.Current_Amount_Due__c
            );

        } else {
            this.flags.showCurrentAmount = false;
        }
        let schAmt = ScheduledAmount + easyPayScheduledAmount;
        this.strTotalSchedludedAmount = this.formatnumber(schAmt);

        this.flags.showScheduledPayments = schAmt > 0 ? true : false;

        this.strRemainingAmount = totalamt - schAmt;
        if (this.strRemainingAmount < 0) {
            this.strRemainingAmount = 0;
        }
        this.strRemainingAmount = this.formatnumber(this.strRemainingAmount);
        //Added by satish -US# 6069 -END

        this.passEZPFlagToParent();

    }


    @api handleValueChange(wrapper) {
        this.setdata(wrapper);
    }

    @wire(eligibiltyFlagRetrieve, {
        FinanceId: '$IDSAC'
    })
    eligibiltyRetrieve({
        error,
        data
    }) {


        if (data) {
            this.dueDateChange = false;
            this.totalPastDue = false;
            this.leaseExtension = false;
            this.isTotalPastPromise = false;
            this.needHelpData = data;
            this.totalPastDue = this.needHelpData.TotalPastDue;
            this.finAccNo = this.needHelpData.FinanceAccNo;
            this.dueDateChange = this.needHelpData.DueDateChange;
            this.leaseExtension = this.needHelpData.LeaseExtension;
            console.log('due->', this.dueDateChange + 'lease->', this.leaseExtension +
                'pasttotal', this.totalPastDue);
            //Added by Prabu for US 9970 - Start
            if (this.totalPastDue) {
                let sessioneddata = JSON.parse(sessionStorage.getItem(this.finAccNo));
                if (sessioneddata.promiseToPay == true) {
                    this.isTotalPastPromise = true;
                }
            }
            //9970 - End

            if (this.dueDateChange === true || this.leaseExtension === true ||
                (this.totalPastDue === true && this.isTotalPastPromise === true)) {
                this.showNeedHelp = true;

            } else {
                this.showNeedHelp = false;

            }

        } else if (error) {

            this.error = error;

        }
    }




    formatshortdate(dt) {
        var formatdate = new Date(dt);
        formatdate = new Date(
            formatdate.getTime() + formatdate.getTimezoneOffset() * 60 * 1000
        );
        if (formatdate != CONSTANTS.INVALID_DATE) {
            const options = {
                month: "short",
                day: "numeric",
                year: "numeric"
            };
            return formatdate.toLocaleDateString("en-US", options);
        } else {
            return "";
        }
    }


    //formatting number to string
    formatnumber(number) {
        return number.toLocaleString("en-US", {
            minimumFractionDigits: 2
        });
    }

    navigatetopayment() {
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Dashboard:Button:Make a Payment",
            "Event_Metadata.action_category": "Current Bill Tile",
            "Page.page_name": "Dashboard",
            "Page.brand_name": this.adobebrand
        };
        fireAdobeEvent(adobedata, 'click-event');

        sessionStorage.setItem('salesforce_id', this.IDSAC);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },
            state: {
                //sacRecordId: this.IDSAC,
                showOTPDefault: true
            }
        });
    }

    navigateToEasypayByDefault() {
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Dashboard:Button:Enroll in Easypay",
            "Event_Metadata.action_category": "Current Bill Tile",
            "Page.page_name": "Dashboard",
            "Page.brand_name": this.adobebrand
        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('salesforce_id', this.IDSAC);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },
            state: {
                //sacRecordId: this.IDSAC,
                showeasypay: true
            }
        });
    }

    navigatetoschedulepayments() {
        sessionStorage.setItem('salesforce_id', this.IDSAC);
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Dashboard:Button:Manage Easypay",
            "Event_Metadata.action_category": "Current Bill Tile",
            "Page.page_name": "Dashboard",
            "Page.brand_name": this.adobebrand
        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "manage-payment"
            },
            state: {
                sacRecordId: this.IDSAC
            }
        });
    }

    navigatehelppayment() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Dashboard:Hyperlink:Need Help",
            "Event_Metadata.action_category": "Current Bill Tile",
            "Page.page_name": "Dashboard",
            "Page.brand_name": this.adobebrand
        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('salesforce_id', this.IDSAC);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "help-payment"
            },
            state: {
                sacRecordId: this.IDSAC
            }
        });
    }
    navigatepaymentoptions() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Dashboard:Hyperlink:Other Payment Options",
            "Event_Metadata.action_category": "Current Bill Tile",
            "Page.page_name": "Dashboard",
            "Page.brand_name": this.adobebrand
        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','false');
        sessionStorage.setItem('salesforce_id', this.IDSAC);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "paymentoptions"
            },
            state: {
                sacRecordId: this.IDSAC
            }
        });
    }

    passEZPFlagToParent() {
        console.log('value to pass  : ' + this.boolenrolled);
        var EZPFlag = this.boolenrolled;
        this.dispatchEvent(new CustomEvent('eventfromchild', {
            detail: EZPFlag
        }));

    }

    formatCurrency(curNumber) {
        var formatter = new Intl.NumberFormat("en-US", {
            style: "currency",
            currency: "USD",
            maximumFractionDigits: 2
        });
        return formatter.format(curNumber);
    }


}