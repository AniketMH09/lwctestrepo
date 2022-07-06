import {
	LightningElement, track, wire
}
	from 'lwc';
import {
	loadStyle
}
	from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import FORM_FACTOR from "@salesforce/client/formFactor";
import FAQ1 from "@salesforce/resourceUrl/AHFS_Faq1";
import FAQ2 from "@salesforce/resourceUrl/AHFS_Faq2";
import FAQ3 from "@salesforce/resourceUrl/AHFS_Faq3";
import AHFC_FaqHelpPayments from "@salesforce/label/c.Faq_Help_Payments";
import AHFC_FaqHelpAccountManagement from "@salesforce/label/c.Faq_Help_Account_Management";
import AHFC_FaqhelpEndOFTerm from "@salesforce/label/c.Faq_help_End_OF_Term";
import AHFC_FaqHelpViewAllFaq from "@salesforce/label/c.Faq_Help_View_All_Faq";
import AHFC_FaqHelpAccount from "@salesforce/label/c.Faq_Help_Account";
import AHFC_FaqHelpManagement from "@salesforce/label/c.Faq_Help_Management";
import LargeLabel from "@salesforce/label/c.Large";
import MediumLabel from "@salesforce/label/c.Medium";
import AHFC_helpCenter_URL from "@salesforce/label/c.AHFC_helpCenter_URL";
import AHFC_Topic_Id_Account_Management from "@salesforce/label/c.AHFC_Topic_Id_Account_Management";
import AHFC_Topic_Id_End_Of_Lease from "@salesforce/label/c.AHFC_Topic_Id_End_Of_Lease";
import AHFC_Topic_Id_Payment from "@salesforce/label/c.AHFC_Topic_Id_Payment";

import {
	NavigationMixin
}
	from "lightning/navigation";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
export default class aHFC_dashboardfaqhelp extends NavigationMixin(LightningElement) {
	@track showdesktop;
	@track showmobile;
	@track labels = {
		FaqHelpPayments: AHFC_FaqHelpPayments,
		FaqHelpAccountManagement: AHFC_FaqHelpAccountManagement,
		FaqhelpEndOFTerm: AHFC_FaqhelpEndOFTerm,
		FaqHelpViewAllFaq: AHFC_FaqHelpViewAllFaq,
		LargeLabel: LargeLabel,
		MediumLabel: MediumLabel,
		FaqHelpAccount: AHFC_FaqHelpAccount,
		FaqHelpManagement: AHFC_FaqHelpManagement
	}
	get FAQ_Frame1() {
		return FAQ1;
	}
	get FAQ_Frame2() {
		return FAQ2;
	}
	get FAQ_Frame3() {
		return FAQ3;
	}
	connectedCallback() {
		loadStyle(this, ahfctheme + "/theme.css").then(() => { });
		this.showdesktop = true;
		this.showmobile = false;
		if (FORM_FACTOR == this.labels.LargeLabel) {
			this.showdesktop = true;
			this.showmobile = false;
		} else if (FORM_FACTOR == this.labels.MediumLabel) {
			this.showdesktop = true;
			this.showmobile = false;
		} else {
			this.showdesktop = false;
			this.showmobile = true;
		}
		console.log('this.showdesktop',this.showdesktop);
		console.log('this.showmobile',this.showmobile);
	}

	navigateToViewAll() {
		console.log('View All');
		let adobedata = {
			'Event_Metadata.action_type': 'Hyperlink',
			"Event_Metadata.action_label": "Dashboard:Hyperlink:View All FAQS",
			"Event_Metadata.action_category": "FAQs Tile",
			"Page.page_name": "Dashboard",
		};
		fireAdobeEvent(adobedata, 'click-event');
		this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'help-center'
            }
        });
	}
	navigateToAccountManagement() {
		var origin = window.location.origin;

        var URLpart1 = origin+'/s/';
		var urlToNavigate = URLpart1 + AHFC_Topic_Id_Account_Management;
		this[NavigationMixin.Navigate]({
			type: "standard__webPage",
			attributes: {
				url: urlToNavigate
			}
		});
	}
	navigateToPaymentFAQ() {
		var origin = window.location.origin;

        var URLpart1 = origin+'/s/';
		var urlToNavigate = URLpart1 + AHFC_Topic_Id_Payment;
		this[NavigationMixin.Navigate]({
			type: "standard__webPage",
			attributes: {
				url: urlToNavigate
			}
		});
	}
	navigateToEOTFAQ() {
		var origin = window.location.origin;

        var URLpart1 = origin+'/s/';
		var urlToNavigate = URLpart1 + AHFC_Topic_Id_End_Of_Lease;
		this[NavigationMixin.Navigate]({
			type: "standard__webPage",
			attributes: {
				url: urlToNavigate
			}
		});
	}
}