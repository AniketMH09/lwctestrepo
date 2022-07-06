/*  * lWC                :    AHFC_editPaymentPopUp
    * description        :    This Component is used to edit payment
    * modification Log   :    
    * ---------------------------------------------------------------------------
    * developer                   Date                   Description
    * ---------------------------------------------------------------------------
    * Edwin Antony                21-JULY-2021               Created  US:3793
    * Edwin Antony                30-JULY-2021               Modified US:3794 Include logic for payoff/purchase
    * Sagar Ghadigaonkar          29-OCTOBER-2021            Modified for bug Fix : 20175
    * Sagar Ghadigaonkar          3-November-2021            Modified for bug Fix : 20440
    * Sagar Ghadigaonkar          9-November-2021            Modified for bug Fix : 21920
*********************************************************************************/

import { LightningElement, track, api } from 'lwc';
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import { loadStyle } from "lightning/platformResourceLoader";
import getPaymentSources from "@salesforce/apex/AHFC_AddPaymentSourceClass.getPaymentSources";
import checkCutOffFlag from "@salesforce/apex/AHFC_SchedulePaymentController.isAfterCutOffTime";
import managePayOff from "@salesforce/apex/AHFC_AddPaymentSourceClass.managePayOff";
import updateOneTimePayment from "@salesforce/apex/AHFC_Payment.updatePayment";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getConstants } from "c/ahfcConstantUtil";
import AHFC_Payment_Error_Message from "@salesforce/label/c.AHFC_Payment_Error_Message";
const CONSTANTS = getConstants();

// Below labels are part of validation
import AHFC_PaymentErrorForBlankAmount from "@salesforce/label/c.AHFC_PaymentErrorForBlankAmount";
import AHFC_PaymentErrorAmountLessThanOne from "@salesforce/label/c.AHFC_PaymentErrorAmountLessThanOne";
import AHFC_AmountLessThanDueAmt from "@salesforce/label/c.AHFC_AmountLessThanDueAmt";
import AHFC_PaymentGreaterThanPayOff from "@salesforce/label/c.AHFC_PaymentGreaterThanPayOff";
import AHFC_PayAmtGrtrThanPurchaseAmt from "@salesforce/label/c.AHFC_PayAmtGrtrThanPurchaseAmt";
import AHFC_PayAmtGrtrThanPrincipal from "@salesforce/label/c.AHFC_PayAmtGrtrThanPrincipal";

export default class AHFC_editPaymentPopUp extends LightningElement {

    @track items = [];
    @track value = '';
    @api modalHeaderText = 'Edit One-Time Payment'
    @api financeAccData;

    @track paymentDate;
    @track paymentAmount;
    @track sacRecordId;
    @track otp = true;
    @track datSystemDate;
    @track selectedValue;
    @track paymentType;
    @track paymentAmountLabel;
    @track isStandardPayment = false;
    @track isPrincipalPayment = false;
    @track isPayoffPayment = false;
    @track isPurchasePayment = false;
    @track isNotEditable = false;
    isPaymentAmountValid = true;
    isPaymentDateValid = true;
    //validations
    @track decStdPaymentAmount;
    @track dbRemainingAmountDue;
    @track decPayoffAmount;
    @track strAccountType;
    @track otpPaymentAmount;

    @track messages = {
        strStdPaymentAmountMsg: "",
        strScheduleOnMsg: "", //
    };

    @track userAccountInfo = {};
    @track datScheduleOn;
    @track isValidData = true;
    @track dblTotalAmountDue = 0;
    @track dbTotalSchedludedAmount = 0;

    @track flags = {
        showErrorMessageAlert: false,
        boolShowStdPaymentAmountMsg: false,
        boolShowScheduleOnMsg: false,
        pastDueStatusFlag: false
    }

    @track paymentData = {
        paymentAmount: " ",
        paymentRecId: "",
        paymentSource: "",
        paymentType: ""
    };

    @track isLoaded = false;

    dateFormater(selectedDate) {
        const months = CONSTANTS.MONTHS_LC;
        let duedate = new Date(selectedDate);
        duedate = new Date(duedate.getTime() + duedate.getTimezoneOffset() * 60 * 1000);
        return (duedate != CONSTANTS.INVALID_DATE) ? `${months[duedate.getMonth()]} ${duedate.getDate()}, ${duedate.getFullYear()}` : "";
    }
    dateFormaterForDate(selectedDate) {
        const months = CONSTANTS.MONTHS_LC;
        let duedate = selectedDate;
        return (duedate != CONSTANTS.INVALID_DATE) ? `${months[duedate.getMonth()]} ${duedate.getDate()}, ${duedate.getFullYear()}` : "";
    }

    connectedCallback() {
        this.isLoaded = false;
        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
        this.loadPaymentSource();
        console.log('####this.financeAccData:' + JSON.stringify(this.financeAccData));
        this.paymentType = this.financeAccData.paymentType;
        this.paymentDate = this.formatDateForSave(this.financeAccData.paymentDate);
        this.paymentAmount = this.formatnumber(this.financeAccData.paymentAmount);

        this.otpPaymentAmount = this.formatdecimal(this.financeAccData.paymentAmount.replace("$", "").replace(",","")); // replace , in amount for bug fix :20175 changed by Sagar

        console.log('####this.financeAccData.paymentAmount:' + this.otpPaymentAmount);
        if (this.paymentType === 'Standard') {
            this.paymentAmountLabel = 'Standard Payment Amount';
            this.isStandardPayment = true;
        }
        else if (this.paymentType === 'Principal') {
            this.paymentAmountLabel = 'Principal Payment Amount';
            this.isPrincipalPayment = true;
        }
        // US:3794 by edwin cancel/edit payoff/purchase payment -start
        else if (this.paymentType === 'Payoff') {
            this.paymentAmountLabel = 'Payoff Amount';
            this.isPayoffPayment = true;
            this.isNotEditable = true;
        }
        else if (this.paymentType === 'Purchase') {
            this.paymentAmountLabel = 'Purchase Amount';
            this.isPurchasePayment = true;
            this.isNotEditable = true;
        }
        // US:3794 by edwin cancel/edit payoff/purchase payment -end

        this.setPaymentData(this.financeAccData);
        this.getManagePayoff();
        
    }

    setPaymentData(financeAccData) {
        this.paymentData.paymentDate = this.paymentDate;
        this.paymentData.paymentAmount = this.formatdecimal(this.financeAccData.paymentAmount.replace("$", ""));
        this.paymentData.paymentRecId = financeAccData.paymentRecId;
        this.paymentData.paymentSource = financeAccData.paymentSourceId;
        this.paymentData.paymentType = financeAccData.paymentType;
        
    }
    get options() {
        return this.items;
    }

    @api
    setFieldValues(financeAccData) {
        this.financeAccData = financeAccData;
        this.selectedValue = financeAccData.paymentSourceId;
    }
    
    handleInputData(event) {
        console.log('handleInputData>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        this.isValidData = false;
        let targetId;
        targetId = event.target.getAttribute("data-id");
        try {
            switch (targetId) {
                case "payment-amount":
                    this.paymentData.paymentAmount = event.target.value;
                    this.validatePaymentAmount(event);
                    this.isPaymentAmountValid = true;
                    if(!this.isValidData){
                        this.isPaymentAmountValid = false;
                    }

                    if(!this.isPaymentDateValid){
                        this.isValidData = false;
                    }
                    console.log('this.isValidData1',this.isValidData);
                    break;
                case "payment-date":
                    this.paymentData.paymentDate = event.target.value;
                    this.validatePaymentDate(event);
                    this.isPaymentDateValid = true;

                    if(!this.isValidData){
                        this.isPaymentDateValid = false;
                    }
                    if(!this.isPaymentAmountValid){
                        this.isValidData = false;
                    }
                    console.log('this.isValidData2',this.isValidData);
                    break;
                case "payment-source":
                    this.paymentData.paymentSource = event.target.value;
                    if(this.isPaymentAmountValid && this.isPaymentDateValid){
                    this.isValidData = true;
                    }
                    console.log(' this.paymentData.paymentSourceId' + this.paymentData.paymentSource);
                    break;
            }
            console.log('1232');
        }
        catch (e) {
            console.log('Error in on change:' + e);
        }
    }

    /** Method Name: loadPaymentSource
*  Description:   Populate payment source based on finance account number
*  Developer Name: Edwin Antony
*  Created Date:   21-July-2021 
*  User Story :    #3793*/

    loadPaymentSource() {

        getPaymentSources({
            IdSACRecordVar: this.financeAccData.financeAccNum
        })
            .then((result) => {               
                this.paymentSourcesList = JSON.parse(JSON.stringify(result));
                for (var i = 0; i < this.paymentSourcesList.length; i++) {
                    console.log('StrNameee-->',this.paymentSourcesList[i].strName);
                    console.log('length-->',this.paymentSourcesList[i].strName.length);
                    this.items = [...this.items, {                        
                        value: this.paymentSourcesList[i].strID,
                        label: this.paymentSourcesList[i].strName + ' **** ' + this.paymentSourcesList[i].strLast4AccNumber + ''
                    }];
                }
                this.isLoaded = true;
            })
            .catch((error) => {
                this.isLoaded = true;
                this.error = error;
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

    get minDate() {
        return this.datSystemDate;
    }

    /** Method Name: onSave
*  Description:   update the payment based on the values selected
*  Developer Name: Edwin Antony
*  Created Date:   21-July-2021 
*  User Story :    #3793*/


    onSave() {
        //Apex method for update payment record  
        console.log('this.paymentData.paymentDate:' + this.paymentData.paymentDate);
        console.log('this.paymentData.paymentAmount:' + this.paymentData.paymentAmount.replace(",", ""));
        
        updateOneTimePayment({
            paymentRecId: this.paymentData.paymentRecId,
            paymentAmount: this.paymentData.paymentAmount.replace(",", ""),
            paymentDate: this.paymentData.paymentDate,
            paymentSource: this.paymentData.paymentSource,
            paymentType: this.paymentData.paymentType
        }).then((result) => {
            if (result != null && result != "") {
                this.isPaymentUpdateSuccess = true;
                this.paymentList = result;
                if (this.isStandardPayment) {
                    const selectedEvent = new CustomEvent("editmodalsave", {
                        detail: {
                            resultData: JSON.stringify(this.paymentList),
                            isModal: false,
                            modalName: "Standard",
                            isUpdateSuccessful: this.boolResultAfterUpdate,
                            successMsg: 'Your One-Time Payment was successfully updated. Standard Payment Confirmation #' + result.Confirmation_Number__c
                        }
                    });
                    this.dispatchEvent(selectedEvent);
                }
                else if (this.isPrincipalPayment) {
                    const selectedEvent = new CustomEvent("editmodalsave", {
                        detail: {
                            resultData: JSON.stringify(this.responseData),
                            isModal: false,
                            modalName: "Principal",
                            isUpdateSuccessful: this.boolResultAfterUpdate,
                            successMsg: 'Your One-Time Payment was successfully updated. Principal Payment Confirmation #' + result.Confirmation_Number__c
                        }
                    });
                    this.dispatchEvent(selectedEvent);
                }
                // US:3794 by edwin cancel/edit payoff/purchase payment -start
                else if (this.isPayoffPayment) {
                    const selectedEvent = new CustomEvent("editmodalsave", {
                        detail: {
                            resultData: JSON.stringify(this.responseData),
                            isModal: false,
                            modalName: "Payoff",
                            isUpdateSuccessful: this.boolResultAfterUpdate,
                            successMsg: 'Your One-Time Payment was successfully updated. Payoff Payment Confirmation #' + result.Confirmation_Number__c
                        }
                    });
                    this.dispatchEvent(selectedEvent);
                }
                else if (this.isPurchasePayment) {
                    const selectedEvent = new CustomEvent("editmodalsave", {
                        detail: {
                            resultData: JSON.stringify(this.responseData),
                            isModal: false,
                            modalName: "Payoff",
                            isUpdateSuccessful: this.boolResultAfterUpdate,
                            successMsg: 'Your One-Time Payment was successfully updated. Purchase Payment Confirmation #' + result.Confirmation_Number__c
                        }
                    });
                    this.dispatchEvent(selectedEvent);
                }
                // US:3794 by edwin cancel/edit payoff/purchase payment -end
            } else {
                this.paymentCreationError(AHFC_Payment_Error_Message);
                this.isPaymentUpdateSuccess = false;
            }
            this.isLoaded = true;
        })
            .catch((error) => {
                this.isLoaded = true;
                console.log("error>>>", error);
                this.error = error;
                this.paymentCreationError(AHFC_Payment_Error_Message);
            });
    }


    /** Method Name: onCancel
*  Description:   On clicking cancel button, popup will be closed
*  Developer Name: Edwin Antony
*  Created Date:   21-July-2021 
*  User Story :    #3793
*/
    onCancel() {
        const selectedEvent = new CustomEvent("editmodalclose", {
            ismodalopenflag: false
        });
        this.dispatchEvent(selectedEvent);
    }


    /** Method Name: validateCancelPayment
    *  Description:  Validate whether current time is greater than cutoff time
    *  Developer Name: Edwin Antony
    *  Created Date:   26-July-2021 
    */
    validateUpdatePayment() {
       // this.isLoaded = false; // commented by sagar 09-12-2021
        console.log('this.isValidData >>>>>>>>>> '+this.isValidData);
        if (this.isValidData) {     
            
            this.isLoaded = false;

            console.log('inside apex call >>>> ');
            var today = new Date();
            checkCutOffFlag({

            }).then((result) => {
                if (this.financeAccData.paymentDate == this.formatDateNew(today) && result == true) {
                    this.paymentCreationError('This payment cannot be edited or canceled. The cutoff time has passed');
                }
                else {
                    this.onSave();
                }
            });
        }
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
    ///////Added by aniket to remove offset
    formatDateNew(dt) {
        var formatdate = new Date(dt);
        // formatdate = new Date(formatdate.getTime() + formatdate.getTimezoneOffset() * 60 * 1000);
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

    paymentCreationError(msg) {
        const event = new ShowToastEvent({
            title: "Error",
            message: msg,
            variant: "error",
            mode: "dismissable"
        });
        this.dispatchEvent(event);
    }

    getManagePayoff() {

        managePayOff({
            sacRecID: this.financeAccData.financeAccNum
        })
            .then((result) => {
                console.log()
                if (result.datToday) {
                    this.datSystemDate = result.datToday;
                    this.datScheduleOn = result.datToday;
                    this.datScheduleOnPayoff = this.formatDate(result.datToday);
                }

                this.userAccountInfo = result.serAccRec;
                console.log('########this.userAccountInfo:' + JSON.stringify(this.userAccountInfo));
                this.dblTotalAmountDue= result.dblTotalAmountDue;
                this.dbTotalSchedludedAmount=result.dbTotalSchedludedAmount;
                this.strAccountType = result.strAccountType;
                this.flags.pastDueStatusFlag = result.pastDueStatus;
                if (typeof result.dblTotalAmountDue !== CONSTANTS.UNDEFINED && typeof result.dbTotalSchedludedAmount !== CONSTANTS.UNDEFINED) {
                    this.dbRemainingAmountDue = result.dblTotalAmountDue - result.dbTotalSchedludedAmount;
                }

                if (typeof result.decPayoffAmount !== CONSTANTS.UNDEFINED) {
                    this.decPayoffAmount = result.decPayoffAmount;
                    console.log('this.decPayoffAmount>>>>>>>>>> ', Number(this.decPayoffAmount));
                    this.decPayoffAmount = this.formatdecimal(this.decPayoffAmount);
                    this.strPayoffAmount = this.formatnumber(result.decPayoffAmount); // added as part of US 3693 & 3694
                }


                if (typeof this.dbRemainingAmountDue !== CONSTANTS.UNDEFINED) {
                    this.strRemainingAmountDue = this.dbRemainingAmountDue;
                    this.dbRemainingAmountDue = this.formatdecimal(this.dbRemainingAmountDue);
                    this.strRemainingAmountDue = this.formatnumber(this.strRemainingAmountDue);
                }
            })
            .catch((error) => {
                this.error = error;
                console.log('error', error);
                this.paymentCreationError('Please try again later')
                this.onCancel();
            });

    }

    /** Method Name: validatePaymentAmount
    *  Description:   Onchange of payment amount this method will be invoked ands based on payment type validation will be done
    *  Developer Name: Edwin Antony
    *  Created Date:   27-July-2021 
    *  User Story :    #3793
    */

    validatePaymentAmount() {
        console.log('Inside validatePaymentAmount');
        if (this.isStandardPayment) {
            this.validateStdPaymentAmount();
        }
        else if (this.isPrincipalPayment) {
            this.validatePricipalAmount();
        }
    }

    /** Method Name: validateStdPaymentAmount
     *  Description:   If payment type is principal, we will be valid payment amount on UI against backend information associated with Finance Account
     *  Developer Name: Edwin Antony
     *  Created Date:   27-July-2021 
     *  User Story :    #3793
     */

    validateStdPaymentAmount() {
        console.log('decStdPaymentAmount: ' + this.paymentData.paymentAmount);
        console.log('this.dbRemainingAmountDue: ' + this.dbRemainingAmountDue);
        console.log('this.decPayoffAmount: ' + this.decPayoffAmount);

        let targetPart = this.template.querySelector(".ahfc-input");

        this.decStdPaymentAmount = this.paymentData.paymentAmount;
        if (!this.decStdPaymentAmount) {
            targetPart.setCustomValidity(AHFC_PaymentErrorForBlankAmount);
            this.flags.boolShowStdPaymentAmountMsg = false;
            this.isValidData = false;
        }
        else if (this.decStdPaymentAmount < 1) {
            targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            this.flags.boolShowStdPaymentAmountMsg = false;
            this.isValidData = false;
        }

        else if (this.decStdPaymentAmount < Number(this.dbRemainingAmountDue)) {
            this.flags.boolShowStdPaymentAmountMsg = true;
            this.linkonToast = '';
            this.messages.strStdPaymentAmountMsg = AHFC_AmountLessThanDueAmt;
            targetPart.setCustomValidity("");
            this.isValidData = true;
        }
        else {
            this.flags.boolShowStdPaymentAmountMsg = false;
            targetPart.setCustomValidity("");
            this.linkonToast = '';
            this.isValidData = true;
        }
        if (this.decStdPaymentAmount >= Number(this.decPayoffAmount)) {
            if ((this.strAccountType === 'Balloon' && this.userAccountInfo.Fl_Refinanced__c) || this.strAccountType === 'Retail') { //payoff
                this.flags.boolShowStdPaymentAmountMsg = false;
                targetPart.setCustomValidity(AHFC_PaymentGreaterThanPayOff);
                this.isValidData = false;
            }
            else if (this.strAccountType === 'Lease' || this.strAccountType === 'Balloon') { //purchase
                this.flags.boolShowStdPaymentAmountMsg = false;
                targetPart.setCustomValidity(AHFC_PayAmtGrtrThanPurchaseAmt);
                this.isValidData = false;
            }
            else {
                this.flags.boolShowStdPaymentAmountMsg = false;
                targetPart.setCustomValidity("");
                this.isValidData = true;
            }
        }
         
        // added by sagar for bug fix 21920,20203
        if(targetPart!==null && targetPart.checkValidity()==false)
        {
            this.isValidData = false;
        }

        targetPart.reportValidity();
    }

    /** Method Name: validatePricipalAmount
 *  Description:    Valid the inputs of Additional Principal Amount on UI against backend information associated with Finance Account
 *  Developer Name: Edwin Antony
 *  Created Date:   04-Aug-2021 
 *  User Story :    3793
 */
    validatePricipalAmount() {
        this.decAddnlPricipalAmount = this.paymentData.paymentAmount;
        let targetPart = this.template.querySelector(".ahfc-input");

        if (!this.decAddnlPricipalAmount) {
            targetPart.setCustomValidity(AHFC_PaymentErrorForBlankAmount);
            this.isValidData = false;
        }
        else if (this.decAddnlPricipalAmount < 1) {
            targetPart.setCustomValidity(AHFC_PaymentErrorAmountLessThanOne);
            this.isValidData = false;
        }
        else if (this.decAddnlPricipalAmount > this.userAccountInfo.Principal_Balance_Amount__c) {
            targetPart.setCustomValidity(AHFC_PayAmtGrtrThanPrincipal);
            this.isValidData = false;
        }
        else {
            targetPart.setCustomValidity("");
            this.isValidData = true;
        }
        targetPart.reportValidity();
    }

    /** Method Name: validatePaymentDate
     *  Description:    Valid the inputs of Payment Date on UI against backend information associated with Finance Account
     *  Developer Name: Edwin Antony
     *  Created Date:   27-July-2021 
     *  User Story :    #3793
     */

    validatePaymentDate() {
        this.datScheduleOn = this.paymentData.paymentDate;
       
        // Added by sagar for bug fix 20440 ,call datevalidation rules based on payment type
        if(this.isPrincipalPayment== true && this.paymentType === 'Principal')
        {
            this.validateSchDateForAdditionalPrincipalAmt();
        }else{
            this.validateScheduleOnLogic();
        } 
        //this.validateScheduleOnLogic();
    }

    /* Added by sagar for bug fix 20440 validations for schedule date 
     if user paying only additional principal amount  */

    validateSchDateForAdditionalPrincipalAmt()
    {
        console.log('this.datScheduleOn: ' + this.datScheduleOn);
        console.log('this.userAccountInfo.Maturity_Date__c: ' + this.userAccountInfo.Maturity_Date__c);
        console.log('this.datSystemDate: ' + this.datSystemDate);

        let targetPart = this.template.querySelector(".schedule-input");

       // let currentDate = new Date();
        let currentDate = new Date(this.datSystemDate);
        console.log('0000000000000000currentDatexxx',currentDate.getTime());
        console.log('0000000000000000currentDatexxx',currentDate.getTimezoneOffset() * 60 * 1000);
        let currentDateWithTimeZero = new Date(currentDate.getTime() + currentDate.getTimezoneOffset() * 60 * 1000);
       // let currentDateWithTimeZero = new Date(currentDate.getFullYear(),currentDate.getMonth(),currentDate.getDate());
        console.log('0000000000000000currentDate',currentDate);
        console.log('0000000000000000currentDateWithTimeZero2222',currentDateWithTimeZero);

        let schDate = new Date(this.datScheduleOn);
        let schDateWithoutOffset = new Date(schDate.getTime() + schDate.getTimezoneOffset() * 60 * 1000);
        console.log('0000000000000000this.schDate',schDate);
        console.log('0000000000000000this.schDateWithoutOffset',schDateWithoutOffset);


        if (!this.datScheduleOn && (this.datScheduleOn == null || this.datScheduleOn == '' || this.datScheduleOn == undefined)) { 
            console.log('1 Entered Empty Schedule Date');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Select a payment date.");
            this.isValidData = false;
        }else if (schDateWithoutOffset < currentDateWithTimeZero) {
            console.log('2 Entered Past Schedule Date');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be in the past.");
            this.isValidData = false;
        }else if (this.datScheduleOn > this.userAccountInfo.Maturity_Date__c) {
            console.log('3 Entered  Schedule Date beyond Maturity Date ');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond the Maturity Date of " + this.dateFormater(this.userAccountInfo.Maturity_Date__c));
            this.isValidData = false;
        }else {
            console.log('no error');
           // this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("");
            this.isValidData = true;
        }           

        targetPart.reportValidity();   
    }

    validateScheduleOnLogic() {
        console.log('this.datScheduleOn: ' + this.datScheduleOn);
        console.log('this.flags.pastDueStatusFlag: ' + this.flags.pastDueStatusFlag);
        console.log('this.userAccountInfo.Maturity_Date__c: ' + this.userAccountInfo.Maturity_Date__c); 
        console.log('this.datSystemDate: ' + this.datSystemDate);
        console.log('this.userAccountInfo.Next_Due_Date__c: ' + this.userAccountInfo.Next_Due_Date__c);

        let targetPart = this.template.querySelector(".schedule-input");

        let dueDate = this.userAccountInfo.Next_Due_Date__c;
        let dueDateForSchDate = this.dateFormater(dueDate);

     //   let currentDate = new Date(); 
        let currentDate = new Date(this.datSystemDate);
        let currentDateWithTimeZero = new Date(currentDate.getTime() + currentDate.getTimezoneOffset() * 60 * 1000);
        //let currentDateWithTimeZero = new Date(currentDate.getFullYear(),currentDate.getMonth(),currentDate.getDate());

        console.log('0000000000000000currentDate',currentDate);
        console.log('0000000000000000currentDateWithTimeZero',currentDateWithTimeZero);

        let dueDate2 = new Date(this.userAccountInfo.Next_Due_Date__c);
        let dueDate2WithoutOffset = new Date(dueDate2.getTime() + dueDate2.getTimezoneOffset() * 60 * 1000);
        
        console.log('0000000000000000dueDate2',dueDate2);
        console.log('0000000000000000dueDate2WithoutOffset',dueDate2WithoutOffset);
        
        let schDate = new Date(this.datScheduleOn);
        let schDateWithoutOffset = new Date(schDate.getTime() + schDate.getTimezoneOffset() * 60 * 1000);

        console.log('0000000000000000this.schDate',schDate);
        console.log('0000000000000000this.schDateWithoutOffset',schDateWithoutOffset);

        let todayDate = new Date(this.datSystemDate);
        console.log('0000000000000000this.todayDate',todayDate);

        let paidToDate = this.userAccountInfo.Paid_to_Date__c;
        let paidToDateFormat = new Date(new Date(paidToDate).getTime() + new Date(paidToDate).getTimezoneOffset() * 60 * 1000);

        console.log('paidToDateFormat >>>>>', paidToDateFormat);
        console.log('paidToDateWithoutFormat >>>>>', new Date(paidToDate));

        //let daysPastDue = this.userAccountInfo.AHFC_Total_days_past_due__c;
        let daysPastDue = this.getDPD(paidToDateFormat,currentDateWithTimeZero);
        console.log('daysPastDue >>>>>', daysPastDue);

        let totalDueAmount = this.dblTotalAmountDue;
        let totalScheduledAmount = this.dbTotalSchedludedAmount;
        console.log('totalDueAmount-->',this.dblTotalAmountDue);
        console.log('dbTotalSchedludedAmount-->',this.dbTotalSchedludedAmount);
        
        let remainingAmountDue = this.formatdecimal(totalDueAmount) - this.formatdecimal(totalScheduledAmount);

        if (remainingAmountDue < 0) {
            remainingAmountDue = 0;
        }

        let dueDatePlus10 = new Date(this.userAccountInfo.Next_Due_Date__c);
        dueDatePlus10.setDate(dueDatePlus10.getDate() + 10);
        let dueDatePlus10WithOutOffset = new Date(dueDatePlus10);
        dueDatePlus10WithOutOffset = new Date(dueDatePlus10WithOutOffset.getTime()+ dueDatePlus10WithOutOffset.getTimezoneOffset() * 60 * 1000);

        this.flags.boolShowScheduleOnMsg = false;
        let paidToDateFormatPlus10 = new Date(paidToDateFormat.getFullYear(),paidToDateFormat.getMonth(),paidToDateFormat.getDate()) ;
        paidToDateFormatPlus10.setDate(paidToDateFormatPlus10.getDate()+10);
        
        if (schDateWithoutOffset > currentDate && schDateWithoutOffset > dueDate2WithoutOffset && remainingAmountDue > 0) {
            console.log('Entered Futured Schedule Date greater than payment due date');
            this.flags.boolShowScheduleOnMsg = true;
            this.messages.strScheduleOnMsg = "You are scheduling a payment after your Payment Due Date of " + dueDateForSchDate + ". Please make a payment on or before your Payment Due Date to avoid any additional fees and/or interest.";
            targetPart.setCustomValidity("");
            this.isValidData = true;
        }

        if(!this.datScheduleOn && (this.datScheduleOn == null || this.datScheduleOn == '' || this.datScheduleOn == undefined))
        {
            console.log('1 Entered Empty Schedule Date');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Select a payment date.");
            this.isValidData = false;
        }else if (schDateWithoutOffset < currentDateWithTimeZero) {
            console.log('2 Entered Past Schedule Date');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be in the past.");
            this.isValidData = false;
        } else if (this.flags.pastDueStatusFlag == false && this.userAccountInfo.Region_Code__c != "NRC" && this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == true &&
            schDateWithoutOffset > dueDatePlus10WithOutOffset && remainingAmountDue >0) {
            console.log('3 Current Finance non NRC Account- Futer OTP date selected due date+10');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond " + this.addDays(dueDate2, 10));
            this.isValidData = false;
        } else if (this.flags.pastDueStatusFlag == false && this.userAccountInfo.Region_Code__c == "NRC" && this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == true &&
            schDateWithoutOffset > dueDatePlus10WithOutOffset && remainingAmountDue >0) {
            console.log('4 Current Finance  NRC Account- Futer OTP date selected due date+10');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond " + this.addDays(dueDate2, 10));
            this.isValidData = false;
        } else if (this.flags.pastDueStatusFlag == true && daysPastDue >= 11 && daysPastDue <= 59 && schDateWithoutOffset > currentDateWithTimeZero) {
            console.log('5 past due account- daysPastDue > 10 with ');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond " + this.dateFormaterForDate(currentDateWithTimeZero));
            this.isValidData = false;
        } else if (this.flags.pastDueStatusFlag == true && this.userAccountInfo.Region_Code__c != "NRC" && this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == true &&
            paidToDateFormat < currentDateWithTimeZero && daysPastDue <= 10 && schDateWithoutOffset > paidToDateFormatPlus10 && remainingAmountDue >0) {
            console.log('6 Current Finance non  NRC Account- Futer OTP date selected paid to date +10' +new Date(paidToDate)+'_____________________'+this.addDays(new Date(paidToDate), 10));
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond " + this.addDays(new Date(paidToDate), 10));
            this.isValidData = false;
        } else if (this.flags.pastDueStatusFlag == true && this.userAccountInfo.Region_Code__c == "NRC" && this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == true &&
            paidToDateFormat < currentDateWithTimeZero && daysPastDue <= 10 && schDateWithoutOffset > paidToDateFormatPlus10 && remainingAmountDue >0) {
            console.log('7 Current Finance   NRC Account- Futer OTP date selected paid to date +10');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond " + this.addDays(new Date(paidToDate), 10));
            this.isValidData = false;
        } else if (this.flags.pastDueStatusFlag == false && this.userAccountInfo.Region_Code__c != "NRC" && this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == true &&
                   this.datScheduleOn <= this.userAccountInfo.Maturity_Date__c && this.getDPD(currentDateWithTimeZero, schDateWithoutOffset) > 182 && remainingAmountDue ==0) {
            console.log('8 Current Finance  non NRC Account-  + Sch Payments+ 182 from Today Criteria');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond " + this.addDaysWithOutOffSet(currentDateWithTimeZero, 182));
            this.isValidData = false;
        }else if(this.flags.pastDueStatusFlag == true && this.userAccountInfo.Region_Code__c != "NRC" && this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == true &&
                 this.datScheduleOn <= this.userAccountInfo.Maturity_Date__c &&  paidToDateFormat < currentDateWithTimeZero && daysPastDue <= 10 && this.getDPD(currentDateWithTimeZero, schDateWithoutOffset) > 182 && remainingAmountDue ==0){
            console.log('9 past due account +10 DPD before Maturity + non NRC + Sch Payments+ 182 from Today Criteria');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond " + this.addDaysWithOutOffSet(currentDateWithTimeZero, 182));
            this.isValidData = false;
        } else if (this.userAccountInfo.Region_Code__c != "NRC" && this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == true
                    && (this.datScheduleOn > this.userAccountInfo.Maturity_Date__c)) {
            console.log('10 Schedule Date > Maturity + !NRC Criteria');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Scheduled Payment Date cannot be beyond the Maturity Date of " + this.dateFormater(this.userAccountInfo.Maturity_Date__c));
            this.isValidData = false;
        }  else if (this.userAccountInfo.Fl_Future_OneTime_Payment_Eligible_Web__c == false && schDateWithoutOffset > currentDateWithTimeZero) {
            console.log('11 Fl_Future_OneTime_Payment_Eligible_Web__c is false');
            this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("Error: Payment date cannot be beyond " + this.dateFormaterForDate(currentDateWithTimeZero));
            this.isValidData = false;
        } else {
            console.log('no error');
           // this.flags.boolShowScheduleOnMsg = false;
            targetPart.setCustomValidity("");
            this.isValidData = true;
        }           

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

    addDaysWithOutOffSet(date, days) {
        const months = CONSTANTS.MONTHS_LC;
        var result = date;
        result.setDate(result.getDate() + days);
        return (result != CONSTANTS.INVALID_DATE) ? `${months[result.getMonth()]} ${result.getDate()}, ${result.getFullYear()}` : "";
    }

    formatdecimal(number) {
        if (typeof number != CONSTANTS.UNDEFINED && number !== "" && number !== 0) {

            let decimalcount = 0;
            console.log('mod value >> ',(number % 1));
            if (number % 1 !== 0) {
                decimalcount = number.toString().split(".")[1].length || 0;
                console.log('decimalcount >> ',decimalcount);
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

    formatDateForSave(date) {
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
}