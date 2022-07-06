/* Component Name   :    AHFC_helpCenterFooterMenu
* @Description      :   LWC for Menu Footer for blank dashboard
* Modification Log  :
* --------------------------------------------------------------------------- 
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Aswin Jose               	Jul 23 2021                Created
*********************************************************************************/
import {LightningElement, track, wire} from "lwc";
import acurawhiteLogo from "@salesforce/resourceUrl/AHFC_ACURA_White_Logo";
import hondabikeLogo from "@salesforce/resourceUrl/AHFC_Honda_Bike_White_Logo";
import hondacarLogo from "@salesforce/resourceUrl/AHFC_Honda_Car_White_Logo";
import hondaJetLogo from "@salesforce/resourceUrl/AHFC_Honda_Jet_White_Logo";
import hondaMarineLogo from "@salesforce/resourceUrl/AHFC_Honda_Marine_White_Logo";
import hondaPowerEqLogo from "@salesforce/resourceUrl/AHFC_Honda_Power_Equipment_White_Logo";
import isguest from '@salesforce/user/isGuest';
import NAME_FIELD from '@salesforce/schema/User.Name';
import USER_ID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from "lightning/navigation";
import FORM_FACTOR from "@salesforce/client/formFactor";
import {labels} from "c/aHFC_dashboardConstantsUtil";
import {registerListener, unregisterAllListeners} from 'c/pubsub';
import {CurrentPageReference} from 'lightning/navigation';
import {getConstants} from "c/ahfcConstantUtil";
import AHFC_helpCenter_URL from "@salesforce/label/c.AHFC_helpCenter_URL";
import AHFC_Customer_URL from "@salesforce/label/c.AHFC_Customer_URL";
import AHFC_DoNotSell_URL from "@salesforce/label/c.AHFC_DoNotSell_URL";
import AHFC_Privacy_Policy_PDF from "@salesforce/resourceUrl/AHFC_Privacy_Policy";
import { fireAdobeEvent } from "c/aHFC_adobeServices";


const CONSTANTS = getConstants();
export default class AHFC_helpCenterFooterMenu extends NavigationMixin (LightningElement) {
    @track privacyPolicyPdfUrl = AHFC_Privacy_Policy_PDF;
	get acurawhiteLogoUrl() {
		return acurawhiteLogo;
	}
	get hondabikeLogoUrl() {
		return hondabikeLogo;
	}
	get hondacarLogoUrl() {
		return hondacarLogo;
	}
	get hondaJetLogoUrl() {
		return hondaJetLogo;
	}
	get hondaMarineLogoUrl() {
		return hondaMarineLogo;
	}
	get hondaPowerEqLogoUrl() {
		return hondaPowerEqLogo;
	}@
	track showdesktop;@track isSubMenuOpenProdSupport = false;@track isSubMenuOpenDealer = false;@track isSubMenuOpenCalculator = false;@track isSubMenuOpenOffer = false;@track isSubMenuOpenFinance = false;@track isSubMenuOpenSupport = false;@track isSubMenuOpenMyacc = false;@track showmobile;@track labels = labels;
	isCheck = isguest;@track isGuestCheck = false;@track payLoadWrapper;@track getAccountInfo = {};@track finAccData;@track isWebAccLocked;@track islockedHeaderFooter = false;@track isArchived;@track isGetAccountInfo = false;@track isDisplay =true;@track isDoNotDisplay =true;@wire(CurrentPageReference) pageRef;
	@track IDSAC;
	@track userName;
    @track isSubMenuOwner = false;

	label={
        AHFC_helpCenter_URL
    }

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
    onSubmenuOwnerClick() {
		this.isSubMenuOwner = !this.isSubMenuOwner;
	}

	onSubmenuFinanceClick() {
		this.isSubMenuOpenFinance = !this.isSubMenuOpenFinance;
		this.isSubMenuOpenOffer = false;
		this.isSubMenuOpenCalculator = false;
		this.isSubMenuOpenDealer = false;
	}
	onSubmenuSupportClick() {
		this.isSubMenuOpenSupport = !this.isSubMenuOpenSupport;
		this.isSubMenuOpenProdSupport = false;
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
	//	registerListener('financeAccountInfo', this.pubsubfunction, this);
		if(FORM_FACTOR == this.labels.LargeLabel) {
			this.showdesktop = true;
			this.showmobile = false;
		} else if(FORM_FACTOR == this.labels.MediumLabel) {
			this.showdesktop = true;
			this.showmobile = true;
		} else {
			this.showdesktop = false;
			this.showmobile = true;
		}
	}
	navigateToPrintableForms() {
		console.log('Navigate to payment options!!!!!!!');
        console.log('Credit**');
        var urlToNavigate = AHFC_Customer_URL+'printable-forms-pre-login';
        
        console.log('urlToNavigate As : '+urlToNavigate);
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        }); 
	}
	navigateToTermsAndConditions() {
		var urlToNavigate = AHFC_Customer_URL+'legal-terms-and-conditions';
        
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

	navigateToCreaditPreApproval(){
        var urlToNavigate = AHFC_Customer_URL+'creditpreapproval-prelogin';
        
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

	navigateToAddAccount() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'add-a-finance-account'
            },
        });
    }

	navigateToContactUsPage() {
        var urlToNavigate = AHFC_Customer_URL+'contact-us-pre-login';
        
        console.log('urlToNavigate As : '+urlToNavigate);
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        }); 
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


	navigateToAboutUsPage()
	{
		var urlToNavigate = AHFC_Customer_URL+'about-us-pre-login';
        
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
	 /*End  US :10993   navigate to login page*/

     navigateToDoNotSellPerInfo(){
        let adobedata = {
			'Event_Metadata.action_type': 'footer_links',
			"Event_Metadata.action_label": ":do_not_cell_personal_info",
			"Event_Metadata.action_category": "ccpa",

		};
		fireAdobeEvent(adobedata, 'click-event');
        var urlToNavigate= AHFC_Customer_URL+AHFC_DoNotSell_URL;
        console.log('urlToNavigate As : '+urlToNavigate);
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        }); 
        
	}
    privacyPolicyTagging() {
		let adobedata = {
			'Event_Metadata.action_type': 'footer_links',
			"Event_Metadata.action_label": ":privacy_policy",
			"Event_Metadata.action_category": "ccpa",

		};
		fireAdobeEvent(adobedata, 'click-event');
	}
	cookiePolicyTagging() {
		let adobedata = {
			'Event_Metadata.action_type': 'footer_links',
			"Event_Metadata.action_label": ":cookie_policy",
			"Event_Metadata.action_category": "ccpa",

		};
		fireAdobeEvent(adobedata, 'click-event');
	}
 
	 

}