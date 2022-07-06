import { LightningElement, track, wire } from "lwc";
import acurawhiteLogo from "@salesforce/resourceUrl/AHFC_ACURA_White_Logo";
import hondabikeLogo from "@salesforce/resourceUrl/AHFC_Honda_Bike_White_Logo";
import hondacarLogo from "@salesforce/resourceUrl/AHFC_Honda_Car_White_Logo";
import hondaJetLogo from "@salesforce/resourceUrl/AHFC_Honda_Jet_White_Logo";
import hondaMarineLogo from "@salesforce/resourceUrl/AHFC_Honda_Marine_White_Logo";
import hondaPowerEqLogo from "@salesforce/resourceUrl/AHFC_Honda_Power_Equipment_White_Logo";
import isguest from '@salesforce/user/isGuest';


//import { loadStyle } from "lightning/platformResourceLoader";
import FORM_FACTOR from "@salesforce/client/formFactor";
import { labels } from "c/aHFC_dashboardConstantsUtil";
//import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";


export default class aHFC_MenuFooter extends LightningElement {
  get acurawhiteLogoUrl() {
    return acurawhiteLogo;
  }
  get hondabikeLogoUrl(){
    return hondabikeLogo;
  }
  get hondacarLogoUrl(){
    return hondacarLogo;
  }
  get hondaJetLogoUrl(){
    return hondaJetLogo;
  }
  get hondaMarineLogoUrl(){
    return hondaMarineLogo;
  }
  get hondaPowerEqLogoUrl(){
    return hondaPowerEqLogo;
  }
  @track showdesktop;
  @track isSubMenuOpenProdSupport = false;
  @track isSubMenuOpenDealer = false;
  @track isSubMenuOpenCalculator = false;
  @track isSubMenuOpenOffer = false;
  @track isSubMenuOpenFinance = false;
  @track isSubMenuOpenSupport = false;
  @track isSubMenuOpenMyacc = false;
  @track showmobile;
  @track labels=labels;
  
  isCheck =isguest;
  @track isGuestCheck =false;
  
  /*@track labels = {
  MyAccount: 'My Account',
  FINANCETOOLS: 'FINANCE TOOLS',
  ApplyforPreApproval: 'Apply for Pre-Approval',
  LeaseVsFinance: 'Lease vs. Finance',
  HondaLoyaltyBenefits: 'Honda Loyalty Benefits',
  AcuraLoyaltyAdvantage: 'Acura Loyalty Program',
  EndofTerm: 'End of Term',
  ProtectionofProducts: 'Protection Products',
  SUPPORT: 'SUPPORT',
  HelpCenter: 'Help Center',
  ContactUs: 'Contact Us',
  PaymentOptions: 'Payment Options',
  PrintableForms: 'Printable Forms',
  OWNERS: 'OWNERS',
  Large:'Large',
  Medium:'Medium'
  
  };*/
  
  onSubmenuFinanceClick() {
  this.isSubMenuOpenFinance = !this.isSubMenuOpenFinance;
  console.log('Entry Success');
  }
  
  onSubmenuSupportClick() {
  this.isSubMenuOpenSupport = !this.isSubMenuOpenSupport;
  console.log('Entry Success');
  }
  onSubmenuMyaccClick() {
  this.isSubMenuOpenMyacc = !this.isSubMenuOpenMyacc;
  }
  
  onSubmenuOfferClick() {
  this.isSubMenuOpenOffer = !this.isSubMenuOpenOffer;
  }
  onSubmenuCalcClick() {
  this.isSubMenuOpenCalculator = !this.isSubMenuOpenCalculator;
  }
  onSubmenuDealClick() {
  this.isSubMenuOpenDealer = !this.isSubMenuOpenDealer;
  }
  
  
  onSubmenuProdSupClick() {
    this.isSubMenuOpenProdSupport = !this.isSubMenuOpenProdSupport;
    } 
  
  
  connectedCallback() {
  //loadStyle(this, ahfctheme + "/theme.css").then(() => {});
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
  console.log('Form Factor-->',FORM_FACTOR);
  }
  
  
  }