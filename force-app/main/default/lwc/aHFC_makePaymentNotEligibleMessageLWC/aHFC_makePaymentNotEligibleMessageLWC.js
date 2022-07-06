/*  Component Name       :    aHFC_makePaymentNotEligibleMessageLWC
    * Description        :    This Component is used to display Easy Page section of make a payment page
    * Modification Log   :    Created by Vishnu 
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Vishnu                     1/07/2021              Created
    * Aswin Jose                 14/7/2021              Modified for US : 3692
*********************************************************************************/
import { LightningElement,api,track } from 'lwc';
import { NavigationMixin
  } from 'lightning/navigation';

export default class AHFC_makePaymentNotEligibleMessageLWC  extends NavigationMixin(LightningElement) {

    @track isOneTime = false;
    @track isEasyPay = false;
    @track isPayOff = false;
    @track isPurchase = false;
    @api paymentType;
    @api showDueInEligibilityErrorMsg;
    @api showErrorOTPPaymentRecordCount;
    @api dueAmmount;

    //sets payment error message on intial load
    connectedCallback() {
     this.updatePaymentType(this.paymentType);
    }

    //sets message based on the payment type info
    @api
    updatePaymentType(paymentType){
        console.log('PAYMENT TYPE ******: '+paymentType);
        console.log('record Count flag'+this.showErrorOTPPaymentRecordCount);
        if (paymentType == 'One-Time'){
            this.isOneTime = true;
            this.isEasyPay = false;
            this.isPayOff = false;
            this.isPurchase = false;

        }else if (paymentType == 'Enroll in EasyPay'){
            this.isOneTime = false;
            this.isEasyPay = true;
            this.isPayOff = false;
            this.isPurchase = false;
        }else if (paymentType == 'Payoff'){
            this.isOneTime = false;
            this.isEasyPay = false;
            this.isPayOff = true;
            this.isPurchase = false;
        }else if (paymentType == 'Purchase'){
            this.isOneTime = false;
            this.isEasyPay = false;
            this.isPayOff = false;
            this.isPurchase = true;
        }
        console.log('Error Message');
    
    }

    //navigation function to return to dashboard
    returnToDashBoard() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "dashboard"
            },
        });
    }

    navigatetoPaymentActivityPage(){
        this[NavigationMixin.Navigate]({
          type: "comm__namedPage",
          attributes: {
            pageName: "manage-payment"
          }
        });
      }
}