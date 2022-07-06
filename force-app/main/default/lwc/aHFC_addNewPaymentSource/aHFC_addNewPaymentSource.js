/*  * LWC Name           :    aHFC_addNewPaymentSource
    * Description        :    This Component is used to add payment sources for the customer
    * Modification Log   :    Modified by Akash as part of US 6953
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Satish                                             Created
    * Akash                      20-July-2021            Modified
    * Akash                      12-Aug-2021             Modified - US 9949
    * Akash                      02-Sep-2021             Modified - For ADA US 9346
*********************************************************************************/
import { LightningElement, track, api } from 'lwc';
import bankInfoSvg from "@salesforce/resourceUrl/AHFCpayment_bankInfo";
import { loadStyle } from "lightning/platformResourceLoader";
import warningSvg from "@salesforce/resourceUrl/AHFC_warning";
import infoSvg from "@salesforce/resourceUrl/AHFC_info";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import insertPaymentSource from "@salesforce/apex/AHFC_AddPaymentSourceClass.insertPaymentSource";
import retrieveBankName from "@salesforce/apex/AHFC_AddPaymentSourceClass.retrieveBankName";
import preferredPaymentSource from "@salesforce/apex/AHFC_AddPaymentSourceClass.getPaymentSourcePreferred";
import AHFC_Validate_Routing_Number from "@salesforce/label/c.AHFC_Validate_Routing_Number";
import AHFC_Validate_Bank_Account_Number from "@salesforce/label/c.AHFC_Validate_Bank_Account_Number";
import AHFC_Routing_Number_Validation from "@salesforce/label/c.AHFC_Routing_Number_Validation";
import AHFC_Payment_Source_Creation_Error_Message from "@salesforce/label/c.AHFC_Payment_Source_Creation_Error_Message";
import AHFC_Agent_Profile from "@salesforce/label/c.AHFC_Agent_Profile";
import spinnerWheelMessage from "@salesforce/label/c.Spinner_Wheel_Message"; //US_11044
import AHFC_Payment_Source_Creation_Success_Message from "@salesforce/label/c.AHFC_Payment_Source_Creation_Success_Message";
import ContactMobile from '@salesforce/schema/Case.ContactMobile';

import allTnC from "@salesforce/resourceUrl/AHFC_Terms_and_Conditions_pdf";  //US 3738
export default class AHFC_addNewPaymentSource extends LightningElement
 {
  @track paymentAuthTnCUrl = allTnC + "/Payment_Withdrawal_Authorization.pdf";
  @api finId;
  @api options = [];
  @api userprofiletype;
  @api renderwithpreferredpaymentoptions = false;
  @api showreenterbankaccnum;
  @track AHFCBankAccountNickName = "";
  @track AHFCBankRoutingNumber = "";
  @track AHFCBankName = "";
  @track AHFCBankAccountNumber = "";
  @track AHFCBankAccountType = "Checking";
  @track bankAccountNumberErrorMessage = "";
  @track AHFCreEnterBankAccountNumber = "";
  @track boolDisplayRoutingNumberErrorMsg = false;
  @track boolbankAccountNumberErrorMsg = false;
  @track routingNumberErrorMessage = "";
  @track routingNumberErrorMsg = false;
  @track routingSpinner = false;
  @track showReEnterBankAccNum;
  @track renderBankNameText = false;
  @track showBankNamePopover = false;
  @track AHFCPreferredPaymentSource = false;
  @api preferredpayment = false;
  @track openCancelmodal = false;
  @api sacrecordid;
  boolSave;
  bankInfoSvg = bankInfoSvg; 
  warningSvg = warningSvg;
  infoSvg = infoSvg;
  isFormValid;
  @track nickNameError = false;
  @track isBankNumberBlank = false; //Added by Akash as part of US 6953
  @track spinnerMessage = spinnerWheelMessage;

  value = [];
  fields = [
    { key: "routing-input", error: false },
    { key: "bankaccount-input", error: false },
    { key: "accountnumbervalidate-input", error: false },
    { key: "bankname-input", error: false }
  ];

  fieldsForAgent = [
    { key: "routing-input", error: false },
    { key: "bankaccount-input", error: false },
    { key: "bankname-input", error: false }
  ];

  //US 9346 - Added by Akash as Part of ADA compliance to trap focus inside a pop up so that screen reader reads out only pop up content and not the content in the backdrop
  renderedCallback() {
    const modal1 = this.template.querySelector(`[data-id="exampleModal"]`);
    console.log('modal1-----------> ', modal1);
    if (modal1 != null) {
      this.trapFocusForModal(modal1);
    }
    const modal2 = this.template.querySelector(`[data-id="confirm-modal"]`);
    if (modal2 != null) {
      this.trapFocusForModal(modal2);
      console.log('modal2-----------> ', modal2);
    }
  }

  //US 9346 - Added by Akash as Part of ADA compliance to trap focus inside a pop up so that screen reader reads out only pop up content and not the content in the backdrop
  trapFocusForModal(modal) {

    const focusableElements =
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])';
    console.log('modal-------> ', modal);
    const firstFocusableElement = modal.querySelectorAll(focusableElements)[0]; // get first element to be focused inside modal
    console.log('firstFocusableElement-------> ', firstFocusableElement);
    const focusableContent = modal.querySelectorAll(focusableElements);
    console.log('focusableContent-------> ', focusableContent);
    const lastFocusableElement = focusableContent[focusableContent.length - 1]; // get last element to be focused inside modal
    console.log('lastFocusableElement-------> ', lastFocusableElement);

    document.addEventListener("keydown", (e) => {
      let isTabPressed = e.key === 'Tab'

      if (!isTabPressed) {
        return;
      }
      if (e.shiftKey) { // if shift key pressed for shift + tab combination
        if (this.template.activeElement === firstFocusableElement) {
          lastFocusableElement.focus(); // add focus for the last focusable element
          e.preventDefault();
        }
      } else { // if tab key is pressed
        if (this.template.activeElement === lastFocusableElement) { // if focused has reached to last focusable element then focus first focusable element after pressing tab
          firstFocusableElement.focus(); // add focus for the first focusable element
          e.preventDefault();
        }
      }
    });
  }

  connectedCallback() {
    loadStyle(this, ahfctheme + "/theme.css").then(() => { });
    this.showreenterbankaccnum = true;
    preferredPaymentSource({
      finAccId: this.finId
    })
      .then((result) => {
        this.preferredpayment = result;
        console.log('this.preferredpayment>>>>', this.preferredpayment);
        if (this.preferredpayment) {
          this.renderwithpreferredpaymentoptions = false;
        } else {
          this.renderwithpreferredpaymentoptions = true;
        }
      })
      .catch((error) => {
      });
  }
  closeModal() {
    this.AHFCBankAccountType = "Checking";
    this.AHFCBankRoutingNumber = "";
    this.AHFCBankName = "";
    this.AHFCBankAccountNumber = "";
    this.AHFCreEnterBankAccountNumber = "";
    this.AHFCBankAccountNickName = "";
    this.AHFCPreferredPaymentSource = false;
    this.isModalOpen = false;
    this.boolDisplayRoutingNumberErrorMsg = false;
    this.boolbankAccountNumberErrorMsg = false;
    this.routingNumberErrorMsg = false;
    const selectedEvent = new CustomEvent("modalclose", {
      detail: false
    });
    this.dispatchEvent(selectedEvent);
  }
  handlePaymentChange(e) {
    this.value = e.detail.value;
  }
  handlepreferredpaymentChange(event) {
    this.preferredpayment = event.target.checked;
  }
  handlechangeAHFCBankAccountNickName(event) {
    this.AHFCBankAccountNickName = event.target.value;
    this.validateNickName(); // added by Akash as part of US 9949
  }
  //added by Akash as part of US 9949
  validateNickName() {
    let targetPart = this.template.querySelector(".nick-name");
    if (this.AHFCBankAccountNickName.length > 21) {
      this.nickNameError = true;
      this.template
        .querySelector(".nick-name")
        .classList.add("slds-has-error");
    } else {
      this.nickNameError = false
      this.template
        .querySelector(".nick-name")
        .classList.remove("slds-has-error");
    }
  }
  //added by Akash as part of US 9949
  handleAHFCPreferredPaymentSource(event) {
    this.AHFCPreferredPaymentSource = !this.AHFCPreferredPaymentSource;
  }
  handlechangeAHFCBankAccountType(event) {
    this.AHFCBankAccountType = event.target.label;
  }
  handlechangeAHFCBankRoutingNumber(event) {
    this.AHFCBankRoutingNumber = event.target.value;
  }
  handleChangeAHFCBankAccountNumber(event) {
    if (isNaN(event.target.value)) {
      this.validateAccountNumber(event.target.getAttribute("data-id"));
    } else {
      this.AHFCBankAccountNumber = event.target.value;
    }
  }
  handlechangeAHFCBankName(event) {
    this.AHFCBankName = event.target.value;
  }
  handlechangeReEnterBankAccountNumber(event) {
    if (isNaN(event.target.value)) {
      this.validateAccountNumber(event.target.getAttribute("data-id"));
    } else {
      this.AHFCreEnterBankAccountNumber = event.target.value;
    }

  }

  test(event) {

    setTimeout(() => {
      this.AHFCreEnterBankAccountNumber = '';
      event.target.value = '';
    }, 10)


  }
  onClickBankNameInfo() {
    this.showBankNamePopover = true;
  }
  onleaveBankNameInfo() {
    this.showBankNamePopover = false;
  }
  onTouchstartBankNameInfo() {
    this.showBankNamePopover = true;
  }

  Oncancel() {
    this.openCancelmodal = true;
  }
  OnBack() {
    this.openCancelmodal = false;
  }
  validateOnBlur(event) {
    let targetId;
    let fields = [];
    let fieldsForAgent = [];
    if (this.userprofiletype !== AHFC_Agent_Profile) {
      targetId = event.target.getAttribute("data-id");
      fields.push({ key: targetId, error: false });
      this.validateFields(fields);
      if (targetId === "accountnumbervalidate-input") {
        this.validateAccountNumber(targetId);
      }
    } else {
      targetId = event.target.getAttribute("data-id");
      fieldsForAgent.push({ key: targetId, error: false });
      this.validatefieldsForAgent(fieldsForAgent);
    }

    if (targetId === "routing-input") {
      if (
        this.AHFCBankRoutingNumber.length !== 9 ||
        !/^[0-9]+$/.test(this.AHFCBankRoutingNumber)
      ) {
        this.routingNumberErrorMsg = true;
        this.routingNumberErrorMessage = AHFC_Validate_Routing_Number;
        this.boolSave = false;
        this.template
          .querySelector(`.${targetId}`)
          .classList.add("slds-has-error");
      } else {
        this.routingNumberErrorMsg = false;
        this.retrieveBankName(this.AHFCBankRoutingNumber);
        this.boolSave = true;
        this.template
          .querySelector(`.${targetId}`)
          .classList.remove("slds-has-error");
      }
    }
    if (targetId === "bankaccount-input") {
      if (
        this.AHFCBankAccountNumber.length < 4 ||
        !/^[0-9]+$/.test(this.AHFCBankAccountNumber)
      ) {
        this.boolbankAccountNumberErrorMsg = true;
        this.bankAccountNumberErrorMessage = AHFC_Validate_Bank_Account_Number;
        this.boolSave = false;
        this.template
          .querySelector(`.${targetId}`)
          .classList.add("slds-has-error");
      } else {
        this.boolbankAccountNumberErrorMsg = false;
        this.boolSave = true;
        this.template
          .querySelector(`.${targetId}`)
          .classList.remove("slds-has-error");
      }
    }
  }
  validateOnEnter(event) {
    let targetId;
    let fields = [];
    let fieldsForAgent = [];
    if (this.userprofiletype !== AHFC_Agent_Profile) {
      targetId = event.target.getAttribute("data-id");
      switch (targetId) {
        case "bankname-input":
          this.AHFCBankName = event.target.value;
          break;
        case "routing-input":
          this.AHFCBankRoutingNumber = event.target.value;
          break;
        case "bankaccount-input":
          this.AHFCBankAccountNumber = event.target.value;
          break;
        case "accountnumbervalidate-input":
          this.AHFCreEnterBankAccountNumber = event.target.value;
          break;
      }
      fields.push({ key: targetId, error: false });
      this.validateFields(fields);
      if (targetId === "accountnumbervalidate-input") {
        this.validateAccountNumber(targetId);
      }
    } else {
      targetId = event.target.getAttribute("data-id");
      switch (targetId) {
        case "bankname-input":
          this.AHFCBankName = event.target.value;
          break;
        case "routing-input":
          this.AHFCBankRoutingNumber = event.target.value;
          break;
        case "bankaccount-input":
          this.AHFCBankAccountNumber = event.target.value;
          break;
      }
      fieldsForAgent.push({ key: targetId, error: false });
      this.validatefieldsForAgent(fieldsForAgent);
    }
  }
  showBankInfo() {
    this.template.querySelector(".bankinfo-text").style.display = "none";
    this.template.querySelector(".bankinfo-img").style.display = "block";
    this.template.querySelector(".bankinfo-hr").style.display = "block";
  }
  retrieveBankName(routingNumber) {
    retrieveBankName({
      decRoutingNumber: routingNumber
    })
      .then((result) => {
        this.AHFCBankName = result;
        this.renderBankNameText = true;
        if (result == "") {
          this.boolDisplayRoutingNumberErrorMsg = true;
          this.routingNumberErrorMessage = AHFC_Routing_Number_Validation;
        } else {
          this.boolDisplayRoutingNumberErrorMsg = false;
          if (
            this.template
              .querySelector(".bankname-input")
              .classList.contains("slds-has-error")
          ) {
            this.template
              .querySelector(".bankname-input")
              .classList.remove("slds-has-error");
          }
        }
      })
      .catch((error) => {
        this.AHFCBankName = "";
        this.renderBankNameText = false;
        this.boolDisplayRoutingNumberErrorMsg = true;
        this.routingNumberErrorMessage = AHFC_Routing_Number_Validation;
      });
  }
  validateAccountNumber(targetId) {
    if (isNaN(this.AHFCBankAccountNumber) || isNaN(this.AHFCreEnterBankAccountNumber) || this.AHFCreEnterBankAccountNumber == '') {

      this.template
        .querySelector(`.${targetId}`)
        .classList.add("slds-has-error");
      this.fields.find((field) => field.key === targetId)["error"] = true;
      this.boolSave = false;
    } else if (this.AHFCBankAccountNumber !== this.AHFCreEnterBankAccountNumber) {
      this.template
        .querySelector(`.${targetId}`)
        .classList.add("slds-has-error");
      this.fields.find((field) => field.key === targetId)["error"] = true;
      this.boolSave = false;
    } else {
      this.template
        .querySelector(`.${targetId}`)
        .classList.remove("slds-has-error");
      this.fields.find((field) => field.key === targetId)["error"] = false;
      this.boolSave = true;
    }
  }
  validateFields(fields) {
    fields.forEach((field) => {
      const element = this.template.querySelector(`[data-id=${field.key}]`);

      if (element != null) {
        if (element.value.trim() === "") {
          this.template
            .querySelector(`.${field.key}`)
            .classList.add("slds-has-error");
          field.error = true;
        } else {
          this.template
            .querySelector(`.${field.key}`)
            .classList.remove("slds-has-error");
          field.error = false;
        }
      }

      /** Added by Akash as part of 6953 starts  */
      if (field.key === 'routing-input') {
        if (element.value.length != 9 || !/^[0-9]+$/.test(this.AHFCBankRoutingNumber)) {
          this.template.querySelector(`.${field.key}`).classList.add("slds-has-error");
          field.error = true;
        } else {
          this.template.querySelector(`.${field.key}`).classList.remove("slds-has-error");
          field.error = false;
        }
      }
      if (field.key === "bankaccount-input") {
        if (
          element.value.length < 4 ||
          !/^[0-9]+$/.test(element.value)
        ) {
          this.template
            .querySelector(`.${field.key}`)
            .classList.add("slds-has-error");
        } else {
          this.template
            .querySelector(`.${field.key}`)
            .classList.remove("slds-has-error");
        }
      }
      /** Added by Akash as part of 6953 Ends  */
    });
  } 
  savePaymentSource() {
    const topDiv = this.template.querySelector('[data-id="saved"]');
    topDiv.scrollIntoView({behavior: "smooth", block: "center", inline: "nearest"});
    if (this.userprofiletype !== AHFC_Agent_Profile) {
      this.validateFields(this.fields);
      //this.validateOnBlur("routing-input");
      this.validateAccountNumber("accountnumbervalidate-input");
      this.isFormValid = this.fields.every((field) => !field.error);
      this.validateNickName(); //added by Akash as part of US 9949
    } else {
      this.validatefieldsForAgent(this.fieldsForAgent);
      this.validateNickName(); //added by Akash as part of US 9949
      this.isFormValid = this.fieldsForAgent.every((field) => !field.error);
    }
    if (this.isFormValid && this.boolSave && !this.boolbankAccountNumberErrorMsg && !this.routingNumberErrorMsg && !this.nickNameError) {
      let paymentAddedStatus = false;
      let personName = '';
      let accLast4 = '';
      let psId = '';
      this.routingSpinner = true;
      console.log("brfore entering--->" + this.personName)
      console.log('this.AHFCBankRoutingNumber>>>>', this.AHFCBankRoutingNumber);
      insertPaymentSource({
        bankAccountNumber: this.AHFCBankAccountNumber,
        bankName: this.AHFCBankName,
        bankAccountType: this.AHFCBankAccountType,
        bankRoutingNumber: this.AHFCBankRoutingNumber,
        bankAccountNickName: this.AHFCBankAccountNickName,
        preferredPaymentSource: this.preferredpayment,
        sacRecordId: this.finId,
        lstSACIdsToUpdate: this.value
      })
        .then((result) => {
          this.routingSpinner = false;
          console.log("entering insert payment", result);
          console.log("succesfull paymentsource--->" + result.successfulPaymentSource)
          if (result.successfulPaymentSource) {
            personName = result.insertedPaymentSource.Payment_Source_Nickname__c;
            console.log("person name" + personName);
            accLast4 = result.insertedPaymentSource.Last_4__c;
            console.log("id" + result.insertedPaymentSource.id);
            psId = result.insertedPaymentSource.id;
            paymentAddedStatus = true;
            this.boolPaymentSourceError = false;

          } else {
            paymentAddedStatus = false;
            this.boolPaymentSourceError = true;
          }
          this.AHFCBankAccountType = "Checking";
          this.AHFCBankRoutingNumber = "";
          this.AHFCBankName = "";
          this.AHFCBankAccountNumber = "";
          this.AHFCreEnterBankAccountNumber = "";
          this.AHFCBankAccountNickName = "";
          this.AHFCPreferredPaymentSource = false;
          const selectedEvent = new CustomEvent("modalsave", {
            detail: {
              paymentAddedStatus: paymentAddedStatus,
              personName: personName,
              accLast4: accLast4,
              psId: psId
            }
          });
          this.dispatchEvent(selectedEvent);
          this.closeModal();
        })
        .catch((error) => {
          console.log("entering error", error)
          this.boolPaymentSourceError = true;
          this.AHFCBankAccountType = "";
          this.AHFCBankRoutingNumber = "";
          this.AHFCBankName = "";
          this.AHFCBankAccountNumber = "";
          this.AHFCreEnterBankAccountNumber = "";
          this.AHFCBankAccountNickName = "";
          this.AHFCPreferredPaymentSource = false;
          const selectedEvent = new CustomEvent("modalsave", {
            detail: { paymentAddedStatus: false }
          });
          this.dispatchEvent(selectedEvent);
        });
    }
  }

  validatefieldsForAgent(fieldsForAgent) {
    fieldsForAgent.forEach((field) => {
      const element = this.template.querySelector(`[data-id=${field.key}]`);
      if (element.value.trim() == "") {
        this.template
          .querySelector(`.${field.key}`)
          .classList.add("slds-has-error");
        field.error = true;
      } else {
        this.template
          .querySelector(`.${field.key}`)
          .classList.remove("slds-has-error");
        field.error = false;
      }
    });
  }
  openPageLoader() {
    this.template
      .querySelector("c-a-h-f-c_vehicleswitcher")
      .openLoader();
  }
}