/* Apex Class Name       :    aHFC_loginFlow
    * Description        :    This Component is used to control login and register flow
    * Modification Log   :    
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Akash                     25/08/2021               Created
*********************************************************************************/
import {
    LightningElement,
    track,
    wire,
    api
} from 'lwc';
import SFDecrypt from "@salesforce/apex/AHFC_FLOW_Controller.SFDecrypt";
import {
    NavigationMixin
} from 'lightning/navigation';
import AHFC_CIAM_HONDA_APP_ID from "@salesforce/label/c.AHFC_CIAM_HONDA_APP_ID";
import AHFC_CIAM_ACURA_APP_ID from "@salesforce/label/c.AHFC_CIAM_ACURA_APP_ID";
import AHFC_CIAM_HONDA_LOGIN_URL from "@salesforce/label/c.AHFC_CIAM_HONDA_LOGIN_URL";
import AHFC_CIAM_ACURA_LOGIN_URL from "@salesforce/label/c.AHFC_CIAM_ACURA_LOGIN_URL";
import getFinAcctWithActiveJunction from "@salesforce/apex/AHFC_AddFinanceAccountController.getFinanceAccountWithActiveJunction";
import encryptedU from "@salesforce/apex/AHFC_FLOW_Controller.getEncryptedValue";
import spinnerWheelMessage from "@salesforce/label/c.Spinner_Wheel_Message_LoginFlow";
//import hondaLogo from "@salesforce/resourceUrl/Honda_financial_logo";
import hondaLogo from "@salesforce/resourceUrl/Honda_financial_services_logo";
import hondaLogoMobile from "@salesforce/resourceUrl/Honda_financial_services_mobile_logo";
import { fireAdobeEvent } from "c/aHFC_adobeServices";

export default class AHFC_loginFlow extends NavigationMixin(LightningElement) {
    acuraLoginUrl = AHFC_CIAM_ACURA_LOGIN_URL;
    hondaLoginUrl = AHFC_CIAM_HONDA_LOGIN_URL;
    acuraAppId = AHFC_CIAM_ACURA_APP_ID;
    hodaAppId = AHFC_CIAM_HONDA_APP_ID;
    @track parameters = '';
    @track encodedValue = '';
    @track financeAccNumber = '';
    @track currentEmailAdd = '';
    @track finAcctExists = false;
    @track isHondaURL = false;
    @track isAcuraURL = true;
    @track finalURL = '';
    @track registrationURL = '';
    @track brandName = '';
    @track counterStarts = spinnerWheelMessage;
    @api isReviewPayment = false;
    @api loadingMessage; 
    @track vin = '';
    @track pageName = '';
    label = {
        spinnerWheelMessage
    }

    connectedCallback() {
        this.parameters = this.getQueryParameters();
        this.encodedValue = this.parameters['encea'];
        this.vin = this.parameters['vin'];
        this.pageName = this.parameters['pagename'];
        let adobedata = {};
        let url = window.location.href;
        console.log('url123',url);
        let refURL = document.referrer;
        let newLink = '';

console.log('line 67',this.vin)

// this.finalURL = this.hondaLoginUrl +'login/?app='+  this.hodaAppId + '&RelayState=/s/ciam-login-successfull?Brand=honda:vin='+ this.vin + ':pagename='+this.pageName;

       
if(this.vin != undefined && this.pageName != undefined){

    newLink = ':vin='+ this.vin + ':pagename='+this.pageName;
    console.log('line 75', newLink);
}
        
        if (refURL !== undefined || refURL !== '' || refURL !== null) {
            
            
            if (refURL.includes('honda.')) {
                this.isHondaURL = true
                if(newLink != '' && newLink != undefined){
                    this.finalURL = this.hondaLoginUrl +'login/?app='+  this.hodaAppId + '&RelayState=/s/ciam-login-successfull?Brand=honda'+newLink;
                }else {
                    this.finalURL = this.hondaLoginUrl +'login/?app='+  this.hodaAppId + '&RelayState=/s/ciam-login-successfull?Brand=honda';
                }               
                
                this.brandName = 'honda';
                adobedata = {
                    "Page.page_name": "Correspondence",
                    "Page.site_section": "Correspondence",
                    "Page.referrer_url": document.referrer,
                    "Page.brand_name": 'Honda'
                };
            } else if (refURL.includes('acura.')) {
                this.isAcuraURL = true;
                if(newLink != '' && newLink != undefined){
                this.finalURL = this.acuraLoginUrl +'login/?app='+ this.acuraAppId + '&RelayState=/s/ciam-login-successfull?Brand=acura'+newLink;                
                }else {
                this.finalURL = this.acuraLoginUrl +'login/?app='+ this.acuraAppId + '&RelayState=/s/ciam-login-successfull?Brand=acura';
                }
                this.brandName = 'acura';
                adobedata = {
                    "Page.page_name": "Correspondence",
                    "Page.site_section": "Correspondence",
                    "Page.referrer_url": document.referrer,
                    "Page.brand_name": 'Acura'
                };
            } else {
                this.isHondaURL = false;
                this.isAcuraURL = false;
                this.brandName = '';
                adobedata = {
                    "Page.page_name": "Correspondence",
                    "Page.site_section": "Correspondence",
                    "Page.referrer_url": document.referrer,
                    "Page.brand_name": ''
                };
            }
        }
        if (url !== undefined || url !== '') {
            if (url.includes('honda.')) {
                
                if(newLink != '' && newLink != undefined){
                this.finalURL = this.hondaLoginUrl +'login/?app='+  this.hodaAppId + '&RelayState=/s/ciam-login-successfull?Brand=honda'+newLink;                
                }else {
                this.finalURL = this.hondaLoginUrl +'login/?app='+  this.hodaAppId + '&RelayState=/s/ciam-login-successfull?Brand=honda';   
                }
                this.isHondaURL = true;
                this.brandName = 'honda';
                 adobedata = {
                    "Page.page_name": "Correspondence",
                    "Page.site_section": "Correspondence",
                    "Page.referrer_url": document.referrer,
                    "Page.brand_name": 'Honda'
                };
                
            } else if (url.includes('acura.')) {
                this.isAcuraURL = true;
                if(newLink != '' && newLink != undefined){
                this.finalURL = this.acuraLoginUrl +'login/?app='+  this.acuraAppId +'&RelayState=/s/ciam-login-successfull?brand=acura'+newLink;                
                }else {
                this.finalURL = this.acuraLoginUrl +'login/?app='+  this.acuraAppId +'&RelayState=/s/ciam-login-successfull?brand=acura';     
                }
                this.brandName = 'acura';
                adobedata = {
                    "Page.page_name": "Correspondence",
                    "Page.site_section": "Correspondence",
                    "Page.referrer_url": document.referrer,
                    "Page.brand_name": 'Acura'
                };
                
            } else {
                this.isHondaURL = false;
                this.isAcuraURL = false;
                this.brandName = '';
                adobedata = {
                    "Page.page_name": "Correspondence",
                    "Page.site_section": "Correspondence",
                    "Page.referrer_url": document.referrer,
                    "Page.brand_name": ''
                };
                
            }
        } else {
            console.log('No url parameters found')
        }
        fireAdobeEvent(adobedata, 'PageLoadReady');
        if(newLink != '' && newLink != undefined){
            console.log('173', this.finalURL);
            setTimeout(() => {
                window.open( this.finalURL,'_self');
            }, 3000);
        }else {
            this.decryptParams(this.encodedValue);
        }
       
    }
    get hondaLogoUrl() {
        return hondaLogo;
    }

    getEncryptedU() {
        let appId =''
        if(this.isAcuraURL){
            appId = this.acuraAppId;
        }else if(this.isHondaURL){
            appId = this.hodaAppId;
        }
        encryptedU({
            email: this.currentEmailAdd,
            appId :appId
        }).then((result) => {
            let iv = result.encryptedRandomNumber;
            let returnURL ='';
            if(this.brandName == 'honda'){
                returnURL='/s/add-a-finance-account?encea='+this.encodedValue +':honda';
            }
            else{
                returnURL='/s/add-a-finance-account?encea='+this.encodedValue +':acura';
            }
            if (this.isHondaURL) {
                this.registrationURL = this.hondaLoginUrl + 'login/SelfRegister?app=' + this.hodaAppId + '&r=';
                this.registrationURL += iv + '&RelayState=' + returnURL + '&u=';
                this.registrationURL += result.encryptedUrl + '&cmpid=WELCOME&m=e';
            } else if (this.isAcuraURL) {
                this.registrationURL = this.acuraLoginUrl + 'login/SelfRegister?app=' + this.acuraAppId + '&r=';
                this.registrationURL += iv + '&RelayState=' + returnURL + '&u='
                this.registrationURL += result.encryptedUrl + '&cmpid=WELCOME&m=e';
            }
            console.log('finalURL==',this.registrationURL);
            this.navigateToRegistration();
        }).catch((error) => {
            console.log('Error-----> ', error);
        });

    }
    get hondaLogoMobileUrl() {
        return hondaLogoMobile;
    }

    get backgroundContent() {
        if (this.isReviewPayment) { 
            return "action-container ";
        } else {
            return "slds-spinner_background";
        }
    }
    processUrlParameters() {

    }
    // First this method will be called and url parameter encea will passed to SFDecrypt to get decrypted value of fin account no. and email
    decryptParams(encryptedValue) {
        console.log('encryptedValue',encryptedValue);
        SFDecrypt({
            value: encryptedValue
        }).then((result) => {
            this.enceaDecrypted = result;
            /*console.log('this.enceaDecrypted',this.enceaDecrypted);
            this.financeAccNumber = result.substring(0, result.indexOf(":"));
            console.log('this.financeAccNumber==',this.financeAccNumber );
            this.currentEmailAdd = result.substring(result.indexOf(":")+1 , result.length);
            console.log('this.currentEmailAdd==',this.currentEmailAdd);
            if (!(this.financeAccNumber == undefined || this.financeAccNumber == '')) {
                this.checkForFinAcct(this.financeAccNumber);
            }*/
            console.log('this.enceaDecrypted',this.enceaDecrypted);
            this.currentEmailAdd = result.substring(0, result.indexOf(":"));
            console.log('this.financeAccNumber==',this.financeAccNumber );
            this.financeAccNumber = result.substring(result.indexOf(":")+1 , result.length);
            console.log('this.currentEmailAdd==',this.currentEmailAdd);
            if (!(this.financeAccNumber == undefined || this.financeAccNumber == '')) {
                this.checkForFinAcct(this.financeAccNumber);
            }

        }).catch((error) => {
            console.log('error',error);
            this.finAcctExists = false;
        })
    }
    // This will be called at the end from above method and will get finance account number and check if there is active customer finance account record for the passed finance account no.
    checkForFinAcct(finAcct) {
        console.log('finAcct',finAcct);
        getFinAcctWithActiveJunction({
            finAcctNo: finAcct
        }).then((result) => {
            console.log('getFinAcctWithActiveJunction',result);
          if (result == false) {
             //   this.counterStarts = 'This Finance Account is already registered. You are being redirected to the login page.';
                this.getEncryptedU();
                this.finAcctExists = false;
               
            } else { 
             this.finAcctExists = true;
            this.counterStarts = 'This Finance Account is already registered. You are being redirected to the login page.';
            setTimeout(() => {
                window.open( this.finalURL,'_self');
            }, 3000);

                
            } 

        }).catch((error) => {
            console.log('Error in Check Finance Account-----> ', error);
        })
    }
    // This method will check for url parameters and convert them into key value pair and we need only encea url parameter
    getQueryParameters() {

        var params = {};
        var search = location.search.substring(1);

        if (search) {
            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
                return key === "" ? value : decodeURIComponent(value)
            });
        }

        return params;
    }

    navigateToLogin() {
        // Navigate to a URL
        console.log('this.finalURL', this.finalURL);

        this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: this.finalURL
                }
            },
            true // Replaces the current page in your browser history with the URL
        );
    }
    navigateToRegistration() {
        window.open(this.registrationURL,'_self');
    }
}