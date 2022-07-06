/*  Component Name       :    aHFC_maintenancePage
    * Description        :    This is LWC for maintenance page 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------

    * Ziya Khan                12/08/2021                 Created 
*/

import { LightningElement } from 'lwc';
import { loadStyle } from "lightning/platformResourceLoader";
import { NavigationMixin } from "lightning/navigation";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import hondaLogo from "@salesforce/resourceUrl/Honda_financial_services_logo";
import hondaLogoMobile from "@salesforce/resourceUrl/Honda_financial_services_mobile_logo";

export default class AHFC_maintenancePage extends NavigationMixin(LightningElement)  {
    get hondaLogoUrl() {
        return hondaLogo;
    }
    get hondaLogoMobileUrl() {
        return hondaLogoMobile;
    }
    connectedCallback(){
        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
    }
}