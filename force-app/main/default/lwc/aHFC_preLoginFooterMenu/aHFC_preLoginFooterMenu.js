/* Component Name   :    aHFC_preLoginFooterMenu
* @Description      :   LWC for Menu Footer for pre login pages
* Modification Log  :
* -------------------------------------------------------------------------------------------- 
* Developer                   Date                   Description
* --------------------------------------------------------------------------------------------
* Aswin Jose               	Jul 23 2021                Created
* Sagar Ghadigaonkar        Aug 11 2021              using this footer component for prelogin
***********************************************************************************************/
import { LightningElement, track, wire } from "lwc";
import acurawhiteLogo from "@salesforce/resourceUrl/AHFC_ACURA_White_Logo";
import hondabikeLogo from "@salesforce/resourceUrl/AHFC_Honda_Bike_White_Logo";
import hondacarLogo from "@salesforce/resourceUrl/AHFC_Honda_Car_White_Logo";
import hondaJetLogo from "@salesforce/resourceUrl/AHFC_Honda_Jet_White_Logo";
import hondaMarineLogo from "@salesforce/resourceUrl/AHFC_Honda_Marine_White_Logo";
import hondaPowerEqLogo from "@salesforce/resourceUrl/AHFC_Honda_Power_Equipment_White_Logo";
import isguest from '@salesforce/user/isGuest';
import { NavigationMixin } from "lightning/navigation";
import FORM_FACTOR from "@salesforce/client/formFactor";
import { labels } from "c/aHFC_dashboardConstantsUtil";
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';
import { getConstants } from "c/ahfcConstantUtil";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import AHFC_Privacy_Policy_PDF from "@salesforce/resourceUrl/AHFC_Privacy_Policy";



import AHFC_CIAM_HONDA_APP_ID from "@salesforce/label/c.AHFC_CIAM_HONDA_APP_ID";
import AHFC_CIAM_ACURA_APP_ID from "@salesforce/label/c.AHFC_CIAM_ACURA_APP_ID";
import AHFC_CIAM_HONDA_LOGIN_URL from "@salesforce/label/c.AHFC_CIAM_HONDA_LOGIN_URL";
import AHFC_CIAM_ACURA_LOGIN_URL from "@salesforce/label/c.AHFC_CIAM_ACURA_LOGIN_URL";

import AHFC_helpCenter_URL from "@salesforce/label/c.AHFC_helpCenter_URL";

const CONSTANTS = getConstants();
export default class aHFC_preLoginFooterMenu extends NavigationMixin(LightningElement) {
	@track adobepagename = '';
	@track privacyPolicyPdfUrl = AHFC_Privacy_Policy_PDF;
	@track isSubMenuOwner = false;
	
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
	}

	label = {
		AHFC_helpCenter_URL,
		AHFC_CIAM_HONDA_APP_ID,
		AHFC_CIAM_ACURA_APP_ID,
		AHFC_CIAM_HONDA_LOGIN_URL,
		AHFC_CIAM_ACURA_LOGIN_URL
	}

	@track showdesktop; @track isSubMenuOpenProdSupport = false; @track isSubMenuOpenDealer = false; @track isSubMenuOpenCalculator = false; @track isSubMenuOpenOffer = false; @track isSubMenuOpenFinance = false; @track isSubMenuOpenSupport = false; @track isSubMenuOpenMyacc = false; @track showmobile; @track labels = labels;
	isCheck = isguest; @track isGuestCheck = false; @track payLoadWrapper; @track getAccountInfo = {}; @track finAccData; @track isWebAccLocked; @track islockedHeaderFooter = false; @track isArchived; @track isGetAccountInfo = false; @track isDisplay = true; @track isDoNotDisplay = true; @wire(CurrentPageReference) pageRef;
	@track IDSAC;

	@track hondaLoginUrl;
	@track acuraLoginUrl;

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
		console.log('97',this.isCheck);
		this.adobepagename = this.pageRef.attributes.name;
		if (FORM_FACTOR == this.labels.LargeLabel) {
			this.showdesktop = true;
			this.showmobile = true; //Modified by Prabu for the bug - 22443
		} else if (FORM_FACTOR == this.labels.MediumLabel) {
			this.showdesktop = true;
			this.showmobile = true;
		} else {
			this.showdesktop = false;
			this.showmobile = true;
		}

		this.hondaLoginUrl = AHFC_CIAM_HONDA_LOGIN_URL + 'login/?app=' + AHFC_CIAM_HONDA_APP_ID+ '&RelayState=/s/ciam-login-successfull?Brand=honda';
		this.acuraLoginUrl = AHFC_CIAM_ACURA_LOGIN_URL + 'login/?app=' + AHFC_CIAM_ACURA_APP_ID+ '&RelayState=/s/ciam-login-successfull?Brand=acura';
	}
	navigateToPrintableForms() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Printable Forms",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'printable-forms-pre-login'
			},
			state: {
				sacRecordId: this.IDSAC
			}
		});
	}
	navigateToTermsAndConditions() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Post Legal Terms and Conditions",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'legal-terms-and-conditions'
			},
		});
	}
	navigateToProtectionProducts() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Protection Products",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'protection-products-pre-login'
			}
		});
	}

	navigateToCreaditPreApproval() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Credit Pre-Approval",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'creditpreapproval-prelogin'
			}
		});
	}

	navigateToLeaseVSFinance() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Lease vs Finance",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'lease-vs-finance-prelogin'
			}
		});
	}

	navigateTohondaLoyaltyBenfits() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Loyalty",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'honda-loyalty-benefits-pre-login'
			}
		});
	}
	navigateToEndOfTerm() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:End of Lease",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'end-of-lease-pre-login'
			}
		});
	}
	navigateToAcuraLoyalotyPage() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Acura Loyalty",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'acura-loyalty-advantage-pre-login'
			}
		});
	}

	navigateToAddAccount() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Add a Finance Account",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'add-a-finance-account'
			},
		});
	}

	navigateToContactUsPage() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Customer Service Pre-Login",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'contact-us-pre-login'
			},
		});
	}

	navigateToPaymentOptions() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Payment Options",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		console.log('Navigate to payment options!!!!!!!');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'paymentoptions-prelogin'
			}
		});
	}
	navigateTohelpCenter() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Help Center",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        /*var urlToNavigate = AHFC_helpCenter_URL;
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        });*/
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'help-center'
            }

        });
    }


	navigateToAboutUsPage() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:About Us",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'about-us-pre-login'
			}
		});

	}

	/*Start  US :10993   navigate to login page*/
	navigateToLoginPage() {
		/*  this[NavigationMixin.Navigate]({
			  type: "comm__loginPage",
			  attributes: {
				  pageName: 'login',
				 actionName: 'login'
			  }
			  
		  });*/

		console.log('<<<<<< domainBrand >>>>>> ' + sessionStorage.getItem('domainBrand'));

		var loginUrl;
		if (sessionStorage.getItem('domainBrand') == 'Honda') {
			loginUrl = this.hondaLoginUrl;
		} else if (sessionStorage.getItem('domainBrand') == 'Acura') {
			loginUrl = this.acuraLoginUrl;
		}


		console.log('<<<<<< loginUrl >>>>>> ' + loginUrl);

		window.location.href = loginUrl;
	}


	/*End  US :10993   navigate to login page*/

	navigateToDoNotSellPerInfo() {
		let adobedata = {
			'Event_Metadata.action_type': 'footer_links',
			"Event_Metadata.action_label": ":do_not_sell_personal_info",
			"Event_Metadata.action_category": "ccpa",

		};
		fireAdobeEvent(adobedata, 'do_not_sell');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'submit-ccpa-request'
			},
			state: {
				S: 'F',
				T: 'DNS'
			}
		});

	}
	privacyPolicyTagging() {
		let adobedata = {
			'Event_Metadata.action_type': 'footer_links',
			"Event_Metadata.action_label": ":privacy_policy",
			"Event_Metadata.action_category": "ccpa",

		};
		fireAdobeEvent(adobedata, 'privacy_policy');
	}
	cookiePolicyTagging() {
		let adobedata = {
			'Event_Metadata.action_type': 'footer_links',
			"Event_Metadata.action_label": ":cookie_policy",
			"Event_Metadata.action_category": "ccpa",

		};
		fireAdobeEvent(adobedata, 'cookie_policy');
	}



}