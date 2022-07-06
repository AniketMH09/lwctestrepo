/* Component Name   :    aHFC_Menu
* @Description      :   LWC for Menu Header
* Modification Log  :
* --------------------------------------------------------------------------- 
* Developer                          Date                    Description
* ---------------------------------------------------------------------------
* Prabu Mohanasundaram               May 03 2021             Created
* Prabu Mohanasundaram               Jul 06 2021             added pusub function to get the finance account data and getAccount info from dashboard
* Shristi Agarwal                    July 30 2021            modified for US: 8745
* Aswin Jose                         Aug 02 2021             Added changes for US :8396
********************************************************************************/
import { api, LightningElement, track, wire } from "lwc";
import hondaLogo from "@salesforce/resourceUrl/Honda_financial_logo";
import userImgUrl from "@salesforce/resourceUrl/AHFC_UserImg";
import NAME_FIELD from '@salesforce/schema/User.Name';
import AHFC_CIAM_SF_User_Id from '@salesforce/schema/User.AHFC_CIAM_SF_User_Id__c';
import USER_ID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
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
import AHFC_CIAM_HONDA_APP_ID from "@salesforce/label/c.AHFC_CIAM_HONDA_APP_ID";
import AHFC_CIAM_ACURA_APP_ID from "@salesforce/label/c.AHFC_CIAM_ACURA_APP_ID";
import AHFC_CIAM_HONDA_LOGIN_URL from "@salesforce/label/c.AHFC_CIAM_HONDA_LOGIN_URL";
import AHFC_CIAM_ACURA_LOGIN_URL from "@salesforce/label/c.AHFC_CIAM_ACURA_LOGIN_URL";
import AHFC_helpCenter_URL from "@salesforce/label/c.AHFC_helpCenter_URL";
import { fireAdobeEvent } from "c/aHFC_adobeServices";

import basePath from "@salesforce/community/basePath";
import AHFC_Community_Named_Dashboard from "@salesforce/label/c.AHFC_Community_Named_Dashboard";
import ahfc_hondaMobileLogo from "@salesforce/resourceUrl/ahfc_hondaMobileLogo";

//import { publish,createMessageContext,releaseMessageContext, subscribe, unsubscribe } from 'lightning/messageService';
import mainContent from "@salesforce/messageChannel/MainContent__c";

import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled }  from 'lightning/empApi';


const CONSTANTS = getConstants();
export default class aHFC_Menu extends NavigationMixin(LightningElement) {
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
    @track boolEnrolledEZP = false;
    @track showManageEZPButton = false;
    @track showEZPButton = false;
    @track isMobileUserProfile = false;
    @track mainContentData = ''; // Added by Akash as Part of Landmark ADA compliance
    userName;
    ciamUserId = '';
    @track adobepagename = '';
    @track isContentPage = true;
    @track pageRef;

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
 
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.pageRef = currentPageReference;
        console.log('98',this.pageRef.attributes.name);
        if (
          this.pageRef.attributes.name == "submit_ccpa_request__c" ||
          this.pageRef.attributes.name == "Submit_SCRA_Request__c"
        ) {
          this.mainContentData = "#main-container";
        }
    }
    get hondaMobileLogoUrl() {
        return ahfc_hondaMobileLogo;
    }

    
    /*Added for 7239 US - Start*/
    /*
* @Description: added pusub function to get the finance account data and getAccount info from dashboard*/
    pubsubfunction(payload) {
        console.log('50', JSON.parse(payload));
        this.payLoadWrapper = JSON.parse(payload);
        this.getAccountInfo = this.payLoadWrapper.getAccountInfo;
        console.log('this.getAccountInfo ', this.getAccountInfo);
        this.isWebAccLocked = this.payLoadWrapper.finaAccountData.AHFC_Web_Account_Locked__c;
        console.log('this.isWebAccLocked ', this.isWebAccLocked);
        console.log('this.isWebAccLocked ', this.payLoadWrapper.finaAccountData);

        this.isArchived = this.payLoadWrapper.finaAccountData.AHFC_Fl_Archived__c;
        console.log('this.isArchived ', this.isArchived);
        this.boolEnrolledEZP = this.payLoadWrapper.finaAccountData.boolenrolled; //US:8396 Aswin Jose - To check if the finance account is enrolled in EZP
        console.log('Bool Enrol EZP :  ', this.boolEnrolledEZP);
        sessionStorage.setItem('salesforce_id_content', this.payLoadWrapper.finaAccountData.Id);
        //	this.IDSAC = this.payLoadWrapper.finaAccountData.serAccRec.Id;
        if (this.getAccountInfo.isWebsiteRestricted == true) {
            console.log('111');
            this.isDisplay = true;
            this.isDoNotDisplay = false;
            this.showManageEZPButton = false;
            this.showEZPButton = false;

        } else if (this.isWebAccLocked === 'Y') {
            console.log('222');
            this.isDisplay = true;
            this.isDoNotDisplay = false;
            this.showManageEZPButton = false;
            this.showEZPButton = false;

        } else if (this.isArchived === 'Y') {
            console.log('9999');
            this.isDisplay = true;
            this.isDoNotDisplay = false;
            this.showManageEZPButton = false;
            this.showEZPButton = false;
        }
        else {
            console.log('444');
            this.isDisplay = true;
            this.isDoNotDisplay = true;
        }


        console.log('DONOT DISPLAY : ' + this.isDoNotDisplay);
        console.log('EZP : ' + this.boolEnrolledEZP);
        //US:8396 start-  Aswin Jose 
        if (this.isDoNotDisplay == true && this.boolEnrolledEZP) {
            this.showManageEZPButton = true; //When Boolean EZP enrolled is true
            this.showEZPButton = false;
        }
        if (this.isDoNotDisplay == true && !this.boolEnrolledEZP) {
            this.showEZPButton = true; //When Boolean EZP enrolled is false
            this.showManageEZPButton = false;
        }
        //US:8396 End-  Aswin Jose 

    }
    /*Added for 7239 US - End*/

    /*navigating to make-a-apyment page as part of 4531*/



    navigateTomakeotp() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Make a Payment",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');

        sessionStorage.setItem('salesforce_id', this.payLoadWrapper.finaAccountData.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },
            state: {
                showOTPDefault: true
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    }

    navigatetopayment() {
        if( window.event.which == 1 ||  window.event.which == 13){
        console.log('EntryNavigatePaymt>>>');
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Make a Payment",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('salesforce_id', this.payLoadWrapper.finaAccountData.Id);
        console.log('salesforce_id >>>> ', this.payLoadWrapper.finaAccountData.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },
            state: {
                showOTPDefault: true,
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    }
    /*navigating to make-a-apyment page as part of 4531*/
    navigateToEasypayByDefault() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Make a Payment",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('salesforce_id', this.payLoadWrapper.finaAccountData.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },
            state: {
                showeasypay: true
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
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
    addClass(evt) {
        evt.preventDefault();
        //console.log('addClassEntry', this.isDisplay + '----- ');
        evt.currentTarget.parentElement.classList.add('AHFC_Smenuhover');
        evt.currentTarget.classList.add('AHFC_MenubordBoardClick');
        //subMenuBoardClick



    }
    myAccountLabelClicked(evt){
        let code = evt.keyCode || evt.which;
        console.log('code',code);
        if(code == 1){
            this.navigateToDashboard();
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



    onButtonClickNavigate() {
        evt.preventDefault();
        console.log('onButtonClickNavigate ---------------------------entery', evt.keyCode);
        if (evt.keyCode === 13) {
            let navigateMethod = evt.currentTarget.dataset.id;
            console.log('navigateMethod', navigateMethod)
            if (navigateMethod == 'navigateToDashboard') {

            } else if (navigateMethod == 'navigateToDashboard') {
                this.navigateToDashboard();

            } else if (navigateMethod == 'navigatetopayment') {
                this.navigatetopayment();

            } else if (navigateMethod == 'navigateToEasypayByDefault') {
                this.navigateToEasypayByDefault();

            }
        } else {
            return true;
        }
    }
    /*  onclickNavigate(evt){
          console.log('onclickNavigate ---------------------------entery');
          evt.preventDefault();
          if(evt.detail == 1 ){
             let navigateMethod = evt.currentTarget.dataset.id;
             if(navigateMethod == 'navigateToDashboard'){
              this.navigateToDashboard();
             }else if(navigateMethod == 'navigateToDashboard'){
                 this.navigateToDashboard();
  
             }else if(navigateMethod == 'navigatetopayment'){
              this.navigatetopayment();
                 
             }else if(navigateMethod == 'navigateToEasypayByDefault'){
              this.navigateToEasypayByDefault();
                 
              } 
          }
          return false;   
      } */
    addClass1(evt) {
        evt.preventDefault();
        evt.currentTarget.classList.add('AHFC_Smenuhover');
        evt.currentTarget.classList.add('submenuDisplay');
        evt.currentTarget.classList.add("hover");
        /*
        console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        let liCom = document.queryselector('.subMenu1');
        console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> liCom',liCom);
        liCom.classList.add('submenuDisplay') ;
        console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>',liCom);*/
        // this.template.querySelectorAll('.subMenu');
        //display: none;

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
        //  this.navigateToDashboard();
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

    onUserProfileClickforMobile() {
        this.isMobileUserProfile = !this.isMobileUserProfile;
        this.isSubMenuOpenMenu = false;
    }
    get logoutUrl() {
        sessionStorage.removeItem('salesforce_id');
        sessionStorage.clear();

        const sitePrefix = basePath.replace(/\/s$/i, ""); // site prefix is the site base path without the trailing "/s"
        console.log('sitePrefix >>>>>>>>>>>>>>>>>>>>>', sitePrefix);
        return sitePrefix + "/secur/logout.jsp";

    }    
    // Added by Akash as Part of Landmark ADA compliance
    pubsubfunctionMainContent(data) {
        this.mainContentData = '#' + data;
        console.log('data in header-----> ', data);
    }
    
    disconnectedCallback() {
       // releaseMessageContext(this.context);
    }
 
    // channel;
    // context = createMessageContext();
    connectedCallback() {
this.handleSubscribe();
        //const parentPage = this;
        // this.channel = subscribe(this.context, mainContent,  (event) => {
        //     console.log('hiii');
        //     console.log('in event... ',event);
        //     this.mainContentData = '#main-container';
        //     console.log('in lms ');
        //     if (event != null) {
        //         console.log('in event... ',event);
        //         //const message = event.messageBody;
        //         //const source = event.source;
        //         //parentPage.receivedMessage = 'Message: ' + message + '. Sent From: ' + source;
        //     }
        // });

        console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>123contentPageCheckMenu');
        this.contentPageCheckMenu();
        console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>123contentPageCheckMenu');
        console.log('this.pageRef', this.pageRef);
        this.adobepagename = this.pageRef.attributes.name;
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
        registerListener('populateMenu', this.contentPageCheckMenu, this); // Added by Akash as Part of Landmark ADA compliance


        /*       var menuItems = this.template.querySelectorAll('.subMenu');
               console.log('1232132>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>',menuItems);
       Array.prototype.forEach.call(menuItems, function(el, i){
           el.querySelector('a').addEventListener("keyup",  function(evt){
               console.log('1232132>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
               if (this.parentNode.className == "subMenu") {
                   this.parentNode.className = "subMenu open";
                   this.setAttribute('aria-expanded', "true");
               } else {
                   this.parentNode.className = "subMenu";
                   this.setAttribute('aria-expanded', "false");
               }
               evt.preventDefault();
               return false;
           });
       });*/
        registerListener('financeAccountInfo', this.pubsubfunction, this);

        //	registerListener('BlankDashboardShow', this.pubsubBlankDashboardfn, this);
        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
        console.log('form factor',FORM_FACTOR );
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
        sessionStorage.setItem('salesforce_id', this.payLoadWrapper.finaAccountData.Id);
        console.log('salesforce Id >>>> ', this.payLoadWrapper.finaAccountData.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'payment-source'
            },
            state: {
                sacRecordId: this.payLoadWrapper.finaAccountData.Id
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    }
 
    navigateToContactUsPost() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Customer Service Post-Login",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        console.log('736');
        sessionStorage.setItem('salesforce_id',this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
        console.log('738',sessionStorage.getItem('salesforce_id'));
       if(sessionStorage.getItem('salesforce_id') == 'null' || sessionStorage.getItem('salesforce_id') == undefined){
           console.log('740');
        sessionStorage.setItem('ContentPageCheck','false');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-pre-login'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
        return false;

       }

       console.log('753');
        sessionStorage.setItem('ContentPageCheck','false');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'contact-us-post-login'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
        return false;
    }
    }
    navigateToPaymentOptions() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Payment Options",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','false');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'paymentoptions'
            },
            state: {
                sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content')
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    }
    navigateToPrintableForms() {
        if( window.event.which == 1 ||  window.event.which == 13){       
            let adobedata = {
                'Event_Metadata.action_type': 'Hyperlink',
                "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Printable Forms",
                "Event_Metadata.action_category": "Header Navigation",
                "Page.page_name": this.adobepagename

            };
            fireAdobeEvent(adobedata, 'click-event');            
            sessionStorage.setItem('salesforce_id', this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
            sessionStorage.setItem('ContentPageCheck','false');
            this[NavigationMixin.Navigate]({
                type: "comm__namedPage",
                attributes: {
                    pageName: 'printable-forms'
                },
                state: {
                    sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content')
                }
            });       
        }
    }


    navigateToPrintableFormsMobile() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Printable Forms",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('salesforce_id', this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
        sessionStorage.setItem('ContentPageCheck','false');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'printable-forms'
            },
            state: {
                sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content')
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    }

    closeOwnerPopup(event) {
        let code = event.keyCode || event.which;
        if (code === 9) {
            let firstClass4 = this.template.querySelector(".subMenu4");
            firstClass4.classList.remove('subMenuBoardClick');
            this.removeClass(event);
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
        }     
    }
    navigateToProtectionProductsMobile() {
        if( window.event.which == 1 ||  window.event.which == 13){
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
                pageName: 'protection-products'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    }



    navigateToLeaseVSFinance() {
        if( window.event.which == 1 ||  window.event.which == 13){
        console.log(" Entering navigation of lease vs finance");
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Lease vs Finance",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','true');
        console.log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>header nav lease-vs-finance ContentPageCheck');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'lease-vs-finance'
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    }

    contentPageCheckMenu()
    {
        let sessioneddata = sessionStorage.getItem('ContentPageCheck');
        console.log('Session Data for header--->1232321312',sessioneddata);
        if(sessioneddata == 'true')
        {
            this.isContentPage=false;
            this.showEZPButton=false;
        }
        else
        {
            this.isContentPage=true;
            this.showEZPButton=true;
        }
    }
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
    }
    }
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
    }
    }
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
    }
    }

    //Added by Aniket - 8/2/2021 for navigation to credit pre approval page
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
        }
        
    }



    navigateToCommunicationPage() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Communication Preferences",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('salesforce_id',this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
      //  console.log('salesforce_id_CommPreff >>>> ', this.payLoadWrapper.finaAccountData.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "communicationpreference"
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    }

    navigatetoschedulepayments() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Already Made a Payment",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "manage-payment"
            },
            state: {
                sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content')
            }
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    }
    navigateToCorrespondance() {     
        if( window.event.which == 1 ||  window.event.which == 13){  
            let adobedata = {
                'Event_Metadata.action_type': 'Hyperlink',
                "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Correspondence",
                "Event_Metadata.action_category": "Header Navigation",
                "Page.page_name": this.adobepagename

            };
            fireAdobeEvent(adobedata, 'click-event');            
            this[NavigationMixin.Navigate]({
                type: "comm__namedPage",
                attributes: {
                    pageName: 'correspondence'
                },
                state: {
                    sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content')
                }

            });
            this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
        }
    }

    navigateToCorrespondanceMobile() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Correspondence",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'correspondence'
            },
            state: {
                sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content')
            }

        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    }


    navigateToDashboard() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Dashboard",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        sessionStorage.setItem('ContentPageCheck','false');
        sessionStorage.setItem('salesforce_id', this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: AHFC_Community_Named_Dashboard
            }

        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    }


    navigateToFinanceAccountDetails() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Finance Account Details",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'finance-account-profile'
            },
            state: {
               // sacRecordId: this.payLoadWrapper.finaAccountData.Id
               sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content')
            }

        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
    }
    navigateToStatements() {
        if( window.event.which == 1 ||  window.event.which == 13){
        let adobedata = {
            'Event_Metadata.action_type': 'Hyperlink',
            "Event_Metadata.action_label": this.adobepagename + ":Hyperlink:Statements",
            "Event_Metadata.action_category": "Header Navigation",
            "Page.page_name": this.adobepagename

        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'singlestatement'
            },
            state: {
                sacRecordId: this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content')
            }

        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
    }
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
        /*var urlToNavigate = AHFC_helpCenter_URL;
        this[NavigationMixin.Navigate]({
            type: "standard__webPage",
            attributes: {
                url: urlToNavigate
            }
        });*/
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'help-center'
            }

        });
    }
    } 

    navigateToProfilePage(evt) {
        //sessionStorage.removeItem('salesforce_id');
        //sessionStorage.clear();
        evt.preventDefault();
        let hondaLoginUrl = AHFC_CIAM_HONDA_LOGIN_URL + 'profile/' + this.ciamUserId + '?app=' + AHFC_CIAM_HONDA_APP_ID + '&RelayState=/s/dashboard';
        let acuraLoginUrl = AHFC_CIAM_ACURA_LOGIN_URL + 'profile/' + this.ciamUserId + '?app=' + AHFC_CIAM_ACURA_APP_ID + '&RelayState=/s/dashboard';
        console.log(hondaLoginUrl);
        console.log(acuraLoginUrl);
        if (sessionStorage.getItem('domainBrand').toLowerCase() == 'acura') {
            window.location.href = acuraLoginUrl;
        } else if (sessionStorage.getItem('domainBrand').toLowerCase() == 'honda') {
            window.location.href = hondaLoginUrl;
        }
        return false;
    }

    onlogoclick(){
        if( window.event.which == 1 ||  window.event.which == 13){
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: AHFC_Community_Named_Dashboard
            }

        });
    }
    }
    navigateToLogout(evt){
        evt.preventDefault();
        
        sessionStorage.removeItem('salesforce_id');
        sessionStorage.clear();
        
        const sitePrefix = basePath.replace(/\/s$/i, ""); // site prefix is the site base path without the trailing "/s"
        console.log('sitePrefix >>>>>>>>>>>>>>>>>>>>>', sitePrefix);
        window.location.href =  sitePrefix + "/secur/logout.jsp";
    }
    onPaymentActivityClick() {
        if( window.event.which == 1 ||  window.event.which == 13){
        sessionStorage.setItem('isRefreshed', 'false');
        sessionStorage.setItem('salesforce_id', this.payLoadWrapper? this.payLoadWrapper.finaAccountData.Id: sessionStorage.getItem('salesforce_id_content'));
        let adobedata = {
          'Event_Metadata.action_type': 'Hyperlink',
          "Event_Metadata.action_label": this.adobepagename+ "Hyperlink:View Activity Details",
          "Event_Metadata.action_category": "Header Navigation",
          "Page.page_name": this.adobepagename,
        };
        fireAdobeEvent(adobedata, 'click-event');
        this[NavigationMixin.Navigate]({
          type: "comm__namedPage",
          attributes: {
            pageName: 'manage-payment'
          },
        });
        this.isSubMenuOpenMenu = !this.isSubMenuOpenMenu;
      }
    }


    //platform event dont deploy this****************
    channelName = '/event/platform_test__e';
    subscription = {};

    handleSubscribe() {
       // this.registerErrorListener();
        console.log('1264');
        subscribe(this.channelName, -1, this.messageCallback).then(response => {
            // Response contains the subscription information on subscribe call
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
           
        })
    }

    messageCallback(response){
      console.log('1274', response);
    }
    registerErrorListener() {
        // Invoke onError empApi method
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }
}