/* Component Name        :    AHFC_supportcorrespondence
    * Description        :    This is LWC for Correspondence Page. 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aniket                     07/06/2021              Created 
    * Edwin                      24/08/2021              Modified US 5186 add navigation to case list page 
*/
import { LightningElement, track, api } from 'lwc';
import supportrequestlogo from "@salesforce/resourceUrl/AHFC_SypportRequest";
import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import correspondencelogo from "@salesforce/resourceUrl/correspondenceLogo";
import { labels } from "c/aHFC_dashboardConstantsUtil";
import { NavigationMixin } from "lightning/navigation";
import { fireAdobeEvent } from "c/aHFC_adobeServices";


export default class AHFC_supportcorrespondence extends NavigationMixin(LightningElement) {

    @track labels = labels;
    @api supportrequest = false;
    @api correspondence = false;
    @api finaaccdata;

    get supportLogo() {
        return supportrequestlogo;
    }

    get corresponenceLogo() {
        return correspondencelogo;
    }

    connectedCallback() {
        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
    }

    //when dashboard corusal changes
    @api handleValueChange(data) {
        this.finaaccdata = data;
    }

    //Navigates to Corres. Page
    onCorrespondenceClick() {
        console.log('47');

        let findata = JSON.parse(this.finaaccdata);
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Dashboard:Hyperlink:View Correspondence",
            "Event_Metadata.action_category": "Correspondence Tile",
            "Page.page_name": "Dashboard",
            "Page.brand_name": findata.serAccRec.Honda_Brand__c ? findata.serAccRec.Honda_Brand__c : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
        console.log('58');
        sessionStorage.setItem('salesforce_id', findata.serAccRec.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'correspondence'
            }
        });
      

    }

    //Navigates to support request dashboard
    onTrackSupportRequestClick12() {
        let findata = JSON.parse(this.finaaccdata);
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Dashboard:Hyperlink:Track Requests",
            "Event_Metadata.action_category": "Support Requests Tile",
            "Page.page_name": "Dashboard",
            "Page.brand_name": findata.serAccRec.Honda_Brand__c ? findata.serAccRec.Honda_Brand__c : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('salesforce_id', findata.serAccRec.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'supportrequestdashboard'
            },
            state: {

            }
        });

    }
    //Navigates to support request dashboard
    onTrackSupportRequestClick() {
        let findata = JSON.parse(this.finaaccdata);
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Dashboard:Hyperlink:Track Requests",
            "Event_Metadata.action_category": "Support Requests Tile",
            "Page.page_name": "Dashboard",
            "Page.brand_name": findata.serAccRec.Honda_Brand__c ? findata.serAccRec.Honda_Brand__c : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('financeAccId', findata.serAccRec.Id);
        sessionStorage.setItem('salesforce_id', findata.serAccRec.Id)
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Case',
                actionName: 'list'
            },
            state: {

            }
        });
    }
}