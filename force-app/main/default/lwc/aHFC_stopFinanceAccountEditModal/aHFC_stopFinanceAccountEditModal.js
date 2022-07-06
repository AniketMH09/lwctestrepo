/*
COMPONENT NAME  : aHFC_stopFinanceAccountEditModal 
AUTHOR          : Akash Solanki
CREATED DATE    : 25-MAY-2021
MODIFICATION LOG
----------------      
MODIFIED DATE   :                                       MODIFIED BY :
DETAILS         :
*/
import {LightningElement,track,api} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import closeCustomerFinanceAccount from "@salesforce/apex/AHFC_EditFinanceAccount.closeCustomerFinanceAccount";
import { NavigationMixin } from "lightning/navigation";

export default class AHFC_stopFinanceAccountEditModal extends LightningElement {

    @api finaccdata;
    @track error;
    
    //US 9346 - Added by Akash as Part of ADA compliance to trap focus inside a pop up so that screen reader reads out only pop up content and not the content in the backdrop
    renderedCallback(){
        const modal1 = this.template.querySelector(`[data-id="stop-modal"]`);
        console.log('modal1-----------> ',modal1);
        if(modal1 != null){
          this.trapFocusForModal(modal1);
        }
      }
    //US 9346 - Added by Akash as Part of ADA compliance to trap focus inside a pop up so that screen reader reads out only pop up content and not the content in the backdrop
      trapFocusForModal(modal){
        const  focusableElements =
        'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])';
        console.log('modal-------> ',modal);
        const firstFocusableElement = modal.querySelectorAll(focusableElements)[0]; // get first element to be focused inside modal
        console.log('firstFocusableElement-------> ',firstFocusableElement);
        const focusableContent = modal.querySelectorAll(focusableElements);
        console.log('focusableContent-------> ',focusableContent);
        const lastFocusableElement = focusableContent[focusableContent.length - 1]; // get last element to be focused inside modal
        console.log('lastFocusableElement-------> ',lastFocusableElement);
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
        console.log('this.finaccdata----> ' + this.finaccdata);
    }
    onSave(event) {
        closeCustomerFinanceAccount({
                finAcctId: this.finaccdata
            }).then((result) => {
                if (result == 'SUCCESS') {
                    const closeQA = new CustomEvent('save');
                    this.dispatchEvent(closeQA);
                } else {
                    this.error = result;
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'error',
                        message: 'This account has already been closed!',
                        variant: 'error'
                    }));
                    const closeQA = new CustomEvent('close');
                    this.dispatchEvent(closeQA);
                }
            })
            .catch(error => {
                this.error = error;
                //Record access check exception handling - Supriya Chakraborty 17-Nov-2021
                if(error.body.message == 'invalid access'){
                  this[NavigationMixin.Navigate]({
                      type: "comm__namedPage",
                      attributes: {
                          pageName: "dashboard"
                      }
                  });
                }
            });
    }

    onCancel() {
        const closeQA = new CustomEvent('close');
        this.dispatchEvent(closeQA);
    }

}