import {
  LightningElement, track, api
}
  from "lwc";
import updateFinanceNickName from "@salesforce/apex/AHFC_EditFinanceNicknameController.updateFinanceNickName";
import {
  ShowToastEvent
}
  from 'lightning/platformShowToastEvent';
import {
  labels
}
  from "c/aHFC_dashboardConstantsUtil";
export default class AHFC_financeAccountEditModal extends LightningElement {

  @track updatenickname = "";
  @track data;
  @api SerAccRec;
  @api accdata;
  @track nickName = "";
  @track errorMessage = "";
  @track boolErr = false;
  @track labels = labels;
  connectedCallback() {
    this.data = JSON.parse(this.accdata);
  }
  renderedCallback() {
    this.template.querySelector('[data-id="InfoEdit"]').focus();
  }
  handleChange(event) {
    this.updatenickname = event.target.value;
    console.log('updatenick-->' + this.updatenickname);
  }
  onSave(event) {
    if (String(this.updatenickname).length == 0) {
      this.errorMessage = 'Error: Nickname cannot be blank.';
      this.boolErr = true;
      return boolErr;
    } else if (String(this.updatenickname).length > 46) {
      this.errorMessage = 'Error: More than 46 characters are not allowed.';
      this.boolErr = true;
      return boolErr;
    }
    updateFinanceNickName({
      FinanceId: this.data.serAccRec.Id,
      NickName: this.updatenickname
    }).then((result) => {
      this.dispatchEvent(new ShowToastEvent({
        title: 'Success',
        message: 'Your vehicle nickname has been updated.',
        variant: 'success'
      }));
      const closeQA = new CustomEvent('close', {
        detail: {id:this.data.serAccRec.Id,name:this.updatenickname}
      });
      // Dispatches the event.
      this.dispatchEvent(closeQA);
    }).catch((err) => console.log(err));
  }
  onCancel(event) {
    const closeQA = new CustomEvent('close');
    // Dispatches the event.
    console.log(" Cancel is pressed");
    this.dispatchEvent(closeQA);
  }
}