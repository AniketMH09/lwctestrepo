/* Component Name   :    AHFC_helpCenterHeaderMenu
* @Description      :   LWC for Menu Header for pre login page
* Modification Log  :
* --------------------------------------------------------------------------------------------------- 
* Developer                          Date                    Description
* ---------------------------------------------------------------------------------------------------
* Aswin Jose                         May 03 2021             
* Sagar Ghadigaonkar                 Aug 11 2021              using this header component for prelogin
*******************************************************************************************************/
import { api, LightningElement, track, wire } from "lwc";
import hondaLogo from "@salesforce/resourceUrl/Honda_financial_logo";
import NAME_FIELD from '@salesforce/schema/User.Name';
import USER_ID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import userImgUrl from "@salesforce/resourceUrl/AHFC_UserImg";
import acuraLogo from "@salesforce/resourceUrl/AHFC_Acura_Header_Logo";
import { loadStyle } from "lightning/platformResourceLoader";
import FORM_FACTOR from "@salesforce/client/formFactor";
import { labels } from "c/aHFC_dashboardConstantsUtil";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import { NavigationMixin } from "lightning/navigation";
import isguest from '@salesforce/user/isGuest';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { getConstants } from "c/ahfcConstantUtil";
import AHFC_Community_Named_Dashboard from "@salesforce/label/c.AHFC_Community_Named_Dashboard";
import AHFC_helpCenter_URL from "@salesforce/label/c.AHFC_helpCenter_URL";
import AHFC_Customer_URL from "@salesforce/label/c.AHFC_Customer_URL";
import basePath from "@salesforce/community/basePath";
const CONSTANTS = getConstants();
export default class AHFC_helpCenterHeaderMenu extends NavigationMixin(LightningElement) {
    @track payLoadWrapper;
    @track isSubMenuOpenAc = false;
    @track isUserProfile = false;
    @track isSubMenuOpenSupport = false;
    @track isSubMenuOpenFinance = false;
    @track isSubMenuOpenMenu = false;
    @track isSubMenuOpenOwner = false; 
    @track showdesktop;
    @track showmobile;
    @track getAccountInfo;
    @track finAccData;
    @track labels = labels;
    @track isWebAccLocked;
    @track islockedHeaderFooter = false;
    @track isArchived;
    @track isGetAccountInfo = false;
    @track isDisplay = true;
    @track isDoNotDisplay = true;
    isCheck = isguest;
    @track isGuestCheck = false;
    @track IDSAC;
    @track boolEnrolledEZP = false;
    @track showManageEZPButton = false;
    @track showEZPButton = false;
    @track userName;

    @wire(CurrentPageReference) pageRef;

    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        console.log('Guest User : '+this.isCheck);
        
        if (error) {
           console.log('error',error);
        } else if (data) {
            console.log('data',data);
            this.userName = data.fields.Name.value;
        }
    }

    label={
        AHFC_helpCenter_URL
    }
   

    get hondaLogoUrl() {
        return hondaLogo;
    }
    get userImgUrl() {
        return userImgUrl;
    }
    get AcuraLogoUrl() {
        return acuraLogo;
    }
    addClass(evt) {
        evt.currentTarget.parentElement.classList.add('AHFC_Smenuhover');
    }
    removeClass(evt) {
        evt.currentTarget.parentElement.classList.remove('AHFC_Smenuhover');
    }
    onHamburgerClick() {
        console.log('hamburger click')
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
        this.isUserProfile = false;
        this.isSubMenuOpenFinance = false;
        this.isSubMenuOpenSupport = false;
        this.isSubMenuOpenAc = false;
        this.isSubMenuOpenOwner = false; //Added  for US 8745

    }
    onSubmenuFinanceClick() {
        this.isSubMenuOpenFinance = !this.isSubMenuOpenFinance;
    }
    onSubmenuSupportClick() {
        this.isSubMenuOpenSupport = !this.isSubMenuOpenSupport;
    }
    // Added for US 8745
    onSubmenuOwnerClick() {
        this.isSubMenuOpenOwner = !this.isSubMenuOpenOwner;
    }
    onSubmenuAccClick() {
        this.isSubMenuOpenAc = !this.isSubMenuOpenAc;
    }
    onUserProfileClick() {
        this.isUserProfile = !this.isUserProfile;
        this.isSubMenuOpenMenu = false;
    }
    connectedCallback() {

        console.log('user ID *'+USER_ID);

        document.addEventListener("click", (evt) => {
            if (evt.target.dataset.xyz == undefined) {
                this.isUserProfile = false;
                //this.isSubMenuOpenMenu = false;
            }

        });
       
      
        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
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
    }

    
    navigateToPaymentOptions() {

        var urlToNavigate = AHFC_Customer_URL+'paymentoptions-prelogin';
        
        console.log('urlToNavigate As : '+urlToNavigate);
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        }); 
    }
    navigateToPrintableForms() {

        var urlToNavigate = AHFC_Customer_URL+'printable-forms-pre-login';
        
        console.log('urlToNavigate As : '+urlToNavigate);
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        }); 
    }
    navigateToProtectionProducts() {

        var urlToNavigate = AHFC_Customer_URL+'protection-products-pre-login';
        
        console.log('urlToNavigate As : '+urlToNavigate);
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        }); 
    }
    navigateToLeaseVSFinance() {

        var urlToNavigate = AHFC_Customer_URL+'lease-vs-finance-prelogin';
        
        console.log('urlToNavigate As : '+urlToNavigate);
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        }); 
    }
    navigateTohondaLoyaltyBenfits() {

        var urlToNavigate = AHFC_Customer_URL+'honda-loyalty-benefits-pre-login';
        
        console.log('urlToNavigate As : '+urlToNavigate);
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        }); 
    }
    navigateToEndOfTerm() {

        var urlToNavigate = AHFC_Customer_URL+'end-of-lease-pre-login';
        
        console.log('urlToNavigate As : '+urlToNavigate);
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        }); 
    }
    navigateToAcuraLoyalotyPage() {

        var urlToNavigate = AHFC_Customer_URL+'acura-loyalty-advantage-pre-login';
        
        console.log('urlToNavigate As : '+urlToNavigate);
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        }); 
    }

    navigateToCreaditPreApproval() {
        console.log('Credit**');
        var urlToNavigate = AHFC_Customer_URL+'creditpreapproval-prelogin';
        
        console.log('urlToNavigate As : '+urlToNavigate);
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        }); 
    }

    
    navigateToContactUsPage()
    {
        console.log('Credit**');
        var urlToNavigate = AHFC_Customer_URL+'contact-us-pre-login';
        
        console.log('urlToNavigate As : '+urlToNavigate);
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        }); 
    }   

    /*Start  US :10993   navigate to login page*/
    navigateToLoginPage()
    {
          this[NavigationMixin.Navigate]({
              type: "comm__loginPage",
              attributes: {
                  pageName: 'login',
                 actionName: 'login'
              }
              
          });
    }

    get logoutUrl() {
        const sitePrefix = basePath.replace(/\/s$/i, ""); // site prefix is the site base path without the trailing "/s"
        console.log('sitePrefix >>>>>>>>>>>>>>>>>>>>>',sitePrefix);
        return sitePrefix + "/secur/logout.jsp";

    }

    
    /*End  US :10993   navigate to login page*/


}