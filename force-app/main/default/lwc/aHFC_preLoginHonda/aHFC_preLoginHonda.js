import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { fireEvent } from 'c/pubsub'
import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import ahfc_preloginHondaBanner1Desktop from "@salesforce/resourceUrl/ahfc_preloginHondaBanner1Desktop";
import ahfc_preloginHondaBanner2Desktop from "@salesforce/resourceUrl/ahfc_preloginHondaBanner2Desktop";
import ahfc_preloginHondaBanner3Desktop from "@salesforce/resourceUrl/ahfc_preloginHondaBanner3Desktop";
import ahfc_preloginHondaBanner1Mobile from "@salesforce/resourceUrl/ahfc_preloginHondaBanner1Mobile";
import ahfc_preloginHondaBanner2Mobile from "@salesforce/resourceUrl/ahfc_preloginHondaBanner2Mobile";
import ahfc_preloginHondaBanner3Mobile from "@salesforce/resourceUrl/ahfc_preloginHondaBanner3Mobile";
import ahfc_preloginWaiver1 from "@salesforce/resourceUrl/ahfc_preloginWaiver1";
import ahfc_preloginWaiver2 from "@salesforce/resourceUrl/ahfc_preloginWaiver2";
import ahfc_preloginWaiver3 from "@salesforce/resourceUrl/ahfc_preloginWaiver3";
import ahfc_preloginMiddleImageDesktop from "@salesforce/resourceUrl/ahfc_preloginMiddleImageDesktop";
import ahfc_preloginMiddleImageMobile from "@salesforce/resourceUrl/ahfc_preloginMiddleImageMobile";
import ahfc_protectionProductsDesktop from "@salesforce/resourceUrl/ahfc_protectionProductsDesktop";
// import ahfc_hondaSpecialOffers from "@salesforce/resourceUrl/ahfc_hondaSpecialOffers";
import ahfc_hondaSpecialOffers from "@salesforce/resourceUrl/ahfc_hondaSpecialOffersImage1";
import ahfc_hondaPowerSportsDesktop from "@salesforce/resourceUrl/ahfc_hondaPowerSportsDesktop";
import ahfc_hondaPowerEquipmentDesktop from "@salesforce/resourceUrl/ahfc_hondaPowerEquipmentDesktop";
import ahfc_hondaMarineDesktop from "@salesforce/resourceUrl/ahfc_hondaMarineDesktop";
import globalAlertMessage from "@salesforce/apex/AHFC_globalAlert.globalAlertMessage";

import ahfc_protectionProductsMobile from "@salesforce/resourceUrl/ahfc_protectionProductsImage1";
// import ahfc_hondaSpecialOffersMobile from "@salesforce/resourceUrl/ahfc_hondaSpecialOffersMobile";
// import ahfc_hondaPowerSportsMobile from "@salesforce/resourceUrl/ahfc_hondaPowerSportsMobile";
import ahfc_hondaPowerSportsMobile from "@salesforce/resourceUrl/ahfc_hondaPowerSportsImage1";
// import ahfc_hondaPowerEquipmentMobile from "@salesforce/resourceUrl/ahfc_hondaPowerEquipmentMobile";
import ahfc_hondaPowerEquipmentMobile from "@salesforce/resourceUrl/ahfc_hondaPowerEquipmentImage1";
// import ahfc_hondaMarineMobile from "@salesforce/resourceUrl/ahfc_hondaMarineMobile";
import ahfc_hondaMarineMobile from "@salesforce/resourceUrl/ahfc_hondaMarineImage1";
import { NavigationMixin } from "lightning/navigation";
import { fireAdobeEvent } from "c/aHFC_adobeServices";

import AHFC_CIAM_HONDA_APP_ID from "@salesforce/label/c.AHFC_CIAM_HONDA_APP_ID";
import AHFC_CIAM_HONDA_LOGIN_URL from "@salesforce/label/c.AHFC_CIAM_HONDA_LOGIN_URL";
import AHFC_CIAM_URL from "@salesforce/label/c.AHFC_CIAM_URL";


export default class AHFC_preLoginHonda extends NavigationMixin(LightningElement) {


    /* US 2320 -- Added by Narain */
    @track globalAlertFlag = false;
    @track alertMessageArray = [];
    @track alertMessage;
    @track alertMessageArrayMain = [];

    @track domainBrand = 'Honda';

    // Swipe functionality start (Jordan)
    @track swipeStart;
    @track swipeEnd;

    touchStart(event) {
        this.swipeStart = event.touches[0].clientX;
    }

    @wire(CurrentPageReference) pageRef;
    //Added by Prabu for the ADA US - 9142 - Prelogin
    renderedCallback() {
        let firstClass = this.template.querySelector(".main-content");
        fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
    }

    touchEndTopCarousel(event) {
        this.swipeEnd = event.changedTouches[0].clientX;
        if (this.swipeStart > this.swipeEnd) {
            if (this.isFirst) {
                console.log('First slide swipe');
                this.isFirst = false;
                this.isSecond = true;
                this.isThird = false;

                this.accObj[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj[1].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
                this.accObj[2].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            } else {
                if (this.isSecond) {
                    this.isFirst = false;
                    this.isSecond = false;
                    this.isThird = true;
    
                    this.accObj[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                    this.accObj[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                    this.accObj[2].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
                }
            }
        } 
        else if (this.swipeStart == this.swipeEnd) {
            // do nothing
        } else {
            if (this.isThird) {
                this.isFirst = false;
                this.isSecond = true;
                this.isThird = false;

                this.accObj[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj[1].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
                this.accObj[2].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            } else {
                if (this.isSecond) {
                    this.isFirst = true;
                    this.isSecond = false;
                    this.isThird = false;
    
                    this.accObj[0].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
                    this.accObj[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                    this.accObj[2].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                }
            }
        }
    }

    touchEndBottomCarousel(event) {
        this.swipeEnd = event.changedTouches[0].clientX;
        if (this.swipeStart > this.swipeEnd) {
            if (this.isFirst_Offers) {
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
            } else if (this.isSecond_Offers) {
                this.isFirst_Offers = false;
                this.isSecond_Offers = false;
                this.isThird_Offers = true;
                this.isFourth_Offers = false;
                this.isFifth_Offers = false;
                this.accObj1[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[2].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
                this.accObj1[3].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[4].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            } else if (this.isThird_Offers) {
                this.isFirst_Offers = false;
                this.isSecond_Offers = false;
                this.isThird_Offers = false;
                this.isFourth_Offers = true;
                this.isFifth_Offers = false;
                this.accObj1[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[2].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[3].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
                this.accObj1[4].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            } else if (this.isFourth_Offers) {
                this.isFirst_Offers = false;
                this.isSecond_Offers = false;
                this.isThird_Offers = false;
                this.isFourth_Offers = false;
                this.isFifth_Offers = true;
                this.accObj1[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[2].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[3].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[4].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
            }
        } 
        else if (this.swipeStart == this.swipeEnd) {
            // do nothing
        } else {
            if (this.isFifth_Offers) {
                this.isFirst_Offers = false;
                this.isSecond_Offers = false;
                this.isThird_Offers = false;
                this.isFourth_Offers = true;
                this.isFifth_Offers = false;
                this.accObj1[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[2].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[3].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
                this.accObj1[4].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            } else if (this.isFourth_Offers) {
                this.isFirst_Offers = false;
                this.isSecond_Offers = false;
                this.isThird_Offers = true;
                this.isFourth_Offers = false;
                this.isFifth_Offers = false;
                this.accObj1[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[2].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
                this.accObj1[3].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj1[4].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            } else if (this.isThird_Offers) {
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
            } else if (this.isSecond_Offers) {
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
            }
        }
    }
    // Swipe functionality end

    get Banner1Desktop() {
        return ahfc_preloginHondaBanner1Desktop;
    }
    get Banner2Desktop() {
        return ahfc_preloginHondaBanner2Desktop;
    }
    get Banner3Desktop() {
        return ahfc_preloginHondaBanner3Desktop;
    }
    get Banner1Mobile() {
        return ahfc_preloginHondaBanner1Mobile;
    }
    get Banner2Mobile() {
        return ahfc_preloginHondaBanner2Mobile;
    }
    get Banner3Mobile() {
        return ahfc_preloginHondaBanner3Mobile;
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
        return ahfc_preloginMiddleImageDesktop;
    }
    get middleImageMobile() {
        return ahfc_preloginMiddleImageMobile;
    }

    get protectionProductsLogoUrl() {
        return ahfc_protectionProductsDesktop;
    }
    get hondaSpecialOffersLogoUrl() {
        return ahfc_hondaSpecialOffers;
    }
    get hondaPowerSportsDesktopLogoUrl() {
        return ahfc_hondaPowerSportsDesktop;
    }
    get hondaPowerEquipmentDesktopLogoUrl() {
        return ahfc_hondaPowerEquipmentDesktop;
    }
    get hondaMarineLogoUrl() {
        return ahfc_hondaMarineDesktop;
    }

    get protectionProductsMobileLogoUrl() {
        return ahfc_protectionProductsMobile;
    }
    // get hondaSpecialOffersMobileLogoUrl() {
    //     return ahfc_hondaSpecialOffersMobile;
    // }
    get hondaPowerSportsMobileLogoUrl() {
        return ahfc_hondaPowerSportsMobile;
    }
    get hondaPowerEquipmentMobileLogoUrl() {
        return ahfc_hondaPowerEquipmentMobile;
    }
    get hondaMarineMobileLogoUrl() {
        return ahfc_hondaMarineMobile;
    }

    @track isFirst = true;
    @track isSecond = false;
    @track isThird = false;
    @track isFirst_Offers = true;
    @track isSecond_Offers = false;
    @track isThird_Offers = false;
    @track isFourth_Offers = false;
    @track isFifth_Offers = false;

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
    },
    {
        keyNo: "3",
        indicatorId: "3",
        indicatorClass: "slds-carousel__indicator-action ahfc_corouselButton",
        ariaSelected: false,
        panelId: "3",
        name: "third"
    },
    {
        keyNo: "4",
        indicatorId: "4",
        indicatorClass: "slds-carousel__indicator-action ahfc_corouselButton",
        ariaSelected: false,
        panelId: "4",
        name: "fourth"
    },
    {
        keyNo: "5",
        indicatorId: "5",
        indicatorClass: "slds-carousel__indicator-action ahfc_corouselButton",
        ariaSelected: false,
        panelId: "5",
        name: "fifth"
    }
    ]

    connectedCallback() {
        setInterval(() => {
            this.template.querySelectorAll('.ahfc_corouselButton').forEach(element => {
                element.blur();
            });
            if(this.isFirst){
                this.isFirst = false;
                this.isSecond = true;
                this.isThird = false;
                this.accObj[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj[1].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
                this.accObj[2].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            }else if(this.isSecond) {
                this.isFirst = false;
                this.isSecond = false;
                this.isThird = true;
                this.accObj[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj[2].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
            }else {
                this.isFirst = true;
                this.isSecond = false;
                this.isThird = false;
                this.accObj[0].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
                this.accObj[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj[2].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            }
        }, 5000);
        this.globalAlert();
        
        loadStyle(this, ahfctheme + "/theme.css").then(() => { });

        // set domain brand in session storage --- added by sagar 
        sessionStorage.setItem('domainBrand', this.domainBrand);
        let adobedata = {
            "Page.page_name": "Honda Landing",
            "Page.site_section": "Honda Landing",
            "Page.referrer_url": document.referrer,
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
       // let panelBlock = this.template.querySelector(`.ahfc_corouselButton`);
       // console.log(document.getElementsByClassName(".ahfc_corouselButton"),'c', panelBlock);
         this.automaticSlide();

    }

    automaticSlide(){
        console.log('inside automaticSlide >>>');
      //  let panelBlock = this.template.querySelector(`.ahfc_corouselButton`);
        setInterval(function(){
            console.log('inside automaticSlide 1 >>>');
        },5000); 
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

    // top banner carousal
    onCarousalIndicatorClick(event) {
        console.log(event.target.dataset.indicator, 'indicator');
        if (event.target.dataset.indicator == 1) {
            this.isFirst = true;
            this.isSecond = false;
            this.isThird = false;
            this.accObj[0].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
            this.accObj[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj[2].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
        } else if (event.target.dataset.indicator == 2) {
            this.isFirst = false;
            this.isSecond = true;
            this.isThird = false;
            this.accObj[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj[1].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
            this.accObj[2].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
        } else {
            this.isFirst = false;
            this.isSecond = false;
            this.isThird = true;
            this.accObj[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj[2].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
        }

    }

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
        } else if (event.target.dataset.indicator == 2) {
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
        } else if (event.target.dataset.indicator == 3) {
            this.isFirst_Offers = false;
            this.isSecond_Offers = false;
            this.isThird_Offers = true;
            this.isFourth_Offers = false;
            this.isFifth_Offers = false;
            this.accObj1[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[2].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
            this.accObj1[3].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[4].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
        } else if (event.target.dataset.indicator == 4) {
            this.isFirst_Offers = false;
            this.isSecond_Offers = false;
            this.isThird_Offers = false;
            this.isFourth_Offers = true;
            this.isFifth_Offers = false;
            this.accObj1[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[2].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[3].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
            this.accObj1[4].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
        } else {
            this.isFirst_Offers = false;
            this.isSecond_Offers = false;
            this.isThird_Offers = false;
            this.isFourth_Offers = false;
            this.isFifth_Offers = true;
            this.accObj1[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[2].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[3].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj1[4].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
        }

    }

    //navigate to credit preapproval page
    onPreApprovalClick() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Honda Landing:Hyperlink: Apply Now",
            "Event_Metadata.action_category": "Apply For Credit",
            "Page.page_name": "Honda Landing",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');

        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'creditpreapproval-prelogin'
            }
        });
    }

    //navigate to lease vs finance page
    onLeaseVsFinanceClick() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Honda Landing:Hyperlink:Learn More",
            "Event_Metadata.action_category": "Lease vs Finance",
            "Page.page_name": "Honda Landing",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'lease-vs-finance-prelogin'
            }
        });
    }

    //navigate to end of lease page
    onEndOfLeaseClick() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Honda Landing:Hyperlink:Learn More",
            "Event_Metadata.action_category": "End of Lease",
            "Page.page_name": "Honda Landing",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'end-of-lease-pre-login'
            }
        });
    }

    //navigate to Honda Loyalty Benefits page
    onHondaLoyaltyBenefitsClick() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Honda Landing:Hyperlink:Learn More",
            "Event_Metadata.action_category": "Honda Loyalty Benefits",
            "Page.page_name": "Honda Landing",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'honda-loyalty-benefits-pre-login'
            }
        });
    }
    hondaAutombileSpecialOffers(){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Honda Landing:Hyperlink:Find Offers",
            "Event_Metadata.action_category": "Honda Special Offers",
            "Page.page_name": "Honda Landing",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
    }

    hondaPowerSportsOffers(){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Honda Landing:Hyperlink:Learn More",
            "Event_Metadata.action_category": "Powersports Offers",
            "Page.page_name": "Honda Landing",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
    }

    hondaPowerEquipmentOffers(){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Honda Landing:Hyperlink:Find Offers",
            "Event_Metadata.action_category": "Power Equipment Offers",
            "Page.page_name": "Honda Landing",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
    }

    hondaMarineOffers(){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Honda Landing:Hyperlink:Learn More",
            "Event_Metadata.action_category": "Marine Offers",
            "Page.page_name": "Honda Landing",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
    }
    //navigate to Protection Products page
    onProtectionProductsClick() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Honda Landing:Hyperlink:Learn More",
            "Event_Metadata.action_category": "Protection Products",
            "Page.page_name": "Honda Landing",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'protection-products-pre-login'
            }
        });
    }

    navigateToLogin(){
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Honda Landing:Button:Login",
            "Event_Metadata.action_category": "Hero",
            "Page.page_name": "Honda Landing",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
        let hondaLoginUrl = AHFC_CIAM_HONDA_LOGIN_URL +'login/?app='+ AHFC_CIAM_HONDA_APP_ID;
        let loginUrl =hondaLoginUrl +'&RelayState=/s/ciam-login-successfull?Brand=honda';
        window.location.href = loginUrl;
     }
     navigateToRegistration(){
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Honda Landing:Button:Register",
            "Event_Metadata.action_category": "Hero",
            "Page.page_name": "Honda Landing",
            "Page.brand_name": sessionStorage.getItem('domainBrand') ? sessionStorage.getItem('domainBrand') : ''
        };
        fireAdobeEvent(adobedata, 'click-event');
         let hondaLoginUrl = AHFC_CIAM_HONDA_LOGIN_URL + 'login/SelfRegister?app=' + AHFC_CIAM_HONDA_APP_ID;
         let registrationURL = hondaLoginUrl + '&RelayState=/s/ciam-login-successfull?Brand=honda';
         window.location.href = registrationURL;
     }

}