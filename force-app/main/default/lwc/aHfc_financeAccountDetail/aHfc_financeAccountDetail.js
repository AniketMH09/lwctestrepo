import { LightningElement, track, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CurrentPageReference } from "lightning/navigation";
import hondaLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import carImg from "@salesforce/resourceUrl/AHFC_CAR_LOGO";
import successIcon from "@salesforce/resourceUrl/AHFC_SuccessIcon";
import getFinannceAccountHandler from "@salesforce/apex/AHFC_EditFinanceAccount.getFinannceAccountHandler";
//import getFinanceAccountNumber from "@salesforce/apex/AHFC_EditFinanceAccount.getFinanceAccountNumber";

//import ServiceAcc_OBJECT from "@salesforce/schema/AHFC_Service_Account__c";
//import softDelete from "@salesforce/apex/AHFC_EditFinanceAccount.softDelete";

//Show custom labels
import AHFC_Garaging_Address_Update from "@salesforce/label/c.AHFC_Garaging_Address_Update";
import AHFC_Error_On_Finance_Account_Save from "@salesforce/label/c.AHFC_Error_On_Finance_Account_Save";
import AHFC_Contact_Information_Save from "@salesforce/label/c.AHFC_Contact_Information_Save";
import AHFC_Billing_Address_Update from "@salesforce/label/c.AHFC_Billing_Address_Update";

export default class AHFC_financeAccountProfile extends LightningElement {
  hondaLogo = hondaLogo;
  carImg = carImg;
  successIcon = successIcon;
  @track isModalOpen = false;
  @track modalHeaderText = "";
  @track nickNameModal = false;
  @track contactInfoModal = false;
  @track garageAddressModal = false;
  @track billingAddressModal = false;
  @track stopFinanceModal = false;
  @track modalBtnSave = "SAVE";
  @track modalBtnCancel = "CANCEL";
  @track boolResultAfterUpdate = false;
  @track boolResultAfterBillingUpdate = false;
  @track sacRecordId;
  @track getFinanceAccountNum = "";

  //serviceAccObject = ServiceAcc_OBJECT;
  @track financeAcc;
  @track error;

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
      zipCode: ""
    }
  };

  @track boolStopFinanceAccount = false;
  @track isUpdateSuccessfully = false;

  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {
    if (currentPageReference) {
      this.urlStateParameters = currentPageReference.state;
      if (typeof currentPageReference.state.sacRecordId != "undefined") {
        this.sacRecordId = currentPageReference.state.sacRecordId;
      }
    }
    console.log("sacRecordId -> " + this.sacRecordId);
  }
  connectedCallback() {
    console.log("sacRecordId -> " + this.sacRecordId);
    this.getFinanceAccountNumDetails();
  }

  getFinanceAccountNumDetails() {
    // getFinanceAccountNumber({ customerId: this.sacRecordId })
    //   .then((result) => {
       this.getFinanceAccountNum = "00000445799300";
        this.getFinanceAccountDetails(this.getFinanceAccountNum);
    //   })
    //   .catch((error) => {
    //     console.log(
    //       "Error while fetching finance account number",
    //       error.body.message
    //     );
    //   });
  }
  getFinanceAccountDetails(financeAccountNum) {

    getFinannceAccountHandler({ financeAccNumber: financeAccountNum })
      .then((result) => {
        this.resultData = result;
        if (this.resultData.otherDemographics.homePhone == undefined) {
          this.resultData.otherDemographics.homePhone = "";
        }
        if (this.resultData.otherDemographics.cellPhone == undefined) {
          this.resultData.otherDemographics.cellPhone = "";
        }
        if (this.resultData.otherDemographics.cellPhone2 == undefined) {
          this.resultData.otherDemographics.cellPhone2 = "";
        }
        if (this.resultData.otherDemographics.workPhone == undefined) {
          this.resultData.otherDemographics.workPhone = "";
        }
        if (this.resultData.otherDemographics.placeOfEmployment === undefined) {
          this.resultData.otherDemographics.placeOfEmployment = "";
        }
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

        if (this.resultData.billToAddress === "") {
          this.resultData.billToAddress.addressLine1 = this.resultData.garagingAddress.addressLine1;
          this.resultData.billToAddress.addressLine2 = this.resultData.garagingAddress.addressLine2;
          this.resultData.billToAddress.state = this.resultData.garagingAddress.state;
          this.resultData.billToAddress.city = this.resultData.garagingAddress.city;
          this.resultData.billToAddress.zipCode = this.resultData.garagingAddress.zipCode;
        }
        if (this.resultData.billToAddress.addressLine1 === undefined) {
          this.resultData.billToAddress.addressLine1 = "";
        }
        if (this.resultData.billToAddress.addressLine2 === undefined) {
          this.resultData.billToAddress.addressLine2 = "";
        }
        if (this.resultData.billToAddress.state === undefined) {
          this.resultData.billToAddress.state = "";
        }
        if (this.resultData.billToAddress.city === undefined) {
          this.resultData.billToAddress.city = "";
        }
        if (this.resultData.billToAddress.zipCode === undefined) {
          this.resultData.billToAddress.zipCode = "";
        }
      })
      .catch((error) => {
        console.log(
          "Error while fetching finance account details",error
        );
      });
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

  onModalOpen(event) {
    const targetModal = event.target.getAttribute("data-id");
    console.log('>>>>>',targetModal);
    this.nickNameModal = false;
    this.contactInfoModal = false;
    this.garageAddressModal = false;
    this.billingAddressModal = false;
    this.stopFinanceModal = false;
    switch (targetModal) {
      case "nickNameEdit":
        this.modalHeaderText = "Edit nickname";
        this.nickNameModal = true;
        break;
      case "contactInfoEdit":
        this.modalHeaderText = "Edit contact information";
        this.contactInfoModal = true;
        break;
      case "garagingAddressEdit":
        this.modalHeaderText = "Edit garaging address";
        this.garageAddressModal = true;
        break;
      case "billingAddressEdit":
        this.modalHeaderText = "Edit billing address";
        this.billingAddressModal = true;
        break;
      case "stopFinanceEdit":
        this.modalHeaderText = "Stop managing this finance account?";
        this.modalBtnSave = "YES, REMOVE";
        this.modalBtnCancel = "BACK";
        this.stopFinanceModal = true;
        break;
    }
    this.isModalOpen = true;
    const scrollOptions = {
      left: 0,
      top: 0,
      behavior: "smooth"
    };
    window.scrollTo(scrollOptions);
  }

  onModalSave(event) {
    if (event.detail.modalName === "stopFinanceAccount") {
      console.log("inside-save-stop-finance::::");
      console.log("sacRecordId", this.sacRecordId);
    //   softDelete({ idSAC: this.sacRecordId })
    //     .then((result) => {
    //       this.isModalOpen = event.detail.isModal;
    //       this.boolStopFinanceAccount = true;
    //     })
    //     .catch((Error) => {
    //       console.error(
    //         "Error while fetching payment source",
    //         error.body.message
    //       );
    //     });
    } else if (event.detail.modalName === "Contact") {
      this.isModalOpen = event.detail.isModal;
      this.isUpdateSuccessfully = event.detail.isUpdateSuccessful;
      if (this.isUpdateSuccessfully == true) {
        this.resultData = JSON.parse(event.detail.resultData);
        this.showSuccessMessage(AHFC_Contact_Information_Save);
      } else {
        this.showErrorMessage(AHFC_Error_On_Finance_Account_Save);
      }
    } else if (event.detail.modalName === "GarageAddress") {
      this.isModalOpen = event.detail.isModal;
      this.isUpdateSuccessfully = event.detail.isUpdateSuccessful;
      if (this.isUpdateSuccessfully == true) {
        this.resultData = JSON.parse(event.detail.resultData);
        this.showSuccessMessage(AHFC_Garaging_Address_Update);
      } else {
        this.showErrorMessage(AHFC_Error_On_Finance_Account_Save);
      }
    } else if (event.detail.modalName === "BillAddress") {
      this.isModalOpen = event.detail.isModal;
      this.isUpdateSuccessfully = event.detail.isUpdateSuccessful;
      if (this.isUpdateSuccessfully == true) {
        this.resultData = JSON.parse(event.detail.resultData);
        this.showSuccessMessage(AHFC_Billing_Address_Update);
      } else {
        this.showErrorMessage(AHFC_Error_On_Finance_Account_Save);
      }
    }
  }

  onModalClose(event) {
    this.isModalOpen = event.detail;
  }
}