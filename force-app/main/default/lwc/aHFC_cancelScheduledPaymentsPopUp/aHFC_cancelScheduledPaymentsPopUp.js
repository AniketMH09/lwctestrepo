/*  * lWC                :    AHFC_cancelScheduledPaymentsPopUp
    * description        :    This Component is used to display cancel scheduled payment popup of EasyPay
    * modification Log   :    Modified by 
    * ---------------------------------------------------------------------------
    * developer                   Date                   Description
    * ---------------------------------------------------------------------------
    * Aswin Jose                06-JULY-2021               Created
*********************************************************************************/

import { LightningElement,api,track} from 'lwc';
import {CurrentPageReference,NavigationMixin} from "lightning/navigation";

//Apex Classes
import updatePayments from "@salesforce/apex/AHFC_ReviewPaymentDetails.updatePaymentAfterCancelEasyPay";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
//Custom Labels
import AHFC_Payment_Error_Message from "@salesforce/label/c.AHFC_Payment_Error_Message";
import Label_MonthlyPayAmt from "@salesforce/label/c.AHFC_ReviewEZP_PaymentAmt";
import Label_PaySource from "@salesforce/label/c.AHFC_ReviewEZP_PaySource";
import Label_WithdrawPayBy from "@salesforce/label/c.AHFC_ReviewEZP_NextWithdrawal";
import {
  getConstants
} from "c/ahfcConstantUtil";
const CONSTANTS = getConstants();
export default class AHFC_cancelScheduledPaymentsPopUp extends  NavigationMixin(LightningElement) {

@track paymentRecId;
@api isPaymentUpdateSuccess = false;
@track paymentList;

@track strAutoPaymentAmt;
@track strNextWithdrawlDate;
@track strNextWithdrawlDate2;
@track strPaymentSource;
@track last4accnumofselpaysource ;
@track paymentTypeSelected;
@api PaymentData; // to set the values from the parent component
@api successmessage;
@api closemodalflag;
@api successmessagevalue;

@api ezpPaymentData;



//To use custom labels in HTML
label = {
    Label_MonthlyPayAmt,
    Label_PaySource,
    Label_WithdrawPayBy
  };

/** Method Name: connectedCallback
 *  Description:   On Load get data and display details on UI
 *  Developer Name: Aswin Jose
 *  Created Date:   05-July-2021 
 *  User Story :    #3797
 *  Modified By : Aswin Jose
 */

 connectedCallback() {

    const todayDate = new Date();
    

   console.log('EZP DATA from scheduled payments'+JSON.stringify(this.ezpPaymentData));

    this.isModalOpen = true;
    // this.strNextWithdrawlDate = this.ezpPaymentData.Next_Withdrawal_Date__c;
    this.strNextWithdrawlDate = this.formatDate(this.ezpPaymentData.Next_Withdrawal_Date__c);
    console.log('strNextWithdrawlDate'+this.strNextWithdrawlDate);

    
    if(!this.ezpPaymentData.hasOwnProperty('Payment_Source_Nickname__c')){
      this.ezpPaymentData.Payment_Source_Nickname__r = {};
      this.ezpPaymentData.Payment_Source_Nickname__r.Last_4__c = '';
    } 

    this.last4accnumofselpaysource = this.ezpPaymentData.Payment_Source_Nickname__r.Last_4__c;
    this.strPaymentSource = this.ezpPaymentData.Payment_Source_Nickname__r.Payment_Source_Nickname__c;
    this.paymentRecIdToPass = this.ezpPaymentData.Id;
    this.strAutoPaymentAmt = this.formatCurrency(this.ezpPaymentData.ChargentOrders__Charge_Amount__c);// Bug 21692

    console.log('Pop Up Open : '+this.strAutoPaymentAmt+''+this.strNextWithdrawlDate+''+this.strPaymentSource);

 } 
 // Bug 21692
 formatCurrency(curNumber) {
  var formatter = new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD",
      maximumFractionDigits: 2
  });
  return formatter.format(curNumber);
}

 //Added by Aswin Jose on 6 September 2021 for bug fix
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

 /** Method Name: cancelEasyPay
 *  Description:   On update payment data and close the pop up and show success message on parent
 *  Developer Name: Aswin Jose
 *  Created Date:   05-July-2021 
 *  User Story :    #3797
 *  Modified By : Aswin Jose
 */
 
 cancelEasyPay() {

    //Apex method for update payment record
     updatePayments({
        paymentRecId: this.paymentRecIdToPass,
        
      }) .then((result) => {
          console.log('Payment After Update'+result); 
           if (result != null && result != "") {
             this.isPaymentUpdateSuccess = true;
             this.paymentList = result; 
             this.successMessage = 'Your EasyPay Schedule has been cancelled.'; 
             this.closeModalPopUp();
           } else {
             this.paymentCreationError();
             this.isPaymentUpdateSuccess = false;
           }
        })
        .catch((error) => {
          console.log("error>>>", error);
          this.error = error;
          this.paymentCreationError();
        });    
 }

 paymentCreationError() {
    const event = new ShowToastEvent({
      title: "Error",
      message: AHFC_Payment_Error_Message,
      variant: "error",
      mode: "dismissable"
    });
    this.dispatchEvent(event);
  }

//For US : 3797 Aswin Jose
//close the modal on clicking back button
  closeModal(){
      this.successMessage = '';
      this.closeModalPopUp();
  }

  //close the modal on clicking back button or Cancel button . pass values to parent
  closeModalPopUp(){
    const selectedEvent = new CustomEvent('custevent', {
        detail: {
            successmessagevalue: this.successMessage,
            closemodalflag:false
        } 
    });
    this.dispatchEvent(selectedEvent);
  }
  //For US : 3797 Aswin Jose

}