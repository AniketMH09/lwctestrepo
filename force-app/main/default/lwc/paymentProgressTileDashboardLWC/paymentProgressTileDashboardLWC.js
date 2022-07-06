/*
*COMPONENT NAME     : PaymentProgressTileDashboardLWC - Payment Progress
*AUTHOR             : LTI - Satish LOKININDI.
*CREATED DATE       : 05-05-2021
* Modification Log  :
* -----------------------------------------------------------------------------------------------------------------------------------------------------------
* Developer                   Date                   Description
* -----------------------------------------------------------------------------------------------------------------------
* Sagar Ghadigaonkar          Sep 08 2021            gray off details in payment progress tile  US-7659
                                                     if AHFC_Web_Dashboard_Payment_Progress__c value is 'N' 
*/
import {
    api,
    LightningElement,
    track
} from "lwc";
import PaymentProgressContractDetails from "@salesforce/label/c.PaymentProgressContractDetails";
import PaymentProgressMaturityDate from "@salesforce/label/c.PaymentProgressMaturityDate";
import PaymentProgressPayoffCalender from "@salesforce/label/c.PaymentProgressPayoffCalender";
import PaymentProgressPaymentLeft from "@salesforce/label/c.PaymentProgressPaymentLeft";
import PaymentProgressTerm from "@salesforce/label/c.PaymentProgressTerm";
import {
    getConstants
} from "c/ahfcConstantUtil";
const CONSTANTS = getConstants();
import {
    NavigationMixin
} from "lightning/navigation";
import { fireAdobeEvent } from "c/aHFC_adobeServices";

export default class PaymentProgressTileDashboardLWC extends NavigationMixin(LightningElement) {
    labels = {
        PaymentProgressContractDetails,
        PaymentProgressMaturityDate,
        PaymentProgressPayoffCalender,
        PaymentProgressPaymentLeft,
        PaymentProgressTerm,

    };

    @api dashboardData;

    @track financeAccNumber;

    @track serAccountNickName;

    @track accountType;

    @track isPayoff = false;

    @track refinanced;

    @track showGrayOffPaymentProgressTile = false;

    dashboardServAccData;
    minValue = 0;
    maturitydate;
    totalTerm;
    currentValue;
    maxValue;
    showRingData;
    @track adobebrand = '';
    @track payOffAmount = '';

    connectedCallback() {
        if (this.dashboardData) {
            this.processData(this.dashboardData);
        }
    }
    // Function to call when Finance Account changes on dashboard corosal
    @api handleValueChange(data) {
        this.processData(data);

    }
    processData(data) {
        this.payOffAmount = this.formatnumber(0);
        this.dashboardServAccData = JSON.parse(data);
        this.adobebrand = this.dashboardServAccData.serAccRec.Honda_Brand__c ? this.dashboardServAccData.serAccRec.Honda_Brand__c : '';
        // Change serAccRec var name based on input info.
        console.log('xxx>>',this.dashboardServAccData)
        /* US -25938 Start  added by aniket */
        if(this.dashboardServAccData.serAccRec.Payoff_Amount__c != undefined){
            this.payOffAmount = this.formatnumber(this.dashboardServAccData.serAccRec.Payoff_Amount__c);
        }
        

        /* US -7659 Start  added by sagar */

        if (this.dashboardServAccData.serAccRec.AHFC_Web_Dashboard_Payment_Progress__c == 'N') {
            this.showGrayOffPaymentProgressTile = true;
        } else {
            this.showGrayOffPaymentProgressTile = false;
        }

        /* US -7659 End  added by sagar */

        if (!this.dashboardServAccData.serAccRec.hasOwnProperty('Account_Type__c')) {
            this.dashboardServAccData.serAccRec.Account_Type__c = '';
        }

        this.accountType = this.dashboardServAccData.serAccRec.Account_Type__c;
        this.refinanced = this.dashboardServAccData.serAccRec.Fl_Refinanced__c;
        this.totalTerm = this.dashboardServAccData.serAccRec.Term__c;
        this.maxValue = this.dashboardServAccData.serAccRec.AHFC_Total_Payments__c;
        this.financeAccNumber = this.dashboardServAccData.serAccRec.Finance_Account_Number__c;
        this.serAccountNickName = this.dashboardServAccData.serAccRec.AHFC_Product_Nickname__c;
        if (this.maxValue) {
            this.showRingData = true;
        }
        else {
            this.showRingData = false;
        }
        if (
            typeof this.dashboardServAccData.serAccRec.Maturity_Date__c !==
            CONSTANTS.UNDEFINED
        ) {
            this.maturitydate = this.formatdate(
                this.dashboardServAccData.serAccRec.Maturity_Date__c
            );
        }
        else {
            this.maturitydate = "";
        }

        if (this.accountType !== null && (this.accountType == 'Retail' || (this.accountType == 'Balloon' && this.refinanced))) {
            this.isPayoff = true;
        } else if (this.accountType !== null && (this.accountType == 'Baloon' || this.accountType == 'Lease')) {
            this.isPayoff = false;
        }

        this.dashboardServAccData.serAccRec.Term__c =
            typeof this.dashboardServAccData.serAccRec.Term__c !== CONSTANTS.UNDEFINED ?
                this.dashboardServAccData.serAccRec.Term__c :
                0;
        this.dashboardServAccData.serAccRec.AHFC_Total_Payments__c =
            typeof this.dashboardServAccData.serAccRec.AHFC_Total_Payments__c !== CONSTANTS.UNDEFINED ?
                this.dashboardServAccData.serAccRec.AHFC_Total_Payments__c :
                0;
        if (
            typeof this.dashboardServAccData.serAccRec.AHFC_Total_Payments__c !== CONSTANTS.UNDEFINED &&
            typeof this.dashboardServAccData.serAccRec
                .AHFC_Number_of_Payments_Remaining__c !== CONSTANTS.UNDEFINED
        ) {
            this.currentValue =
                this.dashboardServAccData.serAccRec.AHFC_Total_Payments__c -
                this.dashboardServAccData.serAccRec
                    .AHFC_Number_of_Payments_Remaining__c;
        }
        else {
            this.currentValue = 0;
        }

    }
    formatdate(dt) {
        let formatdate = new Date(dt);
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
    formatnumber(number) {
        return number.toLocaleString("en-US", {
          minimumFractionDigits: 2
        });
      }
    navigatetoContracts() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Dashboard:Hyperlink:Contract Details",
            "Event_Metadata.action_category": "Payment Progress Tile",
            "Page.page_name": "Dashboard",
            "Page.brand_name": this.adobebrand
        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "contracts"
            },
            state: {
                financeAccNumber: this.financeAccNumber,
                serAccountNickName: this.serAccountNickName
            }
        });
    }
    navigatetoPayoffCalendar() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Dashboard:Hyperlink:Payoff Calendar",
            "Event_Metadata.action_category": "Payment Progress Tile",
            "Page.page_name": "Dashboard",
            "Page.brand_name": this.adobebrand
        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('salesforce_id', this.dashboardServAccData.serAccRec.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "payoffcalendar"
            }
        });

    }

    navigatetopayoffpage() {
        sessionStorage.setItem('salesforce_id', this.dashboardServAccData.serAccRec.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },
            state: {
                payOff: true
            }
        }); 
    }
    // Get the Arc for Progress Completed
    get dValue() {
        if (this.maxValue == 0) {
            return "M 1 0 A 1 1 0 " + Math.floor(0 / (100 / 2)) + " 1 " +
                Math.cos(2 * Math.PI * (0 / 100)) + " " +
                Math.sin(2 * Math.PI * (0 / 100)) + " L 0 0";
        } else if (this.currentValue != this.maxValue) {
            return "M 1 0 A 1 1 0 " + Math.floor(this.currentValue / (this.maxValue / 2)) + " 1 " +
                Math.cos(2 * Math.PI * (this.currentValue / this.maxValue)) + " " +
                Math.sin(2 * Math.PI * (this.currentValue / this.maxValue)) + " L 0 0";
        } else {
            return "M 1 0 A 1 1 0 " + Math.floor(99 / (100 / 2)) + " 1 " +
                Math.cos(2 * Math.PI * (99 / 100)) + " " +
                Math.sin(2 * Math.PI * (99 / 100)) + " L 0 0";
        }
    }

    // Get the Arc for Starting Point
    get dStartValue() {
        return "M 1 0 A 1 1 0 " + Math.floor(0.3 / (100 / 2)) + " 1 " +
            Math.cos(2 * Math.PI * 0.3 / 100) + " " +
            Math.sin(2 * Math.PI * 0.3 / 100) + " L 0 0";
    }

    // Get the Remaining Payments Count
    get remainingValue() {
        return this.maxValue - this.currentValue;
    }

    // Get the X Co-Ordinate of Circle
    get circlex() {
        let x;
        let percentage = (this.maxValue == 0 || this.currentValue == 0) ? 1 : (this.currentValue / this.maxValue) * 100;
        let xCo = (((3.6 * percentage) + 90) * (Math.PI / 180));
        x = (42 * Math.cos(xCo)) + 50;

        return x;
    }

    // Get the Y Co-Ordinate of Circle
    get circley() {
        let y;
        let percentage = (this.maxValue == 0 || this.currentValue == 0) ? 1 : (this.currentValue / this.maxValue) * 100;
        let yCo = (((3.6 * percentage) + 90) * (Math.PI / 180));
        y = (42 * Math.sin(yCo)) + 50;

        return y;
    }


}