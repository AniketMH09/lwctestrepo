/* Name               :    aHFC_alreadyMadePayment
 * Description        :    This Component will display the DDC, LE and Already Made Payment based on the conditions which written in the Apex controller,
 * Modification Log   :
 * ---------------------------------------------------------------------------
 * Developer                   Date                   Description
 * ---------------------------------------------------------------------------
 * Prabu                    29/05/2021              created
 * Prabu                    28/07/2021              Modified by Prabu US#: 9970 
 *********************************************************************************/
import { api, LightningElement, track, wire } from "lwc";
import { loadStyle } from "lightning/platformResourceLoader";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import { CurrentPageReference } from "lightning/navigation";
import { getLabels } from "c/aHFC_alreadyMadePaymentConstantsUtil";
import eligibiltyFlagRetrieve from "@salesforce/apex/AHFC_NeedHelpPaymentController.eligibiltyFlagRetrieve";
import hondaHeadLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import hondaVehImg from "@salesforce/resourceUrl/AHFC_Honda_Header_Car";
import HelpImg1 from "@salesforce/resourceUrl/Payment_DueDate";
import HelpImg2 from "@salesforce/resourceUrl/Payment_LeaseExt";
import HelpImg3 from "@salesforce/resourceUrl/Payment_AlreadyPayment";
import handleGetAccountInfo from "@salesforce/apex/AHFC_GetAccountInfoIntergationHandler.handleGetAccountInfo";
import { NavigationMixin } from "lightning/navigation";
import { registerListener } from 'c/pubsub';
import spinnerWheelMessage from "@salesforce/label/c.Spinner_Wheel_Message";
import { fireAdobeEvent } from "c/aHFC_adobeServices";


import { labels } from "c/aHFC_paymentConstantsUtil";
import { fireEvent } from 'c/pubsub';

export default class AHFC_Help_Payments extends NavigationMixin(
    LightningElement
) {

    @track spinnerMessage = spinnerWheelMessage;
    @track loadingspinner = true;

    // @track serviceAccountWrapper = [];
    @wire(CurrentPageReference) pageRef;
    @track handleData;
    @track payLoadWrapper;
    @track getAccountInfo;
    @track isNeedHelp = false;
    @track sacRecordId = '';
    @track needHelpData;
    @track dueDateChange;
    @track leaseExtension;
    @track totalPastDue = false;
    @track finAccNo;
    @track showPage = false;
    @track ddcFlowFlag;
    @track leflowFlag;
    @track isDisplayAlready = false;
    @track productNickname;
    @track promiseTrue = false;
    label = getLabels();
    @track labels = labels;
    //@api recordId;
    connectedCallback() {
        loadStyle(this, ahfctheme + "/theme.css").then(() => {});
        let adobedata = {
            "Page.page_name": "Help Payment",
            "Page.site_section": "Help Payment",
            "Page.referrer_url": document.referrer
        };
        fireAdobeEvent(adobedata, 'PageLoadReady');
        this.OneligibiltyFlagRetrieve();
    }

    get Payment_Img1() {
        return HelpImg1;
    }
    get Payment_Img2() {
        return HelpImg2;
    }
    get Payment_Img3() {
        return HelpImg3;
    }
    get hondaheadLogoUrl() {
        return hondaHeadLogo;
    }

    get hondaVehImgUrl() {
        return hondaVehImg;
    }



    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            console.log('urlStateParameters------> ' + this.urlStateParameters);
            if (typeof currentPageReference.state.sacRecordId != "undefined") {
                this.sacRecordId = currentPageReference.state.sacRecordId;
            }
        }
        console.log("sacRecordId -> " + this.sacRecordId);
    }


    /* @wire(eligibiltyFlagRetrieve, {FinanceId: '$sacRecordId'})
eligibiltyRetrieve({ error, data }) {
  console.log('data -'+JSON.stringify(data));

  if (data) 
  {
    this.needHelpData = data;
    this.dueDateChange = this.needHelpData.DueDateChange;
    this.leaseExtension =this.needHelpData.LeaseExtension;
    this.totalPastDue = this.needHelpData.TotalPastDue;   
    console.log(' this.dueDateChange-->',  this.dueDateChange + ' this.leaseExtension',  
    this.leaseExtension +
    'this.totalPastDue',this.totalPastDue) 
  } else if (error) {
    console.log('error--',error);
    this.error = error;
    
  }
} */


    OneligibiltyFlagRetrieve() {
            console.log('recorddddIDDD', this.sacRecordId);
            eligibiltyFlagRetrieve({
                    FinanceId: this.sacRecordId
                })
                .then((result) => {
                    if (result) {
                        this.needHelpData = result;
                        this.totalPastDue = this.needHelpData.TotalPastDue;
                        this.finAccNo = this.needHelpData.FinanceAccNo;
                        this.productNickname = this.needHelpData.ProductNickname;
                        this.dueDateChange = this.needHelpData.DueDateChange;
                        this.leaseExtension = this.needHelpData.LeaseExtension;
                        this.loadingspinner = false;

                        //Added by Prabu for US 9970 - Start
                        if (this.totalPastDue) {
                            let sessioneddata = JSON.parse(sessionStorage.getItem(this.finAccNo));
                            this.loadingspinner = false;

                            if (sessioneddata.promiseToPay == true) {
                                this.isDisplayAlready = true;
                                this.loadingspinner = false;

                            }
                        }
                        //9970 - End


                    }
                })


            .catch(error => {
                this.isWebServiceDown = true;
                this.loadingspinner = false;


            });
        }
        // US 9970 - End

    pubsubfunction(payload) {
        console.log('50', JSON.parse(payload));

        this.payLoadWrapper = JSON.parse(payload);
        this.getAccountInfo = this.payLoadWrapper.getAccountInfo;
        console.log('this.getAccountInfo ', this.getAccountInfo);
    }


    handleDDCflow() {
        let obj = {};
        obj.ddcFlowFlag = true;
        const selectedEvent = new CustomEvent("needHelpEvt", {
            detail: {
                resultData: JSON.stringify(this.needHelpData),
                secondParam: JSON.stringify(obj)
            }

        });
        this.dispatchEvent(selectedEvent);
        this.showPage = true;
    }

    handleLEFlow() {
        let obj = {};
        obj.leflowFlag = true;

        const selectedEvent = new CustomEvent("needHelpEvt", {
            detail: {
                resultData: JSON.stringify(this.needHelpData),
                secondParam: JSON.stringify(obj)
            }

        });
        this.dispatchEvent(selectedEvent);
        this.showPage = true;
    }




    //navigate to made-payment page
    navigateToMadePayment() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'already-made-a-payment'
            },
            state: {
                sacRecordId: this.sacRecordId
            }
        });
    }

    //Navigate To Dashboard
    navigateBackToDashboard() {
            this[NavigationMixin.Navigate]({
                type: "comm__namedPage",
                attributes: {
                    pageName: this.label.communityNamedDashboard
                }
            });
            // window.history.back(); 
            // return false;
        }
        //for ADA fix
    renderedCallback() {
        let firstClass = this.template.querySelector(".main-content");
        fireEvent(this.pageRef, 'MainContent', firstClass.getAttribute('id'));
    }

}