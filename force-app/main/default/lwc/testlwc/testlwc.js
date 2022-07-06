import { LightningElement, track } from 'lwc';
import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import ahfc_preloginAcuraBanner1Desktop from "@salesforce/resourceUrl/ahfc_preloginAcuraBanner1Desktop";
import ahfc_preloginAcuraBanner1Mobile from "@salesforce/resourceUrl/ahfc_preloginAcuraBanner1Mobile";
import ahfc_preloginWaiver1 from "@salesforce/resourceUrl/ahfc_preloginWaiver1";
import ahfc_preloginWaiver2 from "@salesforce/resourceUrl/ahfc_preloginWaiver2";
import ahfc_preloginWaiver3 from "@salesforce/resourceUrl/ahfc_preloginWaiver3";
import ahfc_preloginAcuraMiddleImageDesktop from "@salesforce/resourceUrl/ahfc_preloginAcuraMiddleImageDesktop";
import ahfc_preloginMiddleAcuraImageMobile from "@salesforce/resourceUrl/ahfc_preloginMiddleAcuraImageMobile";
import ahfc_acuraProtectionProductsDesktop from "@salesforce/resourceUrl/ahfc_acuraProtectionProductsDesktop";
import ahfc_acuraProtectionProductsMobile from "@salesforce/resourceUrl/ahfc_acuraProtectionProductsMobile";
import ahfc_acuraSpecialOffers from "@salesforce/resourceUrl/ahfc_acuraSpecialOffers";
import globalAlertMessage from "@salesforce/apex/AHFC_globalAlert.globalAlertMessage";

// import ahfc_acuraSpecialOffersMobile from "@salesforce/resourceUrl/ahfc_acuraSpecialOffersMobile";

import ahfc_hondaPowerEquipmentDesktop from "@salesforce/resourceUrl/ahfc_hondaPowerEquipmentDesktop";
import ahfc_hondaMarineDesktop from "@salesforce/resourceUrl/ahfc_hondaMarineDesktop";

import ahfc_protectionProductsMobile from "@salesforce/resourceUrl/ahfc_protectionProductsMobile";
// import ahfc_hondaSpecialOffersMobile from "@salesforce/resourceUrl/ahfc_hondaSpecialOffersMobile";
import ahfc_hondaPowerSportsMobile from "@salesforce/resourceUrl/ahfc_hondaPowerSportsMobile";
import ahfc_hondaPowerEquipmentMobile from "@salesforce/resourceUrl/ahfc_hondaPowerEquipmentMobile";
import ahfc_hondaMarineMobile from "@salesforce/resourceUrl/ahfc_hondaMarineMobile";
import { NavigationMixin } from "lightning/navigation";

export default class AHFC_preLoginAcura extends NavigationMixin(LightningElement) {
    /* US 2320 -- Added by Narain */
    @track globalAlertFlag = false;
    @track alertMessageArray = [];
    @track alertMessage;
    @track alertMessageArrayMain = [];
    @track domainBrand = 'Acura';

    get Banner1AcuraDesktop() {
        return ahfc_preloginAcuraBanner1Desktop;
    }
    get Banner1AcuraMobile() {
        return ahfc_preloginAcuraBanner1Mobile;
    }
    get preloginWaiver1LogoUrl() {
        return ahfc_preloginWaiver1;
    }
    get preloginWaiver2LogoUrl() {
        return ahfc_preloginWaiver2;
    }
    get preloginWaiver3LogoUrl() {
        return ahfc_preloginWaiver3;
    }
    get middleImageDesktop() {
        return ahfc_preloginAcuraMiddleImageDesktop;
    }
    get middleImageMobile() {
        return ahfc_preloginMiddleAcuraImageMobile;
    }
    get protectionProductsLogoUrl() {
        return ahfc_acuraProtectionProductsDesktop;
    }
    get protectionProductsMobileLogoUrl() {
        return ahfc_acuraProtectionProductsMobile;
    }
    get acuraSpecialOffersLogoUrl() {
        return ahfc_acuraSpecialOffers;
    }


    @track isFirst_Offers = true;
    @track isSecond_Offers = false;

    @track accObj = [{
            keyNo: "1",
            indicatorId: "1",
            indicatorClass: "slds-carousel__indicator-action  ahfc_corouselButton slds-is-active ahfc_isActive",
            ariaSelected: false,
            panelId: "1",
            name: "first"
        },
        {
            keyNo: "2",
            indicatorId: "2",
            indicatorClass: "slds-carousel__indicator-action ahfc_corouselButton",
            ariaSelected: false,
            panelId: "2",
            name: "second"
        },
        {
            keyNo: "3",
            indicatorId: "3",
            indicatorClass: "slds-carousel__indicator-action ahfc_corouselButton",
            ariaSelected: false,
            panelId: "3",
            name: "third"
        }
    ]
    @track accObj1 = [{
            keyNo: "1",
            indicatorId: "1",
            indicatorClass: "slds-carousel__indicator-action  ahfc_corouselButton slds-is-active ahfc_isActive",
            ariaSelected: false,
            panelId: "1",
            name: "first"
        },
        {
            keyNo: "2",
            indicatorId: "2",
            indicatorClass: "slds-carousel__indicator-action ahfc_corouselButton",
            ariaSelected: false,
            panelId: "2",
            name: "second"
        }
    ]

    connectedCallback() {
        this.globalAlert();

        loadStyle(this, ahfctheme + "/theme.css").then(() => {});

        // set domain brand in session storage --- added by sagar 

        sessionStorage.setItem('domainBrand', this.domainBrand);


    }

    //US 2320 Start Added by Narain
    globalAlert() {
        globalAlertMessage({}).then(result => {
            let data = result;
            let isErrorOccured = data['isErrorOccured'];

            if (isErrorOccured === true) {
                console.log('error');
            } else {
                this.globalAlertFlag = true;
                this.alertMessageArray = result;
                let alertName;
                if (data.length != 0) {
                    for (let i = 0; i < data.length; i++) {
                        let currTmpDocItem = {};
                        this.alertMessage = result[i].Alert_Message__c;
                        currTmpDocItem.Alert_Message__c = this.alertMessage;
                        currTmpDocItem.Name = alertName;
                        this.alertMessageArrayMain.push(currTmpDocItem);

                    }
                }
            }

        }).catch(error => {
            // Showing errors if any while inserting the files
            console.log('inside catch ', error);

        });

    }

    // US 2320 end Added by Narain
    // bottom offers carousal
    onOffersCarousalIndicatorClick(event) {
        console.log(event.target.dataset.indicator, 'indicator');
        if (event.target.dataset.indicator == 1) {
            this.isFirst_Offers = true;
            this.isSecond_Offers = false;
            this.isThird_Offers = false;
            this.isFourth_Offers = false;
            this.isFifth_Offers = false;
            this.accObj1[0].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
            this.accObj1[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[2].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[3].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[4].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
        } else {
            this.isFirst_Offers = false;
            this.isSecond_Offers = true;
            this.isThird_Offers = false;
            this.isFourth_Offers = false;
            this.isFifth_Offers = false;
            this.accObj1[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[1].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
            this.accObj1[2].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[3].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[4].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
        }

    }

    //navigate to credit preapproval page
    onPreApprovalClick() {
        // console.log('hi');

        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'creditpreapproval-prelogin'
            }
        });
    }

    //navigate to lease vs finance page
    onLeaseVsFinanceClick() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'lease-vs-finance-prelogin'
            }
        });
    }

    //navigate to end of lease page
    onEndOfLeaseClick() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'end-of-lease-pre-login'
            }
        });
    }

    //navigate to Acura Loyalty Benefits page
    onHondaLoyaltyBenefitsClick() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'acura-loyalty-advantage-pre-login'
            }
        });
    }

    //navigate to Protection Products page
    onProtectionProductsClick() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'protection-products-pre-login'
            }
        });
    }




}