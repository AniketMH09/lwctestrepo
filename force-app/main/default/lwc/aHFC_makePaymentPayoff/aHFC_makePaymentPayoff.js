import { LightningElement,track,wire} from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import getPayoffDetails from "@salesforce/apex/AHFC_Payment.payoffPaymentDetail";
import getFinanceAccDetail from "@salesforce/apex/AHFC_Payment.getPaymentDetailFromFinanceAccount";

export default class AHFC_makePaymentPayoff extends 
  LightningElement

 {
    @track payoffamt;
    @track confirmationNumber;
    @track scheduledOn;
    @track authorizedOn;
    @track paymentSourceNickname;
    @track paymentNameWithAccNo;
    @track payoffAccountNo;
    @track payOffData;
    @track IsnewPayment = false;

    connectedCallback()
    {
      
       // console.log('payoffffammttt',decimalpayoffamount);
       // this.payoffamt = this.decimalpayoffamount;
       this.OngetPayoffDetails();
    }

   
    @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
    if (currentPageReference) {
      this.urlStateParameters = currentPageReference.state;
      console.log('urlStateParameters------> '+this.urlStateParameters);
      if (typeof currentPageReference.state.sacRecordId != "undefined") {
        this.sacRecordId = currentPageReference.state.sacRecordId;
      }
    }
    console.log("sacRecordId -> " + this.sacRecordId);
  } 


  OngetPayoffDetails() {
       
    getPayoffDetails ({
      finAccId:  this.sacRecordId
    }).then((result) => {
      if(result){
        this.IsnewPayment = false;
        console.log('resulttttttttttt',JSON.parse(JSON.stringify(result)));
        this.payOffData = result;
        this.payoffamt = this.payOffData.ChargentOrders__Charge_Amount__c;
        this.confirmationNumber = this.payOffData.Confirmation_Number__c;
        this.scheduledOn = this.payOffData.ChargentOrders__Payment_Start_Date__c;
        this.authorizedOn = this.payOffData.PaymentAuthorizedOn__c;
        this.paymentSourceNickname = this.payOffData.Payment_Source_Nickname__c;
        this.payoffAccountNo = this.payOffData.Payment_Source_Nickname__r.Last_4__c;
        this.paymentNameWithAccNo = this.payOffData.Payment_Source_Nickname__r.Payment_Source_Nickname__c + this.payOffData.Payment_Source_Nickname__r.Last_4__c;
        
      }else{
        this.IsnewPayment = true;
        getFinanceAccDetail({
            finAccId:  this.sacRecordId
        })
        .then((result) => {
          let paymentDetail = JSON.parse(JSON.stringify(result));
          console.log('result>>>purchase>>>>',JSON.parse(JSON.stringify(result)));
          this.payoffamt = paymentDetail.Payoff_Amount__c;
          this.scheduledOn = paymentDetail.Good_Through_Date__c;
        }) 
        .catch((error) => {
          console.log('Errorrrr',error);
        });
      }
    }) 
    .catch((error) => {
      console.log('Errorrrr',error);
    });
  } 

  get scheduledDate() {
    const months = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC"
    ];
    console.log("Due Date-?" + this.scheduledOn);

    let duedate = new Date(this.scheduledOn);
    duedate = new Date(
      duedate.getTime() + duedate.getTimezoneOffset() * 60 * 1000
    );
    return (
      months[duedate.getMonth()] +
      " " +
      duedate.getDate() +
      ", " +
      duedate.getFullYear()
    );
  }

}