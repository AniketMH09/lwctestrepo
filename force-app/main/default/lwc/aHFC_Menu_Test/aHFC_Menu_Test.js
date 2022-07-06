import {api, LightningElement, track, wire } from "lwc";
import hondaLogo from "@salesforce/resourceUrl/Honda_financial_logo";
import acuraLogo from "@salesforce/resourceUrl/AHFC_Acura_Header_Logo";

import { loadStyle } from "lightning/platformResourceLoader";
import FORM_FACTOR from "@salesforce/client/formFactor";
import { labels } from "c/aHFC_dashboardConstantsUtil";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import { NavigationMixin } from "lightning/navigation";
import isguest from '@salesforce/user/isGuest';

export default class aHFC_Menu_Test extends NavigationMixin(LightningElement) {
  get hondaLogoUrl() {
    return hondaLogo;
  }
  get AcuraLogoUrl() {
    return acuraLogo;
  }
  
  @track isSubMenuOpenAc = false;
  @track isUserProfile = false;
  @track isSubMenuOpenSupport = false;
  @track isSubMenuOpenFinance = false;
  @track isSubMenuOpenMenu = false;
  @track showdesktop;
  @track showmobile;
  @track labels=labels;
 isCheck =isguest;
  @track isGuestCheck =false;
  
 /* @track labels = {
    MyAccount: 'My Account',
    FINANCETOOLS: 'FINANCE TOOLS',
    ApplyforPreApproval: 'Apply for Pre-Approval',
    LeaseVsFinance: 'Lease vs. Finance',
    HondaLoyaltyBenefits: 'Honda Loyalty Benefits',
    AcuraLoyaltyAdvantage: 'Acura Loyalty Advantage',
    EndofTerm: 'End of Term',
    ProtectionofProducts: 'Protection Products',
    SUPPORT: 'SUPPORT',
    HelpCenter: 'Help Center',
    ContactUs: 'Contact Us',
    PaymentOptions: 'Payment Options',
    PrintableForms: 'Printable Forms',
    OWNERS: 'OWNERS',
    Large: 'Large',
    Medium: 'Medium'

  };*/

  // get checkGuest() {
  //   if(isCheck)
  //   {
  //     console.log('isGuestCheck',isGuestCheck);
  //     this.isGuestCheck = isCheck;
  //     console.log('isGuestCheck',this.isGuestCheck);

  //   }
  //   else
  //   {
  //     this.isGuestCheck = isCheck;
  //   }
  // }
  addClass(evt){
    console.log("in");
  evt.currentTarget.parentElement.classList.add('AHFC_Smenuhover');
    
    
  }
removeClass(evt){
  evt.currentTarget.parentElement.classList.remove('AHFC_Smenuhover');
  console.log("out");

}
  onHamburgerClick() {
    this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    this.isUserProfile = false;
    this.isSubMenuOpenFinance = false;
    this.isSubMenuOpenSupport = false;
    this.isSubMenuOpenAc = false;
  }
  onSubmenuFinanceClick() {
    this.isSubMenuOpenFinance = !this.isSubMenuOpenFinance;

  }
  onSubmenuSupportClick() {
    this.isSubMenuOpenSupport = !this.isSubMenuOpenSupport;

  }
  onSubmenuAccClick() {
    this.isSubMenuOpenAc = !this.isSubMenuOpenAc;

  }
  onUserProfileClick() {
    this.isUserProfile = !this.isUserProfile;
    this.isSubMenuOpenMenu = false;
  }


  connectedCallback() {
    loadStyle(this, ahfctheme + "/theme.css").then(() => {});
    console.log('Form Factor Entry');
    if (FORM_FACTOR == this.labels.LargeLabel) {
      this.showdesktop = true;
      this.showmobile = false;
    } else if (FORM_FACTOR == this.labels.MediumLabel) {
      this.showdesktop = true;
      this.showmobile = true;
    } else {
      this.showdesktop = false;
      this.showmobile = true;
    }
    console.log('Form Factor-->', FORM_FACTOR);
  }
  navigatetoMyPaymentSource() {
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        pageName: 'payment-source'
      }
    });
  }

  navigateToPaymentOptions() {
    this[NavigationMixin.Navigate]({
        type: "comm__namedPage",
        attributes: {
            pageName: 'paymentoptions'
         }
        // state: {
        //     sacRecordId: JSON.parse(this.selServiceAccountWrapper).serAccRec.Id
        // }
    });
}




}