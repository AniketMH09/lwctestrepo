import { LightningElement, track, wire } from "lwc";
import hondaLogo from "@salesforce/resourceUrl/Honda_financial_logo";
//import { loadStyle } from "lightning/platformResourceLoader";
import FORM_FACTOR from "@salesforce/client/formFactor";
//import { labels } from "c/aHFC_dashboardConstantsUtil";
//import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";


export default class aHFC_MenuItem extends NavigationMixin(LightningElement) {
    get hondaLogoUrl() {
        return hondaLogo;
      }
      @track showdesktop;
  @track showmobile;
  @track labels = {
    MyAccount: 'My Account',
    FINANCETOOLS: 'FINANCE TOOLS',
    ApplyforPreApproval: 'Apply for Pre-Approval',
    LeaseVsFinance: 'Lease vs Finance',
    HondaLoyaltyBenefits: 'Honda Loyalty Benefits',
    AcuraLoyaltyAdvantage: 'Acura Loyalty Advantage',
    EndofTerm: 'End of Term',
    ProtectionofProducts: 'Protection of Products',
    SUPPORT: 'SUPPORT',
    HelpCenter: 'Help Center',
    ContactUs: 'Contact Us',
    PaymentOptions: 'Payment Options',
    PrintableForms: 'Printable Forms',
    OWNERS: 'OWNERS',
    Large:'Large',
    Medium:'Medium'
};

  // connectedCallback() {
  //   //loadStyle(this, ahfctheme + "/theme.css").then(() => {});
  //   console.log('Form Factor Entry');
  //   if (FORM_FACTOR == this.labels.Large) {
  //     this.showdesktop = true;
  //     this.showmobile = false;
  //   } else if (FORM_FACTOR == this.labels.Medium) {
  //     this.showdesktop = true;
  //     this.showmobile = true;
  //   } else {
  //     this.showdesktop = false;
  //     this.showmobile = true;
  //   }
  //   console.log('Form Factor-->',FORM_FACTOR);
  // }
  
}