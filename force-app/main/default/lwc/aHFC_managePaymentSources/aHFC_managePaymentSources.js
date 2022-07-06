/* Name               :    AHFC_managePaymentSources
 * Description        :    This Component is used to manage payment sources.
 * Modification Log   :
 * ---------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ---------------------------------------------------------------------------
 * Kangaraj                                           created
 * Satish                     14/06/2021              Modified by satish US#: 7027
 * Satish                     14/07/2021              Modified by satish US#: 4486
 *********************************************************************************/
import {
  LightningElement,
  track,
  wire
} from "lwc";
import bankInfoSvg from "@salesforce/resourceUrl/AHFCpayment_bankInfo";
import warningSvg from "@salesforce/resourceUrl/AHFC_warning";
import infoSvg from "@salesforce/resourceUrl/AHFC_info";
import getPaymentSource from "@salesforce/apex/AHFC_ManagePaymentSourceClass.getPaymentSource";
import AHFC_Restrict_payment_sources from "@salesforce/label/c.AHFC_Restrict_payment_sources";
import AHFC_Payment_Source_Creation_Error_Message from "@salesforce/label/c.AHFC_Payment_Source_Creation_Error_Message";
import AHFC_Manage_Payment_Source_Added_Message from "@salesforce/label/c.AHFC_Manage_Payment_Source_Added_Message";
import AHFC_Manage_Payment_Sources_Saved from "@salesforce/label/c.AHFC_Manage_Payment_Sources_Saved";
import AHFC_Manage_Payment_Sources_Delete from "@salesforce/label/c.AHFC_Manage_Payment_Sources_Delete";
import spinnerWheelMessage from "@salesforce/label/c.Spinner_Wheel_Message";  //US_11044
import checkPaymentSource from "@salesforce/apex/AHFC_ManagePaymentSourceClass.checkPaymentSource";
import deletePaymentSource from "@salesforce/apex/AHFC_ManagePaymentSourceClass.deletePaymentSource"; //added for US#: 7027-satish
import { fireEvent } from 'c/pubsub';
import {
  NavigationMixin
} from "lightning/navigation";
import {
  CurrentPageReference
} from "lightning/navigation";
import {
  registerListener,
  unregisterAllListeners
} from 'c/pubsub';
import { fireAdobeEvent } from "c/aHFC_adobeServices";
export default class AHFC_managePaymentSources extends NavigationMixin(LightningElement) {
  @track isModalOpen = false;
  @track jsonData;
  @track isEditModalOpen = false;
  @track isDeleteModalOpen = false;
  @track deleteClickValue;
  @track paymentSourcesList = [];
  @track successSaveMsg = '';
  @track boolShowSuccessMsg = false;
  @track showReEnterBankAccNum;
  @track userprofiletype;
  @track options = [];
  @track serviceAccountList = [];
  @track sacRecordId = null;
  @track showErrorMessage = false;
  @track toastType;
  @track toastLabel;
  @track popDisplayDelete = '';
  @track popDisplayBack = '';
  @track displaySchPayments = false;
  currentPageReference = null;
  urlStateParameters = null;
  @track isUpdated = false;
  @track pageRef;
  @track spinnerMessage = spinnerWheelMessage;
  @wire(CurrentPageReference)
  getStateParameters(currentPageReference) {

    this.pageRef = currentPageReference;
    if (currentPageReference) {
      this.urlStateParameters = currentPageReference.state;
      if (typeof currentPageReference.state.issuccess != "undefined") {
        this.isUpdated = currentPageReference.state.issuccess;
      }

    }
  }

  renderedCallback() {
    let firstClass = this.template.querySelector(".main-content");
    fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
  }

  connectedCallback() {
    registerListener('AHFC_Account_Selected', this.getDataFromPubsubEvent, this);



  }
  disconnectedCallback() {
    unregisterAllListeners(this);
  }
  @track newadobedata = {};
  //pubsub function
  getDataFromPubsubEvent(data) {
    this.newadobedata = JSON.parse(data);
    let adobedata = {
      "Page.page_name": "Payment Sources",
      "Page.site_section": "Payment Sources",
      "Page.brand_name": this.newadobedata.serAccRec.Honda_Brand__c ? this.newadobedata.serAccRec.Honda_Brand__c : '',
      "Page.referrer_url": document.referrer
    };
    fireAdobeEvent(adobedata, 'PageLoadReady');


    this.jsonData = JSON.parse(data);
    this.sacRecordId = this.jsonData.serAccRec.Id;
    this.getAllPaymentSource(this.jsonData);
    this.boolShowSuccessMsg = false;
    this.showErrorMessage = false;
    if (this.isUpdated) {
      this.successSaveMsg = "Payment sources have been updated";
      this.boolShowSuccessMsg = true;
      this.toastType = "success";
      this.toastLabel = "Success";
      this.isUpdated = false;
    }

  }
  
  /*Label below is used to store available payment options  for customer/agent
    structure to be sent for label:
    label: [{name: '',serviceNumber: ''}]
    along with rest of the fields.
  */
  getAllPaymentSource(data) {

    getPaymentSource({
      sacRecId: data.serAccRec.Id
      // sacRecId: '00000444549136'
    }).then((result) => {

      this.paymentSourcesList.length = 0;
      const paymentSourcesList = result && result.map(item => {
        const {
          Id = '', Name = '', Payment_Source_Nickname__c = '',
          Last_4__c = '',
          Bank_Name__c = '',
          Bank_Account_Type__c = "",
          Preferred_Payment_Source__c,
        } = item;
        let data = [];
        if (this.serviceAccountList.length > 0) {
          this.serviceAccountList && this.serviceAccountList.forEach(item => {
            const {
              Id: financeAccId = '',
              Finance_Account__c = '',
              Finance_Account__r: {
                Finance_Account_Number__c = '',
                Name = ''
              }
            } = item;
            data.push({
              label: `${Name}: ${Finance_Account_Number__c}`,
              name: Name,
              serviceNumber: Finance_Account_Number__c,
              value: financeAccId
            });

          });
        }
        return {
          key: data.length == 0 || data[0] == null ? Id : `${Id}${data.length}`,
          Preferred_Payment_Source__c: Preferred_Payment_Source__c,
          name: `${Payment_Source_Nickname__c}`,
          paymentID: Id,
          type: Bank_Account_Type__c,
          accnumber: Last_4__c,
          cardsubtitle: `${Bank_Account_Type__c} **** ${Last_4__c}`,
          cardsubtitle1: `${Bank_Account_Type__c}`,
          cardsubtitle2: `${Last_4__c}`,
          descriptiontext: Bank_Name__c,
          label: data.length == 0 || data[0] == null ? [] : data,
          errortext: '',
        };
      });
      this.paymentSourcesList = [...paymentSourcesList];
      this.closePageLoader();
    })
      .catch((error) => {
        //Record access check exception handling - Supriya Chakraborty 11-Nov-2021
        if(error.body.message == 'invalid access'){
          this[NavigationMixin.Navigate]({
              type: "comm__namedPage",
              attributes: {
                  pageName: "dashboard"
              }
          });
        }
        this.closePageLoader();
      });

  }

  value = [];
  selectedPaymentCard = {};
  selectedDeletePaymentCard = {};
  bankInfoSvg = bankInfoSvg;
  warningSvg = warningSvg;
  infoSvg = infoSvg;
  errMsgLabel = AHFC_Restrict_payment_sources;
  get renderWithPaymentList() {
    return this.paymentSourcesList.length > 0 ? true : false;
  }

  /*set renderWithPaymentList(value) {
    return value;
  }*/

  handlePaymentChange(e) {
    this.value = e.detail.value;
  }
  // code for preferred payment sources -ends

  openmodal() {

    let adobedata = {
      'Event_Metadata.action_type': 'Button',
      "Event_Metadata.action_label": "Payment Sources:Button:Add New Payment Source",
      "Event_Metadata.action_category": "",
      "Page.page_name": "Payment Sources",
      "Page.brand_name": this.newadobedata.serAccRec.Honda_Brand__c ? this.newadobedata.serAccRec.Honda_Brand__c : '',
    };
    fireAdobeEvent(adobedata, 'click-event');
    if (this.paymentSourcesList.length >= 4) {
      this.showErrorMessage = true;

    } else {
      this.isModalOpen = true;
      const scrollOptions = {
        left: 0,
        top: 0,
        behavior: "smooth"
      };
      window.scrollTo(scrollOptions);

    }
  }
 
  closeModal() {
    this.isModalOpen = false;
  }
  closeErrorToast() {
    this.showErrorMessage = false;
  }
  handleEditClick(event) {
    let adobedata = {
      'Event_Metadata.action_type': 'Button',
      "Event_Metadata.action_label": "Payment Sources:Button:Edit Nickname",
      "Event_Metadata.action_category": "",
      "Page.page_name": "Payment Sources",
      "Page.brand_name": this.newadobedata.serAccRec.Honda_Brand__c ? this.newadobedata.serAccRec.Honda_Brand__c : '',
    };
    fireAdobeEvent(adobedata, 'click-event');
    this.selectedPaymentCard = this.paymentSourcesList.find(
      (item) => item.paymentID === event.detail
    );


    this.isEditModalOpen = true;
  }

  onNewPaymentModalClose(event) {
    this.isModalOpen = event.detail;
  }
  onEditModalClose(event) {
    this.isEditModalOpen = event.detail;
  }

  onEditModalSave(event) {
    this.connectedCallback();

    this.successSaveMsg = `'${event.detail.nickname}'` + AHFC_Manage_Payment_Sources_Saved;
    this.boolShowSuccessMsg = true;
    this.toastType = "success";
    this.toastLabel = "Success";
    this.isEditModalOpen = event.detail.detail;
    this.getAllPaymentSource(this.jsonData);
  }


  savePaymentSource(event) {
    let adobedata = {
      'Event_Metadata.action_type': 'Button',
      "Event_Metadata.action_label": "Payment Sources:Button:Add Payment Source",
      "Event_Metadata.action_category": "Modal",
      "Page.page_name": "Payment Sources",
      "Page.brand_name": this.newadobedata.serAccRec.Honda_Brand__c ? this.newadobedata.serAccRec.Honda_Brand__c : '',
    };
    fireAdobeEvent(adobedata, 'click-event');
    if (event.detail.personName || event.detail.paymentAddedStatus) {
      this.openPageLoader();
      this.successSaveMsg = `'${event.detail.personName}' ${AHFC_Manage_Payment_Source_Added_Message}`;
      this.boolShowSuccessMsg = true;
      this.toastType = "success";
      this.toastLabel = "Success";
      this.getAllPaymentSource(this.jsonData);

    } else {
      this.isModalOpen = false;
      this.boolShowSuccessMsg = true;
      this.successSaveMsg = `${AHFC_Payment_Source_Creation_Error_Message}`;
      this.toastType = "error";
      this.toastLabel = "Error";
    }
  }
  onCloseToast() {
    this.boolShowSuccessMsg = false;
  }

  //Added for US# :7027 :satish -start -Delete payment source
  handleDeleteClick(event) {
    let adobedata = {
      'Event_Metadata.action_type': 'Button',
      "Event_Metadata.action_label": "Payment Sources:Button:Delete",
      "Event_Metadata.action_category": "",
      "Page.page_name": "Payment Sources",
      "Page.brand_name": this.newadobedata.serAccRec.Honda_Brand__c ? this.newadobedata.serAccRec.Honda_Brand__c : '',
    };
    fireAdobeEvent(adobedata, 'click-event');
    const paymentList = this.paymentSourcesList.find(
      (item) => item.paymentID === event.detail
    );

    this.selectedDeletePaymentCard = JSON.parse(JSON.stringify(paymentList));
    console.log('this.selectedDeletePaymentCard>>>'+JSON.stringify(this.selectedDeletePaymentCard));
    this.onclickDelete();
  }
  onDeleteModalClose(event) {
    this.isDeleteModalOpen = event.detail;
  }
  onDeleteModalSave(event) {
    this.isDeleteModalOpen = event.detail;
    this.openPageLoader();
    if (this.displaySchPayments) {
      this.goToSchPayPage();
    } else {
      this.onDeletepaymentSource();
    }
  }
  onclickDelete() {
    checkPaymentSource({
      paymentId: `${this.selectedDeletePaymentCard.paymentID}`
    })
      .then((result) => {

        if (result.displayNoPayments) {
          this.popDisplayDelete = "YES, DELETE";
          this.popDisplayBack = "CANCEL";
          this.displaySchPayments = false;
          this.isDeleteModalOpen = true;
        } else if (result.displaySchPayments) {
          this.popDisplayDelete = "VIEW SCHEDULED PAYMENTS";
          this.popDisplayBack = "BACK";
          this.displaySchPayments = true;
          this.isDeleteModalOpen = true;
        } else {

          this.successSaveMsg = "A payment is being processed. This payment source cannot be deleted or replaced at this time. ";
          this.boolShowSuccessMsg = true;
          this.toastType = "error";
          this.toastLabel = "Error";


        }





      })
      .catch((error) => { });
  }
  onDeletepaymentSource() {

    deletePaymentSource({
      paymentId: `${this.selectedDeletePaymentCard.paymentID}`
    })
      .then((result) => {

        if (result) {
          this.successSaveMsg = `'${this.selectedDeletePaymentCard.name}'` + ' ' + AHFC_Manage_Payment_Sources_Delete;
          this.boolShowSuccessMsg = true;
          this.toastType = "success";
          this.toastLabel = "Success";
          this.getAllPaymentSource(this.jsonData);

        }
      })
      .catch((error) => { });

  }

  openPageLoader() {
    this.template
      .querySelector("c-a-h-f-c_vehicleswitcher")
      .openLoader();
  }

  closePageLoader() {
    this.template
      .querySelector("c-a-h-f-c_vehicleswitcher")
      .closeLoader();
  }

  goToSchPayPage() {
    this[NavigationMixin.Navigate]({
      type: "comm__namedPage",
      attributes: {
        pageName: "scheduled-payment"
      },

      state: {
        psId: `${this.selectedDeletePaymentCard.paymentID}`
      }
    });
  }
  //Added for US# :7027 :satish -END


}