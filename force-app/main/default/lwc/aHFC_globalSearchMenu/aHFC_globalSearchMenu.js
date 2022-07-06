import { LightningElement,track,wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import {labels} from "c/aHFC_dashboardConstantsUtil";
import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import { loadStyle } from "lightning/platformResourceLoader";
import userImgUrl from "@salesforce/resourceUrl/AHFC_UserImg";
import hondaLogo from "@salesforce/resourceUrl/Honda_financial_logo";
import FORM_FACTOR from "@salesforce/client/formFactor";
import basePath from "@salesforce/community/basePath";
import isguest from '@salesforce/user/isGuest';
import ACURA_HOME_URL from "@salesforce/label/c.Acura_home_url";
import HONDA_HOME_URL from "@salesforce/label/c.Honda_home_url";
import AHFC_CIAM_HONDA_LOGIN_URL from "@salesforce/label/c.AHFC_CIAM_HONDA_LOGIN_URL";
import AHFC_CIAM_ACURA_LOGIN_URL from "@salesforce/label/c.AHFC_CIAM_ACURA_LOGIN_URL";
import AHFC_CIAM_HONDA_APP_ID from "@salesforce/label/c.AHFC_CIAM_HONDA_APP_ID";
import AHFC_CIAM_ACURA_APP_ID from "@salesforce/label/c.AHFC_CIAM_ACURA_APP_ID";
import AHFC_CIAM_SF_User_Id from '@salesforce/schema/User.AHFC_CIAM_SF_User_Id__c';
import AHFC_Community_Named_Dashboard from "@salesforce/label/c.AHFC_Community_Named_Dashboard";

export default class AHFC_globalSearchMenu extends LightningElement {
    @track isUserProfile = false;
    @track showdesktop;
    @track labels = labels;
    @track isMobileUserProfile =false;
    isCheck = isguest;
    userName;
    @track isDisplay = true;
    @track isSubMenuOpenMenu;
    @track hondaLoginUrl;
    @track acuraLoginUrl;
    @track ciamUserId;

    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD,AHFC_CIAM_SF_User_Id]
    }) wireuser({
        error,
        data
    }) {

        console.log('GUEST USER : '+this.isCheck); 
        if (error) {
           console.log('error',error);
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
    connectedCallback(){
        document.addEventListener("click", (evt) => {
            if (evt.target.dataset.xyz == undefined) {
                this.isUserProfile = false;
            }
        });
        loadStyle(this, ahfctheme + "/theme.css").then(() => { });
        if (FORM_FACTOR == this.labels.LargeLabel) {
            this.showdesktop = true;
            this.showmobile = false;
        } else if (FORM_FACTOR == this.labels.MediumLabel) {
            this.showdesktop = false;
            this.showmobile = true;
        } else {
            this.showdesktop = false;
            this.showmobile = true;
        }
        this.hondaLoginUrl = AHFC_CIAM_HONDA_LOGIN_URL +'login/?app='+ AHFC_CIAM_HONDA_APP_ID;
        this.acuraLoginUrl = AHFC_CIAM_ACURA_LOGIN_URL +'login/?app='+ AHFC_CIAM_ACURA_APP_ID;
    }
    
    onUserProfileClick() {
        this.isUserProfile = !this.isUserProfile
        this.isSubMenuOpenMenu = false;
    }
    get logoutUrl() {
        const sitePrefix = basePath.replace(/\/s$/i, ""); 
        return sitePrefix + "/secur/logout.jsp";

    }
    onUserProfileClickforMobile() {
        this.isMobileUserProfile = !this.isMobileUserProfile;
        this.isSubMenuOpenMenu = false;
    }
    navigateToCommunityPages(){
        console.log('this.isCheck',this.isCheck);
        if(this.isCheck){
            this.navigateToHome();
        }else{
            this.navigateToDashboard();
        }
    }
    navigateToHome(){
        let domainBrand = sessionStorage.getItem('domainBrand');
        let url = window.location.href;
        if(domainBrand == null){
            if (url.includes('honda.')) {
            domainBrand = 'Honda'
            }else if (url.includes('acura.')) {
                domainBrand='Acura';
            }
        }
        console.log(ACURA_HOME_URL);
        console.log(domainBrand);
        console.log(HONDA_HOME_URL);
        if(domainBrand == 'Acura'){
            window.open( ACURA_HOME_URL,'_self');
           // window.location.href = ACURA_HOME_URL;
        }else if(domainBrand == 'Honda'){
            window.open( HONDA_HOME_URL,'_self');
       //     window.location.href = HONDA_HOME_URL;
        }
        //domainBrand
        /*this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: ''
            }
    
        });*/
    }
    navigateToDashboard() {
    this[NavigationMixin.Navigate]({
        type: "comm__namedPage",
        attributes: {
            pageName: AHFC_Community_Named_Dashboard
        }

    });
}

navigateToLoginPage() {
    let url = window.location.href;
    let loginUrl;
    if (url.includes('honda.')) {
        loginUrl = this.hondaLoginUrl +'&RelayState=/s/ciam-login-successfull?Brand=honda';
    } else if (url.includes('acura.')) {
        loginUrl = this.acuraLoginUrl + '&RelayState=/s/ciam-login-successfull?Brand=acura';
    }
    window.location.href = loginUrl;
}
navigateToProfilePage(evt){
    evt.preventDefault();
    let hondaLoginUrl = AHFC_CIAM_HONDA_LOGIN_URL+'profile/'+this.ciamUserId+'?app='+ AHFC_CIAM_HONDA_APP_ID+'&RelayState=/MyAccount';
    let acuraLoginUrl = AHFC_CIAM_ACURA_LOGIN_URL +'profile/'+this.ciamUserId+'?app='+  AHFC_CIAM_ACURA_APP_ID+'&RelayState=/MyAccount';
    console.log(hondaLoginUrl);
    console.log(acuraLoginUrl);
    if(sessionStorage.getItem('domainBrand') == 'acura'){
        window.location.href = acuraLoginUrl;
    }else if(sessionStorage.getItem('domainBrand') == 'honda'){
        window.location.href = hondaLoginUrl;
    }
    let url = window.location.href;
    if (url.includes('honda.')) {
        window.location.href = acuraLoginUrl;
        
    } else if (url.includes('acura.')) {
        window.location.href = acuraLoginUrl;
    }
    return false;
}
}