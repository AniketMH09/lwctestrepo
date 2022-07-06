import { LightningElement,track } from 'lwc';
import {labels} from "c/aHFC_dashboardConstantsUtil";
import hondacarLogo from "@salesforce/resourceUrl/AHFC_Honda_Car_White_Logo";
import acurawhiteLogo from "@salesforce/resourceUrl/AHFC_ACURA_White_Logo";
import hondabikeLogo from "@salesforce/resourceUrl/AHFC_Honda_Bike_White_Logo";
import hondaPowerEqLogo from "@salesforce/resourceUrl/AHFC_Honda_Power_Equipment_White_Logo";
import hondaMarineLogo from "@salesforce/resourceUrl/AHFC_Honda_Marine_White_Logo";
import hondaJetLogo from "@salesforce/resourceUrl/AHFC_Honda_Jet_White_Logo";
import AHFC_Privacy_Policy_PDF from "@salesforce/resourceUrl/AHFC_Privacy_Policy";
import { NavigationMixin } from "lightning/navigation";
import { fireAdobeEvent } from "c/aHFC_adobeServices";

export default class AHFC_globalSearchFooter extends NavigationMixin(LightningElement) {

	@track privacyPolicyPdfUrl = AHFC_Privacy_Policy_PDF;
    @track labels = labels;

    get hondacarLogoUrl() {
		return hondacarLogo;
	}
    get acurawhiteLogoUrl() {
		return acurawhiteLogo;
	}
    get hondabikeLogoUrl() {
		return hondabikeLogo;
	}
    get hondaPowerEqLogoUrl() {
		return hondaPowerEqLogo;
	}
    get hondaMarineLogoUrl() {
		return hondaMarineLogo;
	}
    get hondaJetLogoUrl() {
		return hondaJetLogo;
	}
    navigateToAboutUs() {		
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName:'about-us-pre-login'
			}
		});
	}
    navigateToTermsAndConditions() {
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName:'legal-terms-and-conditions'
			},
		});
	}
    navigateToDoNotSellPerInfo(){
		let adobedata = {
			'Event_Metadata.action_type': 'footer_links',
			"Event_Metadata.action_label": ":do_not_sell_personal_info",
			"Event_Metadata.action_category": "ccpa",

		};
		fireAdobeEvent(adobedata, 'do_not_sell');
		this[NavigationMixin.Navigate]({
			type: "comm__namedPage",
			attributes: {
				pageName:'submit-ccpa-request'
			},
			state: {
				S:'F',
				T:'DNS'
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