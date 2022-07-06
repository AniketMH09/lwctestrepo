/*  * lWC                :    AHFC_cancelPaymentPopUp
    * description        :    This Component is used to display cancel payment popup
    * modification Log   :    
    * ---------------------------------------------------------------------------
    * developer                   Date                   Description
    * ---------------------------------------------------------------------------
    * Edwin Antony               21-JULY-2021               Created  US:3793
    * Edwin Antony               30-JULY-2021               Modified US:3794 Include logic for payoff/purchase
*********************************************************************************/

import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from "lightning/navigation";

import updatePayments from "@salesforce/apex/AHFC_ReviewPaymentDetails.updatePaymentAfterCancelEasyPay";
import checkCutOffFlag from "@salesforce/apex/AHFC_SchedulePaymentController.isAfterCutOffTime";
import todayDateTime from "@salesforce/apex/AHFC_SchedulePaymentController.todayDateTime";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
//Custom Labels
import AHFC_Payment_Error_Message from "@salesforce/label/c.AHFC_Payment_Error_Message";
import Label_MonthlyPayAmt from "@salesforce/label/c.AHFC_ReviewEZP_PaymentAmt";
import Label_PaySource from "@salesforce/label/c.AHFC_ReviewEZP_PaySource";
import Label_WithdrawPayBy from "@salesforce/label/c.AHFC_ReviewEZP_NextWithdrawal";
import { getConstants } from "c/ahfcConstantUtil";
import LOCALE from '@salesforce/i18n/locale';
const CONSTANTS = getConstants();
export default class AHFC_cancelPaymentPopUp extends NavigationMixin(LightningElement) {


  @api isPaymentUpdateSuccess = false;
  @api successmessage;
  @api closemodalflag;
  @api successmessagevalue;
  @api financeAccData;

  @track paymentList;
  @track paymentAmountLabel;
  @track paymentRecId;
  @track headerTextLabel;
  @track paymentDateLabel


  //To use custom labels in HTML
  label = {
    Label_MonthlyPayAmt,
    Label_PaySource,
    Label_WithdrawPayBy
  };
  fetcOrgTime(){
    todayDateTime({
    }).then((result) => {
      console.log('result',result);
    }).catch((error) => {
      this.error = error;
      this.paymentCreationError(AHFC_Payment_Error_Message);
    });
  }

  connectedCallback() {
    this.fetcOrgTime();
    this.isModalOpen = true;
    this.headerTextLabel ='Are you sure you want to cancel this payment?';
      // US:3794 by edwin cancel/edit payoff/purchase payment -start
    if (this.financeAccData.paymentType === 'Payoff') {
      this.paymentAmountLabel = 'PAYOFF AMOUNT';
      this.paymentDateLabel = 'PAYOFF DATE' ;
    }
    else if (this.financeAccData.paymentType === 'Purchase') {
      this.paymentAmountLabel = 'PURCHASE AMOUNT';
      this.paymentDateLabel = 'PURCHASE DATE';
    }
      // US:3794 by edwin cancel/edit payoff/purchase payment -end
    else {
      this.paymentAmountLabel = 'PAYMENT AMOUNT';
      this.paymentDateLabel = 'PAYMENT DATE';
      this.headerTextLabel = 'Are you sure you want to cancel this One-Time Payment?'
    }
  }

  /** Method Name: cancelEasyPay
  *  Description:   On cancel payment data and close the pop up and show success message on parent
  *  Developer Name: Edwin Antony
  *  Created Date:   26-July-2021 
  */

  cancelPayment() {

    //Apex method for cancel payment record
    updatePayments({
      paymentRecId: this.financeAccData.paymentRecId,

    }).then((result) => {
      console.log('Payment After Update' + JSON.stringify(result));
      if (result != null && result != "") {
        this.isPaymentUpdateSuccess = true;
        this.paymentList = result;
        this.successMessage = 'Your payment has been cancelled.';
        this.closeModalPopUp();
      } else {
        this.paymentCreationError();
        this.isPaymentUpdateSuccess = false;
      }
    })
      .catch((error) => {
        this.error = error;
        this.paymentCreationError(AHFC_Payment_Error_Message);
      });
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


  closeModal() {
    this.successMessage = '';
    this.closeModalPopUp();
  }

  //close the modal on clicking back button or Cancel button . pass values to parent
  closeModalPopUp() {
    const selectedEvent = new CustomEvent('cancelmodalclose', {
      detail: {
        successmessagevalue: this.successMessage,
        closemodalflag: false
      }
    });
    this.dispatchEvent(selectedEvent);
  }


  /** Method Name: validateCancelPayment
  *  Description:  Validate whether current time is greater than cutoff time
  *  Developer Name: Edwin Antony
  *  Created Date:   26-July-2021 
  */
  validateCancelPayment() {
    var today = new Date();
    var isValid = false;

    checkCutOffFlag({

    }).then((result) => {
      if (this.financeAccData.paymentDate == this.formatDate(today) && result == true) {
        this.paymentCreationError('This payment cannot be edited or canceled. The cutoff time has passed');
      }
      else {
        this.cancelPayment();
      }
    });
  }

  formatDate(dt) {
    var formatdate = new Date(dt);
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