/** Controller Name: AHFC_addFinanceAccount_Parent
 *  Description:     Add Finance account page logic when customer wants to add finance account to the person account.
 *  Developer Name:  Akash Solanki
 *  Created Date:    08-May-2021 
 */
import { LightningElement, track, api, wire } from 'lwc';
import accountsetupBanner from "@salesforce/resourceUrl/AHFCaccount_setup_banner";
import hondaLogo from "@salesforce/resourceUrl/Honda_financial_logo";
import LabelFederationId from "@salesforce/label/c.AHFC_Federation_Id_Label";
import LabelEmailId from "@salesforce/label/c.AHFC_Email_Label";
import LabelGuestProfile from "@salesforce/label/c.AHFC_Guest_Username";
import fetchuserdetails from "@salesforce/apex/AHFC_AddFinanceAccountController.fetchuserdetails";
import getFinanceAccountExists from "@salesforce/apex/AHFC_AddFinanceAccountController.getFinanceAccountExists";
import { fireEvent } from 'c/pubsub'; // added by Akash as part of ADA
import { CurrentPageReference } from "lightning/navigation";
import { fireAdobeEvent } from "c/aHFC_adobeServices";

export default class AHFC_addFinanceAccount_Parent extends LightningElement {

  label = { LabelFederationId, LabelGuestProfile, LabelEmailId };
  @track tabsList = [
    {
      id: 1,
      key: "accountNumber",
      title: "ACCOUNT NUMBER",
      tabClass: "slds-tabs_default__item slds-is-active",
      name: 'ACCOUNT NUMBER'
    },
    {
      id: 2,
      key: "vinCode",
      title: "VIN + ZIP CODE",
      tabClass: "slds-tabs_default__item",
      name: 'VIN ZIP CODE'
    }
  ];
  @track currentTab = "accountNumber";
  @track currentTabActive = true;
  @track showPopover = false;
  @track userdetails;
  @track error;
  @api useremail;
  @track username;
  @track userFirstName;
  accountsetupBanner = accountsetupBanner;
  parameters = {};
  @api strFedId = '';
  @api strEmail = '';
  @track accountExists;

  connectedCallback() {
    let adobedata = {
      "Page.page_name": "Account Setup (Welcome)",
      "Page.site_section": "Account Setup (Welcome)",
      "Page.referrer_url": document.referrer

    };
    fireAdobeEvent(adobedata, 'PageLoadReady');
    this.parameters = this.getQueryParameters();
    var strFedUrlParameter = this.label.LabelFederationId;
    var strEmailParameter = this.label.LabelEmailId;
    this.strFedId = this.parameters[strFedUrlParameter];
    this.strEmail = this.parameters[strEmailParameter];
  }

  get hondaLogoUrl() {
    return hondaLogo;
  }

  /** Method Name: getFinanceAccountExists
   *  Description: Method used to check whether finance account exists for the particular user, if yes don't land user to welcome page.
   * Developer Name: Akash Solanki
   * @param {*} None 
   */
  @wire(getFinanceAccountExists)
  getFinAcctExist({ error, data }) {
    if (data) {
      this.accountExists = data;

    } else if (error) {
      this.error = error;
    }
  }

  @wire(CurrentPageReference) pageRef;

  renderedCallback() {
    this.setBanner();
    let firstClass = this.template.querySelector(".main-content");
    fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
  }

  setBanner() {
    const ele = this.template.querySelector(".banner-container");
    ele.style.backgroundImage = `url(${accountsetupBanner})`;
  }

  /** Method Name: fetchuserdetails
   *  Description: Method to get the logged in user details.
   * Developer Name: Akash Solanki
   * @param {*} None 
   */
  @wire(fetchuserdetails)
  wiredContacts({ error, data }) {
    if (data) {
     
      this.userdetails = data;
      this.error = undefined;
      this.useremail = this.userdetails.Email;
      this.username = this.userdetails.Name;
      this.userFirstName = this.userdetails.FirstName;
    } else if (error) {
      this.error = error;
      this.userdetails = undefined;
    }
  }
/*Bug Fix 21492 Starts*/
  @track checkedBilling = 'true';
  @track checkedPayment = 'true';
  @track checkedSpecialOffers = 'true';
  setCommValues(event){
    console.log('123123213',event.detail);
    let commPrefValueChange = event.detail.commprefValueChanged;
    let isChecked = event.detail.checked;
    if(commPrefValueChange == 'SpecialOffers'){
      this.checkedSpecialOffers = isChecked;
    }else if(commPrefValueChange == 'Payment'){
      this.checkedPayment = isChecked;
    }else if(commPrefValueChange== 'Billing'){
      this.checkedBilling = isChecked;
    }
  }
  setCommValuesForChild(){
    console.log('this.template.querySelector("c-a-h-f-c_add-finance-account-number-tab")',this.template.querySelector("c-a-h-f-c_add-finance-account-number-tab"));
    console.log('("c-a-h-f-c_add-finance-account-vin-zip-tab")',this.template.querySelector("c-a-h-f-c_add-finance-account-vin-zip-tab"));
    if(this.template.querySelector("c-a-h-f-c_add-finance-account-number-tab") != undefined){
      this.template.querySelector("c-a-h-f-c_add-finance-account-number-tab").setCommPrefValues(this.checkedSpecialOffers,'SpecialOffers');
      this.template.querySelector("c-a-h-f-c_add-finance-account-number-tab").setCommPrefValues(this.checkedPayment,'Payment');
      this.template.querySelector("c-a-h-f-c_add-finance-account-number-tab").setCommPrefValues(this.checkedBilling,'Billing');
      }
      if(this.template.querySelector("c-a-h-f-c_add-finance-account-vin-zip-tab") != undefined){
      this.template.querySelector("c-a-h-f-c_add-finance-account-vin-zip-tab").setCommPrefValues(this.checkedSpecialOffers,'SpecialOffers');
      this.template.querySelector("c-a-h-f-c_add-finance-account-vin-zip-tab").setCommPrefValues(this.checkedPayment,'Payment');
      this.template.querySelector("c-a-h-f-c_add-finance-account-vin-zip-tab").setCommPrefValues(this.checkedBilling,'Billing');
      }
  }
  /*Bug Fix 21492 Starts*/

  onTabChange(event) {
    this.onTabToggle(event.currentTarget.dataset.id);
  }

  onTabToggle(tab) {
    if (tab === "accountNumber") {
      let adobedata = {
        'Event_Metadata.action_type': 'Tab',
        "Event_Metadata.action_label": "Account Setup:Tab:Account Number",
        "Event_Metadata.action_category": "",
        "Page.page_name": "Account Setup (Welcome)",
      };
      fireAdobeEvent(adobedata, 'click-event');
      this.template
        .querySelector('li[data-id="vinCode"]')
        .classList.remove("slds-is-active");
      this.template
        .querySelector('li[data-id="accountNumber"]')
        .classList.add("slds-is-active");
    } else if (tab === "vinCode") {
      let adobedata = {
        'Event_Metadata.action_type': 'Tab',
        "Event_Metadata.action_label": "Account Setup:Tab:VIN & Zip",
        "Event_Metadata.action_category": "",
        "Page.page_name": "Account Setup (Welcome)",
      };
      fireAdobeEvent(adobedata, 'click-event');
      this.template
        .querySelector('li[data-id="accountNumber"]')
        .classList.remove("slds-is-active");
      this.template
        .querySelector('li[data-id="vinCode"]')
        .classList.add("slds-is-active");
    }
    this.currentTabActive = tab === "accountNumber";
  }

  
  onIconEnter() {
    this.showPopover = true;
  }

  onIconLeave() {
    this.showPopover = false;
  }

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

  @api get boolIsGuestUser() {
    var strUserName = this.username;

    if (strUserName !== undefined) {
      strUserName = strUserName.toLowerCase();
    }
    var strGuestProfile = this.label.LabelGuestProfile.toLowerCase();
    return strUserName == strGuestProfile;
  }
}