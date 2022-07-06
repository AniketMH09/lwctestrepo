/*  * lWC                :    AHFC_commonModalPopUp
    * description        :    This component is used to display attention message
    * modification Log   :    Modified by 
    * ---------------------------------------------------------------------------
    * developer                   Date                   Description
    * ---------------------------------------------------------------------------
    * Edwin Antony         09-JULY-2021               Created
*********************************************************************************/


import { LightningElement, api } from 'lwc';

export default class AHFC_commonModalPopUp extends LightningElement {

@api nextwithdrawaldate;
@api nextpaymentduedate;
@api ismodalopen = false;
    //Dispatch Event on closing toast
    closeModel(){
     /*   if(this.timeout){
          clearTimeout(this.timeout);
        }*/
        this.ismodalopen = false;
        const selectedEvent = new CustomEvent("closeAttentionModal", {});
        // Dispatches the event.      
        this.dispatchEvent(selectedEvent);
      }
      
      @api openModal(){
        this.ismodalopen = true;
      }
}