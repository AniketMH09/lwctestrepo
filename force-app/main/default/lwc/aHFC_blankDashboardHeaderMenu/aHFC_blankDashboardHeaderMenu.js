/* Component Name   :    aHFC_blankDashboardHeaderMenu
* @Description      :   LWC for Menu Header for blank dashboard 
* Modification Log  :
* --------------------------------------------------------------------------- 
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Aswin Jose               July 23 2021                Created
* Shristi Agarwal          July 30 2021                Modified
********************************************************************************/
import { api, LightningElement, track, wire } from "lwc";
import NAME_FIELD from '@salesforce/schema/User.Name';
import USER_ID from '@salesforce/user/Id';
import hondaLogo from "@salesforce/resourceUrl/Honda_financial_logo";
import acuraLogo from "@salesforce/resourceUrl/AHFC_Acura_Header_Logo";
import userImgUrl from "@salesforce/resourceUrl/AHFC_UserImg";
import { loadStyle } from "lightning/platformResourceLoader";
import FORM_FACTOR from "@salesforce/client/formFactor";
import { labels } from "c/aHFC_dashboardConstantsUtil";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import { NavigationMixin } from "lightning/navigation";
import isguest from '@salesforce/user/isGuest';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { getConstants } from "c/ahfcConstantUtil";
import { getRecord } from 'lightning/uiRecordApi';
import { fireAdobeEvent } from "c/aHFC_adobeServices";
import AHFC_CIAM_HONDA_LOGIN_URL from "@salesforce/label/c.AHFC_CIAM_HONDA_LOGIN_URL";
import AHFC_CIAM_ACURA_LOGIN_URL from "@salesforce/label/c.AHFC_CIAM_ACURA_LOGIN_URL";
import AHFC_CIAM_SF_User_Id from '@salesforce/schema/User.AHFC_CIAM_SF_User_Id__c';
import AHFC_CIAM_HONDA_APP_ID from "@salesforce/label/c.AHFC_CIAM_HONDA_APP_ID";
import AHFC_CIAM_ACURA_APP_ID from "@salesforce/label/c.AHFC_CIAM_ACURA_APP_ID";
import basePath from "@salesforce/community/basePath";
const CONSTANTS = getConstants();
export default class AHFC_blankDashboardHeaderMenu extends NavigationMixin(LightningElement) {
    @track payLoadWrapper;
    @track isSubMenuOpenAc = false;
    @track isUserProfile = false;
    @track isSubMenuOpenSupport = false;
    @track isSubMenuOpenFinance = false;
    @track isSubMenuOpenMenu = false;
    @track isSubMenuOpenOwner = false; //Added for US 8745
    @track showdesktop;
    @track showmobile;
    @track getAccountInfo;
    @track finAccData;
    @track labels = labels; 
    @track isWebAccLocked;
    @track islockedHeaderFooter = false;
    @track isArchived;
    @track isGetAccountInfo = false;
    @track isDisplay = true;
    @track isDoNotDisplay = true;
    isCheck = isguest;
    @track isGuestCheck = false;
    @track IDSAC;
    @wire(CurrentPageReference) pageRef;
    @track userName;
    @track adobepagename = ''; 
    @track ciamUserId = '';

    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD, AHFC_CIAM_SF_User_Id]
    }) wireuser({
        error,
        data
    }) {
        console.log('Guest User : ' + this.isCheck);

        if (error) {
            console.log('error', error);
        } else if (data) {
            console.log('data', data);
            this.userName = data.fields.Name.value;
            this.ciamUserId = data.fields.AHFC_CIAM_SF_User_Id__c.value;
        }
    }

    get hondaLogoUrl() {
        return hondaLogo;
    }
    get AcuraLogoUrl() {
        return acuraLogo;
    }
    get userImgUrl() {
        return userImgUrl;
    }
    addClass(evt) {
        evt.preventDefault();
        console.log('addClassEntry', this.isDisplay + '----- ');
        evt.currentTarget.parentElement.classList.add('AHFC_Smenuhover');
        evt.currentTarget.classList.add('AHFC_MenubordBoardClick');
        //subMenuBoardClick
    }
    myAccountLabelClicked(evt){
        let code = evt.keyCode || evt.which;
        console.log('code',code);
        if(code == 1){
        }
    }
    onclickAddClass(evt) {
        console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>..1111111111111111111111111111111');
        let code = evt.keyCode || evt.which;
        if (evt.shiftKey && code === 9) {
            let firstClass1 = this.template.querySelector(".subMenu1");
            firstClass1.classList.remove('subMenuBoardClick');
            this.removeClass(evt);
        }
        if (evt.keyCode === 27){
            let firstClass1 = this.template.querySelector(".subMenu1");
            firstClass1.classList.remove('subMenuBoardClick');
            this.removeClass(evt);
        }
        //evt.preventDefault();
        console.log('onclickAddClass ---------------------------entery');
        if (evt.keyCode === 13) {
            console.log('xxxxxxxxxxxxxxxx');
            let firstClass = this.template.querySelector(".subMenu1");
            firstClass.classList.add('subMenuBoardClick');
            evt.currentTarget.parentElement.classList.add('AHFC_Smenuhover');
            evt.currentTarget.classList.add('AHFC_Smenuhover');
            this.addClass(evt);
        } else {
            return true;
        }

        //  return false;
    }

    onclickAddClassFinance(evt) {
        let code = evt.keyCode || evt.which;
        if (evt.shiftKey && code === 9) {
            let firstClass2 = this.template.querySelector(".subMenu2");
            firstClass2.classList.remove('subMenuBoardClick');
            this.removeClass(evt);
        }

        if (evt.keyCode === 27){
            let firstClass1 = this.template.querySelector(".subMenu2");
            firstClass1.classList.remove('subMenuBoardClick');
            this.removeClass(evt);
        }
        //evt.preventDefault();
        console.log('onclickAddfianance ---------------------------entery');
        if (evt.keyCode === 13) {
            let firstClass = this.template.querySelector(".subMenu2");
            firstClass.classList.add('subMenuBoardClick');
            evt.currentTarget.parentElement.classList.add('AHFC_Smenuhover');
            evt.currentTarget.classList.add('AHFC_Smenuhover');
            this.addClass(evt);
        } else {
            return true;
        }

        //  return false;
    }

    onclickAddClassSupport(evt) {
        let code = evt.keyCode || evt.which;
        if (evt.shiftKey && code === 9) {
            let firstClass2 = this.template.querySelector(".subMenu3");
            firstClass2.classList.remove('subMenuBoardClick');
            this.removeClass(evt);
        }

        if (evt.keyCode === 27){
            let firstClass1 = this.template.querySelector(".subMenu3");
            firstClass1.classList.remove('subMenuBoardClick');
            this.removeClass(evt);
        }

        console.log('onclickAddfianance ---------------------------entery');
        if (evt.keyCode === 13) {
            let firstClass = this.template.querySelector(".subMenu3");
            firstClass.classList.add('subMenuBoardClick');
            evt.currentTarget.parentElement.classList.add('AHFC_Smenuhover');
            evt.currentTarget.classList.add('AHFC_Smenuhover');
            this.addClass(evt);
        } else {
            return true;
        }

        //  return false;
    }


    onclickAddClassOwners(evt) {
        let code = evt.keyCode || evt.which;
        if (evt.shiftKey && code === 9) {
            let firstClass2 = this.template.querySelector(".subMenu4");
            firstClass2.classList.remove('subMenuBoardClick');
            this.removeClass(evt);
        }
        if (evt.keyCode === 27){
            let firstClass1 = this.template.querySelector(".subMenu4");
            firstClass1.classList.remove('subMenuBoardClick');
            this.removeClass(evt);
        }
        console.log('onclickAddfianance ---------------------------entery');
        if (evt.keyCode === 13) {
            let firstClass = this.template.querySelector(".subMenu4");
            firstClass.classList.add('subMenuBoardClick');
            evt.currentTarget.parentElement.classList.add('AHFC_Smenuhover');
            evt.currentTarget.classList.add('AHFC_Smenuhover');
            this.addClass(evt);
            
        } else {
            return true;
        }

        //  return false;
    }



    
    

    removeClass(evt) {
        console.log('RemoveEntry');
        evt.currentTarget.parentElement.classList.remove('AHFC_Smenuhover');
        // this.template.querySelector(".subMenu1").classList.remove('subMenuBoardClick');

    }
    removeOtherClass(){
        this.removeSubmenu1();
        this.removeSubmenu2();
        this.removeSubmenu3();
        this.removeSubmenu4();
    }

    removeSubmenu1(){
        let firstClass = this.template.querySelector(".subMenu1");
        if(firstClass != undefined){
        firstClass.classList.remove('subMenuBoardClick');
        firstClass.parentElement.classList.remove('AHFC_Smenuhover');
        firstClass.classList.remove('AHFC_Smenuhover');
        }
        let mainMenu = this.template.querySelectorAll(".mainMenu1");
        mainMenu.forEach((element) => { element.classList.remove('AHFC_Smenuhover');} )
    }
    removeSubmenu2(){
        let firstClass = this.template.querySelector(".subMenu2");
        if(firstClass != undefined){
        firstClass.classList.remove('subMenuBoardClick');
        firstClass.parentElement.classList.remove('AHFC_Smenuhover');
        firstClass.classList.remove('AHFC_Smenuhover');
        }
        let mainMenu = this.template.querySelectorAll(".mainMenu2");
        mainMenu.forEach((element) => { element.classList.remove('AHFC_Smenuhover');} )
   
    }
    removeSubmenu3(){
        let firstClass = this.template.querySelector(".subMenu3");
        if(firstClass != undefined){
        firstClass.classList.remove('subMenuBoardClick');
        firstClass.parentElement.classList.remove('AHFC_Smenuhover');
        firstClass.classList.remove('AHFC_Smenuhover');
        }
        let mainMenu = this.template.querySelectorAll(".mainMenu3");
        mainMenu.forEach((element) => { element.classList.remove('AHFC_Smenuhover');} )
    }
    removeSubmenu4(){
        let firstClass = this.template.querySelector(".subMenu4");
        if(firstClass != undefined){
        firstClass.classList.remove('subMenuBoardClick');
        firstClass.parentElement.classList.remove('AHFC_Smenuhover');
        firstClass.classList.remove('AHFC_Smenuhover');
        }
        let mainMenu = this.template.querySelectorAll(".mainMenu4");
        mainMenu.forEach((element) => { element.classList.remove('AHFC_Smenuhover');} )
    }
    onHamburgerClick() {
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
        this.isUserProfile = false;
        this.isSubMenuOpenFinance = false;
        this.isSubMenuOpenSupport = false;
        this.isSubMenuOpenAc = false;
        this.isSubMenuOpenOwner = false; //Added  for US 8745
    }
    onSubmenuFinanceClick() {
        this.isSubMenuOpenFinance = !this.isSubMenuOpenFinance;
    }
    onSubmenuSupportClick() {
        this.isSubMenuOpenSupport = !this.isSubMenuOpenSupport;
    }
    onSubmenuAccClick() {
        this.isSubMenuOpenAc = !this.isSubMenuOpenAc;
    }
    // Added for US 8745
    onSubmenuOwnerClick() {
        this.isSubMenuOpenOwner = !this.isSubMenuOpenOwner;
    }
    onUserProfileClick(evt) {
        let code = evt.keyCode || evt.which;
        console.log('ProfileCoddeee-->', code);
        if (evt.shiftKey && code === 9) {
            console.log('ShiftInside');
            this.isUserProfile = !this.isUserProfile
            this.isSubMenuOpenMenu = false;

        }
        if (evt.shiftKey && code === 13) {
            this.isUserProfile = !this.isUserProfile
            this.isSubMenuOpenMenu = false;

        }
        //evt.preventDefault();
        console.log('onclickAddClass ---------------------------entery');
        if (evt.keyCode === 13 || code === 1) {
            this.isUserProfile = !this.isUserProfile
            this.isSubMenuOpenMenu = false;

        } else {
            return true;
        }


    }
    closeProfilePopup(event) {
        let code = event.keyCode || event.which;
        console.log('CodeeeProfilw--->', code);
        if (code === 9) {
            console.log('InsideCodeee');
            this.isUserProfile = !this.isUserProfile
            this.isSubMenuOpenMenu = false;
 

        }

    }
    connectedCallback() {
        this.adobepagename = this.pageRef.attributes.name;
        //	registerListener('BlankDashboardShow', this.pubsubBlankDashboardfn, this);

        document.addEventListener("click", (evt) => {
            if (evt.target.dataset.xyz == undefined) {
                this.isUserProfile = false;
                //  this.isSubMenuOpenMenu = false;
            }

        });

        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
        if (FORM_FACTOR == this.labels.LargeLabel) {
            this.showdesktop = true;
            this.showmobile = false;
        } else if (FORM_FACTOR == this.labels.MediumLabel) {
            this.showdesktop = true;
            this.showmobile = true;
        } else {
            this.showdesktop = false;
            this.showmobile = true;
        }

        this.showdesktop = true;
        document.addEventListener("click", (evt) => {
            if (evt.target.dataset.xyz == undefined) {
                this.isUserProfile = false;
                //this.isSubMenuOpenMenu = false;
            }
            if (!this.template.querySelector(".subMenu1").contains(evt.target)) {
                let firstClass = this.template.querySelector(".subMenu1");
                firstClass.classList.remove('subMenuBoardClick');
            }
            if (!this.template.querySelector(".subMenu2").contains(evt.target)) {
                let firstClass = this.template.querySelector(".subMenu2");
                firstClass.classList.remove('subMenuBoardClick');
            }
            if (!this.template.querySelector(".subMenu3").contains(evt.target)) {
                let firstClass = this.template.querySelector(".subMenu3");
                firstClass.classList.remove('subMenuBoardClick');
            }
            if (!this.template.querySelector(".subMenu4").contains(evt.target)) {
                let firstClass = this.template.querySelector(".subMenu4");
                firstClass.classList.remove('subMenuBoardClick');
            }
        });

        document.addEventListener("focusin", (evt) => {
            console.log('xxxxxx');
            if (this.template.querySelector(".mainMenu1").contains(evt.target)) {
                console.log('111111111111111');
                let firstClass2 = this.template.querySelector(".subMenu2");
                firstClass2.classList.remove('subMenuBoardClick');
                let firstClass3 = this.template.querySelector(".subMenu3");
                firstClass3.classList.remove('subMenuBoardClick');
                let firstClass4 = this.template.querySelector(".subMenu4");
                firstClass4.classList.remove('subMenuBoardClick');
            }
            if (this.template.querySelector(".mainMenu2").contains(evt.target)) {
                console.log('22222222222222222');
                let firstClass1 = this.template.querySelector(".subMenu1");
                firstClass1.classList.remove('subMenuBoardClick');
                let firstClass3 = this.template.querySelector(".subMenu3");
                firstClass3.classList.remove('subMenuBoardClick');
                let firstClass4 = this.template.querySelector(".subMenu4");
                firstClass4.classList.remove('subMenuBoardClick');
            }
            if (this.template.querySelector(".mainmenu3").contains(evt.target)) {
                console.log('333333333333333333');
                let firstClass1 = this.template.querySelector(".subMenu1");
                firstClass1.classList.remove('subMenuBoardClick');
                let firstClass2 = this.template.querySelector(".subMenu2");
                firstClass2.classList.remove('subMenuBoardClick');
                let firstClass4 = this.template.querySelector(".subMenu4");
                firstClass4.classList.remove('subMenuBoardClick');
            }
            if (this.template.querySelector(".mainMenu4").contains(evt.target)) {
                let firstClass1 = this.template.querySelector(".subMenu1");
                firstClass1.classList.remove('subMenuBoardClick');
                let firstClass2 = this.template.querySelector(".subMenu2");
                firstClass2.classList.remove('subMenuBoardClick');
                let firstClass3 = this.template.querySelector(".subMenu3");
                firstClass3.classList.remove('subMenuBoardClick');
            }
        });
        registerListener('MainContent', this.pubsubfunctionMainContent, this);
    }
    navigatetoMyPaymentSource() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Payment Source",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'payment-source'
            }
        });
    }}
    navigateToPaymentOptions() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Payment Options",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','true');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'paymentoptions'
            }
        });
    }}
    navigateToPrintableForms() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Printable Forms",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','false');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'printable-forms'
            },
            state: {
                sacRecordId: this.IDSAC
            }
        });
    }}
    navigateToProtectionProducts() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Protection Products",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','true');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'protection-products'
            }
        });
    }}
    navigateToLeaseVSFinance() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Lease vs Finance",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','true');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'lease-vs-finance'
            }
        });
    }}

    navigateToAddAccount() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Add a Account",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'add-a-finance-account'
            },
        });
    }}


    pubsubfunctionMainContent(data) {
        this.mainContentData = '#' + data;
        console.log('data in header-----> ', data);
    }

    navigateTohelpCenter() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Help Center",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','false');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'help-center'
            }

        });
    }}
    navigateToCreaditPreApproval() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Credit Pre-Approval",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','true');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'creditpreapproval'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }}
    navigateTohondaLoyaltyBenfits() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Loyalty",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','true');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'honda-loyalty-benefits'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }}
    navigateToAcuraLoyalotyPage() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Acura Loyalty",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','true');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'acura-loyalty-advantage'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }}
    navigateToEndOfTerm() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:End of Lease",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','true');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'end-of-lease'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }}
    navigateToContactUsPost() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Customer Service Pre-Login",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','false');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-pre-login'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }}


    navigateToProfilePage(evt) {
        evt.preventDefault();
        let hondaLoginUrl = AHFC_CIAM_HONDA_LOGIN_URL + 'profile/' + this.ciamUserId + '?app=' + AHFC_CIAM_HONDA_APP_ID + '&RelayState=/s/dashboard';
        let acuraLoginUrl = AHFC_CIAM_ACURA_LOGIN_URL + 'profile/' + this.ciamUserId + '?app=' + AHFC_CIAM_ACURA_APP_ID + '&RelayState=/s/dashboard';
        console.log(hondaLoginUrl);
        console.log('#####',sessionStorage.getItem('domainBrand'));
        if (sessionStorage.getItem('domainBrand').toLowerCase() == 'acura') {
            window.location.href = acuraLoginUrl;
        } else if (sessionStorage.getItem('domainBrand').toLowerCase() == 'honda') {
            window.location.href = hondaLoginUrl;
        }
        return false;
    }


    get logoutUrl() {
        sessionStorage.removeItem('salesforce_id');
        sessionStorage.clear();
        
        const sitePrefix = basePath.replace(/\/s$/i, ""); // site prefix is the site base path without the trailing "/s"
        console.log('sitePrefix >>>>>>>>>>>>>>>>>>>>>', sitePrefix);
        return sitePrefix + "/secur/logout.jsp";

    }
    navigateToLogout(evt){
        evt.preventDefault();
        
        sessionStorage.removeItem('salesforce_id');
        sessionStorage.clear();
        
        const sitePrefix = basePath.replace(/\/s$/i, ""); // site prefix is the site base path without the trailing "/s"
        console.log('sitePrefix >>>>>>>>>>>>>>>>>>>>>', sitePrefix);
        window.location.href =  sitePrefix + "/secur/logout.jsp";
    }
    
}