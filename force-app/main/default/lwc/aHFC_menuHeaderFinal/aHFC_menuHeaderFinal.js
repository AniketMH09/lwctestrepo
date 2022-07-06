/* Component Name   :    aHFC_Menu
* @Description      :   LWC for Menu Header
* Modification Log  :
* --------------------------------------------------------------------------- 
* Developer                          Date                    Description
* ---------------------------------------------------------------------------
* Prabu Mohanasundaram               May 03 2021             Created
* Prabu Mohanasundaram               Jul 06 2021             added pusub function to get the finance account data and getAccount info from dashboard
* Shristi Agarwal                    July 30 2021            modified for US: 8745
* Aswin Jose                         Aug 02 2021             Added changes for US :8396
********************************************************************************/
import { api, LightningElement, track, wire } from "lwc";
import hondaLogo from "@salesforce/resourceUrl/Honda_financial_logo";
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

import basePath from "@salesforce/community/basePath";
import AHFC_Community_Named_Dashboard from "@salesforce/label/c.AHFC_Community_Named_Dashboard";
import ahfc_hondaMobileLogo from "@salesforce/resourceUrl/ahfc_hondaMobileLogo";

const CONSTANTS = getConstants();
export default class aHFC_Menu extends NavigationMixin(LightningElement) {
    @track payLoadWrapper;
    @track isSubMenuOpenAc = false;
    @track isUserProfile = false;
    @track isSubMenuOpenSupport = false;
    @track isSubMenuOpenFinance = false;
    @track isSubMenuOpenMenu = false;
    @track isSubMenuOpenOwner = false; //Added for US 8745
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

    @wire(CurrentPageReference) pageRef;
    get hondaMobileLogoUrl() {
        return ahfc_hondaMobileLogo;
    }
    /*Added for 7239 US - Start*/
    /*
* @Description: added pusub function to get the finance account data and getAccount info from dashboard*/
    pubsubfunction(payload) {
        console.log('50', JSON.parse(payload));

        this.payLoadWrapper = JSON.parse(payload);
        this.getAccountInfo = this.payLoadWrapper.getAccountInfo;
        console.log('this.getAccountInfo ', this.getAccountInfo);
        this.isWebAccLocked = this.payLoadWrapper.finaAccountData.AHFC_Web_Account_Locked__c;
        console.log('this.isWebAccLocked ', this.isWebAccLocked);
        console.log('this.isWebAccLocked ', this.payLoadWrapper.finaAccountData);

        this.isArchived = this.payLoadWrapper.finaAccountData.AHFC_Fl_Archived__c;
        console.log('this.isArchived ', this.isArchived);
        this.boolEnrolledEZP = this.payLoadWrapper.finaAccountData.boolenrolled; //US:8396 Aswin Jose - To check if the finance account is enrolled in EZP
        console.log('Bool Enrol EZP :  ', this.boolEnrolledEZP);

        //	this.IDSAC = this.payLoadWrapper.finaAccountData.serAccRec.Id;
        if (this.getAccountInfo.isWebsiteRestricted == true) {
            console.log('111');
            this.isDisplay = true;
            this.isDoNotDisplay = false;
            this.showManageEZPButton = false;
            this.showEZPButton = false;

        } else if (this.isWebAccLocked === 'Y') {
            console.log('222');
            this.isDisplay = true;
            this.isDoNotDisplay = false;
            this.showManageEZPButton = false;
            this.showEZPButton = false;

        } else if (this.isArchived === 'Y') {
            console.log('9999');
            this.isDisplay = true;
            this.isDoNotDisplay = false;
            this.showManageEZPButton = false;
            this.showEZPButton = false;
        }
        else {
            console.log('444');
            this.isDisplay = true;
            this.isDoNotDisplay = true;
        }


        console.log('DONOT DISPLAY : ' + this.isDoNotDisplay);
        console.log('EZP : ' + this.boolEnrolledEZP);
        //US:8396 start-  Aswin Jose 
        if (this.isDoNotDisplay == true && this.boolEnrolledEZP) {
            this.showManageEZPButton = true; //When Boolean EZP enrolled is true
            this.showEZPButton = false;
        }
        if (this.isDoNotDisplay == true && !this.boolEnrolledEZP) {
            this.showEZPButton = true; //When Boolean EZP enrolled is false
            this.showManageEZPButton = false;
        }
        //US:8396 End-  Aswin Jose 

    }
    /*Added for 7239 US - End*/

    /*navigating to make-a-apyment page as part of 4531*/



    navigateTomakeotp() {
        sessionStorage.setItem('salesforce_id', this.payLoadWrapper.finaAccountData.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },
            state: {
                showOTPDefault: true
            }
        });
    }

    navigatetopayment() {
        sessionStorage.setItem('salesforce_id', this.payLoadWrapper.finaAccountData.Id);
        console.log('salesforce_id >>>> ', this.payLoadWrapper.finaAccountData.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },
            state: {
                showOTPDefault: true
            }
        });
    }
    /*navigating to make-a-apyment page as part of 4531*/
    navigateToEasypayByDefault() {
        sessionStorage.setItem('salesforce_id', this.payLoadWrapper.finaAccountData.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },
            state: {
                showeasypay: true
            }
        });
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
        evt.preventDefault();
        
        evt.currentTarget.parentElement.classList.add('AHFC_Smenuhover ');
        
    }

    addClass1(evt) {
        console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        evt.preventDefault();
        evt.currentTarget.classList.add('AHFC_Smenuhover');
        evt.currentTarget.classList.add('submenuDisplay');
        evt.currentTarget.classList.add("hover");
        /*
        console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        let liCom = document.queryselector('.subMenu1');
        console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> liCom',liCom);
        liCom.classList.add('submenuDisplay') ;
        console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>',liCom);*/
       // this.template.querySelectorAll('.subMenu');
        //display: none;
        
    }

    removeClass(evt) {
        evt.currentTarget.parentElement.classList.remove('AHFC_Smenuhover');
    }
    onHamburgerClick() {
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
    get logoutUrl() {
        const sitePrefix = basePath.replace(/\/s$/i, ""); // site prefix is the site base path without the trailing "/s"
        console.log('sitePrefix >>>>>>>>>>>>>>>>>>>>>',sitePrefix);
        return sitePrefix + "/secur/logout.jsp";

    }

    connectedCallback() {

        document.addEventListener("click", (evt) => {
            if (evt.target.dataset.xyz == undefined) {
                this.isUserProfile = false;
                this.isSubMenuOpenMenu = false;
            }

        });


 /*       var menuItems = this.template.querySelectorAll('.subMenu');
        console.log('1232132>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>',menuItems);
Array.prototype.forEach.call(menuItems, function(el, i){
	el.querySelector('a').addEventListener("keyup",  function(evt){
        console.log('1232132>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
		if (this.parentNode.className == "subMenu") {
			this.parentNode.className = "subMenu open";
			this.setAttribute('aria-expanded', "true");
		} else {
			this.parentNode.className = "subMenu";
			this.setAttribute('aria-expanded', "false");
		}
		evt.preventDefault();
		return false;
	});
});*/
        registerListener('financeAccountInfo', this.pubsubfunction, this);

        //	registerListener('BlankDashboardShow', this.pubsubBlankDashboardfn, this);
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
    navigatetoMyPaymentSource() {
        sessionStorage.setItem('salesforce_id', this.payLoadWrapper.finaAccountData.Id);
        console.log('salesforce Id >>>> ', this.payLoadWrapper.finaAccountData.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'payment-source'
            },
            state: {
                sacRecordId: this.payLoadWrapper.finaAccountData.Id
            }
        });

    }

    navigateToContactUsPost() {
        sessionStorage.setItem('salesforce_id', this.payLoadWrapper.finaAccountData.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-post-login'
            }
        });
    }
    navigateToPaymentOptions() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'paymentoptions'
            },
            state: {
                sacRecordId: this.payLoadWrapper.finaAccountData.Id
            }
        });
    }
    navigateToPrintableForms() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'printable-forms'
            },
            state: {
                sacRecordId: this.IDSAC
            }
        });
    }
    navigateToProtectionProducts() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'protection-products'
            }
        });
    }
    navigateToLeaseVSFinance() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'lease-vs-finance'
            }
        });
    }
    navigateTohondaLoyaltyBenfits() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'honda-loyalty-benefits'
            }
        });
    }
    navigateToEndOfTerm() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'end-of-lease'
            }
        });
    }
    navigateToAcuraLoyalotyPage() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'acura-loyalty-advantage'
            }
        });
    }

    //Added by Aniket - 8/2/2021 for navigation to credit pre approval page
    navigateToCreaditPreApproval() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'creditpreapproval'
            }
        });
    }



    navigateToCommunicationPage() {
        sessionStorage.setItem('salesforce_id', this.payLoadWrapper.finaAccountData.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "communicationpreference"
            }
        });

    }

    navigatetoschedulepayments() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "manage-payment"
            },
            state: {
                sacRecordId: this.payLoadWrapper.finaAccountData.Id
            }
        });
    }
    navigateToCorrespondance() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'correspondence'
            },
            state: {
                sacRecordId: this.payLoadWrapper.finaAccountData.Id
            }
        });
    }
    navigateToDashboard() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: AHFC_Community_Named_Dashboard
            }

        });
    }

    navigateToFinanceAccountDetails() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'finance-account-profile'
            },
            state: {
                sacRecordId: this.payLoadWrapper.finaAccountData.Id
            }

        });
    }
    navigateToStatements() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'singlestatement'
            },
            state: {
                sacRecordId: this.payLoadWrapper.finaAccountData.Id
            }

        });
    }

}