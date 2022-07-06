import { LightningElement } from 'lwc';
import isGuest from '@salesforce/user/isGuest';
import {NavigationMixin} from "lightning/navigation";


export default class AHFC_GuestUserNavigation extends NavigationMixin(LightningElement) {
  isGuestUser = isGuest;
  
  navigateToAddAcountPage(){
     
      
  this[NavigationMixin.Navigate]({
    type: "comm__namedPage",
    attributes: {
        pageName: 'add-a-finance-account'
    }
    });
  
}
connectedCallback() {
    if(this.isGuestUser){
        this.navigateToHondaUrl();
    
    }else{
        this.navigateToAddAcountPage();
    }
}
navigateToHondaUrl(){
    //
    this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
        attributes: {
            url: 'https://poc.honda.americanhondafinance.com/s/'
        }
    },
    true // Replaces the current page in your browser history with the URL
  );
}
}