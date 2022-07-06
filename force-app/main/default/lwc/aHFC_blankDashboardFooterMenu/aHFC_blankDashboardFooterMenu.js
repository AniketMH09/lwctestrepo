/* Component Name   :    aHFC_blankDashboardFooterMenu
* @Description      :   LWC for Menu Footer for blank dashboard
* Modification Log  :
* --------------------------------------------------------------------------- 
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Aswin Jose               	Jul 23 2021                Created
*********************************************************************************/
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


const CONSTANTS = getConstants();
export default class AHFC_blankDashboardFooterMenu extends NavigationMixin(LightningElement) {
	@track privacyPolicyPdfUrl = AHFC_Privacy_Policy_PDF;
	@track adobepagename = '';
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
	} @
		track showdesktop; @track isSubMenuOpenProdSupport = false; @track isSubMenuOpenDealer = false; @track isSubMenuOpenCalculator = false; @track isSubMenuOpenOffer = false; @track isSubMenuOpenFinance = false; @track isSubMenuOpenSupport = false; @track isSubMenuOpenMyacc = false; @track showmobile; @track labels = labels;
	isCheck = isguest; @track isGuestCheck = false; @track payLoadWrapper; @track getAccountInfo = {}; @track finAccData; @track isWebAccLocked; @track islockedHeaderFooter = false; @track isArchived; @track isGetAccountInfo = false; @track isDisplay = true; @track isDoNotDisplay = true; @wire(CurrentPageReference) pageRef;
	@track IDSAC;
	
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
		this.adobepagename = this.pageRef.attributes.name;
		registerListener('financeAccountInfo', this.pubsubfunction, this);
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
	}
	navigateToPrintableForms() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Printable Forms",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		sessionStorage.setItem('ContentPageCheck','false');
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
	navigateToTermsAndConditions() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Post Legal Terms and Conditions",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		sessionStorage.setItem('ContentPageCheck','false');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'post-legal-terms-and-conditions'
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
		sessionStorage.setItem('ContentPageCheck','true');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'protection-products'
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
		sessionStorage.setItem('ContentPageCheck','true');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'lease-vs-finance'
			}
		});
	}

	navigateToAddAccount() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Add a Account",
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

	navigateTohelpCenter() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Help Center",
            "Event_Metadata.action_category": "Footer Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
		sessionStorage.setItem('ContentPageCheck','false');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'help-center'
            }

        });
    }
	navigateToCreaditPreApproval() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Credit Pre-Approval",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','true');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'creditpreapproval'
            }
        });
    }
    navigateTohondaLoyaltyBenfits() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Loyalty",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','true');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'honda-loyalty-benefits'
            }
        });
    }
    navigateToAcuraLoyalotyPage() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Acura Loyalty",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','true');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'acura-loyalty-advantage'
            }
        });
    }
    navigateToEndOfTerm() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:End of Lease",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','true');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'end-of-lease'
            }
        });
    }
    navigateToContactUsPost() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Customer Service pre-Login",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','false');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-pre-login'
            }
        });
    }
	navigateToPaymentOptions() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Payment Options",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','true');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'paymentoptions'
            }
        });
    }
/** START - Added by Prabu for the bug - 22280 */
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
/** END - Added by Prabu for the bug - 22280 */

/** START - Added by sagar for the bug - 22726*/
navigateToAboutUs() {
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
			pageName: 'about-us'
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

/** ENd - Added by sagar for the bug - 22726*/
}