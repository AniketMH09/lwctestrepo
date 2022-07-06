import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getFinanceAccountExists from "@salesforce/apex/AHFC_AddFinanceAccountController.getFinanceAccountExists";
import AHFC_Community_Named_Dashboard from "@salesforce/label/c.AHFC_Community_Named_Dashboard";
import getServiceAccountDetails from "@salesforce/apex/AHFC_DashboardController.getServiceAccountdetails";
//import { fireAdobeEvent } from '../aHFC_adobeServices/aHFC_adobeServices';


import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import UserNameFld from '@salesforce/schema/User.Name';
import userEmailFld from '@salesforce/schema/User.Email';
import UserFirstName from '@salesforce/schema/User.FirstName';
import UserLaststName from '@salesforce/schema/User.LastName';
import { fireAdobeEvent } from "c/aHFC_adobeServices";


export default class AHFC_ciamRegistrationCompletionRedirect extends NavigationMixin(LightningElement) {
    accountExists = false;
    parameters;
    error;
    newParamaters;
    vin = '';
    pagename = '';
 
    userId = Id;
    currentUserName;
    currentUserEmailId;
    currentIsActive;
    currentUserAlias;
    error;


    @wire(getRecord, { recordId: Id, fields: [UserNameFld, userEmailFld, UserFirstName, UserLaststName ]}) 
    userDetails({error, data}) {
        if (data) {
            console.log('caimxxx', data);
            console.log('first name', data.fields.UserFirstName? data.fields.UserFirstName.value : 'no data');
            console.log('last name', data.fields.UserLaststName? data.fields.UserLaststName.value : 'no data');
            console.log('email', data.fields.Email? data.fields.Email.value : 'no data');
            if(data.fields != undefined){
                // let adobedata = {
                //     "Page.page_name": "",
                //     "Page.site_section": "",
                //     "Page.brand_name": '',
                //     "Page.referrer_url": document.referrer,
                //     "user.first_name": data.fields.UserFirstName? data.fields.UserFirstName.value : '',
                //     "user.last_name": data.fields.UserLaststName? data.fields.UserLaststName.value : '',
                //     "user.email": data.fields.Email? data.fields.Email.value : ''
                // };
                // fireAdobeEvent(adobedata, 'PageLoadReady');
            }
            
            this.connectedFunction();


        } else if (error) {
            this.error = error ;
            this.connectedFunction();
         
        }
    }

    connectedCallback() {
        


       

    }





    /** Method Name: getFinanceAccountExists
     *  Description: Method used to check whether finance account exists for the particular user, if yes don't land user to welcome page.
     * Developer Name: Vishnu Mohan
     * @param {*} None 
     */
    /*@wire(getFinanceAccountExists)
    getFinAcctExist({ error, data }) {
        console.log( 'this.accountExists',error);
        if (!error) {
           console.log( 'this.accountExists',this.accountExists);
            this.accountExists = data;
            console.log( 'this.accountExists',this.accountExists);
            this.parameters = this.getQueryParameters();
            console.log( 'this.parameters',this.parameters);
            if(!(this.parameters==null||this.parameters==undefined||this.parameters=='')){
                    sessionStorage.setItem('domainBrand', this.parameters['Brand']);
            }

            if(this.accountExists){
                this.navigateToDashboard();
                
            }else{
                this.NavigateToAddFinancePage();
            }

           


        } else if (error) {
            this.error = error
            console.log( 'this.error',this.error);
        }
    }*/

    navigateToDashboard() {
        console.log('navigateToDashboard', AHFC_Community_Named_Dashboard);
        //window.location.href = '/customer/s/'+AHFC_Community_Named_Dashboard;        

        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'dashboard'
            }

        });
        console.log('Code executed - dashboard');
    }
    NavigateToAddFinancePage() {
        console.log('NavigateToAddFinancePage');
        //window.location.href = '/customer/s/add-a-finance-account';
        //sessionStorage.setItem('addProductFromDashboard', 'true');
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'add-a-finance-account'
            }
        });
        console.log('Code executed - AddFinancePage');
    }

    getQueryParameters() {

        var params = {};
        var search = location.search.substring(1);

        if (search) {
            console.log('search----> ', search);
            params = JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', (key, value) => {
                return key === "" ? value : decodeURIComponent(value)
            });
        }

        return params;
    }


    //**Common Function**/

    getFinData(){
        getFinanceAccountExists()
        .then(data => {
            this.parameters = this.getQueryParameters();
            if (!(this.parameters == null || this.parameters == undefined || this.parameters == '')) {                        
                sessionStorage.setItem('domainBrand', this.parameters['Brand']);
            }

            if (data) {                    
                
                console.log('24', data);
                console.log('this.accountExists', this.accountExists);
                this.accountExists = data;
                console.log('this.accountExists', this.accountExists);
                //this.parameters = this.getQueryParameters();
                console.log('this.parameters', this.parameters);
                // if (!(this.parameters == null || this.parameters == undefined || this.parameters == '')) {                        
                //     sessionStorage.setItem('domainBrand', this.parameters['Brand']);
                // }

                if (this.accountExists) {
                    console.log('35');
                    this.navigateToDashboard();

                } else {
                    console.log('39');
                    this.NavigateToAddFinancePage();
                }
            }else {
                console.log('40');
                this.NavigateToAddFinancePage();
            }
        })
        .catch(error => {
            console.log('error', error);
        })
    }


    connectedFunction(){
        
        console.log('executing connected callback');
        this.newParamaters = this.getQueryParameters();
        let queryparam = this.newParamaters['Brand'];
        console.log('190', queryparam);
        if(queryparam.includes("vin")){
            let queryArray = queryparam.split(':');
            console.log('193', queryArray);
            let vin = queryArray[1].split('=');
            console.log('195', vin);
            if(queryArray[2] == undefined){
                this.navigateToDashboard();
            }
            let pagename = queryArray[2].split('=');
            console.log('197', pagename);
            let brandName = queryArray[0];
            console.log('199', brandName);
            sessionStorage.setItem('domainBrand', brandName);
            
            let isVinAvailable = false;
            console.log('201', isVinAvailable);
    
            //console.log(vin[1]);
            //console.log(pagename[1]);
            this.vin = vin[1];
            console.log('206', this.vin);
            this.pagename = pagename[1];
            console.log('208', this.pagename);

            // if(this.pagename == undefined || this.pagename == ''){
            //     this.getFinData();
            // }
    
            getServiceAccountDetails()
            .then(result => {
                console.log('216', result);
                if(result.length == 0){
                    this.NavigateToAddFinancePage();
                }
    
                for(let i = 0; i < result.length; i++){
                    if(result[i].serAccRec.Vehicle_Identification_Number__c != undefined) {
                        if(result[i].serAccRec.Vehicle_Identification_Number__c == this.vin){
                            isVinAvailable = true;
                            console.log('line 45');
                            sessionStorage.setItem('salesforce_id', result[i].serAccRec.Id);
                            //sessionStorage.setItem('domainBrand', brandName);

                            if(this.pagename == undefined || this.pagename == ''){
                                console.log('243- page name is not available');
                                this.navigateToDashboard();
                            }else if(this.pagename == 'make-a-payment'){
                                console.log('navigate to make a payment');
                                this[NavigationMixin.Navigate]({
                                    type: 'comm__namedPage',
                                    attributes: {
                                        pageName: this.pagename
                                    },
                                    state: {
                                        showOTPDefault: true
                                    }
                                });
                               
                            }else if(this.pagename == 'communicationpreference'){
                                console.log('258 navigate to comm perfernce');
                                this[NavigationMixin.Navigate]({
                                    type: 'comm__namedPage',
                                    attributes: {
                                        pageName: "communicationpreference"
                                    }
                                });
                               
                            }else{
                                console.log('267 navigate to dashboard');
                                this.navigateToDashboard();
                            }
                          
                        }
                    }
                }

                if(!isVinAvailable){
                    this.navigateToDashboard();
                }
            })
              
        }else {
            this.getFinData();
        }
    }
}