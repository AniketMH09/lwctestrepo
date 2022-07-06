import { LightningElement, api, track } from "lwc";
import updatePaymentSource from "@salesforce/apex/AHFC_AddPaymentSourceClass.updatePaymentSource";
import spinnerWheelMessage from "@salesforce/label/c.Spinner_Wheel_Message"; //US_11044

export default class AHFC_paymentSourcesEditModal extends LightningElement {
  @api modalSaveText;
  @api modalCancelText;
  @track isEditModalOpen = false;
  @api options = [];
  @api checkboxvalue;
  @api accountnumber;
  @api bankaccounttype;
  @api bankname;
  @api nickname;
  @api paymentcardid;
  @track isNickNameError = false;
  @track loaded = false;
  @track spinnerMessage = spinnerWheelMessage;

  get renderOptions() {
    return this.options.length > 0 ? true : false;
  }

  connectedCallback() {
    console.log('id', this.paymentcardid);
  }

  onSave() {
    if(!this.isNickNameError){
      this.loaded = true;
    console.log('id', this.paymentcardid);
    console.log('this.checkboxvalue', this.checkboxvalue);
    console.log('this.nickname', this.nickname);
    updatePaymentSource({
      bankAccountId: this.paymentcardid,
      bankAccountNickName: this.nickname,
      preferredPaymentSource: this.checkboxvalue
    }).then((data) => {
      let dateObj = {
        detail: this.isEditModalOpen,
        nickname: this.nickname
      };
      const selectedEvent = new CustomEvent("modalsave", {
        detail: dateObj
      });
       this.loaded = false;
       this.dispatchEvent(selectedEvent);
    }).catch((error) => {
      this.loaded = false;
      console.log('line no 42',error);
    });
  }

  }

  onCancel() {

    const selectedEvent = new CustomEvent("modalclose", {
      detail: this.isEditModalOpen
    });
    this.dispatchEvent(selectedEvent);
  }

  handleDialogClose() {
    const selectedEvent = new CustomEvent("modalclose", {
      detail: this.isEditModalOpen
    });
    this.dispatchEvent(selectedEvent);
  }

  handlepaymentchange(event) {
    this.checkboxvalue = event.target.checked;

  }

  handlechangeAHFCBankAccountNickName(event) {
    this.nickname = event.target.value;
    this.validateNickName(); // added by Akash as part of US 9949
  }
    //added by Akash as part of US 9949
    validateNickName(){
      let targetPart = this.template.querySelector(".nick-name");
        if(this.nickname.length > 21){
          this.isNickNameError = true;
        this.template
          .querySelector(".nick-name")
          .classList.add("slds-has-error");
        }else{
          this.isNickNameError = false
          this.template
          .querySelector(".nick-name")
          .classList.remove("slds-has-error");
        }
    }
    //added by Akash as part of US 9949
}