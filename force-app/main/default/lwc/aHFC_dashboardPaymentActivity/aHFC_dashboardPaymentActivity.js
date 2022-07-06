/* Component Name     :    AHFC_dashboardPaymentActivity
    * Description        :    This is LWC for Payment Activity Tile. 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aniket                     20/05/2021              Created 
    */
import {
  LightningElement,
  api,
  track
} from 'lwc';
import {
  getConstants
} from "c/ahfcConstantUtil";
import {
  labels
} from "c/aHFC_dashboardConstantsUtil";
import {
  NavigationMixin
} from "lightning/navigation";
import { fireAdobeEvent } from "c/aHFC_adobeServices";

const CONSTANTS = getConstants();

export default class AHFC_dashboardPaymentActivity extends NavigationMixin(LightningElement) {

  @track servviceAccountData;
  @track lastPayAmnt = '';
  @track lastPayDate = '';
  @track boolNoDuePayments = false;
  @track nextPayAmnt = '';
  @track dueDate = '';
  @track boolNoPayments = false;
  @track labels = labels;
  @track paymentArray = [];
  @track isSheduledPayment = false;
  @api serviceaccdata;


  connectedCallback() {
    if (this.serviceaccdata) {
      this.servviceAccountData = JSON.parse(this.serviceaccdata);
      this.getPaymentActivity();
    }
  }

  //Function to call when Finance Account changes on dashboard corosal
  @api handleValueChange(data) {
    this.servviceAccountData = JSON.parse(data);
    console.log('53>>', this.servviceAccountData )
    this.getPaymentActivity();
  }

  // Function to formate date
  lastPayDateFormatted(date) {
    var formatdate = new Date(date);
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

  //navigates to managepayments
  onPaymentActivityClick() {

    sessionStorage.setItem('isRefreshed', 'false');
    sessionStorage.setItem('salesforce_id', this.servviceAccountData.serAccRec.Id);
    let adobedata = {
      'Event_Metadata.action_type': 'Hyperlink',
      "Event_Metadata.action_label": "Dashboard:Hyperlink:View Activity Details",
      "Event_Metadata.action_category": "Payment Activity Tile",
      "Page.page_name": "Dashboard",
      "Page.brand_name": this.servviceAccountData.serAccRec.Honda_Brand__c ? this.servviceAccountData.serAccRec.Honda_Brand__c : '',
    };
    fireAdobeEvent(adobedata, 'click-event');
    console.log('this.servviceAccountData.serAccRec.Id', this.servviceAccountData.serAccRec.Id);
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        pageName: 'manage-payment'
      },
      state: {
        sacRecordId: this.servviceAccountData.serAccRec.Finance_Account_Number__c,
        contarctStartDate: this.servviceAccountData.dtContractdate,
        dateToday: this.servviceAccountData.datToday,
        sacRecId: this.servviceAccountData.serAccRec.Id
      }
    });
  }

  //get data to show case on tile.
  getPaymentActivity() {
    this.boolNoPayments = false;
    this.boolNoDuePayments = false;
    this.isSheduledPayment = false;
    this.isEZP = false;
    this.isOTP = false;
    if (this.servviceAccountData.serAccRec.AHFC_Last_Payment_Date__c !== undefined && this.servviceAccountData.serAccRec.AHFC_Last_Payment_Date__c !== '' && this.servviceAccountData.serAccRec.AHFC_Last_Payment_Amount__c !== undefined && this.servviceAccountData.serAccRec.AHFC_Last_Payment_Amount__c !== '') {
      this.boolNoPayments = true;
      this.lastPayAmnt = this.formatnumber(this.servviceAccountData.serAccRec.AHFC_Last_Payment_Amount__c);
      let lastPayDate = this.servviceAccountData.serAccRec.AHFC_Last_Payment_Date__c;
      this.lastPayDate = this.lastPayDateFormatted(lastPayDate);
    }

    if (this.servviceAccountData.lstOtpPayments !== undefined) {
      if (this.servviceAccountData.lstOtpPayments) {
        this.paymentArray = JSON.parse(JSON.stringify(this.servviceAccountData.lstOtpPayments));

        this.paymentArray.sort((a, b) => {
          let x = new Date(a.ChargentOrders__Payment_Start_Date__c);
          let y = new Date(b.ChargentOrders__Payment_Start_Date__c);
          return x - y;
        })
        let xyz = this.paymentArray;
       console.log('124>>',xyz);

       //aniket new changes
       let newRecPymtArray = [];
       let newOTPPymtArray = [];
       let newPayoffPymtArray = [];

       for (let i = 0; i < this.paymentArray.length; i++) {
         if(this.paymentArray[i].RecordType.Name == "Recurring Payment"){
          newRecPymtArray.push(this.paymentArray[i]);
         }else if(this.paymentArray[i].RecordType.Name == "Payoff Payment") {
          newPayoffPymtArray.push(this.paymentArray[i]);
         }else {
          newOTPPymtArray.push(this.paymentArray[i]);
         }
       }
      let nxtamount;
      let nextdata;
       if(newOTPPymtArray.length > 0){
        newOTPPymtArray.sort((a, b) => {
          let x = new Date(a.ChargentOrders__Payment_Start_Date__c);
          let y = new Date(b.ChargentOrders__Payment_Start_Date__c);
          return x - y;
        })
        nxtamount = newOTPPymtArray[0].ChargentOrders__Charge_Amount__c;
        nextdata = newOTPPymtArray[0].ChargentOrders__Payment_Start_Date__c;
      
       }

       if(newPayoffPymtArray.length > 0){
        newPayoffPymtArray.sort((a, b) => {
          let x = new Date(a.Next_Withdrawal_Date__c);
          let y = new Date(b.Next_Withdrawal_Date__c);
          return x - y;
        })
        for(let i = 0; i < newPayoffPymtArray.length;i++){
        if( newOTPPymtArray.length > 0 && newPayoffPymtArray[i].ChargentOrders__Payment_Start_Date__c <= newOTPPymtArray[0].ChargentOrders__Payment_Start_Date__c){
          nxtamount = newPayoffPymtArray[i].ChargentOrders__Charge_Amount__c;
          nextdata = newPayoffPymtArray[i].ChargentOrders__Payment_Start_Date__c;
          }
        }
       }
       if(newRecPymtArray.length > 0){
        newRecPymtArray.sort((a, b) => {
          let x = new Date(a.Next_Withdrawal_Date__c);
          let y = new Date(b.Next_Withdrawal_Date__c);
          return x - y;
        })
       }
    
       
       for(let i = 0; i < newRecPymtArray.length;i++){
        if( nextdata != undefined && newRecPymtArray[i].Next_Withdrawal_Date__c <= nextdata){
          nxtamount = newRecPymtArray[i].ChargentOrders__Charge_Amount__c;
          nextdata = newRecPymtArray[i].Next_Withdrawal_Date__c;
          }
       }
      

       if(newOTPPymtArray.length == 0 && newRecPymtArray.length > 0 && newPayoffPymtArray.length == 0){
        nxtamount = newRecPymtArray[0].ChargentOrders__Charge_Amount__c;
        nextdata = newRecPymtArray[0].Next_Withdrawal_Date__c;
       }
       if(newOTPPymtArray.length > 0 && newRecPymtArray.length == 0 && newPayoffPymtArray.length == 0){
        nxtamount = newOTPPymtArray[0].ChargentOrders__Charge_Amount__c;
        nextdata = newOTPPymtArray[0].ChargentOrders__Payment_Start_Date__c;
       }
       if(newOTPPymtArray.length == 0 && newRecPymtArray.length == 0 && newPayoffPymtArray.length > 0){
        nxtamount = newPayoffPymtArray[0].ChargentOrders__Charge_Amount__c;
        nextdata = newPayoffPymtArray[0].ChargentOrders__Payment_Start_Date__c;
       }

       console.log('nxtamount',nxtamount);
       console.log('nextdata',nextdata);
       console.log('newRecPymtArray',newRecPymtArray);
       console.log('newOTPPymtArray',newOTPPymtArray);

      if(nextdata != undefined && nxtamount != undefined){
        this.dueDate = this.lastPayDateFormatted(nextdata);
        this.nextPayAmnt = this.formatnumber(nxtamount);
        this.isSheduledPayment = true;
        this.boolNoDuePayments = true;
      }

      console.log(' this.dueDate', this.dueDate)
      


        // let datSchd;
        // let amtSchd;
        // let sch = false;
        // if (this.paymentArray.length > 0) {
        //   this.isSheduledPayment = true;
        //   this.boolNoDuePayments = true;

        //   for (let i = 0; i < this.paymentArray.length; i++) {
        //     if (this.paymentArray[i].RecordType.Name === 'Standard One-Time Payment' || this.paymentArray[i].RecordType.Name === 'Principal One-Time Payment' || this.paymentArray[i].RecordType.Name === 'Payoff Payment') {
        //       this.isOTP = true;
        //     }
        //     else if (this.paymentArray[i].RecordType.Name === 'Recurring Payment') {
        //       datSchd = this.paymentArray[i].Next_Withdrawal_Date__c;
        //       if (this.paymentArray[i].ChargentOrders__Charge_Amount__c != undefined) {
        //         amtSchd = this.paymentArray[i].ChargentOrders__Charge_Amount__c;
        //       }
        //       this.isEZP = true;
        //     }
            
        //   }
        //   console.log('145>>',this.isEZP);
        //   console.log('146>>',this.isOTP);
        //   if (!this.isEZP && this.isOTP) {
        //     this.dueDate = this.lastPayDateFormatted(this.paymentArray[0].ChargentOrders__Payment_Start_Date__c);
        //     if (this.paymentArray[0].ChargentOrders__Charge_Amount__c != undefined) {
        //       this.nextPayAmnt = this.formatnumber(this.paymentArray[0].ChargentOrders__Charge_Amount__c);
        //     }
        //   } else if (this.isEZP && !this.isOTP) {
        //     this.dueDate = this.lastPayDateFormatted(datSchd);
        //     this.nextPayAmnt = this.formatnumber(amtSchd);
        //   } else if (this.isEZP && this.isOTP) {
            
        //     for (let i = 0; i < this.paymentArray.length; i++) {
        //       if (datSchd > this.paymentArray[i].ChargentOrders__Payment_Start_Date__c) {
        //         sch = true;
        //       }
        //     }
        //     if (sch) {
        //       if (this.paymentArray[0].RecordType.Name !== 'Recurring Payment') {
        //         this.dueDate = this.lastPayDateFormatted(this.paymentArray[0].ChargentOrders__Payment_Start_Date__c);
        //         if (this.paymentArray[0].ChargentOrders__Charge_Amount__c != undefined) {
        //           this.nextPayAmnt = this.formatnumber(this.paymentArray[0].ChargentOrders__Charge_Amount__c);
        //         }
        //       } else {
        //         this.dueDate = this.lastPayDateFormatted(this.paymentArray[1].ChargentOrders__Payment_Start_Date__c);
        //         if (this.paymentArray[1].ChargentOrders__Charge_Amount__c != undefined) {
        //           this.nextPayAmnt = this.formatnumber(this.paymentArray[1].ChargentOrders__Charge_Amount__c);
        //         }
        //       }
        //     } else {
        //       this.dueDate = this.lastPayDateFormatted(datSchd);
        //       this.nextPayAmnt = this.formatnumber(amtSchd);
        //     }
        //   }
        // }
      }
    }
  }

  formatnumber(number) {
    return number.toLocaleString("en-US", {
      minimumFractionDigits: 2
    });
  }
}