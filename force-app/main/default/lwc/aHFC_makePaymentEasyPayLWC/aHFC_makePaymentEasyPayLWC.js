/*  Component Name       :    aHFC_makePaymentEasyPayLWC
    * Description        :    This Component is used to display Easy Page section of make a payment page
    * Modification Log   :    Created by Vishnu 
    * Modification Log   :    Modified by edwin as pert of US: 4988. Restrict the values populated in date dropdown.
    *                    :    Need to show attention message based on values selected in date dropdown     
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Vishnu                     1/07/2021              Created
    * Edwin                      9/07/2021              Modified
    * Sagar                      11/09/2021             Modified for bug fix 20203
*********************************************************************************/
import { LightningElement, track, api } from 'lwc';
import { label } from "c/aHFC_makeAPaymentUtil";
import { NavigationMixin } from "lightning/navigation";
import { getConstants } from "c/ahfcConstantUtil";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import AHFC_Payment_Error_Message from "@salesforce/label/c.AHFC_Payment_Error_Message";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import AHFC_CutOffTime from "@salesforce/label/c.AHFC_CutOffTime";
import nextWithdrawalDateCaculation from "@salesforce/apex/AHFC_AddPaymentSourceClass.calculateNextWithdrawalDate";
import isAfterCutOffTime from "@salesforce/apex/AHFC_SchedulePaymentController.isAfterCutOffTime";

import {
    loadStyle
} from "lightning/platformResourceLoader";

const CONSTANTS = getConstants();

export default class AHFC_makePaymentEasyPayLWC extends NavigationMixin(LightningElement) {

    @track labels = label;

    @api paymentdate;
    @api paymentamount;
    @api boolShowStdPaymentAmountMsg;
    @api strStdPaymentAmountMsg;
    @api linkonToast;
    @api financeAccountData;
    @api boolShowAutoPayAmtMsg = false;

    @track payOffAmountData;
    @track regularMonthlyPaymentData;
    @track accountTypeData;
    @track flRefinancedData;
    @track attentionMessage = '';
    
    @track boolShowAttentionMsg = false;
    @track hasValueChanged = false;

    //US:4988 by edwin
    @track boolShowAttentionModal = false;
    @track errorMessageLeaseZero = '';
    @track isRenderCall = false;
    @track boolLeaseError = false;
    @track nextPaymentDueDate;
    @track nextWithDrawalDate;

    @track isFromReviewPage = false;
    @track currentCutoffFlag;
    @track chargeDate;
    @track isEasyPayEditPayment=true;

    isEasyPayDateChanged;
    automaticPaymentAmount = 0.0;
    easyPaySelectedDate;
    setEasyPayDate;
    @track dateValueLoaded = true;
    @track slectedDate = '0';
    @track isEditPaymentEasyPay=false;

    renderedCallback() {
        if (!this.isRenderCall) {
            this.validateZeroAmountLeaseType();
        }

    }
    
    connectedCallback() {

        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
        this.automaticPaymentAmount = this.financeAccountData.Regular_Monthly_Payment__c;
        
        if (!this.financeAccountData.hasOwnProperty('isFromEasyPayReview')) {
            console.log('85',this.automaticPaymentAmount);
            sessionStorage.setItem('regularPaymentAmount', this.automaticPaymentAmount);
        }
        this.isFromReviewPage = this.financeAccountData.isFromEasyPayReview;

        //Setup Make Payment on redirecting from Easy Pay Confirm Screen  --edwin
        if (this.isFromReviewPage) {
            if (sessionStorage.getItem('dateValue')) { //bug fix edwin
                console.log('Data from session: ' + sessionStorage.getItem('dateValue'));
                this.value = sessionStorage.getItem('dateValue');
                this.populateNextWithdrawDate(this.value);
                this.isEasyPayDateChanged = true;
            }
        }
        this.isEditPaymentEasyPay = this.financeAccountData.isEditPayment;
        this.getCutoffFlag();

    }

    getCutoffFlag() {
        isAfterCutOffTime({}).then((result) => {
            this.currentCutoffFlag = result;
        });
    }
    /* Bug Fix -21693 */
    @api
    isEditPayment(financeAccountData){
        this.isEasyPayEditPayment = false;
        this.setAutomaticPaymentAmount(financeAccountData);
    }
 
    @api
    setAutomaticPaymentAmount(financeAccountData) {
        console.log('xxxx',financeAccountData);
        sessionStorage.setItem('regularPaymentAmount', this.financeAccountData.Regular_Monthly_Payment__c);
        this.financeAccountData = financeAccountData;
        
        this.automaticPaymentAmount = this.financeAccountData.Regular_Monthly_Payment__c;
        this.isEasyPayDateChanged = false;
        /* Bug Fix -21693 Starts*/
        let withdarDateInput = this.template.querySelector('.withDrawDate');
        console.log('withdarDateInput',withdarDateInput);
        if(withdarDateInput != undefined)
        {
        this.isEasyPayDateChanged = false;
        console.log('this.isEasyPayEditPayment',this.isEasyPayEditPayment);
        if(this.isEasyPayEditPayment){
        withdarDateInput.value= undefined; 
        this.isEasyPayEditPayment = true;
        this.setEasyPayDate = undefined;
        }
        
        withdarDateInput.setCustomValidity('');
        withdarDateInput.reportValidity();
        }
        
        /* Bug Fix -21693 Starts*/
        this.validateZeroAmountLeaseType(); // 20276 Regression testing changes
    }
    /** Method Name: validateZeroAmountLeaseType
     *  Description:    to validate Zero amoount regular monthly pay when Account Type is Lease
     *  Developer Name: Aswin Jose
     *  Created Date:   09-july-2021 
     *  User Story :    3735
     **/
    validateZeroAmountLeaseType() {
        let zeroValue = 0.00; 
        if(!this.financeAccountData.isPayOff){
        
        this.boolLeaseError = false;// 20276 Regression testing changes
        this.boolShowAutoPayAmtMsg = false;// 20276 Regression testing changes
        this.isRenderCall = false;// 20276 Regression testing changes
        this.errorMessageLeaseZero = '';// 20276 Regression testing changes
        }
        let targetPart = this.template.querySelector(".schedule-inputReadonly");
        if (targetPart != null) {
            if (this.financeAccountData.Regular_Monthly_Payment__c == zeroValue && !this.financeAccountData.isPayOff) {
                this.boolShowAutoPayAmtMsg = true;
                this.boolLeaseError = true;
                this.isRenderCall = true;
                this.errorMessageLeaseZero = "Monthly Payment Amount cannot be equal to $0.00.";
            }
        }
    }

    /** Method Name: dateValues
     *  Description:    to get range of date values for the date picker picklist
     *  Developer Name: Vishnu
     *  Created Date:   01-july-2021 
     *  User Story :    4531
     **/
    get dateValues() {
        var dateValues = [];
        var datRange = [];
        dateValues = this.setDateValues(); // US:4988, method to restrict values loaded in dropdown based on business rule
        console.log('@@@dateValues' + dateValues);
        for (var i = 0; i < dateValues.length; i++) {
            var dateVal;
            if (dateValues[i] == 1 || dateValues[i] == 21 || dateValues[i] == 31) {
                dateVal = { label: dateValues[i] + 'st of the month', value: dateValues[i].toString() };
            } else if (dateValues[i] == 2 || dateValues[i] == 22) {
                dateVal = { label: dateValues[i] + 'nd of the month', value: dateValues[i].toString() };
            } else if (dateValues[i] == 3 || dateValues[i] == 23) {
                dateVal = { label: dateValues[i] + 'rd of the month', value: dateValues[i].toString() };
            } else {
                dateVal = { label: dateValues[i] + 'th of the month', value: dateValues[i].toString() };
            }
            datRange.push(dateVal);
        }

        return datRange;
    }

    onToastLinkClicked() {
        //navigate to scheduled payment page
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'manage-payment'
            },
            state: {
                sacRecordId: this.financeAccountData.sacRecordId
            }
        });
    }

    /** Method Name: handleDateValueChange
     *  Description:    Validation can be done here for date range 
     *  Developer Name: Vishnu
     *  Created Date:   01-july-2021 
     *  User Story :    4531
     *  Parameter : date onchange event as parmeter
     **/
    handleDateValueChange(event) {
        this.dateValueLoaded = false;
        sessionStorage.setItem('dateValue', event.detail.value);
        this.valuesChanged();
        let withdarDateInput = this.template.querySelector('.withDrawDate');
        withdarDateInput.setCustomValidity('');
        withdarDateInput.reportValidity();
        var dateValue = parseInt(event.detail.value);
        this.slectedDate = event.detail.value;
        this.populateNextWithdrawDate(dateValue);
    }

    disableReviewButton(){
        const selectedEvent = new CustomEvent('disablereviewbutton');//Bug Fix 21492
        this.dispatchEvent(selectedEvent);//Bug Fix 21492
    }

    enableReviewButton(){
        const selectedEvent = new CustomEvent('enablereviewbutton');//Bug Fix 21492
        this.dispatchEvent(selectedEvent);
    }


    /** Method Name: populateNextWithdrawDate
     *  Description:    calculates next withdrawal date
     *  Developer Name: Vishnu
     *  Created Date:   01-july-2021 
     *  User Story :    4531
     *  Parameter : selected date as parameter
     **/
   
    populateNextWithdrawDate(dateValue) {
        this.disableReviewButton();
        this.chargeDate = dateValue;  // assign charge date as date value selected by user
        nextWithdrawalDateCaculation({
            dateValue: dateValue,
            firstDueDate:this.financeAccountData.firstDueDate
        }).then((result) => {
            this.isEasyPayDateChanged = true;
            console.log(result);
            this.setEasyPayDate = new Date(result);//setCurrtentDate;
            console.log('this.setEasyPayDate',this.setEasyPayDate);
            this.nextWithDrawalDate = this.formatDateForModal(this.setEasyPayDate);

            sessionStorage.setItem('nextWithDrawalDate', this.nextWithDrawalDate);
            this.dateValueLoaded = true;
            this.validateWithdrawalDate();
            this.enableReviewButton();
        }).catch((error) => {
            this.error = error;
            console.log('this.error>>>>>>>>>>>>>>>>>>>>>>',this.error);
            this.paymentCreationError();
            this.dateValueLoaded = true;
            this.enableReviewButton();
        });
    }

   
    /* payment creation error Message*/
    paymentCreationError() {
        const event = new ShowToastEvent({
          title: "Error",
          message: AHFC_Payment_Error_Message,
          variant: "error",
          mode: "dismissable"
        });
        this.dispatchEvent(event);
      }
      
    /** Method Name: sendEasyPayValues
     *  Description:    used to get values for the parent
     *  Developer Name: Vishnu
     *  Created Date:   01-july-2021 
     *  User Story :    4531
     **/
    @api
    sendEasyPayValues() {
        if (typeof this.setEasyPayDate === CONSTANTS.UNDEFINED) {
            let withdarDateInput = this.template.querySelector('.withDrawDate');
            withdarDateInput.setCustomValidity('Error: Select a payment date.');
            withdarDateInput.reportValidity();
            withdarDateInput.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
            return;
        };
        if(this.setEasyPayDate>new Date(this.financeAccountData.ChargentOrders__Payment_End_Date__c)){
            let withdarDateInput = this.template.querySelector('.withDrawDate');
            this.isEasyPayDateChanged = false;
            withdarDateInput.setCustomValidity('Error: Next Withdrawal Date cannot be beyond final Payment Due Date of '+ this.formatDateForModal(new Date(this.financeAccountData.ChargentOrders__Payment_End_Date__c))+'.');
            withdarDateInput.reportValidity();
            withdarDateInput.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
            return; 
        }

        // Added By Sagar for bug fix 20203 , check validaity on amount field 

        let targetPart = this.template.querySelector(".schedule-input");
        
        if(targetPart!==null && targetPart.checkValidity()==false)
        {
            targetPart.scrollIntoView({ behavior: "smooth", block: "center", inline: "nearest" });
            return; 
        }
        const selectedEvent = new CustomEvent('setvalues', { detail: { automaticPaymentAmount: Number(this.automaticPaymentAmount), setEasyPayDate: this.setEasyPayDate, chargeDate: this.chargeDate } });
        this.dispatchEvent(selectedEvent);
    }

    valuesChanged() {
        if (!this.hasValueChanged) {
            const selectedEvent = new CustomEvent('changevalues');
            this.dispatchEvent(selectedEvent);
            this.hasValueChanged = true;
        }
    }
    /** Method Name: validateAutomaticPaymentAmount
     *  Description:    Validation can be done here for payment amount 
     *  Developer Name: Vishnu
     *  Created Date:   01-july-2021 
     *  User Story :    4531
     *  Parameter : amount  onchange event as parmeter
     *  Modified By : Aswin Jose for US 3735
     **/
    validateAutomaticPaymentAmount(event) {
        this.valuesChanged();
        this.boolShowAttentionMsg = false;
        this.automaticPaymentAmount = event.detail.value;
        this.automaticPaymentAmount=Number(this.automaticPaymentAmount).toFixed(2); 
        let targetPart = this.template.querySelector(".schedule-input");
        let userInputMonthlyPayAmt = event.detail.value;

        let payOffAmount = this.financeAccountData.Payoff_Amount__c;
        let regularMonthlyPayment = this.financeAccountData.Regular_Monthly_Payment__c;
       console.log('yyyyy',this.financeAccountData.Regular_Monthly_Payment__c);
        //Setup Make Payment on redirecting from Easy Pay Confirm Screen  --edwin
        if (this.isFromReviewPage && sessionStorage.getItem('regularPaymentAmount')) {
            regularMonthlyPayment = sessionStorage.getItem('regularPaymentAmount');
        }

        let twoDecimal = 0.00;
        let difference = userInputMonthlyPayAmt - regularMonthlyPayment;
        console.log('userInputMonthlyPayAmt',userInputMonthlyPayAmt);
        console.log('twoDecimal',twoDecimal);
        console.log('!this.financeAccountData.isPayOff',this.financeAccountData.isPayOff);
        if (userInputMonthlyPayAmt == twoDecimal && !this.financeAccountData.isPayOff) {
            console.log('5a-');
            this.boolShowAutoPayAmtMsg = true;
            targetPart.setCustomValidity("Error: Monthly Payment Amount cannot be equal to $0.00.");
        } else if (Number(userInputMonthlyPayAmt) < Number(regularMonthlyPayment) && this.financeAccountData.isPayOff) {
            console.log('4a-');
            this.boolShowAutoPayAmtMsg = true;
            targetPart.setCustomValidity("Error: Monthly Payment Amount must be equal to or greater than $" + regularMonthlyPayment + ".");
        } else if (userInputMonthlyPayAmt >= Number(payOffAmount)) {
            console.log('3a-');
            this.boolShowAutoPayAmtMsg = true;
            targetPart.setCustomValidity("Error: Monthly Payment Amount cannot be greater than or equal to the Payoff Amount.");
        } else if (userInputMonthlyPayAmt > Number(regularMonthlyPayment) && targetPart.checkValidity()==true) {
            console.log('6a-');
            this.boolShowAutoPayAmtMsg = false;
            this.boolShowAttentionMsg = true;
            
            this.attentionMessage = "The amount you entered exceeds your Regular Monthly Payment by $" + difference.toFixed(2) + ". A total of $" + Number(userInputMonthlyPayAmt).toFixed(2) + " will be withdrawn from your bank account every month.";
            targetPart.setCustomValidity(""); //Added by Aswin Jose  for SIT bug 14877 :  difference.toFixed(2)
        } else {
            console.log('2a-');
            this.boolShowAutoPayAmtMsg = false;
            targetPart.setCustomValidity("");
        }
        targetPart.reportValidity();

    }

    //US:4988 by edwin starts
    /** Method Name: setDateValues
     *  Description:    configure the dropdown values for next withdrawal field
     *  Developer Name: Edwin
     *  Created Date:   08-july-2021 
     *  User Story :    4988
     **/
    setDateValues() {
        var startdate;
        var endDate;
        var currentDate = new Date();
        var dateRange = [];
        var month = currentDate.getMonth();
        var year = currentDate.getFullYear();
        var lastDayOfTheMonth = new Date(year, month + 1, 0).getDate();
        let dueDate = new Date(this.financeAccountData.dueDate);
        if (typeof this.financeAccountData.dueDate !== CONSTANTS.UNDEFINED) {

            if (this.financeAccountData.Region_Code__c === "NRC") { //If NRC then restrict the customer from selecting a Day of the Month between 1 and 7 days after Due On Day
                startdate = new Date(this.addDays(dueDate, 1)).getDate();
                endDate = new Date(this.addDays(dueDate, 8)).getDate();
            } else if (this.financeAccountData.Region_Code__c !== "NRC") { // If account is not owned by NRC, then restrict customer from selecting a Day of the Month between 1 and 10 days after Due On Day
                startdate = new Date(this.addDays(dueDate, 1)).getDate();
                endDate = new Date(this.addDays(dueDate, 11)).getDate();
            }
            if (startdate < endDate) {
                for (var i = 1; i <= 31; i++) {
                    if (i < startdate || i >= endDate) {
                        dateRange.push(i);
                    }
                }
            } else {
                for (var i = 1; i <= 31; i++) {
                    if (i < startdate && i >= endDate) {
                        dateRange.push(i);
                    }
                }
            }
        } else { //if due date and nrc are not defined
            for (var j = 1; j <= 31; j++) {
                dateRange.push(j);
            }
        }

        return dateRange;

    }

    addDays(date, days) {
        const months = CONSTANTS.MONTHS_LC;
        var result = new Date(date.getTime() + date.getTimezoneOffset() * 60 * 1000);
        result.setDate(result.getDate() + days);
        return (result != CONSTANTS.INVALID_DATE) ? result : "";
    }

    /** Method Name:    validateWithdrawalDate
     *  Description:    validate the next withdrawal date 
     *  Developer Name: Edwin
     *  Created Date:   09-july-2021 
     *  User Story :    4988
     **/
    validateWithdrawalDate() {
        console.log('Validate date selection');
        let nextDuedate = this.financeAccountData.dueDate;
        let nextWithdrawlDate = this.formatDatewithOffset(this.setEasyPayDate);
        console.log('dateValue)))))))))))))))))',nextWithdrawlDate);
        let paidToDate = this.financeAccountData.paidToDate;
        var currentDate = new Date();
        var dayOfSelectedDate = new Date(nextWithdrawlDate);
        dayOfSelectedDate = new Date(dayOfSelectedDate.getTime() + dayOfSelectedDate.getTimezoneOffset() * 60 * 1000).getDate();

        var month = currentDate.getMonth();
        var year = currentDate.getFullYear();
        var lastDayOfTheMonth = new Date(year, month + 1, 0).getDate();

        console.log('@@this.userAccountInfo: ' + JSON.stringify(this.financeAccountData));
        console.log('@@duedate: ' + nextDuedate);
        console.log('@@@@nextWithdrawlDate: ' + nextWithdrawlDate);
        console.log('@@paidToDate: ' + paidToDate);
        console.log('@@lastDayOfTheMonth: ' + lastDayOfTheMonth);

        if (this.slectedDate == 29 || this.slectedDate == 30 || this.slectedDate == 31) { //if user select a day which is not in that month, ex: user select 30 in feb
            this.boolShowAttentionMsg = true;
            this.attentionMessage = 'In months without ' + this.slectedDate + ' days, your payment will be processed on the last day of the month.';
        } else {
            this.boolShowAttentionMsg = false;
            this.attentionMessage = '';
        }
        if (nextWithdrawlDate > nextDuedate && paidToDate <= nextDuedate) {
            if(!this.isEditPaymentEasyPay){
            this.boolShowAttentionModal = true;
            this.nextPaymentDueDate = this.formatDateForModal(nextDuedate);
            this.nextWithDrawalDate = this.formatDateForModal(this.setEasyPayDate);
            if(this.template.querySelector('c-a-h-f-c_common-modal-pop-up')!=null&&this.template.querySelector('c-a-h-f-c_common-modal-pop-up')!=undefined)
            {
                this.template.querySelector('c-a-h-f-c_common-modal-pop-up').openModal();
                
            }
            }else{
                this.isEditPaymentEasyPay = false;
            }
        }
    }
    oncloseAttentionModal() {
        this.boolShowAttentionModal = false;
    }

    /** Method Name:    formatDate
     *  Description:    format the date in yyyy-mm-dd
     *  Developer Name: Edwin
     *  Created Date:   09-july-2021 
     *  User Story :    4988
     **/
    formatDate(date) {
        var d = new Date(date),
            month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();

        if (month.length < 2)
            month = '0' + month;
        if (day.length < 2)
            day = '0' + day;

        return [year, month, day].join('-');
    }

    formatDatewithOffset(date) {
        console.log('dateValue)))))))))))))))))0',date);
        let dateValue = new Date(date) ;
        console.log('dateValue)))))))))))))))))',dateValue);
        dateValue = new Date(dateValue.getTime() + dateValue.getTimezoneOffset() * 60 * 1000);
        console.log('dateValue)))))))))))))))))1',dateValue);
        var d = new Date(dateValue),
            month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();

        if (month.length < 2)
            month = '0' + month;
        if (day.length < 2)
            day = '0' + day;

        return [year, month, day].join('-');
    }

    /** Method Name:    formatDateForModal
     *  Description:    format the date in Aug 3, 2021
     *  Developer Name: Edwin
     *  Created Date:   09-july-2021 
     *  User Story :    4988
     **/
    formatDateForModal(dt) {
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
 
}