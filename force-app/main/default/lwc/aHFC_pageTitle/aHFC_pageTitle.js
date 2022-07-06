/* 
 * Component Name       :    AHFC_pageTitle
 * @Description        :    This Component is used to display Title page with back navigation
 * Modification Log   :
 * ---------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ---------------------------------------------------------------------------  
 * Satish                    14/05/2021               Created
 */
import {
  api,
  LightningElement,
  track
} from 'lwc';
import {
  NavigationMixin
} from "lightning/navigation";
import AHFC_Community_Named_Dashboard from "@salesforce/label/c.AHFC_Community_Named_Dashboard";
export default class AHFC_pageTitle extends NavigationMixin(LightningElement) {

  @api title;
  @api showIcon;
  @api showNotificationOnChange= false;

  @track showPopUpNotificationOnChange = false;
  @track valueChanged= false;

  connectedCallback() {    
    if(this.showIcon === 'false'){
      this.showIcon = false;
    }
  };

  //Navigate To Dashboard

  navigateBackToDashboard() {
    window.history.back(); 
    return false;
    /*this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        pageName: AHFC_Community_Named_Dashboard
      }
    });*/
  }

  showPageNavigationPopup(){
  console.log('this.showNotificationOnChange',this.showNotificationOnChange);
  console.log('this.valueChanged',this.valueChanged);
    if(this.showNotificationOnChange){
      if(this.valueChanged){
        console.log(this.showPopUpNotificationOnChange);
        this.showPopUpNotificationOnChange = true;
      }else{
        this.navigateBackToDashboard();
      }
    }else{
      this.navigateBackToDashboard();
    }
  }
  /* clears vriables on vehicle switcher switchs*/
  @api
  clearVariables(){
    this.valueChanged = false;
  }

  /* */
  @api
  setValueOnChange(){
    this.valueChanged = true;
  }

  acceptNavigation(){
    this.navigateBackToDashboard();
  }

  cancelNavigation(){
    this.showPopUpNotificationOnChange = false;
  }
}