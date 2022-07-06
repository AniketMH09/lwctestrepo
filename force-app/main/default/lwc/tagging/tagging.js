import { LightningElement, track } from 'lwc';

export default class TaggingPoc extends LightningElement {
    @track digitalData;
    connectedCallback(){
        digitalData = {
            "version_dl":"2021.12",
            "property_name":"American Honda Finance",
            "action_type":"Page Load",
            "action_label":"Page Load: Dashboard",
            "action_category":"Page",
            "model_brand":"Honda",
            "content_publish_date":"12/15/2021",
            "Page_page_friendly_url": window.location.href,
            "full_url": window.location.href,            
            "page_name": "Tagging POC",
            "site_section": "",
            "sub_section": "",
            "sub_section2": "Auto Filter 1",
            "sub_section3": "",
            "brand_name": "Honda,Acura",
            "referrer_type": "",
            "referrer_url": document.referrer,
            "environment": "DEV"
        };
    }
    renderedCallback() {
        this.adobetrackerInit();
    }
    adobetrackerInit(){
        
        window.dataLayer = digitalData;
        window._satellite.track('PageLoadReady');
    }
}