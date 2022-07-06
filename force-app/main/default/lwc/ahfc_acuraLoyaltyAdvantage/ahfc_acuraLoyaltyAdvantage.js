import { LightningElement, track, wire } from 'lwc'; 
import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import ahfc_damageWaiver from "@salesforce/resourceUrl/ahfc_damageWaiver";
import ahfc_FeeWaiver from "@salesforce/resourceUrl/ahfc_FeeWaiver";
import ahfc_excessMiles from "@salesforce/resourceUrl/ahfc_excessMiles";
import ahfc_acuraSpecialOffers from "@salesforce/resourceUrl/ahfc_acuraSpecialOffers";
import ahfc_acuraBannerDesktop from "@salesforce/resourceUrl/ahfc_acuraBannerDesktop";
import ahfc_acuraBannerMobile from "@salesforce/resourceUrl/ahfc_acuraBannerMobile";
import ahfc_preApproval from "@salesforce/resourceUrl/ahfc_preApproval";
import ahfc_middleAcuraDesktop from "@salesforce/resourceUrl/ahfc_middleAcuraDesktop";
import ahfc_middleAcuraMobile from "@salesforce/resourceUrl/ahfc_middleAcuraMobile";
import ahfc_applyCreditDesktop from "@salesforce/resourceUrl/ahfc_applyCreditDesktop";
import ahfc_applyCreditMobile from "@salesforce/resourceUrl/ahfc_applyCreditMobile";
import { NavigationMixin } from "lightning/navigation";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import { CurrentPageReference } from "lightning/navigation";
import { fireEvent } from 'c/pubsub';




export default class Ahfc_acuraLoyaltyAdvantage extends NavigationMixin(LightningElement) {

    @wire(CurrentPageReference) pageRef;

    get damageWaiverLogoUrl() {
        return ahfc_damageWaiver;
    }
    get feeWaiverLogoUrl() {
        return ahfc_FeeWaiver;
    }
    get excessWaiverLogoUrl() {
        return ahfc_excessMiles;
    }
    get acuraSpecialOffersLogoUrl() {
        return ahfc_acuraSpecialOffers;
    }
    get hondaPreApprovalLogoUrl() {
        return ahfc_preApproval;
    }
    get topAcuraImageLogoUrl() {
        return ahfc_acuraBannerDesktop;
    }
    get mobileTopAcuraImageLogoUrl() {
        return ahfc_acuraBannerMobile;
    }
    get middleAcuraImageLogoUrl() {
        return ahfc_middleAcuraDesktop;
    }
    get mobileMiddleAcuraImageLogoUrl() {
        return ahfc_middleAcuraMobile;
    }
    get applyCreditDesktopImageLogoUrl() {
        return ahfc_applyCreditDesktop;
    }
    get applyCreditMobileImageLogoUrl() {
        return ahfc_applyCreditMobile;
    }



    @track mobileSections = [
        {
            id: "0",
            parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
            class: "slds-accordion__section ahfc_accordianSection",
            contentClass: "slds-accordion__content",
            isOpened: false,
            header: 'Mileage Forgiveness',
            accordionData: [{ id: 0, item: 'If you drive more than your contracted lease miles, we’ll waive one-half of your excess mileage (up to 7,500)', divOrSpan: true },
            { id: 1, item: '2', customClass: 'ahfc_superScript ahfc_marginRight', divOrSpan: true },
            { id: 2, item: 'when you lease or finance through Acura Financial Services (AFS).', divOrSpan: true },
            ]
        },
        {
            id: "1",
            parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
            class: "slds-accordion__section ahfc_accordianSection",
            contentClass: "slds-accordion__content",
            isOpened: false,
            header: 'Momentum Miles',
            accordionData: [{ id: 0, item: 'If you have driven fewer than your contracted lease miles, your unused lease miles (up to 15,000 miles)', divOrSpan: true },
            { id: 0, item: '3', customClass: 'ahfc_superScript ahfc_marginRight', divOrSpan: true },
            { id: 0, item: 'will be rounded up to the nearest 1,000 and added to your next Acura Luxury Lease.', divOrSpan: true }
            ]
        },
        {
            id: "2",
            parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
            class: "slds-accordion__section ahfc_accordianSection",
            contentClass: "slds-accordion__content",
            isOpened: false,
            header: 'Flexible Terms',
            accordionData: [{ id: 0, item: ' With term choices from 24 to 60 months, you can control how much you pay monthly and how long your lease will run.' }
            ]
        },
        {
            id: "3",
            parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
            class: "slds-accordion__section ahfc_accordianSection",
            contentClass: "slds-accordion__content",
            isOpened: false,
            header: 'Multiple Mileage Options',
            accordionData: [{ id: 0, item: 'Choose from 7,500, 10,000, 12,000 or 15,000 miles per year, and additional miles can be purchased at signing.' }
            ]
        },
        {
            id: "4",
            parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
            class: "slds-accordion__section ahfc_accordianSection",
            contentClass: "slds-accordion__content",
            isOpened: false,
            header: 'Automatic GAP Coverage',
            accordionData: [{ id: 0, item: 'Guaranteed Asset Protection (GAP) generally covers the difference between insurance payments and the outstanding lease if your vehicle is stolen or deemed a total loss. GAP coverage is standard on all Acura Luxury Leases.' }
            ]
        },
        {
            id: "5",
            parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
            class: "slds-accordion__section ahfc_accordianSection",
            contentClass: "slds-accordion__content",
            isOpened: false,
            header: ' Excessive Wear-and-Use or Damage Waiver',
            accordionData: [{ id: 0, item: 'The Acura Luxury Lease includes a $750 Excessive Wear-and-Use or Damage Waiver.' }
            ]
        },

    ]

    @track isFirst = true;
    @track isSecond = false;
    @track isCarousalFirstItem = true;
    @track carousalPrevButtonClass = "slds-button carousal-button-desktop carousal-button-disabled";
    @track isCarousalLastItem = false;
    @track carousalNextButtonClass = "slds-button carousal-button-desktop";
    @track accObj = [{
        keyNo: "1",
        indicatorId: "1",
        indicatorClass: "slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive",
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

    // Swipe functionality start
    @track swipeStart;
    @track swipeEnd;

    touchStart(event) {
        this.swipeStart = event.touches[0].clientX;
    }
    
    touchEnd(event) {
        this.swipeEnd = event.changedTouches[0].clientX;
        if (this.swipeStart > this.swipeEnd) {
            if (this.isFirst) {
                this.isFirst = false;
                this.isSecond = true;

                this.accObj[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
                this.accObj[1].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
            }
        } 
        else if (this.swipeStart == this.swipeEnd) {
            // do nothing
        } else {
            if (this.isSecond) {
                this.isFirst = true;
                this.isSecond = false;

                this.accObj[0].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
                this.accObj[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            }
        }
    }
    // Swipe Functionality End

    //Toggle Accordions 
    onMobileSectionsClick(event) {
        const open = "slds-accordion__section ahfc_accordianSection slds-is-open";
        const close = "slds-accordion__section ahfc_accordianSection";

        const parentopen = "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest ahfc_parentOpen";
        const parentclose = "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest";

        const accDataopen = "slds-accordion__content ahfc_accordionContent";
        const accDataclose = "slds-accordion__content";

        if (event.currentTarget.dataset.keyno) {
            this.mobileSections[event.target.dataset.keyno].isOpened = !this
                .mobileSections[event.target.dataset.keyno].isOpened;
            this.mobileSections[event.target.dataset.keyno].class =
                this.mobileSections[event.target.dataset.keyno].class === open ? close : open;
            this.mobileSections[event.target.dataset.keyno].parentClass =
                this.mobileSections[event.target.dataset.keyno].parentClass === parentopen ? parentclose : parentopen;
            this.mobileSections[event.target.dataset.keyno].contentClass =
                this.mobileSections[event.target.dataset.keyno].contentClass === accDataopen ? accDataclose : accDataopen;
            // this.mobileSections[event.target.dataset.keyno].contentClass = this
            //     .mobileSections[event.target.dataset.keyno].isOpened
            //     ? "slds-accordion__content mobile-accordion-content"
            //     : "slds-accordion__content";
        }
    }

    onFindAlocal() {
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Acura Loyalty:Button:Find a Dealer",
            "Event_Metadata.action_category": "CTA",
            "Page.page_name": "Acura Loyalty"
         };
        fireAdobeEvent(adobedata, 'click-event');
    }

    onClickOffer() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Acura Loyalty:Hyperlink:Acura Offers",
            "Event_Metadata.action_category": "Navigation",
            "Page.page_name": "Acura Loyalty"
        };
        fireAdobeEvent(adobedata, 'click-event');
    }

    connectedCallback() {
        let adobedata = {
            "Page.page_name": "Acura Loyalty",
            "Page.site_section": "Acura Loyalty",
            "Page.referrer_url": document.referrer,
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        loadStyle(this, ahfctheme + "/theme.css").then(() => {

            // this.accObj[0].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action slds-is-active ahfc_isActive';
        });
        fireEvent(this.pageRef, 'populateMenu');
    }

    // Setup the page on Carousal Bottom Indicators Click
    onCarousalIndicatorClick(event) {
        console.log(event.target.dataset.indicator, 'indicator');
        if (event.target.dataset.indicator == 1) {
            this.isFirst = true;
            this.isSecond = false;
            this.accObj[0].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
            this.accObj[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
        } else {
            this.isFirst = false;
            this.isSecond = true;
            this.accObj[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj[1].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
        }


        // if (event.target.dataset.indicator && (event.target.dataset.indicator != this.currentItem)) {
        //     this.setPageData(this.currentItem, event.target.dataset.indicator);
        //     }
    }

    //navigate to credit preapproval page
    onLearnMoreClick() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Acura Loyalty:Hyperlink:Credit App",
            "Event_Metadata.action_category": "Navigation",
            "Page.page_name": "Acura Loyalty"
         };
         fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'creditpreapproval'
            }
        });
    }


    //setup account data when toggle.
    setPageData(prevPage, nextPage) {
        if (prevPage + "") {
            this.accObj[prevPage].ariaHidden = "true";
            this.accObj[prevPage].tabIndex = "-1";
            this.accObj[prevPage].indicatorClass = "slds-carousel__indicator-action";
            this.accObj[prevPage].ariaSelected = "false";
        }
        this.accObj[nextPage].ariaHidden = "false";
        this.accObj[nextPage].tabIndex = "0";
        this.accObj[nextPage].indicatorClass = "slds-carousel__indicator-action slds-is-active";
        this.accObj[nextPage].ariaSelected = "true";

        let panelBlock = this.template.querySelector(`.ahfc-carousal .slds-carousel__panels`);
        const transform = nextPage * 100;
        if (panelBlock) {
            panelBlock.style.transform = `translateX(-${transform}%)`;
        }
        this.currentItem = nextPage;
        this.displayicons();

    }

    // Setup whether the Carousal Next/Previous Buttons be clickable
    displayicons() {
        this.isCarousalFirstItem = this.currentItem == 0 ? true : false;
        this.carousalPrevButtonClass = this.isCarousalFirstItem
            ? "slds-button carousal-button-desktop carousal-button-disabled"
            : "slds-button carousal-button-desktop";
        this.isCarousalLastItem =
            parseInt(this.currentItem) + 1 == this.lstofServiceAccountwrapper.length
                ? true
                : false;
        this.carousalNextButtonClass = this.isCarousalLastItem
            ? "slds-button carousal-button-desktop carousal-button-disabled"
            : "slds-button carousal-button-desktop";
    }

    //On Clicking of Prev in Carousal
    onCarousalPrevDesktop() {
        this.setPageData(parseInt(this.currentItem), parseInt(this.currentItem) - 1);
    }

    //On Clicking of Next in Carousal
    onCarousalNextDesktop() {
        this.setPageData(parseInt(this.currentItem), parseInt(this.currentItem) + 1);
    }


    //for ADA
    renderedCallback() {

        let firstClass = this.template.querySelector(".main-content");

        //fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));

    }


}