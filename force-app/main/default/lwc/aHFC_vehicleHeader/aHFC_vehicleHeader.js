/* Component Name        :    AHFC_vehicleHeader
    * Description        :    This is LWC for Header part om internal Pages. 
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Aniket                     80/10/2021              Created \
   */
import { LightningElement, track, wire } from "lwc";
import hondaCar from "@salesforce/resourceUrl/AHFC_Honda_Header_Car";
import hondaLogo from "@salesforce/resourceUrl/AHFC_Honda_Header_Logo";
import acuraLogo from "@salesforce/resourceUrl/AHFC_Acura_Header_Logo";
import powerequipmentlogo from "@salesforce/resourceUrl/powerequipmentlogo";
import Marinelogo from "@salesforce/resourceUrl/Marinelogo";
import nologo from "@salesforce/resourceUrl/AHFC_nologo";
import { fireEvent } from 'c/pubsub';
import AHFC_Header_AccountNumber from "@salesforce/label/c.AHFC_Header_AccountNumber";
import { CurrentPageReference } from "lightning/navigation";
import AHFC_PS_Collage from "@salesforce/resourceUrl/AHFC_PS_Collage";

import AHFC_static_Image_Marine from "@salesforce/resourceUrl/AHFC_static_Image_Marine";
import AHFC_static_Image_Powerequipment from "@salesforce/resourceUrl/AHFC_static_Image_Powerequipment";
import AHFC_static_Image_Non_honda_acura from "@salesforce/resourceUrl/AHFC_static_Image_Non_honda_acura";
import AHFC_static_Image_Non_available from "@salesforce/resourceUrl/AHFC_static_Image_Non_available";
import AHFC_Acura_services_logo from "@salesforce/resourceUrl/AHFC_Acura_services_logo";
import AHFC_Auto_logo from "@salesforce/resourceUrl/AHFC_Auto_logo";
import Honda_Powersports_Logo from "@salesforce/resourceUrl/Honda_Powersports_Logo";

import getEconfigResponse from "@salesforce/apex/AHFC_EConfigIntegrationHandler.getEconfigResponse";

import getServiceAccountDetails from "@salesforce/apex/AHFC_DashboardController.getServiceAccountdetails";
import handleGetAccountInfo from "@salesforce/apex/AHFC_GetAccountInfoIntergationHandler.handleGetAccountInfo";
import getEconfigResponsepower from "@salesforce/apex/AHFC_EconfigModelIntegHandler.getEconfigResponse";

export default class AHFC_vehicleHeader extends LightningElement {
    currentItem;
    @track containerClass;
    @track lstofServiceAccountwrapper;
    @track customServiceAccounts;
    @track isCarousalFirstItem = true;
    @track carousalPrevIconClass = "ahfc-icon-light-gray carousal-button-disabled";
    @track isCarousalLastItem = false;
    @track carousalNextIconClass = "ahfc-icon-red";
    @track showCarousel = true;
    @track pageRef;
    @track currentFinId;
    @track isLocked = false;
    @track financeSalesforceId = '';
    @track financeAccountId = '';
    @track isPrev = false;
    @track isNext = false;
    @track popuptext;
    @track isFirstTimeLoaded = true;
    @track isLoaded = false;
    @track isOnMobile = false;
    @track indicator;

    label = { AHFC_Header_AccountNumber };

    get hondaLogoUrl() {
        return hondaLogo;
    }

    get acuraLogoUrl() {
        return acuraLogo;
    }

    get carImage() {
        return hondaCar;
    }

    connectedCallback() {

        if (sessionStorage.getItem('salesforce_id') != null) {
            this.currentFinId = sessionStorage.getItem('salesforce_id');
        }

        this.getdata();
    }

    disconnectedCallback() {

    }

    //e-config service
    callEconfiSerice() {
        let econfigArray = [];
        let powersportarray = [];
        let str = '';
        let powersportstr = '';
        for (let i = 0; i < this.customServiceAccounts.length; i++) {
            if (this.customServiceAccounts[i].serAccRec.AHFC_Product_Type__c != undefined) {
                switch (this.customServiceAccounts[i].serAccRec.AHFC_Product_Type__c) {

                    //Product type is Auto
                    case 'Auto':
                        if (this.customServiceAccounts[i].serAccRec.AHFC_Product_Division__c != undefined && this.customServiceAccounts[i].serAccRec.Vehicle_Identification_Number__c != undefined) {
                            if (this.customServiceAccounts[i].serAccRec.AHFC_Product_Division__c != "N09") {
                                if (this.customServiceAccounts[i].serAccRec.AHFC_Product_Division__c == "A03") {
                                    this.customServiceAccounts[i].logourl = hondaLogo;
                                    this.customServiceAccounts[i].cls = 'ahfc-honda-blue';
                                } else if (this.customServiceAccounts[i].serAccRec.AHFC_Product_Division__c == "B04") {
                                    this.customServiceAccounts[i].logourl = acuraLogo;
                                    this.customServiceAccounts[i].cls = 'ahfc-honda-black';
                                } else {
                                    this.customServiceAccounts[i].logourl = nologo;
                                    this.customServiceAccounts[i].cls = 'ahfc-honda-black';
                                }

                                econfigArray.push({ '@vin_number': this.customServiceAccounts[i].serAccRec.Vehicle_Identification_Number__c, "@division_cd": this.customServiceAccounts[i].serAccRec.AHFC_Product_Division__c.charAt(0) })
                                this.customServiceAccounts[i].imageurl = AHFC_static_Image_Non_available;
                            } else {
                                if (this.customServiceAccounts[i].serAccRec.Honda_Brand__c == 'HFS') {
                                    this.customServiceAccounts[i].logourl = hondaLogo;
                                    this.customServiceAccounts[i].cls = 'ahfc-honda-blue';
                                    this.customServiceAccounts[i].imageurl = AHFC_static_Image_Non_honda_acura;
                                }
                                if (this.customServiceAccounts[i].serAccRec.Honda_Brand__c == 'AFS') {
                                    this.customServiceAccounts[i].logourl = acuraLogo;
                                    this.customServiceAccounts[i].imageurl = AHFC_static_Image_Non_honda_acura;
                                    this.customServiceAccounts[i].cls = 'ahfc-honda-black';
                                }
                            }
                        } else {
                            this.customServiceAccounts[i].imageurl = AHFC_static_Image_Non_available;
                            this.customServiceAccounts[i].logourl = nologo;
                            this.customServiceAccounts[i].cls = 'ahfc-honda-black';
                        }
                        break;

                    //Product type is Power sport
                    case 'Powersports':
                        this.customServiceAccounts[i].logourl = Honda_Powersports_Logo;
                        this.customServiceAccounts[i].imageurl = AHFC_PS_Collage;
                        this.customServiceAccounts[i].cls = 'ahfc-honda-red';
                        // if (this.customServiceAccounts[i].serAccRec.AHFC_Model_ID__c != undefined) {
                        //     powersportarray.push({ "@id": this.customServiceAccounts[i].serAccRec.AHFC_Model_ID__c });
                        // }
                        break;


                    //Product type is Marine
                    case 'Marine':
                        this.customServiceAccounts[i].logourl = Marinelogo;
                        this.customServiceAccounts[i].imageurl = AHFC_static_Image_Marine;
                        this.customServiceAccounts[i].cls = 'ahfc-honda-navyblue';
                        break;

                    //Product type is Power Equipment
                    case 'Power Equipment':
                        this.customServiceAccounts[i].logourl = powerequipmentlogo;
                        this.customServiceAccounts[i].cls = 'ahfc-honda-red';
                        this.customServiceAccounts[i].imageurl = AHFC_static_Image_Powerequipment;
                        break;

                    //Product type is Other
                    case 'Other':
                        this.customServiceAccounts[i].logourl = nologo;
                        this.customServiceAccounts[i].cls = 'ahfc-honda-black';
                        this.customServiceAccounts[i].imageurl = AHFC_static_Image_Non_available;
                        if (this.customServiceAccounts[i].serAccRec.Honda_Brand__c != undefined) {
                            if (this.customServiceAccounts[i].serAccRec.Honda_Brand__c == 'HFS') {
                                this.customServiceAccounts[i].logourl = AHFC_Auto_logo;
                                this.customServiceAccounts[i].cls = 'ahfc-honda-blue';
                            }
                            if (this.customServiceAccounts[i].serAccRec.Honda_Brand__c == 'AFS') {
                                this.customServiceAccounts[i].logourl = AHFC_Acura_services_logo;
                                this.customServiceAccounts[i].cls = 'ahfc-honda-black';
                            }
                        }
                        break;
                }

            } else {
                this.customServiceAccounts[i].cls = 'ahfc-honda-black';
                this.customServiceAccounts[i].logourl = nologo;
                this.customServiceAccounts[i].imageurl = AHFC_static_Image_Non_available;
            }

        }
        for (let i = 0; i < econfigArray.length; i++) {
            if (i == econfigArray.length - 1) {
                str = str + JSON.stringify(econfigArray[i]);
            } else {
                str = str + JSON.stringify(econfigArray[i]) + ',';
            }

        }

        for (let i = 0; i < powersportarray.length; i++) {
            if (i == powersportarray.length - 1) {
                powersportstr = powersportstr + JSON.stringify(powersportarray[i]);
            } else {
                powersportstr = powersportstr + JSON.stringify(powersportarray[i]) + ',';
            }
        }
        if (powersportarray.length > 0) {
            this.callPowerSportWebService(powersportstr);
        }


        if (econfigArray.length > 0) {
            getEconfigResponse({ inpVin: str })
                .then(result => {

                    let imagesUrls = JSON.parse(result);
                    let errorcode = '@error_reason';
                    if (imagesUrls[errorcode] == undefined) {
                        for (let key in imagesUrls) {
                            for (let i = 0; i < this.customServiceAccounts.length; i++) {
                                if (this.customServiceAccounts[i].serAccRec.Vehicle_Identification_Number__c == key) {
                                    this.customServiceAccounts[i].imageurl = imagesUrls[key];
                                }
                            }
                        }
                    }
                })
                .catch(error => {
                    console.log('170', error);
                })
        }

    }


    //Actual web service callout for power sport images.
    callPowerSportWebService(str) {
        getEconfigResponsepower({ modelId: str })
            .then(result => {
                if (result.includes('Error')) {
                    return;
                }
                let imagesUrls = JSON.parse(result);
                for (let key in imagesUrls) {
                    for (let i = 0; i < this.customServiceAccounts.length; i++) {
                        if (this.customServiceAccounts[i].serAccRec.AHFC_Model_ID__c == key) {
                            this.customServiceAccounts[i].imageurl = imagesUrls[key];
                        }
                    }
                }
            })
            .catch(error => {
                console.log('powersport web service error', error);
            })
    }


    // Get service account customer id from previous page
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.pageRef = currentPageReference;
    }


    getdata() {
        getServiceAccountDetails()
            .then(data => {
                if (data) {

                    this.lstofServiceAccountwrapper = data;
                    this.formatAccounts(JSON.parse(JSON.stringify(data)));
                    if (data.length > 0) {
                        let index = 0;
                        if (this.currentFinId != undefined) {
                            index = this.customServiceAccounts.findIndex((item) => {
                                return item.serAccRec.Id == this.currentFinId;
                            });
                        }
                        let newArray = this.customServiceAccounts.slice(index, index + 1);
                        this.customServiceAccounts = JSON.parse(JSON.stringify(newArray));
                        index = 0;
                        this.setUpPage('', index);
                    }
                    this.callEconfiSerice();
                    this.showCarousel = data.length > 1 ? true : false;
                    this.containerClass = this.showCarousel ? "ahfc-container container" : "ahfc-container container container-bottom-gap";



                } else if (error) {
                    console.log('error', error);
                }
            })
    }




    // Formatting each account object with extra class names and ids to setup the carousal
    formatAccounts(totalAccounts) {
        this.customServiceAccounts = [];

        let testarray = JSON.parse(JSON.stringify(totalAccounts));
        let newtestarray = [];
        let abc = [];

        for (let i = 0; i < testarray.length; i++) {
            if ((testarray[i].serAccRec.AHFC_Web_Account_Locked__c != undefined && testarray[i].serAccRec.AHFC_Web_Account_Locked__c == 'Y') || (testarray[i].serAccRec.AHFC_Fl_Archived__c != undefined && testarray[i].serAccRec.AHFC_Fl_Archived__c == 'Y')) {
                abc.push(testarray[i]);
            } else {
                newtestarray.push(testarray[i]);
            }
        }

        let sortedData = newtestarray.concat(abc);

        sortedData.forEach((val, index) => {

            val.keyNo = index;
            val.panelId = `panel-${index}`;
            val.ariaHidden = "true";
            val.tabIndex = "-1";
            val.indicatorId = `indicator-${index}`;
            val.indicatorClass = "slds-carousel__indicator-action";
            val.ariaSelected = "false";
            val.name = val.serAccRec
                ? val.serAccRec.AHFC_Product_Nickname__c
                : "";
            val.accNoWoZeros = val.serAccRec
                ? val.serAccRec.Finance_Account_Number_Without_Zeroes__c
                : "";
            val.accNo = val.serAccRec
                ? val.serAccRec.Finance_Account_Number__c
                : "";
            this.customServiceAccounts.push(val);
        });
    }

    // Setup the selected account for the page and respective child elements on changing between accounts in Carousal
    setUpPage(prevPage, nextPage) {
        if (prevPage + "") {
            this.customServiceAccounts[prevPage].ariaHidden = "true";
            this.customServiceAccounts[prevPage].tabIndex = "-1";
            this.customServiceAccounts[prevPage].indicatorClass = "slds-carousel__indicator-action";
            this.customServiceAccounts[prevPage].ariaSelected = "false";
        }

        this.customServiceAccounts[nextPage].ariaHidden = "false";
        this.customServiceAccounts[nextPage].tabIndex = "-1";
        this.customServiceAccounts[nextPage].indicatorClass = "slds-carousel__indicator-action slds-is-active";
        this.customServiceAccounts[nextPage].ariaSelected = "true";

        let panelBlock = this.template.querySelector(`.ahfc-carousal .slds-carousel__panels`);
        const transform = nextPage * 100;
        if (panelBlock) {
            panelBlock.style.transform = `translateX(-${transform}%)`;
        }
        this.currentItem = nextPage;
        //this.displayicons();

        fireEvent(this.pageRef, 'AHFC_Account_Selected', JSON.stringify(this.customServiceAccounts[this.currentItem]));
        sessionStorage.setItem('salesforce_id', this.customServiceAccounts[this.currentItem].serAccRec.Id);
        sessionStorage.setItem('reloaded', 'false');
        if (this.isFirstTimeLoaded) {
            this.isFirstTimeLoaded = false;
            this.getAccountInfo(JSON.stringify(this.customServiceAccounts[this.currentItem]));
        }

    }

    //To get Account info from web sevice call
    getAccountInfo(findata) {

        if (this.isOnMobile) {
            //this.customServiceAccounts[parseInt(event.target.dataset.indicator)].serAccRec.Finance_Account_Number__c

            sessionStorage.setItem('salesforce_id', this.customServiceAccounts[parseInt(this.indicator)].serAccRec.Id);
        }
        if (this.isPrev) {
            sessionStorage.setItem('salesforce_id', this.customServiceAccounts[parseInt(this.currentItem) - 1].serAccRec.Id);

        }
        if (this.isNext) {
            sessionStorage.setItem('salesforce_id', this.customServiceAccounts[parseInt(this.currentItem) + 1].serAccRec.Id);
        }
        let newfindata = JSON.parse(findata);

        let obj = {};
        obj.Id = newfindata.serAccRec.Id;
        obj.boolenrolled = newfindata.boolenrolled;
        if (newfindata.serAccRec.AHFC_Web_Account_Locked__c == undefined && newfindata.serAccRec.AHFC_Fl_Archived__c == undefined) {
            obj.AHFC_Web_Account_Locked__c = "N";
            obj.AHFC_Fl_Archived__c = "N";
        } else if (newfindata.serAccRec.AHFC_Web_Account_Locked__c != undefined && newfindata.serAccRec.AHFC_Fl_Archived__c == undefined) {
            obj.AHFC_Web_Account_Locked__c = newfindata.serAccRec.AHFC_Web_Account_Locked__c;
            obj.AHFC_Fl_Archived__c = 'N';
        } else if (newfindata.serAccRec.AHFC_Web_Account_Locked__c == undefined && newfindata.serAccRec.AHFC_Fl_Archived__c != undefined) {
            obj.AHFC_Web_Account_Locked__c = 'N';
            obj.AHFC_Fl_Archived__c = newfindata.serAccRec.AHFC_Fl_Archived__c;
        } else {
            obj.AHFC_Web_Account_Locked__c = newfindata.serAccRec.AHFC_Web_Account_Locked__c;
            obj.AHFC_Fl_Archived__c = newfindata.serAccRec.AHFC_Fl_Archived__c;
        }
        let payload = {
            finaAccountData: obj,
            getAccountInfo: ''
        };


        if (this.pageRef.attributes.name == 'Finance_Account_Profile__c') {
            fireEvent(this.pageRef, 'financeAccountInfo', JSON.stringify(payload));
            if (this.isPrev) {
                this.setUpPage(parseInt(this.currentItem), parseInt(this.currentItem) - 1);
            }
            if (this.isNext) {
                this.setUpPage(parseInt(this.currentItem), parseInt(this.currentItem) + 1);
            }

            if (this.isOnMobile) {
                this.setUpPage(this.currentItem, this.indicator);
            }
            return;
        }

        if (newfindata.serAccRec.AHFC_Fl_Archived__c !== undefined && newfindata.serAccRec.AHFC_Fl_Archived__c == 'Y') {
            this.isLocked = true;
            fireEvent(this.pageRef, 'financeAccountInfo', JSON.stringify(payload));
            return;
        }

        if (newfindata.serAccRec.AHFC_Web_Account_Locked__c !== undefined && newfindata.serAccRec.AHFC_Web_Account_Locked__c == 'Y') {
            fireEvent(this.pageRef, 'financeAccountInfo', JSON.stringify(payload));
            this.isLocked = true;

        } else {
            if (sessionStorage.getItem(newfindata.accNo) == null) {

                this.isLoaded = true;
                handleGetAccountInfo({ strFinanceAccount: newfindata.accNo })
                    .then(data => {

                        this.isLoaded = false;
                        if (data != 'FAILED') {
                            sessionStorage.setItem(newfindata.accNo, data);
                            let getaccountdata = JSON.parse(data);
                            if (getaccountdata.isWebsiteRestricted == true) {
                                this.isLocked = true;
                            } else if (getaccountdata.isWebsiteRestricted == false) {

                                if (this.isPrev) {
                                    this.setUpPage(parseInt(this.currentItem), parseInt(this.currentItem) - 1);
                                }
                                if (this.isNext) {
                                    this.setUpPage(parseInt(this.currentItem), parseInt(this.currentItem) + 1);
                                }
                                if (this.isOnMobile) {
                                    this.setUpPage(this.currentItem, this.indicator);
                                }
                            }
                            payload.getAccountInfo = getaccountdata;
                            fireEvent(this.pageRef, 'financeAccountInfo', JSON.stringify(payload));
                        } else {
                            if (this.isPrev) {
                                this.setUpPage(parseInt(this.currentItem), parseInt(this.currentItem) - 1);
                            }
                            if (this.isNext) {
                                this.setUpPage(parseInt(this.currentItem), parseInt(this.currentItem) + 1);
                            }
                            if (this.isOnMobile) {
                                this.setUpPage(this.currentItem, this.indicator);
                            }
                            fireEvent(this.pageRef, 'financeAccountInfo', JSON.stringify(payload));
                        }
                    })
                    .catch(error => {

                        this.isLoaded = false;
                        if (this.isPrev) {
                            this.setUpPage(parseInt(this.currentItem), parseInt(this.currentItem) - 1);
                        }
                        if (this.isNext) {
                            this.setUpPage(parseInt(this.currentItem), parseInt(this.currentItem) + 1);
                        }
                        if (this.isOnMobile) {
                            this.setUpPage(this.currentItem, this.indicator);
                        }
                        fireEvent(this.pageRef, 'financeAccountInfo', JSON.stringify(payload));
                    })
            } else {

                let sessioneddata = JSON.parse(sessionStorage.getItem(newfindata.accNo));
                if (sessioneddata.isWebsiteRestricted == true) {
                    this.isLocked = true;
                } else if (sessioneddata.isWebsiteRestricted == false) {

                    if (this.isPrev) {
                        this.setUpPage(parseInt(this.currentItem), parseInt(this.currentItem) - 1);
                    }
                    if (this.isNext) {
                        this.setUpPage(parseInt(this.currentItem), parseInt(this.currentItem) + 1);
                    }
                    if (this.isOnMobile) {

                        this.setUpPage(this.currentItem, this.indicator);
                    }
                }
                payload.getAccountInfo = sessioneddata;
                fireEvent(this.pageRef, 'financeAccountInfo', JSON.stringify(payload));
            }
        }
    }

}