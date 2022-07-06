/* Name               :    aHFC_alreadyMadePayment
 * Description        :    This Component will display the Payment details and select the amount you paid sectiom. 
 * Modification Log   :
 * ---------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ---------------------------------------------------------------------------
 * Kanagaraj                27/04/2021              created
 * Prabu                    28/07/2021              Modified by Prabu US#: 9970 
 * Vishnu                   24/08/2021              Modified by Vishnu US#: 6905 
 * Akash                    26/08/2021              Modified by Akash US# 12062
 *********************************************************************************/
import {
    LightningElement,
    track,
    wire
} from "lwc";
import {
    loadStyle
} from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import successIcon from "@salesforce/resourceUrl/AHFC_SuccessIcon";
import infoSvg from "@salesforce/resourceUrl/AHFC_info";
import {
    getLabels
} from "c/aHFC_alreadyMadePaymentConstantsUtil";
import {
    getConstants
} from "c/ahfcConstantUtil";
import {
    NavigationMixin
} from "lightning/navigation";
import {
    CurrentPageReference
} from "lightning/navigation";
import getFinanceAccountDetails from "@salesforce/apex/AHFC_AlreadyMadeaPaymentClass.getFinanceAccountDetails";
import handlePromiseMade from "@salesforce/apex/AHFC_PromiseMadeServiceHandler.putPromisMade";
import {
    ShowToastEvent
} from "lightning/platformShowToastEvent";
import {
    fireAdobeEvent
} from "c/aHFC_adobeServices";
import {
    fireEvent
} from 'c/pubsub';
import {
    createMessageContext,
    releaseMessageContext,
    APPLICATION_SCOPE,
    subscribe,
    unsubscribe
} from "lightning/messageService";
import spinnerWheelMessage from "@salesforce/label/c.Spinner_Wheel_Message";

export default class aHFC_alreadyMadePayment extends NavigationMixin(
    LightningElement
) {
    @track routingSpinner = false; //Added by Prabu for the bug - 22313
    /* 6905 Variables starts*/
    @track showNotificationOnChange = false;
    @track showPopUpNotificationOnChange = false;
    /* 6905 Variables Ends*/
    @track isPromiseMadeSuccess;
    @track finAccNo;
    @track ispaymentMode = false;
    @track isNegnumber = false;
    @track serviceAccountWrapper = [];
    @track isPromiseMade = false;
    @track dblTotalDaysPastDue;
    @track dblRemainingAmountDue;
    @track listModesOfPayment = [];
    @track dblTotalAmountDue;
    @track dblPastAmountDue;
    @track showTrackingPopover = false;
    @track boolOtherAmountDue = false;
    @track afterResultPaymentMode = "";
    @track sacRecordId;
    @track noCustomerServiceDetail = false;
    @track openCancelmodal = false;
    @track isWebServiceDown = false;
    @track isWrongFormate = false;
    @track madePaymentDetails = {
        lookupID: "",
        confirmNumber: "",
        promiseAmount: "",
        promiseDate: "",
        promiseMadeType: ""
    };
    @track madePaymentPastDueDays = "";
    @track promiseDateFormatted;
    @track finaccDetail;
    @track isTrackingError = false; // Added by Akash as part of 12062
    infoSvg = infoSvg;
    successIcon = successIcon;
    label = getLabels();
    @track spinnerMessage = spinnerWheelMessage;
    onClickTrackingInfo() {
        this.showTrackingPopover = true;
    }
    onleaveTrackingInfo() {
        this.showTrackingPopover = false;
    }
    onTouchstartTrackingInfo() {
        this.showTrackingPopover = true;
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            if (
                currentPageReference.state.sacRecordId != undefined
            ) {
                this.sacRecordId = currentPageReference.state.sacRecordId;
                this.getFinanaceAcc();
            }
        }
    }

    getFinanaceAcc() {
        sessionStorage.setItem('salesforce_id', this.sacRecordId);
        getFinanceAccountDetails({
                selectedFinAcc: this.sacRecordId
            }).then((result) => {
                this.finaccDetail = JSON.parse(JSON.stringify(result));
                console.log('125', this.finaccDetail);
                this.dblTotalDaysPastDue = typeof this.finaccDetail.AHFC_Total_days_past_due__c != undefined ? this.finaccDetail.AHFC_Total_days_past_due__c : 0;
                this.dblRemainingAmountDue = typeof this.finaccDetail.Remaining_Amount_Due__c != undefined ? this.finaccDetail.Remaining_Amount_Due__c : 0;
                this.dblTotalAmountDue = typeof this.finaccDetail.Total_Amount_Due__c != undefined ? this.finaccDetail.Total_Amount_Due__c : 0;
                this.madePaymentDetails.promiseAmount = typeof this.finaccDetail.Total_Amount_Due__c != undefined ? this.finaccDetail.Total_Amount_Due__c : 0;
                this.dblPastAmountDue = typeof this.finaccDetail.Past_Amount_Due__c != undefined ? this.finaccDetail.Past_Amount_Due__c : 0;
                this.madePaymentDetails.lookupID = this.finaccDetail.Id;
                this.finAccNo = this.finaccDetail.Finance_Account_Number__c;
                
                if (this.dblPastAmountDue > 0) {
                    this.madePaymentPastDueDays = this.label.madePaymentPastDueDays.replace("{0}", this.formatCurrency(this.dblPastAmountDue));
                    this.madePaymentPastDueDays = this.madePaymentPastDueDays.replace("{1}", this.dblTotalDaysPastDue);
                } else {
                    this.madePaymentPastDueDays = '';
                }
                if (this.label.Customer_Service_Phone_Number == undefined || this.label.Customer_Service_Phone_Number == '') {
                    this.noCustomerServiceDetail = true;
                }
                console.log('142', this.dblPastAmountDue);

            })
            .catch((error) => {
                console.log('line no 85', error);
            });
    }

    //On page loads - retrieve data from message channel and load modes of payment
    connectedCallback() {
        let adobedata = {
            "Page.site_section": "Already Made a Payment",
            "Page.page_name": "Already Made a Payment",
            "Page.referrer_url": document.referrer
            // "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        loadStyle(this, ahfctheme + "/theme.css").then(() => {});
        this.getPaymentModes();
    }

    //displaying payment modes in picklist [Payment made via US Mail, Payment made via Pay by Phone, 
    //Payment made via Western Union Quick Collect, Payment made via Moneygram, Payment made via Web Payment]
    getPaymentModes() {
        let modeOfPay = this.label.madePaymentModeOfPayments;
        let modeOfPayValue = this.label.madePaymentModeOfPaymentValues;
        let arrModeOfPay = modeOfPay.split(this.label.commaSaparate);
        let arrModeOfPayValue = modeOfPayValue.split(this.label.commaSaparate);
        this.listModesOfPayment = arrModeOfPay.map((arr1, arr2) => {
            const obj = {
                label: arr1,
                value: arrModeOfPayValue[arr2]
            };
            return obj;
        });
    }

    //To get 30 days past date in yyyy-mm-dd format
    get minDate() {
        let temp = new Date(); //today's date
        temp = new Date(temp.setDate(1));
       temp = new Date(temp.setMonth(temp.getMonth()-1));
        let tempDate = this.returnLastDateOfTheMonth(temp.getFullYear,temp.getMonth);        
        let startDate = new Date(); //today's date
        let currentDate = this.returnLastDateOfTheMonth(startDate.getFullYear,startDate.getMonth);        
        if(currentDate> tempDate){            
            startDate = new Date(startDate.setDate(currentDate));            
        }
       startDate = new Date(startDate.setMonth(startDate.getMonth() - 1));       
        console.log('fulldate', startDate.toLocaleString('default', { month: 'long' }));
        return this.formatDateForArray(
            startDate.getDate(),
            startDate.getMonth(),
            startDate.getFullYear()
        );
    }

    returnLastDateOfTheMonth(y, m) {
        return new Date(y, m + 1, 0).getDate();
    }

    //To get todays date in yyyy-mm-dd format
    get maxDate() {
        const today = new Date(); //today's date
        return this.formatDateForArray(
            today.getDate(),
            today.getMonth(),
            today.getFullYear()
        );
    }

    //To format in yyyy-mm-dd
    formatDateForArray(date, month, year) {        
        if (month < 9) {
            month = "0" + (month + 1);
        } else {
            month = month + 1;
        }
        if (date <= 9) {
            date = "0" + date;
        } else {
            date = date;
        }
        return [year, month, date].join("-");
    }

    //Subcribe to MessageChannel to recieve the data from parent
    subscribeToMessageChannel() {

    }

    // received Message Channel from header and retrieving service account related data 
    // handleMessage() {
    //   let stringdata = '[{"boolenrolled":false,"datToday":"2021-04-29","dblTotalAmountDue":7004.7,"dblTotalDaysPastDue":25,"idSAC":"a051g000002D4DcAAK","intDaysUntilDueDate":-71,"intStatusCheck":1,"isHonda":true,"objVehicle":{"AHFC_Service_Account__c":"a061g000003CmRnAAK","Id":"a071g0000030bzwAAA","AHFC_Vehicle_Identification_Number__c":"98765432112345678"},"serAccRec":{"Name":"2021 Accord LX","AHFC_Region_Code__c":"102","Finance_Account_Number__c":"00055445822021","AHFC_Payoff_Payment_Eligible_Web__c":true,"AHFC_Payoff_Payment_Eligible_Agent__c":true,"AHFC_Status__c":"Current","RecordTypeId":"0121g000001aXprAAE","AHFC_One_Time_Payment_Eligible_Web__c":true,"AHFC_Recurring_Payment_Eligible_Agent__c":true,"AHFC_Principal_Balance_Amount__c":49557.41,"AHFC_Number_of_Payments_Remaining__c":31,"CreatedDate":"2021-02-10T16:18:35.000Z","AHFC_Original_Finance_Amount__c":49557.41,"AHFC_Future_OneTime_Payment_Eligible_Web__c":true,"AHFC_Future_OneTime_Payment_Eligible_Agt__c":true,"AHFC_OneTime_Payment_Eligible_Agent__c":true,"AHFC_Current_Amount_Due__c":697.47,"Past_Amount_Due__c":2789.88,"Total_Fees_Due__c":3517.35,"AHFC_Refinanced__c":false,"AHFC_Honda_Brand__c":"HFS","AHFC_Maturity_Date__c":"2023-09-17","AHFC_Calculated_Total_Payments__c":48,"AHFC_Last_Payment_Date__c":"2021-01-17","AHFC_Last_Payment_Amount__c":661.81,"Remaining_Amount_Due__c":661.81,"AHFC_Next_Due_Date__c":"2021-02-17","AHFC_Charge_Amount__c":110,"AHFC_Recurring_Payment_Eligible_Web__c":true,"AHFC_Account_Type__c":"Retail","AHFC_Payment_Status__c":"Cancelled","AHFC_Next_Withdrawal_Date__c":"2021-02-17","AHFC_Product_Nickname__c":"2021 Accord LX","AHFC_Term__c":48,"AHFC_Total_days_past_due__c":98,"Id":"a061g000003CmRnAAK","Collaterals__r":[{"AHFC_Service_Account__c":"a061g000003CmRnAAK","Id":"a071g0000030bzwAAA","AHFC_Vehicle_Identification_Number__c":"98765432112345678"}],"RecordType":{"Name":"Retail","Id":"0121g000001aXprAAE"}}}]';
    //   let data = JSON.parse(stringdata);
    //   this.serviceAccountWrapper = data;

    //   this.dblTotalDaysPastDue = this.serviceAccountWrapper[0].dblTotalDaysPastDue;
    //   this.dblRemainingAmountDue = typeof this.serviceAccountWrapper[0].serAccRec.Remaining_Amount_Due__c != undefined ? this.serviceAccountWrapper[0].serAccRec.Remaining_Amount_Due__c : 0;
    //   this.dblTotalAmountDue = this.serviceAccountWrapper[0].dblTotalAmountDue;
    //   this.dblPastAmountDue = typeof this.serviceAccountWrapper[0].serAccRec.Past_Amount_Due__c != undefined ? this.serviceAccountWrapper[0].serAccRec.Past_Amount_Due__c : 0;
    //   this.madePaymentDetails.promiseAmount = this.serviceAccountWrapper[0].dblTotalAmountDue;
    //   this.madePaymentDetails.lookupID =
    //     this.serviceAccountWrapper[0].serAccRec.Finance_Account_Number__c;
    //   this.madePaymentPastDueDays = this.label.madePaymentPastDueDays.replace(
    //     "{0}",
    //     this.dblPastAmountDue
    //   );
    //   this.madePaymentPastDueDays = this.madePaymentPastDueDays.replace(
    //     "{1}",
    //     this.dblTotalDaysPastDue
    //   );
    // }

    //Unsubscribe to Message channel
    UnsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = undefined;
        releaseMessageContext(this.context);
    }

    Oncancel() {
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Already Made a Payment:Button:Cancel",
            "Event_Metadata.action_category": "Made a Payment",
            "Page.page_name": "Already Made a Payment",
            //"Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
        this.openCancelmodal = true;
    }
    OnBack() {
        this.openCancelmodal = false;
    }
    // added by Akash as part of US 12062
    formatCurrency(curNumber) {
        var formatter = new Intl.NumberFormat("en-US", {
            style: "currency",
            currency: "USD",
            maximumFractionDigits: 2
        });
        return formatter.format(curNumber);
    }

    //Handling Input values
    handleInputData(event) {
        let targetId;
        targetId = event.target.getAttribute("data-id");
        switch (targetId) {
            case "confirm-input":
                this.madePaymentDetails.confirmNumber = event.target.value;
                if (!/^[a-zA-Z0-9]+$/.test(event.target.value) && event.target.value !== '') { //Added by Akash as part of 12062
                    this.isTrackingError = true; //Added by Akash as part of 12062
                } else {
                    this.isTrackingError = false; //Added by Akash as part of 12062
                }
                break;
            case "paymentModeCombo":
                this.inputValuesChanged();
                this.madePaymentDetails.promiseMadeType = event.target.value;
                this.ispaymentMode = false;
                break;
            case "todatemob":
                this.inputValuesChanged();
                this.madePaymentDetails.promiseDate = event.target.value;
                this.isWrongFormate = false;
                break;
            case "radio-total":
                this.isWebServiceDown = false;
                this.madePaymentDetails.promiseAmount = this.dblTotalAmountDue;
                this.boolOtherAmountDue = false;
                break;
            case "radio-past":
                this.isWebServiceDown = false;
                this.madePaymentDetails.promiseAmount = this.dblPastAmountDue;
                this.boolOtherAmountDue = false;
                break;
            case "radio-other":
                this.isWebServiceDown = false;
                this.madePaymentDetails.promiseAmount = event.target.value;
                this.boolOtherAmountDue = true;

                break;
            case "amount-input":
                if (Number(event.target.value) < 1) {
                    this.isNegnumber = true;
                    break;
                } else {
                    this.isNegnumber = false;
                }
                this.madePaymentDetails.promiseAmount = event.target.value;
                break;
        }
    }

    //  To handle Promise made submission from the customer community and
    //  return true if the integration succeeded, false if the integration failed
    onSubmit() {
        console.log('OnSubmitEntry');
        console.log('ConfirmNumber', this.madePaymentDetails.confirmNumber);
        console.log('PromiseAmt', this.madePaymentDetails.promiseAmount);
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Already Made a Payment:Button:Submit",
            "Event_Metadata.action_category": "Made a Payment",
            "Page.page_name": "Already Made a Payment",
            //"Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');        
        const inputList = this.template.querySelectorAll(".slds-input"); //Added by Akash as part of 12062
        for (let i = 0; i < inputList.length; i++) { //Added by Akash as part of 12062
            inputList[i].focus(); //Added by Akash as part of 12062
            inputList[i].blur(); //Added by Akash as part of 12062
        }

        if (this.madePaymentDetails.promiseMadeType == '') {
            this.ispaymentMode = true;
        }
        if (this.madePaymentDetails.promiseAmount < 1 || this.madePaymentDetails.promiseAmount == '') {
            this.isNegnumber = true;
        }
        if (this.madePaymentDetails.promiseDate == '') {
            this.isWrongFormate = true;
        }
        if (this.madePaymentDetails.promiseMadeType == '' || this.madePaymentDetails.promiseAmount < 1 || this.madePaymentDetails.promiseAmount == '' || this.madePaymentDetails.promiseDate == '') {
            this.isWebServiceDown = true;
            return;
        }        
        console.log('MinDate', this.minDate);
        console.log('MaxDate', this.maxDate);        
        if (this.madePaymentDetails.promiseDate <= this.maxDate &&
            this.madePaymentDetails.promiseDate >= this.minDate &&
            (this.madePaymentDetails.promiseAmount !== null && 
                this.madePaymentDetails.promiseAmount !== undefined)
             && this.madePaymentDetails.lookupID !== "") {
            console.log('AfterresultPaymentEntry');
            // this.promiseDateFormatted = this.madePaymentDetails.promiseDate;
            this.promiseDateFormatted = this.formatDate(this.madePaymentDetails.promiseDate);
            for (let count = 0; count < this.listModesOfPayment.length; count++) {
                if (this.madePaymentDetails.promiseMadeType === this.listModesOfPayment[count].value) {
                    this.afterResultPaymentMode = this.listModesOfPayment[count].label;
                }
            }

            //Added by Prabu - US 9970 - Start
            if (this.afterResultPaymentMode !== null &&
                this.isTrackingError == false && this.isNegnumber == false) { //Added this.isTrackingError == false by Akash as part of 12062
                console.log('handlePromiseMade');
                this.routingSpinner = true; //Added by Prabu for the bug - 22313
                handlePromiseMade({
                        lookupId: this.finAccNo,
                        confirmNumber: this.madePaymentDetails.confirmNumber,
                        promiseAmount: this.madePaymentDetails.promiseAmount,
                        promiseMadeType: this.madePaymentDetails.promiseMadeType
                    }).then(result => {
                        this.routingSpinner = false; //Added by Prabu for the bug - 22313
                        console.log('Resulttttt',result);
                        this.isPromiseMadeSuccess = result;
                        if (this.isPromiseMadeSuccess == 'SUCCESS') {                            
                            this.isPromiseMade = true;
                        }
                        //Added by Prabu for US - 6033
                        else {
                            this.routingSpinner = false;
                            this.isWebServiceDown = true;
                        }
                    })
                    .catch(error => {
                        this.routingSpinner = false;
                        this.isWebServiceDown = true;
                    });
            }
        }
        //US 9970 end
        else {
            console.log('ElseWebserviceDown');
            this.isWebServiceDown = true;
        }
    }
    //Added by Prabu - US 9970 - End  

    //To format date in Jan 25,2020
    formatDate(dt) {
        var formatdate = new Date(dt);
        formatdate = new Date(
            formatdate.getTime() + formatdate.getTimezoneOffset() * 60 * 1000
        );
        const options = {
            year: "numeric",
            month: "short",
            day: "numeric"
        };
        return formatdate.toLocaleDateString("en-US", options);
    }

    //Navigate To Dashboard
    navigateBackToDashboard() {
        sessionStorage.setItem('salesforce_id', this.sacRecordId);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "dashboard"
            }
        });
    }
    onToastLinkClicked() {
        //navigate to scheduled payment page
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-post-login'
            }
        });

    }
    /*changes 6905*/
    acceptNavigation() {
        this.navigateBackToDashboard();
    }
    cancelNavigation() {
        this.showPopUpNotificationOnChange = false;
    }

    showPageNavigationPopup() {
        if (this.showNotificationOnChange) {
            this.showPopUpNotificationOnChange = true;
        } else {
            this.onPreviousPage(); //Added by Prabu for the bug - 22281
        }
    }
    inputValuesChanged() {
        this.showNotificationOnChange = true;
    }
    inputValuesChangedAmountPaidValueOnChange(event) {
        this.inputValuesChangedAmountPaid(event.target.value);
    }
    inputValuesChangedAmountPaid(promiseAmt) {
        if (promiseAmt <= 0 || promiseAmt == '') {
            this.isNegnumber = true;
        } else {
            this.madePaymentDetails.promiseAmount = promiseAmt;
            this.isNegnumber = false;
        }
    }

    //formatting number to string
    formatnumber(number) {
        return number.toLocaleString("en-US", {
            minimumFractionDigits: 2
        });
    }
    /*changes 6905*/
    //for ADA fix

    @wire(CurrentPageReference) pageRef;

    renderedCallback() {
        let firstClass = this.template.querySelector(".main-content");
        // console.log('firstClass-----> ',firstClass);
        fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
    }
    /**START - Added by Prabu for the bugs - 22281, 22306 */
    onPreviousPage() {
        window.history.back();
        return false;
    }
    /**END - Added by Prabu for the bugs - 22281, 22306 */

    get amountField(){

        return this.formatCurrency(this.madePaymentDetails.promiseAmount);
    }
}