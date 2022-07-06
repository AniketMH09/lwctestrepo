import {
    api,
    LightningElement,
    track
} from "lwc";
import updateFinannceAccountContactDetails from "@salesforce/apex/AHFC_EditFinanceAccount.updateFinannceAccountContactDetails";
import ecrmAddressValidation from "@salesforce/apex/AHFC_ECRMIntegration.getValidatedAddress";
// import AHFC_Contact_Information_Save from "@salesforce/label/c.AHFC_Contact_Information_Save";
// import AHFC_Contact_Information_WebService from "@salesforce/label/c.AHFC_Contact_Information_WebService";
import US_STATES from "@salesforce/label/c.AHFC_US_State";
import US_STATES_CODE from "@salesforce/label/c.AHFC_US_State_Code";
import handleUpdateAddress from "@salesforce/apex/AHFC_RemoveAndUpdateAddressHandler.handleUpdateAddress";
import handleremovebillingAddress from "@salesforce/apex/AHFC_RemoveAndUpdateAddressHandler.handleRemoveBillToAddress";
import updateFinanceNickName from "@salesforce/apex/AHFC_EditFinanceNicknameController.updateFinanceNickName";
import {
    ShowToastEvent
} from "lightning/platformShowToastEvent";
import ahfctheme from "@salesforce/resourceUrl/AHFC_Theme";
import {
    loadStyle
} from "lightning/platformResourceLoader";
import addressProcessingMessage from "@salesforce/label/c.AHFC_Address_Processing_Message";
import addressValidatatingMessage from "@salesforce/label/c.AHFC_Address_Validation_Message";
import successMessageForBilling from "@salesforce/label/c.AHFC_Success_message_for_Billing";
import successMessageForBillingGaraging from "@salesforce/label/c.AHFC_Success_message_for_Billing_Garaging";
import successMessageForGaraging from "@salesforce/label/c.AHFC_Success_message_for_Garaging";
import successMessageForGaragingBilling from "@salesforce/label/c.AHFC_Success_message_for_Garaging_Billing";
import failureResponseMessage from "@salesforce/label/c.AHFC_Update_Address_Fail";
import webServiceDownMessage from "@salesforce/label/c.AHFC_Update_Address_Webservice_down_Message";
import spinnerWheelMessage from "@salesforce/label/c.Spinner_Wheel_Message";

export default class AHFC_financeAccountDetailEdit extends LightningElement {

    @api modalHeaderText;
    @api nickNameModal;
    @api contactInfoModal;
    @track States = US_STATES;
    @track StatesCode = US_STATES_CODE;
    @api garageAddressModal;
    @api billingAddressModal;
    @api stopFinanceModal;
    @api modalSaveText;
    @api modalCancelText;
    @api resultData;
    @api getFinanceAccountNum;
    @api finacc;
    @api isRedirectedFromPayOff = false; //US:4595 by edwin
    @api isupdatableGaragingAddress; // Added by kanagaraj for the US - 14112
    @api isupdatableBillingAddress; // Added by kanagaraj for the US - 14112

    @track btnSection = false;
    @track isBoolGaragingBillToUpdate = false;
    @track btnSectionForAddress = false;
    @track openValidatemodal = false;
    @track boolGaragingAsBilling;
    @track checkboxVal = false;
    @track checkboxBill = false;
    @track isModalOpen = false;
    @track updatedRecordResult = false;
    @track isValid = false;
    @track isValidcellphone1 = false;
    @track isValidccellphone2 = false;
    @track isValidhomephonenumber = false;
    @track isValidworkphone = false;
    @track isfailLevel = false;
    @track loaded = false;
    @track loadingsprinner = false;
    @track isAddressValidationforGaraging = false;
    @track isCountyModel = false;
    @track selectedCounty;
    @track countyList = [];
    @api updatenicknamefinaccdetail;
    @track nickNameValidation; //bug 20070
    @track listofState = [];
    @track selectedState = '';
    @track spinnerMessage = spinnerWheelMessage;
    @track loadingMsg; //Added by Kanagaraj for US - 10480 & 10481
    @track successMessage; //Added by Kanagaraj for US - 10480 & 10481
    @track isMustonephonenumber = false;
    @track ValidAddress = {
        addressLine1: "",
        addressLine2: "",
        city: "",
        failLevelCode: "",
        state: "",
        zip: "",
        plus4: ""
    };

    @track responseData = {
        otherDemographics: {
            lookupID: "",
            cellPhone: "",
            cellPhone2: "",
            homePhone: "",
            placeOfEmployment: "",
            workPhone: ""
        },
        garagingAddress: {
            lookupID: "",
            addressLine1: "",
            addressLine2: "",
            addressType: "Garaging",
            city: "",
            state: "",
            zipCode: "",
            county: "",
            isScrubbedAccepted: false
        },
        billToAddress: {
            lookupID: "",
            addressLine1: "",
            addressLine2: "",
            addressType: "BillTo",
            city: "",
            state: "",
            zipCode: "",
            county: "",
            isScrubbedAccepted: false,
            isNullBillingAddress: false
        }
    };
    @track label = {
        addressProcessingMessage,
        addressValidatatingMessage,
        successMessageForBilling,
        successMessageForBillingGaraging,
        successMessageForGaraging,
        successMessageForGaragingBilling,
        failureResponseMessage,
        webServiceDownMessage
    };

    @track isCheckBoxGaragingBilling = false; //Added by Prabu for the bug 21975

    connectedCallback() {
        console.log('eneterpopup>>>>');
        loadStyle(this, ahfctheme + "/theme.css").then(() => {});
        this.responseData = JSON.parse(JSON.stringify(this.resultData));

        //START - Added by Prabu for the bug 21975
        if(this.responseData.billToAddress.addressLine1 != undefined)
        {        
        if(this.responseData.billToAddress.addressLine1.includes('PO BOX'))
        {
            this.isCheckBoxGaragingBilling = true;
        }       
        }
        if(this.responseData.billToAddress.addressLine2 != undefined)
        {
        if(this.responseData.billToAddress.addressLine2.includes('PO BOX'))
        {
            this.isCheckBoxGaragingBilling = true;
        }    
        }

        //END - Added by Prabu for the bug 21975
        if (this.responseData.billToAddress.addressLine1 === undefined) {
            this.responseData.billToAddress.addressLine1 = '';
        }
        if (this.responseData.billToAddress.addressLine2 === undefined) {
            this.responseData.billToAddress.addressLine2 = '';
        }
        if (this.responseData.billToAddress.city === undefined) {
            this.responseData.billToAddress.city = '';
        }
        if (this.responseData.billToAddress.state === undefined) {
            this.responseData.billToAddress.state = '';
        }
        if (this.responseData.billToAddress.zipCode === undefined) {
            this.responseData.billToAddress.zipCode = '';
        }
        if (this.responseData.garagingAddress.addressLine1 === undefined) {
            this.responseData.garagingAddress.addressLine1 = '';
        }
        if (this.responseData.garagingAddress.addressLine2 === undefined) {
            this.responseData.garagingAddress.addressLine2 = '';
        }
        if (this.responseData.garagingAddress.city === undefined) {
            this.responseData.garagingAddress.city = '';
        }
        if (this.responseData.garagingAddress.state === undefined) {
            this.responseData.garagingAddress.state = '';
        }
        if (this.responseData.garagingAddress.zipCode === undefined) {
            this.responseData.garagingAddress.zipCode = '';
        }
        if (this.responseData.otherDemographics.cellPhone === undefined) {
            this.responseData.otherDemographics.cellPhone = '';
        }
        if (this.responseData.otherDemographics.cellPhone2 === undefined) {
            this.responseData.otherDemographics.cellPhone2 = '';
        }
        if (this.responseData.otherDemographics.homePhone === undefined) {
            this.responseData.otherDemographics.homePhone = '';
        }
        if (this.responseData.otherDemographics.workPhone === undefined) {
            this.responseData.otherDemographics.workPhone = '';
        }
        if (this.responseData.otherDemographics.placeOfEmployment === undefined) {
            this.responseData.otherDemographics.placeOfEmployment = '';
        }
        if (this.nickNameModal || this.contactInfoModal) {
            this.btnSection = true;
        } else {
            this.btnSectionForAddress = true;
            this.getUSStates();
        }
    }

    getUSStates() {
        let Allstates = String(this.States);
        let Allstatescode = String(this.StatesCode);
        let arrStateSplit = Allstates.split(',');
        let arrStateCodeSplit = Allstatescode.split(',');
        this.listofState = arrStateSplit.map((arr1, arr2) => {
            const obj = {
                label: arr1.trim(),
                value: arrStateCodeSplit[arr2].trim()
            };
            return obj;
        });
        if (this.garageAddressModal) {
            if (this.responseData.garagingAddress.state !== '') {
                this.selectedState = this.responseData.garagingAddress.state;
            }
        } else {
            if (this.responseData.billToAddress.state !== '') {
                this.selectedState = this.responseData.billToAddress.state;
            }
        }
    }
    handleInputData(event) {
        this.validateFields(event);
        let targetId;
        targetId = event.target.getAttribute("data-id");
        switch (targetId) {
            case "cell1-input":
                this.responseData.otherDemographics.cellPhone = event.target.value;
                break;
            case "cell2-input":
                this.responseData.otherDemographics.cellPhone2 = event.target.value;
                break;
            case "homePhone-input":
                this.responseData.otherDemographics.homePhone = event.target.value;
                break;
            case "workPhone-input":
                this.responseData.otherDemographics.workPhone = event.target.value;
                break;
            case "employerName-input":
                this.responseData.otherDemographics.placeOfEmployment =
                    event.target.value;
                break;
            case "address1-input":
                this.responseData.garagingAddress.addressLine1 = event.target.value;
                break;
            case "address2-input":
                this.responseData.garagingAddress.addressLine2 = event.target.value;
                break;
            case "city-input":
                this.responseData.garagingAddress.city = event.target.value;
                break;
            case "state-input":
                this.selectedState = event.target.value;
                this.responseData.garagingAddress.state = event.target.value;
                break;
            case "zipcode-input":
                this.responseData.garagingAddress.zipCode = event.target.value;
                break;
            case "bill-address1-input":
                this.responseData.billToAddress.addressLine1 = event.target.value;
                //START - Added by Prabu for the bug 21975
                if(this.responseData.billToAddress.addressLine1.includes('PO BOX'))
                {
                    this.isCheckBoxGaragingBilling = true;
                }
                else
                {
                    this.isCheckBoxGaragingBilling = false;
                }
                //END - Added by Prabu for the bug 21975
                break;
            case "bill-address2-input":
                this.responseData.billToAddress.addressLine2 = event.target.value;
                //START - Added by Prabu for the bug 21975
                if(this.responseData.billToAddress.addressLine2.includes('PO BOX'))
                {
                    this.isCheckBoxGaragingBilling = true;
                }
                else
                {
                    this.isCheckBoxGaragingBilling = false;
                }
                //END - Added by Prabu for the bug 21975
                break;
            case "bill-city-input":
                this.responseData.billToAddress.city = event.target.value;
                break;
            case "bill-state-input":
                this.selectedState = event.target.value;
                this.responseData.billToAddress.state = event.target.value;
                break;
            case "bill-zipcode-input":
                this.responseData.billToAddress.zipCode = event.target.value;
                break;
        }
    }

    handleCheckedBill(event) {
        this.checkboxBill = event.target.checked;
    }

    handleChecked(event) {
        this.checkboxVal = event.target.checked;
    }

    handleChangeFinAccDetail(event) {
        if (event.target.value.length < 30) {
            this.updatenicknamefinaccdetail = event.target.value;
        } else {
            this.updatenicknamefinaccdetail = event.target.value.slice(0, 30);
        }
    }

    onAddressValidate() {
        this.loaded = true;
        this.loadingMsg = this.label.addressValidatatingMessage; //Added by Kanagaraj for US - 10480 & 10481
        this.btnSectionForAddress = false;
        var addressLine1;
        var addressLine2;
        var cityName;
        var stateValue;
        var zip;
        if (this.billingAddressModal) {
            this.billingAddressModal = false;
            this.isAddressValidationforGaraging = false;
            addressLine1 = this.responseData.billToAddress.addressLine1;
            addressLine2 = this.responseData.billToAddress.addressLine2;
            cityName = this.responseData.billToAddress.city;
            stateValue = this.responseData.billToAddress.state;
            zip = this.responseData.billToAddress.zipCode;             
            ecrmAddressValidation({
                address1: addressLine1,
                address2: addressLine2,
                city: cityName,
                stateName: stateValue,
                zipcode: zip
            }).then((result) => {
                this.loaded = !this.loaded;
                this.openValidatemodal = true;
                this.ValidAddress = JSON.parse(JSON.stringify(result));
                console.log('ValidAddresssss-->',this.ValidAddress);
                if (this.ValidAddress.failLevelCode === "0") {
                    this.isfailLevel = false;
                } else {
                    this.isfailLevel = true;
                }
            });                    
                   
        } else if (this.garageAddressModal) {
            this.garageAddressModal = false;
            this.isAddressValidationforGaraging = true;
            addressLine1 = this.responseData.garagingAddress.addressLine1;
            addressLine2 = this.responseData.garagingAddress.addressLine2;
            cityName = this.responseData.garagingAddress.city;
            stateValue = this.responseData.garagingAddress.state;
            zip = this.responseData.garagingAddress.zipCode;
            //START - Added by Prabu for the bug 21975
            if(addressLine1.includes('PO BOX') || addressLine2.includes('PO BOX'))     
            {
                this.loaded = !this.loaded;
                this.openValidatemodal = true;
                this.isfailLevel = true;
            }
            else
            { 
                this.isfailLevel = false;               
                ecrmAddressValidation({
                    address1: addressLine1,
                    address2: addressLine2,
                    city: cityName,
                    stateName: stateValue,
                    zipcode: zip
                }).then((result) => {
                    this.loaded = !this.loaded;
                    this.openValidatemodal = true;
                    this.ValidAddress = JSON.parse(JSON.stringify(result));
                    console.log('ValidAddresssss-->',this.ValidAddress);
                    if (this.ValidAddress.failLevelCode === "0") {
                        this.isfailLevel = false;
                    } else {
                        this.isfailLevel = true;
                    }
                });                    
            } 
        }       
       //END - Added by Prabu for the bug 21975
        const scrollOptions = {
            left: 0,
            top: 0,
            behavior: "smooth"
        };
        window.scrollTo(scrollOptions);
    }

    onECRMAddressValidation(){
        console.log('cityName-->',cityName);
         
    }

    onEditAddress() {
        this.btnSectionForAddress = true;
        if (this.isAddressValidationforGaraging) {
            this.garageAddressModal = true;
        } else {
            this.billingAddressModal = true;
        }
        this.openValidatemodal = false;
    }
    OnRecommendedAddress() {
        this.loadingMsg = this.label.addressProcessingMessage; //Added by Kanagaraj for US - 10480 & 10481
        this.openValidatemodal = false;
        //Added by Kanagaraj for US - 10480 & 10481
        if (this.ValidAddress.plus4 != undefined && this.ValidAddress.plus4 !== null) {
            this.ValidAddress.zip = this.ValidAddress.zip + '-' + this.ValidAddress.plus4;
        }
        if (this.isAddressValidationforGaraging) {
            this.responseData.garagingAddress.addressLine1 = this.ValidAddress.addressLine1;
            this.responseData.garagingAddress.addressLine2 = this.ValidAddress.addressLine2;
            this.responseData.garagingAddress.city = this.ValidAddress.city;
            this.responseData.garagingAddress.stat = this.ValidAddress.state;
            this.responseData.garagingAddress.zipCode = this.ValidAddress.zip;
            this.responseData.garagingAddress.isScrubbedAccepted = true;
        } else {
            this.responseData.billToAddress.addressLine1 = this.ValidAddress.addressLine1;
            this.responseData.billToAddress.addressLine2 = this.ValidAddress.addressLine2;
            this.responseData.billToAddress.city = this.ValidAddress.city;
            this.responseData.billToAddress.state = this.ValidAddress.state;
            this.responseData.billToAddress.zipCode = this.ValidAddress.zip;
            this.responseData.billToAddress.isScrubbedAccepted = true;
        }
        this.onSave();
    }
    OnEnteredAddress() {
        this.loadingMsg = this.label.addressProcessingMessage;
        this.openValidatemodal = false;
        this.responseData.garagingAddress.isScrubbedAccepted = false;
        this.responseData.billToAddress.isScrubbedAccepted = false;
        this.onSave();
    }
    onSave() {
        if (this.contactInfoModal) {
            if (this.responseData.otherDemographics.cellPhone === '' && this.responseData.otherDemographics.cellPhone2 === '' && this.responseData.otherDemographics.homePhone === '' &&
                this.responseData.otherDemographics.workPhone === '') {
                this.isValid = true;
                this.isMustonephonenumber = true;
                this.template
                    .querySelector(".cellphone1")
                    .classList.add("slds-has-error");
            }
            if (!this.isValid) {
                this.loadingsprinner = true;
                this.contactInfoModal = false;
                this.responseData.otherDemographics.lookupID = this.getFinanceAccountNum;
                updateFinannceAccountContactDetails({
                    financeAccNumber: this.getFinanceAccountNum,
                    stringDemographicsBody: JSON.stringify(this.responseData.otherDemographics)
                }).then((result) => {
                    this.boolResultAfterUpdate = result.isSuccess;
                    const selectedEvent = new CustomEvent("modalsave", {
                        detail: {
                            resultData: JSON.stringify(this.responseData),
                            isModal: false,
                            modalName: "Contact",
                            isUpdateSuccessful: this.boolResultAfterUpdate,
                            isResponseCode: result.isResponseCode
                        }
                    });
                    this.dispatchEvent(selectedEvent);
                }).catch((error) => {
                    //Record access check exception handling - Supriya Chakraborty 17-Nov-2021
                    if(error.body.message == 'invalid access'){
                        this[NavigationMixin.Navigate]({
                            type: "comm__namedPage",
                            attributes: {
                                pageName: "dashboard"
                            }
                        });
                    }
                    this.onWebServiceDown();
                });
            }
        } else if (this.nickNameModal) {
            let targetPart = this.template.querySelector(".nickname");
            console.log('targetPart1', this.updatenicknamefinaccdetail);
            // Bug 20070 

            if (this.updatenicknamefinaccdetail == null || this.updatenicknamefinaccdetail == undefined || this.updatenicknamefinaccdetail == '') {
                this.nickNameValidation = 'Error: Nickname cannot be blank.';
            } else {
                console.log('target2', this.updatenicknamefinaccdetail);
                updateFinanceNickName({
                        FinanceId: this.finacc,
                        NickName: this.updatenicknamefinaccdetail
                    }).then((result) => {
                        const selectedEvent = new CustomEvent("modalsave", {
                            detail: {
                                updatedNickname: result.AHFC_Product_Nickname__c,
                                isModal: false,
                                modalName: "nickNameModal"
                            }
                        });
                        this.dispatchEvent(selectedEvent);
                        const closeQA = new CustomEvent('close');
                        this.dispatchEvent(closeQA);

                    })
                    .catch((err) => {
                        //Record access check exception handling - Supriya Chakraborty 17-Nov-2021
                        if(err.body.message == 'invalid access'){
                            this[NavigationMixin.Navigate]({
                                type: "comm__namedPage",
                                attributes: {
                                    pageName: "dashboard"
                                }
                            });
                        }
                    });
            }


        } else if (this.isAddressValidationforGaraging) {
            this.loaded = true;
            //Added by Kanagaraj for US - 10480 & 10481 start
            if (this.checkboxVal) {
                this.successMessage = this.label.successMessageForGaragingBilling;
            } else {
                this.successMessage = this.label.successMessageForGaraging;
            }
            //Added by Kanagaraj for US - 10480 & 10481 end
            console.log('isNullBilling', this.responseData.billToAddress.isNullBillingAddress);
            if (this.checkboxVal) {
                this.isBoolGaragingBillToUpdate = true;
                this.responseData.billToAddress.addressLine1 = this.responseData.garagingAddress.addressLine1;
                this.responseData.billToAddress.addressLine2 = this.responseData.garagingAddress.addressLine2;
                this.responseData.billToAddress.city = this.responseData.garagingAddress.city;
                this.responseData.billToAddress.state = this.responseData.garagingAddress.state;
                this.responseData.billToAddress.zipCode = this.responseData.garagingAddress.zipCode;
                this.onBoolGaragingAddressUpdate();

                // this.responseData.garagingAddress.isScrubbedAccepted = false;

                // handleremovebillingAddress({
                //   strLookUpID: this.getFinanceAccountNum
                // }).then((result) => {}).catch((error) => {});
            } else if (this.responseData.billToAddress.isNullBillingAddress !== undefined) {
                this.isBoolGaragingBillToUpdate = false;
                this.responseData.billToAddress.lookupID = this.getFinanceAccountNum;
                this.responseData.billToAddress.addressType = "BillTo";
                this.responseData.billToAddress.isScrubbedAccepted = false;
                handleUpdateAddress({
                    strJSON: JSON.stringify(this.responseData.billToAddress)
                }).then((result) => {
                    console.log('resultssssss>>', result);
                    console.log('isResponseCode', result.isResponseCode);
                    if (result.isResponseCode === "200" || result.isResponseCode === "202") {
                        console.log('Inside200');
                        this.isBoolGaragingBillToUpdate = true;
                        this.onBoolGaragingAddressUpdate();
                    } else if (result.isResponseCode === "404") {
                        this.onWebServiceDown();
                    } else if (!result.isSuccess) {
                        this.showErrorMessage(this.label.failureResponseMessage);
                        this.loaded = false;
                    }
                }).catch((error) => {
                    this.onWebServiceDown();
                    this.loaded = false;
                });
            } else {
                this.isBoolGaragingBillToUpdate = true;
                this.onBoolGaragingAddressUpdate();
            }
        } else if (!this.isAddressValidationforGaraging) {
            this.loaded = true;
            //Added by Kanagaraj for US - 10480 & 10481 start
            if (this.checkboxBill) {
                this.successMessage = this.label.successMessageForBillingGaraging;
            } else {
                this.successMessage = this.label.successMessageForBilling;
            }
            //Added by Kanagaraj for US - 10480 & 10481 end 
            if (this.checkboxBill && !this.isRedirectedFromPayOff) { // checkbox will be not visible if we redirect from payoff completion page US:4595 by edwin:- 
                // handleremovebillingAddress({
                //   strLookUpID: this.getFinanceAccountNum
                // }).then((result) => {}).catch((error) => {});
                console.log('502');
                this.responseData.garagingAddress.lookupID = this.getFinanceAccountNum;
                this.responseData.garagingAddress.addressLine1 = this.responseData.billToAddress.addressLine1;
                this.responseData.garagingAddress.addressLine2 = this.responseData.billToAddress.addressLine2;
                this.responseData.garagingAddress.addressType = "Garaging";
                this.responseData.garagingAddress.city = this.responseData.billToAddress.city;
                this.responseData.garagingAddress.state = this.responseData.billToAddress.state;
                this.responseData.garagingAddress.zipCode = this.responseData.billToAddress.zipCode;
                this.responseData.garagingAddress.isScrubbedAccepted = true;
                handleUpdateAddress({
                    strJSON: JSON.stringify(this.responseData.garagingAddress)
                }).then((result) => {
                    this.boolResultAfterBillingUpdate = result.isSuccess;
                    if (result.isResponseCode === "404") {
                        this.onWebServiceDown();
                    } else if (!result.isSuccess) {
                        if (result.counties !== undefined) {
                            this.loaded = false;
                            this.isCountyModel = true;
                            this.countyList = result.counties;
                            return;
                        } else if (!this.boolResultAfterBillingUpdate) {
                            this.loaded = false;
                            this.showErrorMessage(this.label.failureResponseMessage);
                        }
                    }
                    var resData = JSON.parse(JSON.stringify(this.responseData)); //Added the code for the bug - 21927                               
                    console.log('530resBillToData',resData);
                    // Added by Kanagaraj for SIT_BUG_15447
                    if (this.boolResultAfterBillingUpdate && this.checkboxBill && resData.billToAddress.addressType !=="Garaging") {
                        console.log('530');
                        this.checkboxBill = false;
                        handleremovebillingAddress({
                            strLookUpID: this.getFinanceAccountNum
                        }).then((result) => {
                            console.log('line535',result);
                        }).catch((error) => {});
                    }
                    const selectedEvent = new CustomEvent("modalsave", {
                        detail: {
                            resultData: JSON.stringify(this.responseData),
                            isModal: false,
                            modalName: "BillAddress",
                            isUpdateSuccessful: this.boolResultAfterBillingUpdate,
                            isSuccessMessage: this.successMessage,
                            isResponseCode: result.isResponseCode
                        }
                    });
                    const scrollOptions = {
                        left: 0,
                        top: 2000,
                        behavior: "smooth"
                    };
                    window.scrollTo(scrollOptions);
                    this.dispatchEvent(selectedEvent);
                }).catch((error) => {
                    this.onWebServiceDown();
                });
            } else {
                this.responseData.billToAddress.lookupID = this.getFinanceAccountNum;
                this.responseData.billToAddress.addressType = "BillTo";
                handleUpdateAddress({
                    strJSON: JSON.stringify(this.responseData.billToAddress)
                }).then((result) => {
                    this.boolResultAfterBillingUpdate = result.isSuccess;
                    if (result.isResponseCode === "404") {
                        this.onWebServiceDown();
                    } else if (!this.boolResultAfterBillingUpdate) {
                        this.loaded = false;
                        console.log('543');
                        if (!this.isRedirectedFromPayOff) {
                            this.showErrorMessage(this.label.failureResponseMessage);
                        }
                    }
                    console.log('resBillTo',JSON.stringify(this.responseData));                    
                    const selectedEvent = new CustomEvent("modalsave", {
                        detail: {
                            resultData: JSON.stringify(this.responseData),
                            isModal: false,
                            modalName: "BillAddress",
                            isUpdateSuccessful: this.boolResultAfterBillingUpdate,
                            isSuccessMessage: this.successMessage,
                            isResponseCode: result.isResponseCode                            
                        }
                    });
                    const scrollOptions = {
                        left: 0,
                        top: 2000,
                        behavior: "smooth"
                    };
                    window.scrollTo(scrollOptions);
                    this.dispatchEvent(selectedEvent);
                }).catch((error) => {
                    this.onWebServiceDown();
                });
            }
        }
    }


    onBoolGaragingAddressUpdate() {
        if (this.isBoolGaragingBillToUpdate) {
            this.responseData.garagingAddress.lookupID = this.getFinanceAccountNum;
            this.responseData.garagingAddress.addressType = "Garaging";
            handleUpdateAddress({
                strJSON: JSON.stringify(this.responseData.garagingAddress)
            }).then((result) => {
                console.log('result.isSuccess>>', result.isSuccess);
                this.boolResultAfterBillingUpdate = result.isSuccess;
                if (result.isResponseCode === "404") {
                    this.onWebServiceDown();
                } else if (!result.isSuccess) {
                    if (result.counties !== undefined) {
                        this.loaded = !this.loaded;
                        this.isCountyModel = true;
                        this.countyList = result.counties;
                        return;
                    } else if (!this.boolResultAfterBillingUpdate) {
                        this.loaded = false;
                        console.log('451');
                        this.showErrorMessage(this.label.failureResponseMessage);
                    }
                }                
                var resData = JSON.parse(JSON.stringify(this.responseData)); //Added the code for the bug - 21927                
                if (this.boolResultAfterBillingUpdate && this.checkboxVal && resData.billToAddress.addressType !=='Garaging') //Added the code for the bug - 21927
                {
                    console.log('RemovingBillToAddressEmpty');                    
                    this.checkboxVal = false;
                    handleremovebillingAddress({
                        strLookUpID: this.getFinanceAccountNum
                    }).then((result) => {  
                        if(result.statusCode === "200")           
                        {
                        this.responseData.billToAddress.addressType = "Garaging"; 
                        } 
                    }).catch((error) => {
                        console.log('Errrors',error);
                    });                   
                }                
                const selectedEvent = new CustomEvent("modalsave", {
                    detail: {
                        resultData: JSON.stringify(this.responseData),
                        isModal: false,
                        modalName: "GarageAddress",
                        isUpdateSuccessful: this.boolResultAfterBillingUpdate,
                        isSuccessMessage: this.successMessage,
                        isResponseCode: result.isResponseCode                        
                    }
                });
                const scrollOptions = {
                    left: 0,
                    top: 2000,
                    behavior: "smooth"
                };
                window.scrollTo(scrollOptions);
                this.dispatchEvent(selectedEvent);
                this.loaded = false;
            }).catch((error) => {
                this.onWebServiceDown();
                this.loaded = false;

            });
        } else {
            this.loaded = false;
        }
    }
    //Added by Kanagaraj for US - 8037 start
    onWebServiceDown() {
        this.showErrorMessage(this.label.webServiceDownMessage);
        this.onCancel();
        //return;
    }
    //Added by Kanagaraj for US - 8037 end
    onHandlingCounty(event) {
        let targetvalue;
        this.responseData.garagingAddress.county = event.target.value;

    }
    saveGaragingAddress() {

        this.isCountyModel = false;
        this.loaded = true;
        if (this.responseData.garagingAddress.county === undefined) {
            let listlenth = this.countyList.length - 1;
            this.responseData.garagingAddress.county = this.countyList[listlenth];
        }


        handleUpdateAddress({
            strJSON: JSON.stringify(this.responseData.garagingAddress)
        }).then((result) => {

            this.boolResultAfterBillingUpdate = result.isSuccess;
            console.log('resGaraging',JSON.stringify(this.responseData));
            const selectedEvent = new CustomEvent("modalsave", {
                detail: {
                    resultData: JSON.stringify(this.responseData),
                    isModal: false,
                    modalName: "GarageAddress",
                    isUpdateSuccessful: this.boolResultAfterBillingUpdate,
                    isSuccessMessage: this.successMessage,
                    isResponseCode: result.isResponseCode                    
                }
            });
            if (!this.boolResultAfterBillingUpdate) {
                console.log('610');
                this.showErrorMessage(this.label.failureResponseMessage);
            }
            var resData = JSON.parse(JSON.stringify(this.responseData)); //Added the code for the bug - 21927                               
            console.log('ResBillToData1',resData);
            // Added by Kanagaraj for SIT_BUG_15447
            if (this.boolResultAfterBillingUpdate && (this.checkboxVal || this.checkboxBill) && resData.billToAddress.addressType !=="Garaging") {
                console.log('698');
                this.checkboxVal = false;
                this.checkboxBill = false;
                handleremovebillingAddress({
                    strLookUpID: this.getFinanceAccountNum
                }).then((result) => {}).catch((error) => {});
            }            

            const scrollOptions = {
                left: 0,
                top: 2000,
                behavior: "smooth"
            };
            window.scrollTo(scrollOptions);
            this.dispatchEvent(selectedEvent);
        }).catch((error) => {
            this.onWebServiceDown();
        });
    }
    validateFields(event) {
        let targetId;
        targetId = event.target.getAttribute("data-id");
        if (event.target.validity.valid === false && targetId === 'cell1-input') {
            this.template
                .querySelector(".cellphone1")
                .classList.add("slds-has-error");
            this.isValidcellphone1 = true;
            this.isMustonephonenumber = false;
        } else if (event.target.validity.valid === true && targetId === 'cell1-input') {
            this.template
                .querySelector(".cellphone1")
                .classList.remove("slds-has-error");
            this.isValidcellphone1 = false;
        }
        if (event.target.validity.valid === false && targetId === 'cell2-input') {
            this.template
                .querySelector(".cellphone2")
                .classList.add("slds-has-error");
            this.isValidccellphone2 = true;

        } else if (event.target.validity.valid === true && targetId === 'cell2-input') {
            this.template
                .querySelector(".cellphone2")
                .classList.remove("slds-has-error");
            this.isValidccellphone2 = false;
        }
        if (event.target.validity.valid === false && targetId === 'homePhone-input') {
            this.template
                .querySelector(".homephonenumber")
                .classList.add("slds-has-error");
            this.isValidhomephonenumber = true;
        } else if (event.target.validity.valid === true && targetId === 'homePhone-input') {
            this.template
                .querySelector(".homephonenumber")
                .classList.remove("slds-has-error");
            this.isValidhomephonenumber = false;
        }
        if (event.target.validity.valid === false && targetId === 'workPhone-input') {
            this.template
                .querySelector(".workphone")
                .classList.add("slds-has-error");
            this.isValidworkphone = true;

        } else if (event.target.validity.valid === true && targetId === 'workPhone-input') {
            this.template
                .querySelector(".workphone")
                .classList.remove("slds-has-error");
            this.isValidworkphone = false;
        }
        if (this.isValidcellphone1 === true || this.isValidccellphone2 === true || this.isValidhomephonenumber === true || this.isValidworkphone === true) {
            this.isValid = true;
        } else {
            this.isValid = false;
        }
    }

    onCancel() {
        const selectedEvent = new CustomEvent("modalclose", {
            detail: this.isModalOpen
        });
        this.dispatchEvent(selectedEvent);
    }
    showErrorMessage(showErrorMsg) {
        const event = new ShowToastEvent({
            title: "Error",
            message: showErrorMsg,
            variant: "error",
            mode: "dismissable"
        });
        this.dispatchEvent(event);
    }
}