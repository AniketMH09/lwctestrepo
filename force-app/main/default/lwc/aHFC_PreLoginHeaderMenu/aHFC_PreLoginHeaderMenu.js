/* Component Name   :    AHFC_PreLoginHeaderMenu
* @Description      :   LWC for Menu Header for pre login page
* Modification Log  :
* --------------------------------------------------------------------------------------------------- 
* Developer                          Date                    Description
* ---------------------------------------------------------------------------------------------------
* Aswin Jose                         May 03 2021             
* Sagar Ghadigaonkar                 Aug 11 2021            using this header component for prelogin
*******************************************************************************************************/
import { api, LightningElement, track, wire } from "lwc";
import hondaLogo from "@salesforce/resourceUrl/Honda_financial_logo";
import userImgUrl from "@salesforce/resourceUrl/AHFC_UserImg";
import acuraLogo from "@salesforce/resourceUrl/AHFC_Acura_Header_Logo";
import { loadStyle } from "lightning/platformResourceLoader";
import FORM_FACTOR from "@salesforce/client/formFactor";
import { labels } from "c/aHFC_dashboardConstantsUtil";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import { NavigationMixin } from "lightning/navigation";
import isguest from '@salesforce/user/isGuest';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { getConstants } from "c/ahfcConstantUtil";
import AHFC_Community_Named_Dashboard from "@salesforce/label/c.AHFC_Community_Named_Dashboard";
import AHFC_helpCenter_URL from "@salesforce/label/c.AHFC_helpCenter_URL";
import ahfc_hondaMobileLogo from "@salesforce/resourceUrl/ahfc_hondaMobileLogo";

import AHFC_CIAM_HONDA_APP_ID from "@salesforce/label/c.AHFC_CIAM_HONDA_APP_ID";
import AHFC_CIAM_ACURA_APP_ID from "@salesforce/label/c.AHFC_CIAM_ACURA_APP_ID";
import AHFC_CIAM_HONDA_LOGIN_URL from "@salesforce/label/c.AHFC_CIAM_HONDA_LOGIN_URL";
import AHFC_CIAM_ACURA_LOGIN_URL from "@salesforce/label/c.AHFC_CIAM_ACURA_LOGIN_URL";
import { fireAdobeEvent } from "c/aHFC_adobeServices";

import NAME_FIELD from '@salesforce/schema/User.Name';
import AHFC_CIAM_SF_User_Id from '@salesforce/schema/User.AHFC_CIAM_SF_User_Id__c';
import USER_ID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import basePath from "@salesforce/community/basePath";


const CONSTANTS = getConstants();
export default class AHFC_PreLoginHeaderMenu extends NavigationMixin(LightningElement) {
    @track payLoadWrapper;
    @track isSubMenuOpenAc = false;
    @track isUserProfile = false;
    @track isSubMenuOpenSupport = false;
    @track isSubMenuOpenFinance = false;
    @track isSubMenuOpenMenu = false;
    @track isSubMenuOpenOwner = false;
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
    @track boolEnrolledEZP = false;
    @track showManageEZPButton = false;
    @track showEZPButton = false;
    @track hondaLoginUrl;
    @track acuraLoginUrl;
    @track mainContentData = '';
    @track adobepagename = '';
    @track isMobileUserProfile = false;
    userName;
    ciamUserId;

    @wire(CurrentPageReference) pageRef;

    label = {
        AHFC_helpCenter_URL,
        AHFC_CIAM_HONDA_APP_ID,
        AHFC_CIAM_ACURA_APP_ID,
        AHFC_CIAM_HONDA_LOGIN_URL,
        AHFC_CIAM_ACURA_LOGIN_URL
    }

    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD, AHFC_CIAM_SF_User_Id]
    }) wireuser({
        error,
        data
    }) {

        console.log('GUEST USER : ' + this.isCheck);
        if (error) {
            console.log('error', error);
        } else if (data) {
            this.userName = data.fields.Name.value;
            this.ciamUserId = data.fields.AHFC_CIAM_SF_User_Id__c.value;
        }
    }

    get hondaLogoUrl() {
        return hondaLogo;
    }
    get userImgUrl() {
        return userImgUrl;
    }
    get AcuraLogoUrl() {
        return acuraLogo;
    }
    get hondaMobileLogoUrl() {
        return ahfc_hondaMobileLogo;
    }

    addClass(evt) {
        evt.currentTarget.parentElement.classList.add('AHFC_Smenuhover');
    }
    removeClass(evt) {
        evt.currentTarget.parentElement.classList.remove('AHFC_Smenuhover');
    }
    onHamburgerClick() {
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
        this.isMobileUserProfile = false;
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
    // Added for US 8745
    onSubmenuOwnerClick() {
        this.isSubMenuOpenOwner = !this.isSubMenuOpenOwner;
    }
    onSubmenuAccClick() {
        this.isSubMenuOpenAc = !this.isSubMenuOpenAc;
    }
    onUserProfileClick() {
        console.log('qqqq');
        this.isUserProfile = !this.isUserProfile;
        this.isSubMenuOpenMenu = false;
        this.removeOtherClass();
    }

    pubsubfunctionMainContent(data) {
        this.mainContentData = '#' + data;
    }
    connectedCallback() {
        this.adobepagename = this.pageRef.attributes.name;
        registerListener('MainContent', this.pubsubfunctionMainContent, this);
        this.hondaLoginUrl = AHFC_CIAM_HONDA_LOGIN_URL + 'login/?app=' + AHFC_CIAM_HONDA_APP_ID;
        this.acuraLoginUrl = AHFC_CIAM_ACURA_LOGIN_URL + 'login/?app=' + AHFC_CIAM_ACURA_APP_ID;

        document.addEventListener("click", (evt) => {
            if (evt.target.dataset.xyz == undefined) {
                this.isUserProfile = false;
                //  this.isSubMenuOpenMenu = false;
            }

        });


        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
        console.log('FORM_FACTOR',FORM_FACTOR);
        if (FORM_FACTOR == this.labels.LargeLabel) {
            this.showdesktop = true;
            this.showmobile = false;
        } else if (FORM_FACTOR == this.labels.MediumLabel) {
            this.showdesktop = true;
            this.showmobile = false;
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

    }


    navigateToPaymentOptions() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Payment Options",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        console.log('Navigate to payment options!!!!!!!');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'paymentoptions-prelogin'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    navigateToPrintableForms() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Printable Forms",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'printable-forms-pre-login'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    navigateToProtectionProducts() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Protection Products",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'protection-products-pre-login'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    navigateToLeaseVSFinance() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Lease vs Finance",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'lease-vs-finance-prelogin'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    navigateTohondaLoyaltyBenfits() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Loyalty",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'honda-loyalty-benefits-pre-login'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    navigateToEndOfTerm() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:End of Lease",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'end-of-lease-pre-login'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    navigateToAcuraLoyalotyPage() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Acura Loyalty",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'acura-loyalty-advantage-pre-login'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }

    navigateToCreaditPreApproval() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Credit Pre-Approval",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'creditpreapproval-prelogin'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }


    navigateToContactUsPage() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Customer Service Pre-Login",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-pre-login'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }

    navigateTohelpCenter() {
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Help Center",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        

        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'help-center'
            }

        });
    }

    /*Start  US :10993   navigate to login page*/
    navigateToLoginPage() {
        let url = window.location.href;
        let loginUrl;
        if (url.includes('honda.')) {
            loginUrl = this.hondaLoginUrl + '&RelayState=/s/ciam-login-successfull?Brand=honda';
        } else if (url.includes('acura.')) {
            loginUrl = this.acuraLoginUrl + '&RelayState=/s/ciam-login-successfull?Brand=acura';
        }
        else {
            loginUrl = this.hondaLoginUrl + '&RelayState=/s/ciam-login-successfull?Brand=honda';
        }
        window.location.href = loginUrl;
    }
    navigateToPage(){
        if(this.isCheck){
            this.navigateToLoginPage();
        }else{
            this[NavigationMixin.Navigate]({
                type: "comm__namedPage",
                attributes: {
                    pageName: AHFC_Community_Named_Dashboard
                }
    
            });
        }
    }
    onUserProfileClickforMobile() {
        this.isMobileUserProfile = !this.isMobileUserProfile;
        this.isSubMenuOpenMenu = false;
    }

    navigateToProfilePage(evt) {
        evt.preventDefault();
        let hondaLoginUrl = AHFC_CIAM_HONDA_LOGIN_URL + 'profile/' + this.ciamUserId + '?app=' + AHFC_CIAM_HONDA_APP_ID + '&RelayState=/s/dashboard';
        let acuraLoginUrl = AHFC_CIAM_ACURA_LOGIN_URL + 'profile/' + this.ciamUserId + '?app=' + AHFC_CIAM_ACURA_APP_ID + '&RelayState=/s/dashboard';
        console.log(hondaLoginUrl);
        console.log(acuraLoginUrl);
        if (sessionStorage.getItem('domainBrand') == 'acura') {
            window.location.href = acuraLoginUrl;
        } else if (sessionStorage.getItem('domainBrand') == 'honda') {
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

    onlogoclick(){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'home'
            },
        });
    }
    navigateToLogout(evt){
        evt.preventDefault();
        
        sessionStorage.removeItem('salesforce_id');
        sessionStorage.clear();
        
        const sitePrefix = basePath.replace(/\/s$/i, ""); // site prefix is the site base path without the trailing "/s"
        console.log('sitePrefix >>>>>>>>>>>>>>>>>>>>>', sitePrefix);
        window.location.href =  sitePrefix + "/secur/logout.jsp";
    }

    onclickAddClassFinance(evt) {
        
        let code = evt.keyCode || evt.which;
        console.log('onclickAddfianance ---------------------------entery',code);
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
    
    removeOtherClass(){
        console.log('www');
       // this.removeSubmenu1();
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
        console.log('www');
        let firstClass = this.template.querySelector(".subMenu4");
      console.log('mmm',firstClass);
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
        this.isMobileUserProfile = false;
        this.isUserProfile = false;
        this.isSubMenuOpenFinance = false;
        this.isSubMenuOpenSupport = false;
        this.isSubMenuOpenAc = false;
        this.isSubMenuOpenOwner = false; //Added  for US 8745
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
}