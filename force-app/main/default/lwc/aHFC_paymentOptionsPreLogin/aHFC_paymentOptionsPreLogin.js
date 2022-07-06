/* Component Name   :    AHFC_paymentOptionsPreLogin
* @Description      :    Web Component for Pre-Login Payment Page
* Modification Log  :
* --------------------------------------------------------------------------------------------------- 
* Developer                          Date                    Description
* ---------------------------------------------------------------------------------------------------
* Akash Solanki                      25-Aug-2021             US-6035 - Pre Login Payment Page      
 

*******************************************************************************************************/
import { LightningElement, track } from 'lwc';
import { loadStyle } from "lightning/platformResourceLoader";
import { NavigationMixin } from "lightning/navigation";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import AHFC_CIAM_URL_HONDA from "@salesforce/label/c.AHFC_CIAM_HONDA_LOGIN_URL";
import AHFC_CIAM_URL_ACURA from "@salesforce/label/c.AHFC_CIAM_ACURA_LOGIN_URL";
import AHFC_MONEY_GRAM_URL from "@salesforce/label/c.AHFC_MONEY_GRAM_URL";
import AHFC_ACI_PAY_ONLINE from "@salesforce/label/c.AHFC_ACI_PAY_ONLINE";
import AHFC_WESTERN_UN_URL from "@salesforce/label/c.AHFC_WESTERN_UN_URL";
import AHFC_CIAM_HONDA_APP_ID from "@salesforce/label/c.AHFC_CIAM_HONDA_APP_ID";
import AHFC_CIAM_ACURA_APP_ID from "@salesforce/label/c.AHFC_CIAM_ACURA_APP_ID";
import { fireAdobeEvent } from "c/aHFC_adobeServices";


export default class AHFC_paymentOptionsPreLogin extends NavigationMixin(LightningElement) {
    @track honda_ciam_Url;
    @track acura_ciam_Url;
    @track moneyGram_URL;
    @track aci_Pay_URL;
    @track westrn_Un_URL;
    @track finalURL = '';
    @track domainBrand = '';
    @track domainVal = '';
    @track isDomainHonda = false;
    @track isAcuraDomain = false;



    connectedCallback() {
        let adobedata = {
            "Page.page_name": "Payment Option",
            "Page.site_section": "Payment Option",
            "Page.referrer_url": document.referrer,
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
      //  this.hondaLoginUrl = AHFC_CIAM_HONDA_LOGIN_URL +'login/?app='+ AHFC_CIAM_HONDA_APP_ID;
      //  this.acuraLoginUrl = AHFC_CIAM_ACURA_LOGIN_URL +'login/?app='+ AHFC_CIAM_ACURA_APP_ID;
        this.honda_ciam_Url = AHFC_CIAM_URL_HONDA +'login/?app='+ AHFC_CIAM_HONDA_APP_ID+ '&RelayState=/s/ciam-login-successfull?Brand=honda';
        this.moneyGram_URL = AHFC_MONEY_GRAM_URL;
        this.aci_Pay_URL = AHFC_ACI_PAY_ONLINE;
        this.westrn_Un_URL = AHFC_WESTERN_UN_URL;
        this.acura_ciam_Url = AHFC_CIAM_URL_ACURA +'login/?app='+ AHFC_CIAM_ACURA_APP_ID+ '&RelayState=/s/ciam-login-successfull?Brand=acura';
        this.domainBrand = sessionStorage.getItem('domainBrand');

        if (this.domainBrand !== undefined || this.domainBrand !== null || this.domainBrand !== '') {
            if (this.domainBrand == 'Honda') {
                this.finalURL = this.honda_ciam_Url;
                this.domainVal = 'HONDAFINANCE, CA';
                this.isDomainHonda = true;
                this.isAcuraDomain = false;
            }
            if (this.domainBrand == 'Acura') {
                this.finalURL = this.acura_ciam_Url;
                this.domainVal = 'ACURAFINANCE, CA';
                this.isDomainHonda = false;
                this.isAcuraDomain = true;
            }
        } else {
            let url = window.location.href;
            if (url.includes('honda')) {
                this.finalURL = this.honda_ciam_Url;
                this.domainVal = 'HONDAFINANCE, CA';
                this.isDomainHonda = true;
                this.isAcuraDomain = false;
            }
            if (url.includes('acura')) {
                this.finalURL = this.acura_ciam_Url;
                this.domainVal = 'ACURAFINANCE, CA';
                this.isDomainHonda = false;
                this.isAcuraDomain = true;
            }
        }

        loadStyle(this, ahfctheme + "/theme.css").then(() => {});

    }

    navigateBackToDashboard() {
        window.history.back();
        return false;
    }

    navigateToContactUS() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-pre-login'
            }
        });
    }
}