import { LightningElement, api, track } from "lwc";

export default class AHFC_paymentCard extends LightningElement {
  @api title;
  @api cardsubtitle;
  @api cardsubtitle1;
  @api cardsubtitle2;
  @api label;
  @api buttontext;
  @api iconname;
  @api descriptiontext;
  @api errortext;
  @api paymentid;
  @api preferredpaymentsource;
  @track renderPreferredOptions = false;
  @track paymentOptionsLength;
  @track isPaymentOptionsModalOpen = false;
  @track preferredOptionsLabel;

  renderedCallback() {
    console.log("payment card entered");
    //console.log("payment card", this.title);
   // this.computeLabel();
  }

  get className() {
    return this.errortext
      ? "payment-card-container payment-card-container-error"
      : "payment-card-container";
  }
  handleModalClose () {
    this.isPaymentOptionsModalOpen = false;
  }

  // computeLabel() {
  //   if (this.label.length > 0 && this.label.length < 2) {
  //     this.renderPreferredOptions = true;
  //     this.preferredOptionsLabel = this.label[0].name;
  //   } else if (this.label.length == 2) {
  //     this.renderPreferredOptions = true;
  //     this.preferredOptionsLabel = `${this.label[0].name} and ${this.label[1].name}`;
  //   } else if (this.label.length > 2) {
  //     this.renderPreferredOptions = true;
  //     this.paymentOptionsLength = this.label.length - 2;
  //     this.preferredOptionsLabel = `${this.label[0].name}, ${this.label[1].name} and `;
  //   } else {
  //     this.renderPreferredOptions = false;
  //   }
  // }
  onOptionsClick() {
    this.isPaymentOptionsModalOpen = true;
  }

  oneditclick() {
    // Creates the event with the data.
    const selectedEvent = new CustomEvent("editpayment", {
      detail: this.paymentid
    });
    // Dispatches the event.
    this.dispatchEvent(selectedEvent);
  }

  onbuttonclick() {
    // Creates the event with the data.
    const selectedEvent = new CustomEvent("deletepayment", {
      detail: this.paymentid
    });
    // Dispatches the event.
    this.dispatchEvent(selectedEvent);
  }

  get iconTitle() {
    return this.iconname ? `icon-${this.iconname.split(":")[1]}` : "";
  }
}