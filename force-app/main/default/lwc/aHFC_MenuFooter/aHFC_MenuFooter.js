/* Component Name   :    aHFC_MenuFooter
* @Description      :   LWC for Menu Footer
* Modification Log  :
* --------------------------------------------------------------------------- 
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Prabu Mohanasundaram               May 03 2021             Created
* Prabu Mohanasundaram               Jul 06 2021             added pusub function to get the finance account data and getAccount info from dashboard
* Aswin Jose						 Aug 02 2021			 Added changes for US :8396
********************************************************************************/
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
import AHFC_Community_Named_Dashboard from "@salesforce/label/c.AHFC_Community_Named_Dashboard";
import AHFC_helpCenter_URL from "@salesforce/label/c.AHFC_helpCenter_URL";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import AHFC_Privacy_Policy_PDF from "@salesforce/resourceUrl/AHFC_Privacy_Policy";
const CONSTANTS = getConstants();
export default class aHFC_MenuFooter extends NavigationMixin(LightningElement) {

	@track privacyPolicyPdfUrl = AHFC_Privacy_Policy_PDF;
	@track adobepagename = '';
	@track isFooterContentPage=true;
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

	@track boolEnrolledEZP = false;
	@track showManageEZPButton = false;
	@track showEZPButton = false;
	@wire(CurrentPageReference) pageRef;
	/*Added for 7239 US - Start*/
	/*
* @Description: added pusub function to get the finance account data and getAccount info from dashboard*/
	pubsubfunction(payload) {

		console.log('inside pub sub event >> ',payload);
		console.log('50 Footer', JSON.parse(payload));

		this.payLoadWrapper = JSON.parse(payload);
		this.getAccountInfo = this.payLoadWrapper.getAccountInfo;
		console.log('this.getAccountInfo ', this.getAccountInfo);
		this.isWebAccLocked = this.payLoadWrapper.finaAccountData.AHFC_Web_Account_Locked__c;
		console.log('this.isWebAccLocked ', this.isWebAccLocked);
		this.isArchived = this.payLoadWrapper.finaAccountData.AHFC_Fl_Archived__c;
		console.log('this.isArchived ', this.isArchived);
		this.boolEnrolledEZP = this.payLoadWrapper.finaAccountData.boolenrolled; //US:8396 Aswin Jose - To check if the finance account is enrolled in EZP
		console.log('Bool Enrol EZP footer:  ', this.boolEnrolledEZP);
		sessionStorage.setItem('salesforce_id_content', this.payLoadWrapper.finaAccountData.Id);

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
	onKeyPressSubmenuOfferClick() {
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
		this.footerContentPageCheck();
		this.adobepagename = this.pageRef.attributes.name;
		registerListener('financeAccountInfo', this.pubsubfunction, this);
		console.log('FORM_FACTOR >>>> ',FORM_FACTOR);
		if (FORM_FACTOR == this.labels.LargeLabel) {			
			this.showdesktop = true;
			this.showmobile = true;// Added by Prabu for the bug - 22443
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
		sessionStorage.setItem('salesforce_id',this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
		sessionStorage.setItem('ContentPageCheck','false');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'printable-forms'
			},
			state: {
				sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content')
			}
		});
		return false;
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
		return false;
	}
	footerContentPageCheck()
    {
        let sessioneddata = sessionStorage.getItem('ContentPageCheck');
        console.log('Session Data for footer--->',sessioneddata);
        if(sessioneddata == 'true')
        {
            this.isFooterContentPage=false;
			this.showEZPButton=false;
        }
        else
        {
            this.isFooterContentPage=true;
			this.showEZPButton=true;
        }
    }
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
	navigateTohondaLoyaltyBenfits() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Loyalty",
			"Event_Metadata.action_category": "Footer Navigation",
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
	navigateToEndOfTerm() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:End of Lease",
			"Event_Metadata.action_category": "Footer Navigation",
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
	navigateToAcuraLoyalotyPage() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Acura Loyalty",
			"Event_Metadata.action_category": "Footer Navigation",
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
	navigateToContactUsPost() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Customer Service Post-Login",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('salesforce_id',this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
        sessionStorage.setItem('ContentPageCheck','false');

		if(sessionStorage.getItem('salesforce_id') == 'null' || sessionStorage.getItem('salesforce_id') == undefined){
			console.log('740');
		 sessionStorage.setItem('ContentPageCheck','false');
		 this[NavigationMixin.Navigate]({
			 type: "comm__namedPage",
			 attributes: {
				 pageName: 'contact-us-pre-login'
			 }
		 });
		 this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
		 return false;
 
		}
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-post-login'
            }
        });
		return false;
    }

	//Added by Aniket - 8/2/2021 for navigation to credit pre approval page
	navigateToCreaditPreApproval() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Credit Pre-Approval",
			"Event_Metadata.action_category": "Footer Navigation",
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
	/*navigating to make-a-apyment page as part of 4531*/
	navigatetopayment() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Make a Payment",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		sessionStorage.setItem('salesforce_id',this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
		console.log('footer payload OTP: ' + this.payLoadWrapper);
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: "make-a-payment"
			},
			state: {
				sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'),
				showOTPDefault: true
			}
		});
	}
	/*navigating to make-a-apyment page as part of 4531*/
	navigateToEasypayByDefault() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Make a Payment",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		sessionStorage.setItem('salesforce_id',this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
		console.log('footer payload EZP: ' + this.payLoadWrapper);
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: "make-a-payment"
			},
			state: {
				sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'),
				showeasypay: true
			}
		});
	}

	navigatetoschedulepayments() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Already Made a Payment",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		sessionStorage.setItem('salesforce_id',this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: "manage-payment"
			},
			state: {
				sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content')
			}
		});
	}
	navigateToCorrespondance() {
		sessionStorage.setItem('salesforce_id',this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:correspondence",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'correspondence'
			},
			state: {
				sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content')
			}
		});
	}
	navigateToDashboard() {
		sessionStorage.setItem('salesforce_id',this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Dashboard",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		sessionStorage.setItem('ContentPageCheck','false');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: AHFC_Community_Named_Dashboard
			}

		});
	}

	navigateToFinanceAccountDetails() {
		console.log('payLoadWrapper id >>>', this.payLoadWrapper);
		sessionStorage.setItem('salesforce_id',this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Finance Account Details",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'finance-account-profile'
			},
			state: {
				sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content')
			}

		});
	}
	navigateToStatements() {
		sessionStorage.setItem('salesforce_id',this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Statements",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'singlestatement'
			},
			state: {
				sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content')
			}

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
		sessionStorage.setItem('ContentPageCheck','false');
		console.log('entering into paymentoptions');
		sessionStorage.setItem('salesforce_id',this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'paymentoptions'
			},
			state: {
                sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content')
			}
		});
		console.log('ending paymentoptions');
		
	}
	navigatetoMyPaymentSource() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Payment Source",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		sessionStorage.setItem('salesforce_id',this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: 'payment-source'
			}
		});

	}
	navigateToCommunicationPage() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Communication Preferences",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		sessionStorage.setItem('salesforce_id',this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName: "communicationpreference"
			}
		});

	}
	navigateToDoNotSellPerInfo() {
		let adobedata = {
			'Event_Metadata.action_type': 'footer_links',
			"Event_Metadata.action_label": ":do_not_sell_personal_info",
			"Event_Metadata.action_category": "ccpa",

		};
		fireAdobeEvent(adobedata, 'do_not_sell');
		sessionStorage.setItem('ContentPageCheck','false');
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

	navigateTohelpCenter() {
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Help Center",
			"Event_Metadata.action_category": "Footer Navigation",
			"Page.page_name": this.adobepagename

		};
		fireAdobeEvent(adobedata, 'click-event');
		sessionStorage.setItem('ContentPageCheck','false');
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