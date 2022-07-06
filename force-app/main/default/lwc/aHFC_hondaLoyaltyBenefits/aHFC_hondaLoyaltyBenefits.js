import { LightningElement,track, wire } from 'lwc';
import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import ahfc_damageWaiver from "@salesforce/resourceUrl/ahfc_damageWaiver";
import ahfc_FeeWaiver from "@salesforce/resourceUrl/ahfc_FeeWaiver";
import ahfc_hondaSpecialOffers from "@salesforce/resourceUrl/ahfc_hondaSpecialOffers";
import ahfc_topHondaImage from "@salesforce/resourceUrl/ahfc_topHondaImage";
import ahfc_mobileTopHondaImage from "@salesforce/resourceUrl/ahfc_mobileTopHondaImage";
import ahfc_middleHondaImage from "@salesforce/resourceUrl/ahfc_middleHondaImage";
import ahfc_preApproval from "@salesforce/resourceUrl/ahfc_preApproval";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import { fireEvent } from 'c/pubsub';
import { CurrentPageReference } from "lightning/navigation";
import { NavigationMixin } from "lightning/navigation";


export default class AHFC_hondaLoyaltyBenefits extends NavigationMixin(LightningElement) {

    @wire(CurrentPageReference) pageRef;

    get damageWaiverLogoUrl() {
        return ahfc_damageWaiver;
    }
    get feeWaiverLogoUrl() {
        return ahfc_FeeWaiver;
    }
    get hondaSpecialOffersLogoUrl() {
        return ahfc_hondaSpecialOffers;
    }
    get hondaPreApprovalLogoUrl() {
        return ahfc_preApproval;
    }
    get topHondaImageLogoUrl() {
        return ahfc_topHondaImage;
    }
    get mobileTopHondaImageLogoUrl() {
        return ahfc_mobileTopHondaImage;
    }
    get middleImageLogoUrl(){
        return ahfc_middleHondaImage;
    }
    
    @track mobileSections = [
        {
            id: "0",
            parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
            class: "slds-accordion__section ahfc_accordianSection",
            contentClass: "slds-accordion__content",
            isOpened: false,
            header:'Drive a vehicle at its prime',
            accordionData: [{id:0, item: 'In a lease, you contract to enjoy a new vehicle for a specified period of time. You can also choose to lease one of our premier Honda Certified Pre-Owned Vehicles.' }
            ] 
        },
        {
            id: "1",
            parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
            class: "slds-accordion__section ahfc_accordianSection",
            contentClass: "slds-accordion__content",
            isOpened: false,
            header:'Less cash up front',
            accordionData: [{id:0, item: 'One of the biggest advantages of a lease is that it does not usually require a substantial down payment. In many states, you can even pay the sales taxes as part of your monthly lease payment, rather than in a lump sum.' }
            ] 
        },
        {
            id: "2",
            parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
            class: "slds-accordion__section ahfc_accordianSection",
            contentClass: "slds-accordion__content",
            isOpened: false,
            header:'Lower monthly payment',
            accordionData: [{id:0, item: 'If the finance period is the same, your monthly payments will generally be lower when leasing (vs. traditional financing) because your payments will be based on the vehicles estimated depreciation (you are contracting to use a portion of the cars value, rather than buying the entire car).' }
            ] 
        },
        {
            id: "3",
            parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
            class: "slds-accordion__section ahfc_accordianSection",
            contentClass: "slds-accordion__content",
            isOpened: false,
            header:'A new car more often',
            accordionData: [{id:0, item: 'A short-term lease makes it easy to drive a new car more frequently. Plus, if life changes demand a larger or smaller car in a few years, a lease can make it easier to plan and adapt.' }
            ] 
        },
        {
            id: "4",
            parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
            class: "slds-accordion__section ahfc_accordianSection",
            contentClass: "slds-accordion__content",
            isOpened: false,
            header:'Guaranteed future value',
            accordionData: [{id:0, item: 'You dont have to worry about resale value. If your car depreciates more than the estimated residual value in your lease contract at full term, you can turn it in at the end of your lease term. But if it is worth more, you can purchase it. '}
            ] 
        },
        {
            id: "5",
            parentClass: "slds-accordion__list-item ahfc-accordion-item ahfc-background-lightest",
            class: "slds-accordion__section ahfc_accordianSection",
            contentClass: "slds-accordion__content",
            isOpened: false,
            header:'Tax advantage for business',
            accordionData: [{id:0, item: ' People who use a lease car for business may find larger tax deductions with leasing than with buying a vehicle. Check with your tax advisor.' }
            ] 
        },
       
    ]

    @track isFirst = true;
    @track isSecond = false;
    @track isCarousalFirstItem = true;
    @track carousalPrevButtonClass = "slds-button carousal-button-desktop carousal-button-disabled";
    @track isCarousalLastItem = false;
    @track carousalNextButtonClass = "slds-button carousal-button-desktop";
    @track accObj=[{
        keyNo:"1",
        indicatorId:"1",
        indicatorClass:"slds-carousel__indicator-action  ahfc_corouselButton slds-is-active ahfc_isActive",
        ariaSelected:false,
        panelId:"1",
        name:"first"
    },
    {
        keyNo:"2",
        indicatorId:"2",
        indicatorClass:"slds-carousel__indicator-action ahfc_corouselButton",
        ariaSelected:false,
        panelId:"2",
        name:"second"
    }
]

   

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
                this.mobileSections[event.target.dataset.keyno].class === open ? close: open;
            this.mobileSections[event.target.dataset.keyno].parentClass =
            this.mobileSections[event.target.dataset.keyno].parentClass === parentopen ? parentclose: parentopen;
            this.mobileSections[event.target.dataset.keyno].contentClass =
            this.mobileSections[event.target.dataset.keyno].contentClass === accDataopen ? accDataclose: accDataopen;
            // this.mobileSections[event.target.dataset.keyno].contentClass = this
            //     .mobileSections[event.target.dataset.keyno].isOpened
            //     ? "slds-accordion__content mobile-accordion-content"
            //     : "slds-accordion__content";
        }
    }
    onFindAlocal() {
        let adobedata = {
            'Event_Metadata.action_type': 'Button',
            "Event_Metadata.action_label": "Honda Loyalty:Button:Find a Dealer",
            "Event_Metadata.action_category": "CTA",
            "Page.page_name": "Loyalty",
        };
        fireAdobeEvent(adobedata, 'click-event');
    }
    onClickOffer() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Honda Loyalty:Hyperlink:Honda Offers",
            "Event_Metadata.action_category": "Navigation",
            "Page.page_name": "Loyalty",
        };
        fireAdobeEvent(adobedata, 'click-event');
    }

    onLearnMore() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Honda Loyalty:Hyperlink:Credit App",
            "Event_Metadata.action_category": "Navigation",
            "Page.page_name": "Loyalty",
        };
        fireAdobeEvent(adobedata, 'click-event');
        console.log('Hello');
        /*redirect to credit preapproval*/
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "creditpreapproval"
            }
        });
    }

    connectedCallback() {
        fireEvent(this.pageRef, 'populateMenu');
        let adobedata = {
            "Page.page_name": "Loyalty",
            "Page.site_section": "Loyalty",
            "Page.referrer_url": document.referrer
         };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        loadStyle(this, ahfctheme + "/theme.css").then(() => { 

            // this.accObj[0].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action slds-is-active ahfc_isActive';
        });
    }

   // Setup the page on Carousal Bottom Indicators Click
   onCarousalIndicatorClick(event) {
       console.log(event.target.dataset.indicator,'indicator');
        if(event.target.dataset.indicator == 1){
            this.isFirst=true;
            this.isSecond=false;
            this.accObj[0].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
            this.accObj[1].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
        }else{
            this.isFirst=false;
            this.isSecond=true;
            this.accObj[0].indicatorClass = 'slds-carousel__indicator-action ahfc_corouselButton';
            this.accObj[1].indicatorClass = 'ahfc_isActive slds-carousel__indicator-action ahfc_corouselButton slds-is-active ahfc_isActive';
        }


    // if (event.target.dataset.indicator && (event.target.dataset.indicator != this.currentItem)) {
    //     this.setPageData(this.currentItem, event.target.dataset.indicator);
    //     }
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
    renderedCallback(){

        let firstClass = this.template.querySelector(".main-content");

        fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));

    }
}