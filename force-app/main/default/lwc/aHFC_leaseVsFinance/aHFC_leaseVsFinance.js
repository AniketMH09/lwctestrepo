import { LightningElement, track, wire } from 'lwc';
import bannerDesktop from "@salesforce/resourceUrl/AHFC_Lease_vs_Finance_Banner";
import bannerMobile from "@salesforce/resourceUrl/AHFC_Lease_vs_Finance_Banner_Mobile";
import silverHondaSUVDesktop from "@salesforce/resourceUrl/AHFC_Silver_Honda_SUV_Desktop";
import ahfc_hondaSpecialOffers from "@salesforce/resourceUrl/AHFC_Silver_Honda_SUV";
import ahfc_preApproval from "@salesforce/resourceUrl/AHFC_HondaOffers_Tile";
import ahfc_AcuraOffers from "@salesforce/resourceUrl/AHFC_AcuraOffers_Tile";
import ahfc_acuraLoyaltyCar from "@salesforce/resourceUrl/AHFC_AcuraLoyaltyCar";
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import { NavigationMixin } from "lightning/navigation";
import { fireEvent } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';

export default class AHFC_leaseVsFinance extends NavigationMixin(LightningElement) {
    @track leaseData = [{
            id: "0",
            class: "",
            isOpened: false,
            cardTitle: 'Drive a vehicle at its prime',
            cardData: 'In a lease, you contract to enjoy a new vehicle for a specified period of time. You can also choose to lease one of our premier Honda or Acura Certified Pre-Owned Vehicles.'
        },
        {
            id: "1",
            class: "",
            isOpened: false,
            cardTitle: 'Less cash up front',
            cardData: 'One of the biggest advantages of a lease is that it does not usually require a substantial down payment. In many states, you can even pay the sales taxes as part of your monthly lease payment, rather than in a lump sum.'
        },
        {
            id: "2",
            class: "",
            isOpened: false,
            cardTitle: 'Lower monthly payment',
            cardData: "If the finance period is the same, your monthly payments will generally be lower when leasing (vs. traditional financing) because your payments will be based on the vehicle's estimated depreciation. (You are contracting to use a portion of the car's value, rather than buying the entire car)."
        },
        {
            id: "3",
            class: "",
            isOpened: false,
            cardTitle: 'A new car more often',
            cardData: 'A short-term lease makes it easy to drive a new car more frequently. Plus, if life changes demand a larger or smaller car in a few years, a lease can make it easier to plan and adapt.'
        },
        {
            id: "4",
            class: "",
            isOpened: false,
            cardTitle: 'Guaranteed future value',
            cardData: "You don't have to worry about resale value. If your car depreciates more than the estimated residual value in your lease contract at full term, you can turn it in at the end of your lease term. But if it's worth more, you can purchase it."
        },
        {
            id: "5",
            class: "",
            isOpened: false,
            cardTitle: 'Tax advantage for business',
            cardData: 'People who use a lease car for business may find larger tax deductions with leasing than with buying a vehicle. Check with your tax advisor.'
        },
        {
            id: "6",
            class: "",
            isOpened: false,
            cardTitle: 'One Pay Lease',
            cardData: 'One-Pay leases provide the flexibility and protection of a traditional lease, with the simplicity of a single, one-time payment. Contact your Honda or Acura dealer to learn more.'
        }
    ];
    @track financingData = [{
            id: "0",
            class: "",
            isOpened: false,
            cardTitle: 'Get more value',
            cardData: [
                { id: "a1", detail: "If you typically keep your vehicle for five to 10 years, then traditional financing may be your best option. Explore our competitive rates and flexible terms to find the best choice for financing your new vehicle." }
            ]
        },
        {
            id: "1",
            class: "",
            isOpened: false,
            cardTitle: 'Ownership equity',
            cardData: [
                { id: "11", detail: "Payment by payment, your ownership equity may increase. And the longer you drive the vehicle after your contract is complete, the more value you derive from your investment." }
            ]
        },
        {
            id: "2",
            class: "",
            isOpened: false,
            cardTitle: 'No mileage restrictions',
            cardData: [
                { id: "21", detail: "If you drive more than 12,000 to 15,000 miles per year, financing could be the best option for you with no mileage restrictions on your contract." }
            ]
        },
        {
            id: "3",
            class: "",
            isOpened: false,
            cardTitle: 'Customize appearance',
            cardData: [
                { id: "31", detail: "You can alter the interior or exterior to suit your taste. Consider using Honda or Acura Genuine Accessories." }
            ]
        },
        {
            id: "4",
            class: "",
            isOpened: false,
            cardTitle: 'Leadership Purchase Plan',
            cardData: [
                { id: "41", detail: "With the Leadership Purchase Plan, your name is on the title and your payments go toward ownership. At the end of the contract you can purchase the vehicle for a guaranteed price or return the vehicle to your dealer." },
                { id: "42", detail: "The Leadership Purchase Plan is only available to qualified customers in select states.*" },
                { id: "43", detail: "*The Leadership Purchase Plan is only available in South Carolina, Illinois, Georgia, New York, Arkansas, Texas, Virginia, Maryland, Oklahoma and Tennessee. Check with your dealer for availability." }
            ]
        }
    ];
    @track carouselData = [{
            title: "Honda Special Offers",
            detail: "Find special offers in your area.",
            helpLinkLabel: "Find Offers",
            helpLinkUrl: "https://automobiles.honda.com/tools/current-offers",
            hidden: false,
            id: "content-id-01",
            labelledby: "indicator-id-01",
            index: 0,
            selected: true,
            imageSrc: "",
            paginationClass: "slds-carousel__indicator-action slds-is-active",
            transformtype: "zero"
        },
        {
            title: "Honda Leasing Loyalty Benefits",
            detail: "From flexible terms to multiple mileage options, explore the benefits of leasing a new Honda.",
            helpLinkLabel: "LEARN MORE",
            helpLinkUrl: "#",
            hidden: false,
            id: "content-id-02",
            labelledby: "indicator-id-02",
            index: 1,
            selected: true,
            imageSrc: "",
            paginationClass: "slds-carousel__indicator-action",
            transformtype: "one"
        },
        {
            title: "Acura Special Offers",
            detail: "Visit Acura.com to see current offers on the Acura family of precision crafted vehicles.",
            helpLinkLabel: "Find Offers",
            helpLinkUrl: "https://www.acura.com/tools/current-luxury-car-suv-offers-leasing",
            hidden: false,
            id: "content-id-03",
            labelledby: "indicator-id-03",
            index: 2,
            selected: true,
            imageSrc: "",
            paginationClass: "slds-carousel__indicator-action",
            transformtype: "two"
        },
        {
            title: "The Acura Loyalty Advantage",
            detail: "Acura lease customers, explore the exclusive benefits of leasing with us again.",
            helpLinkLabel: "LEARN MORE",
            helpLinkUrl: "#",
            hidden: false,
            id: "content-id-04",
            labelledby: "indicator-id-04",
            index: 3,
            selected: true,
            imageSrc: "",
            paginationClass: "slds-carousel__indicator-action",
            transformtype: "three"
        }
    ];

    //added method as part of bug fix 22344
onLinkClicked(event){
    console.log('data-value:'+event.target.getAttribute('data-value'));
    let title = event.target.getAttribute('data-value');
    if(title == 'Honda Special Offers'){
        window.location.href='https://automobiles.honda.com/tools/current-offers';
    }
    if(title == 'Honda Leasing Loyalty Benefits'){
        this.onClickhondaLoyalty();
    }
    if(title == 'Acura Special Offers'){
        window.location.href='https://www.acura.com/tools/current-luxury-car-suv-offers-leasing';
    }
    if(title == 'The Acura Loyalty Advantage'){
        this.onClickacuraLoyalty();
    }    
}
    @track panelClass = "slds-carousel__panels transform-zero";
    get silverHondaSUVDesktopUrl() {
        return silverHondaSUVDesktop;
    }
    get hondaSpecialOffersLogoUrl() {
        return ahfc_hondaSpecialOffers;
    }
    get hondaPreApprovalLogoUrl() {
        return ahfc_preApproval;
    }
    get acuraOffersUrl() {
        return ahfc_AcuraOffers;
    }
    get acuraLoyaltyCarUrl() {
        return ahfc_acuraLoyaltyCar;
    }
    onCardClick(event) {
        const open = "slds-is-open";
        const close = "";
        this.leaseData.map(function(x, index) {
            if (x.isOpened && index != event.currentTarget.dataset.keyno) {
                x.isOpened = false;
                x.class = "";
            }
            return x
        });
        if (event.currentTarget.dataset.keyno) {
            let keyId = event.currentTarget.dataset.keyno;
            this.leaseData[keyId].isOpened = !this.leaseData[keyId].isOpened;
            this.leaseData[keyId].class = this.leaseData[keyId].class === open ? close : open;
        }
    }
    onCardFinanceClick(event) {
        const open = "slds-is-open";
        const close = "";
        this.financingData.map(function(x, index) {
            if (x.isOpened && index != event.currentTarget.dataset.keyno) {
                x.isOpened = false;
                x.class = "";
            }
            return x
        });
        if (event.currentTarget.dataset.keyno) {
            let keyId = event.currentTarget.dataset.keyno;
            this.financingData[keyId].isOpened = !this.financingData[keyId].isOpened;
            this.financingData[keyId].class = this.financingData[keyId].class === open ? close : open;
        }
    }
    get bannerDesktopUrl() {
        return bannerDesktop;
    }
    get bannerMobileUrl() {
        return bannerMobile;
    }
    onPaginationClick(event) {
        let transformVal = event.currentTarget.dataset.transformtype;
        this.panelClass = "slds-carousel__panels transform-" + transformVal;
        this.carouselData.forEach((value, index) => {
            if (value.transformtype === transformVal)
                value.paginationClass = 'slds-carousel__indicator-action slds-is-active';
            else
                value.paginationClass = 'slds-carousel__indicator-action';
        })
    }

    @wire(CurrentPageReference) pageRef;
    onClickacuraOffers() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Lease vs Finance:Hyperlink:Acura Offers",
            "Event_Metadata.action_category": "Navigation",
            "Page.page_name": "Lease vs Finance",
        };
        fireAdobeEvent(adobedata, 'click-event');
    }

    onClickacuraLoyalty() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Lease vs Finance:Hyperlink:Acura Loyalty",
            "Event_Metadata.action_category": "Navigation",
            "Page.page_name": "Lease vs Finance",
        };
        fireAdobeEvent(adobedata, 'click-event');

         /*redirect to acura*/
         this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "acura-loyalty-advantage"
            }
        });
    }


    onClickhondaOffers() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Lease vs Finance:Hyperlink:Honda Offers",
            "Event_Metadata.action_category": "Navigation",
            "Page.page_name": "Lease vs Finance",
        };
        fireAdobeEvent(adobedata, 'click-event');
    }

    onClickhondaLoyalty() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": "Lease vs Finance:Hyperlink:Honda Loyalty",
            "Event_Metadata.action_category": "Navigation",
            "Page.page_name": "Lease vs Finance",
        };
        fireAdobeEvent(adobedata, 'click-event');

        /*redirect to honda*/
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "honda-loyalty-benefits"
            }
        });
    }


    touchStart(event) {
        //alert('touch start');
        this.swipeStart = event.touches[0].clientX;
    }
    
    touchEnd(event) {
        this.swipeEnd = event.changedTouches[0].clientX;
        
        let transformVal='zero';
        
    
        if (this.swipeStart > this.swipeEnd) {
    
            let nextindex=parseInt(event.currentTarget.dataset.index);
            
            nextindex=nextindex+1;
    
            
            if(nextindex==0)
            {
                transformVal='zero';
            }else if(nextindex==1){
                transformVal='one';
            }else if(nextindex==2){
                transformVal='two';
            }else if(nextindex==3){
                transformVal='three';
            }
    
            this.panelClass = "slds-carousel__panels transform-" + transformVal;
            this.carouselData.forEach((value, index) => {
                if (value.transformtype === transformVal)
                    value.paginationClass = 'slds-carousel__indicator-action slds-is-active';
                else
                    value.paginationClass = 'slds-carousel__indicator-action';
            })
    
        } 
        else if (this.swipeStart == this.swipeEnd) {
            // do nothing
        } else {
    
            let previosIndex=parseInt(event.currentTarget.dataset.index);
            
            previosIndex=previosIndex-1;
    
    
            if(previosIndex==0)
            {
                transformVal='zero';
            }else if(previosIndex==1){
                transformVal='one';
            }else if(previosIndex==2){
                transformVal='two';
            }else if(previosIndex==3){
                transformVal='three';
            }
    
            this.panelClass = "slds-carousel__panels transform-" + transformVal;
            this.carouselData.forEach((value, index) => {
                if (value.transformtype === transformVal)
                    value.paginationClass = 'slds-carousel__indicator-action slds-is-active';
                else
                    value.paginationClass = 'slds-carousel__indicator-action';
            })
    
        }
    }  


    connectedCallback() {
        fireEvent(this.pageRef, 'populateMenu');
        let adobedata = {
            "Page.page_name": "Lease vs Finance",
            "Page.site_section": "Lease vs Finance",

            "Page.referrer_url": document.referrer
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        this.carouselData[0].imageSrc = ahfc_preApproval;
        this.carouselData[1].imageSrc = ahfc_hondaSpecialOffers;
        this.carouselData[2].imageSrc = ahfc_AcuraOffers;
        this.carouselData[3].imageSrc = ahfc_acuraLoyaltyCar;
    }
}