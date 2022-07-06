import { api, LightningElement, track } from 'lwc';
import AHFC_Honda_Contact_Us_URL from "@salesforce/label/c.AHFC_Honda_Contact_Us_URL";
import T_C_Message_1 from "@salesforce/label/c.T_C_Message_1";
import AHFC_Payoff_T_C_Message from "@salesforce/label/c.AHFC_Payoff_T_C_Message";
import T_C_Message_2 from "@salesforce/label/c.T_C_Message_2";
import AHFC_PayOff_Payment_Message from "@salesforce/label/c.AHFC_PayOff_Payment_Message";
import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
//import apex methods here
import commPrefDetail from "@salesforce/apex/AHFC_ReviewPaymentDetails.commPrefDetail";
import getOrgDetail from "@salesforce/apex/AHFC_Payment.getOrgdetail";
import AHFC_Agent_Profile from "@salesforce/label/c.AHFC_Agent_Profile";
import AHFC_CutOffTime from "@salesforce/label/c.AHFC_CutOffTime";
//edwin
import getFinannceAccountHandler from "@salesforce/apex/AHFC_EditFinanceAccount.getFinannceAccountHandler";
import { ShowToastEvent } from "lightning/platformShowToastEvent";


export default class AHFC_reviewPaymentPayoffPurchase extends LightningElement {
  @api paymenttype;
  @api payoffdate;
  @api paymentsourcenickname;
  @api payoffbankaccno;
  @api payoffamt;
  @api finaccid;
  @track Payment_Confirmations_via_Email = false;
  @track Payment_Confirmations_via_Text = false;
  @track commprefemail;
  @track commprefphone;
  @track isSandbox;
  cutOffTime;
  //edwin
  @track resultData = {
    otherDemographics: {
      lookupID: "",
      cellPhone: "",
      cellPhone2: "",
      homePhone: "",
      placeOfEmployment: "",
      workPhone: ""
    },
    garagingAddress: {
      addressLine1: "",
      addressLine2: "",
      addressType: "",
      city: "",
      state: "",
      zipCode: ""
    },
    billToAddress: {
      addressLine1: "",
      addressLine2: "",
      addressType: "",
      city: "",
      state: "",
      zipCode: "",
      isNullBillingAddress: false
    }
  };

  //US:4595
  @track isPayOffSuccess = true;
  @track isAddressEditModalOpen = false;
  @track modalHeaderText = 'Edit Adress';
  @track nickNameModal = false;
  @track contactInfoModal = false;
  @track garageAddressModal = false;
  @track billingAddressModal = true;
  @track stopFinanceModal = false;
  @track modalBtnSave = 'SAVE';
  @track modalBtnCancel = 'CANCEL';
  @track isUpdateSuccessfully = false;
  @track getFinanceAccountNum = "00000449919921";
  @track isPaymentSuccess = true;
  @track isAddressUpdatedSucess =false;

  label = {
    AHFC_PayOff_Payment_Message,
    T_C_Message_1,
    T_C_Message_2,
    AHFC_Payoff_T_C_Message,
    AHFC_Honda_Contact_Us_URL
  };

  connectedCallback() {

    this.cutOffTime = (AHFC_CutOffTime % 12) || 12;
    console.log('this.sacRecordId-->' + this.finaccid);
    loadStyle(this, ahfctheme + "/theme.css").then(() => { });
    this.getFinanceAccountDetails('00000449919921');
    /* 
           commPrefDetail({
             finid: this.finaccid
           }).then((result) => {
               console.log("commPrefDetail Response", result);
               if(result != null){
                 this.Payment_Confirmations_via_Email = result.Payment_Confirmations_via_Email__c;
                 this.Payment_Confirmations_via_Text = result.Payment_Confirmations_via_Text__c;
                 this.strCommunicationEmail = result.Email_Address__c;
                 var cleaned = ('' + result.Text_Number__c).replace(/\D/g, '');
                   var match = cleaned.match(/^(1|)?(\d{3})(\d{3})(\d{4})$/);
                   if (match) {
                     var intlCode = (match[1] ? '+1 ' : '');
                     this.strCommunicationPhone = [intlCode, '(', match[2], ') ', match[3], '-', match[4]].join('');
                   }
               }      
             })
             .catch((error) => {
               console.log("error ", error);
             });
   this.OngetOrgDetail();
          */
  };

  OngetOrgDetail() {
    getOrgDetail({
    })
      .then((result) => {
        if (result)
          this.isSandbox = '12pm.';
        else
          this.isSandbox = '2pm.';
      })
      .catch((error) => {
        console.log('Errorrrr', error);
      }
      );
  }

  // US:4595 by edwin starts here
  /** Method Name: getFinanceAccountDetails
 *  Description:   To fetch address details from web service
 *  Developer Name: Edwin Antony
 *  Created Date:   14-July-2021 
 *  User Story :    #4595
 */
    getFinanceAccountDetails(financeAccountNum) {

    getFinannceAccountHandler({ financeAccNumber: financeAccountNum })
      .then((result) => {
        this.resultData = result;

        console.log('resultData'+JSON.stringify(result));
        
        if (this.resultData.garagingAddress.addressLine1 === undefined) {
          this.resultData.garagingAddress.addressLine1 = "";
        }
        if (this.resultData.garagingAddress.addressLine2 === undefined) {
          this.resultData.garagingAddress.addressLine2 = "";
        }
        if (this.resultData.garagingAddress.state === undefined) {
          this.resultData.garagingAddress.state = "";
        }
        if (this.resultData.garagingAddress.city === undefined) {
          this.resultData.garagingAddress.city = "";
        }
        if (this.resultData.garagingAddress.zipCode === undefined) {
          this.resultData.garagingAddress.zipCode = "";
        }

      })
      .catch((error) => {
        console.log(
          "Error while fetching finance account details",error
        );
        this.showErrorMessage('An error occurred. Please refresh the page.');
      });
  }


  editAddress() {
    this.isAddressEditModalOpen =true;
   }


  onModalSave(event) {
    if (event.detail.modalName === "BillAddress") {
      this.isAddressEditModalOpen = event.detail.isModal;
      this.isUpdateSuccessfully = event.detail.isUpdateSuccessful;
      if (this.isUpdateSuccessfully == true) {
        this.resultData = JSON.parse(event.detail.resultData);
        this.isAddressUpdatedSucess = true;
        //this.showSuccessMessage('Your address was successfully updated');
      } else {
        this.isAddressUpdatedSucess = false;
        this.showErrorMessage('An error occurred. Please refresh the page');
      }
    }
  }


  showSuccessMessage(showSuccessMsg) {
    console.log("success message-->" + showSuccessMsg);
    const event = new ShowToastEvent({
      title: "success",
      message: showSuccessMsg,
      variant: "success",
      mode: "dismissable"
    });
    this.dispatchEvent(event);
  }

  showErrorMessage(showErrorMsg) {
    console.log("Erro message-->" + showErrorMsg);
    const event = new ShowToastEvent({
      title: "Error",
      message: showErrorMsg,
      variant: "error",
      mode: "dismissable"
    });
    this.dispatchEvent(event);
  }

  onModalClose(event) {
    this.isAddressEditModalOpen = false;
  }


  //Navigate to dashboard screen on clicking Continue to Dashboard button
  navigateToDashboard() {
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        pageName: "dashboard"
      }
    });
  }
}

  // US:4595 ends here