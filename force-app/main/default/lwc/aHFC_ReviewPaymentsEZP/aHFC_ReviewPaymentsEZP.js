import { LightningElement, track, api } from 'lwc';
import hondaHeadLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import hondaVehImg from "@salesforce/resourceUrl/AHFC_Honda_Header_Car";
import financeDetails from "@salesforce/apex/AHFC_ReviewPaymentDetails.getFinanceAccData";
import paymentDetails from "@salesforce/apex/AHFC_ReviewPaymentDetails.getPaymentData";
import commPrefDetail from "@salesforce/apex/AHFC_ReviewPaymentDetails.commPrefDetail";

import { NavigationMixin } from "lightning/navigation";

export default class AHFC_ReviewPaymentsEZP extends NavigationMixin(LightningElement) {

  @track isPaymentSuccess = false;
  @track strAutoPaymentAmt ;
  @track strNextWithdrawlDate ;
  @track strpaymentSource ;
  @track last4accnumofselpaysource ;
  @api recordId ='a1e0U0000027H9CQAU';
@track strCommunicationEmail;
@track strCommunicationPhone;

  connectedCallback() {
    financeDetails({
      finAccId: 'a1e0U0000027H9CQAU'
    }).then((result) => {
        console.log("Response", result);
        if(result != null){
          this.strAutoPaymentAmt = result.Regular_Monthly_Payment__c;
          this.strNextWithdrawlDate = result.FA_Next_Withdrawal_Date__c;
        }      
      })
      .catch((error) => {
        console.log("error ", error);
      });

      paymentDetails({
        finAccId: 'a1e0U0000027H9CQAU'
      }).then((result) => {
          console.log("paymentDetails Response", result);
          console.log("payment Nick Name", result.Payment_Source_Nickname__r.Payment_Source_Nickname__c);
          if(result != null){
            this.strpaymentSource = result.Payment_Source_Nickname__r.Payment_Source_Nickname__c;
            this.last4accnumofselpaysource = result.Payment_Source_Nickname__r.Last_4__c;           
          }        
        })
        .catch((error) => {
          console.log("error ", error);
        });

        commPrefDetail({
          finid: 'a1e0U0000027H9CQAU'
        }).then((result) => {
            console.log("commPrefDetail Response", result);
            if(result != null){
              this.strCommunicationEmail = result.Email_Address__c;
              this.strCommunicationPhone = result.Text_Number__c;
            }      
          })
          .catch((error) => {
            console.log("error ", error);
          });
  };

    get hondaheadLogoUrl() {
        return hondaHeadLogo;
      }
    
      get hondaVehImgUrl(){
        return hondaVehImg;
      }

      handleSubmitPayment() {
        // submit button click login
      }

      editPayment() {
          //edit payment link redirect
      }

      navigateToDashboard() {
        this[NavigationMixin.Navigate]({
          type: "comm__namedPage",
          attributes: {
            pageName: "dashboard"
          }
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