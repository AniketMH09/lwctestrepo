/* Component Name   :    aHFC_errorPageFooterMenu
 * @Description      :   LWC for Menu Footer for VF Error dashboard
 * Modification Log  :
 * --------------------------------------------------------------------------- 
 * Developer                   Date                   Description
 * ---------------------------------------------------------------------------
 * Narain              	August 12 2021                Created
 *********************************************************************************/



import { LightningElement, track, wire } from "lwc";
import acurawhiteLogo from "@salesforce/resourceUrl/AHFC_ACURA_White_Logo";
import hondabikeLogo from "@salesforce/resourceUrl/AHFC_Honda_Bike_White_Logo";
import hondacarLogo from "@salesforce/resourceUrl/AHFC_Honda_Car_White_Logo";
import hondaJetLogo from "@salesforce/resourceUrl/AHFC_Honda_Jet_White_Logo";
import hondaMarineLogo from "@salesforce/resourceUrl/AHFC_Honda_Marine_White_Logo";
import hondaPowerEqLogo from "@salesforce/resourceUrl/AHFC_Honda_Power_Equipment_White_Logo";
import isguest from '@salesforce/user/isGuest';
import { NavigationMixin } from "lightning/navigation";
import FORM_FACTOR from "@salesforce/client/formFactor";
import { labels } from "c/aHFC_dashboardConstantsUtil";
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';
import { getConstants } from "c/ahfcConstantUtil";
import AHFC_Community_Named_Dashboard from "@salesforce/label/c.AHFC_Community_Named_Dashboard";
import AHFC_CUSTOMER from "@salesforce/label/c.AHFC_CUSTOMER";

const CONSTANTS = getConstants();

export default class aHFC_errorPageFooterMenu extends NavigationMixin(LightningElement) {


    get acurawhiteLogoUrl() {
        return acurawhiteLogo;
    }
    get hondabikeLogoUrl() {
        return hondabikeLogo;
    }
    get hondacarLogoUrl() {
        return hondacarLogo;
    }
    get hondaJetLogoUrl() {
        return hondaJetLogo;
    }
    get hondaMarineLogoUrl() {
        return hondaMarineLogo;
    }
    get hondaPowerEqLogoUrl() {
        return hondaPowerEqLogo;
    }
    @
    track showdesktop;@track isSubMenuOpenProdSupport = false;@track isSubMenuOpenDealer = false;@track isSubMenuOpenCalculator = false;@track isSubMenuOpenOffer = false;@track isSubMenuOpenFinance = false;@track isSubMenuOpenSupport = false;@track isSubMenuOpenMyacc = false;@track showmobile;@track labels = labels;
    isCheck = isguest;@track isGuestCheck = false;@track payLoadWrapper;@track getAccountInfo = {};@track finAccData;@track isWebAccLocked;@track islockedHeaderFooter = false;@track isArchived;@track isGetAccountInfo = false;@track isDisplay = true;@track isDoNotDisplay = true;@wire(CurrentPageReference) pageRef;
    @track IDSAC;

    @track boolEnrolledEZP = false;
    @track showManageEZPButton = false;
    @track showEZPButton = false;
    aHFC_customerUrl = AHFC_CUSTOMER;

    /*Added for 7239 US - Start*/
    /*
     * @Description: added pusub function to get the finance account data and getAccount info from dashboard*/
    pubsubfunction(payload) {
        console.log('50 Footer', JSON.parse(payload));

        this.payLoadWrapper = JSON.parse(payload);
        this.getAccountInfo = this.payLoadWrapper.getAccountInfo;
        console.log('this.getAccountInfo ', this.getAccountInfo);
        this.isWebAccLocked = this.finaApayLoadWrapperccountData.AHFC_Web_Account_Locked__c;
        console.log('this.isWebAccLocked ', this.isWebAccLocked);
        this.isArchived = this.payLoadWrapper.finaAccountData.AHFC_Fl_Archived__c;
        console.log('this.isArchived ', this.isArchived);
        this.boolEnrolledEZP = this.payLoadWrapper.finaAccountData.boolenrolled; //US:8396 Aswin Jose - To check if the finance account is enrolled in EZP
        console.log('Bool Enrol EZP footer:  ', this.boolEnrolledEZP);

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
        } else {
            console.log('444');
            this.isDisplay = true;
            this.isDoNotDisplay = true;
        }

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
    onSubmenuFinanceClick() {
        this.isSubMenuOpenFinance = !this.isSubMenuOpenFinance;
        this.isSubMenuOpenOffer = false;
        this.isSubMenuOpenCalculator = false;
        this.isSubMenuOpenDealer = false;
    }
    onSubmenuSupportClick() {
        this.isSubMenuOpenSupport = !this.isSubMenuOpenSupport;
        this.isSubMenuOpenProdSupport = false;
    }
    onSubmenuMyaccClick() {
        this.isSubMenuOpenMyacc = !this.isSubMenuOpenMyacc;
    }
    onSubmenuOfferClick() {
        this.isSubMenuOpenOffer = !this.isSubMenuOpenOffer;
    }
    onSubmenuCalcClick() {
        this.isSubMenuOpenCalculator = !this.isSubMenuOpenCalculator;
    }
    onSubmenuDealClick() {
        this.isSubMenuOpenDealer = !this.isSubMenuOpenDealer;
    }
    onSubmenuProdSupClick() {
        this.isSubMenuOpenProdSupport = !this.isSubMenuOpenProdSupport;
    }
    connectedCallback() {
        //registerListener('financeAccountInfo', this.pubsubfunction, this);
        this.navigationUrls();
        if (FORM_FACTOR == this.labels.LargeLabel) {
            this.showdesktop = true;
            this.showmobile = false;
        } else if (FORM_FACTOR == this.labels.MediumLabel) {
            this.showdesktop = true;
            this.showmobile = true;
        } else {
            this.showdesktop = false;
            this.showmobile = true;
        }
    }

    navigationUrls() {

        this.aboutUs = this.labels.errorFooterUrl + this.labels.errorFooter_aboutUs;
        this.termsAndConditions = this.labels.errorFooterUrl + this.labels.errorFooter_termsAndConditions;
        this.applyforPreApproval = this.labels.errorFooterUrl + this.labels.errorFooter_creditpreapproval;
        this.leaseVsFinance = this.labels.errorFooterUrl + this.labels.errorFooter_leaseVsFinance;
        this.hondaLoyaltyBenefits = this.labels.errorFooterUrl + this.labels.errorFooter_hondaLoyaltyBenefits;
        this.acuraLoyaltyAdvantage = this.labels.errorFooterUrl + this.labels.errorFooter_acuraLoyaltyAdvantage;
        this.endofTerm = this.labels.errorFooterUrl + this.labels.errorFooter_endofTerm;
        this.protectionofProducts = this.labels.errorFooterUrl + this.labels.errorFooter_protectionofProducts;
        this.printableForms = this.labels.errorFooterUrl + this.labels.errorFooter_printableForms;
        this.paymentOptions = this.labels.errorFooterUrl + this.labels.errorFooter_paymentOptions;
        this.myDashboard = this.labels.errorFooterUrl + this.labels.errorFooter_dashboard;
        this.financeAccountDetails = this.labels.errorFooterUrl + this.labels.errorFooter_financeAccountDetails;
        this.myPaymentSources = this.labels.errorFooterUrl + this.labels.errorFooter_myPaymentSources;
        this.communicationPreferences = this.labels.errorFooterUrl + this.labels.errorFooter_communicationPreferences;
        this.statements = this.labels.errorFooterUrl + this.labels.errorFooter_statements;
        this.correspondence = this.labels.errorFooterUrl + this.labels.errorFooter_correspondence;
    }

    /*
    	navigateToPrintableForms() {
    		this[NavigationMixin.Navigate]({
    			type: "comm__namedPage",
    			attributes: {
    				pageName:'printable-forms'
    			},
    			state: {
    				sacRecordId: this.IDSAC
    			  }
    		});
    	}
    	navigateToTermsAndConditions() {
    		this[NavigationMixin.Navigate]({
    			type: "comm__namedPage",
    			attributes: {
    				pageName:'post-legal-terms-and-conditions'
    			},
    		});
    	}
    	navigateToProtectionProducts() {
    		this[NavigationMixin.Navigate]({
    			type: "comm__namedPage",
    			attributes: {
    				pageName:'protection-products'
    			}
    		});
    	}
        navigateToLeaseVSFinance() {
    		this[NavigationMixin.Navigate]({
    			type: "comm__namedPage",
    			attributes: {
    				pageName:'lease-vs-finance'
    			}
    		});
    	}
        /* navigateToAboutUs() {
    		this[NavigationMixin.Navigate]({
    			type: "comm__namedPage",
    			attributes: {
    				pageName: AHFC_CUSTOMER
    			}
    		});
    	} 
    	
    	navigateTohondaLoyaltyBenfits() {
    		this[NavigationMixin.Navigate]({
    			type: "comm__namedPage",
    			attributes: {
    				pageName:'honda-loyalty-benefits'
    			}
    		});
    	}
        navigateToEndOfTerm() {
    		this[NavigationMixin.Navigate]({
    			type: "comm__namedPage",
    			attributes: {
    				pageName:'end-of-lease'
    			}
    		});
    	}
    	navigateToAcuraLoyalotyPage() {
    		this[NavigationMixin.Navigate]({
    			type: "comm__namedPage",
    			attributes: {
    				pageName:'acura-loyalty-advantage'
    			}
    		});
    	}

    //Added by Aniket - 8/2/2021 for navigation to credit pre approval page
    	/*navigateToCreaditPreApproval() {
    		this[NavigationMixin.Navigate]({
    			type: "comm__namedPage",
    			attributes: {
    				pageName:'creditpreapproval'
    			}
    		});
    	} */
    /*navigating to make-a-apyment page as part of 4531*/
    navigatetopayment() {
        console.log('footer payload OTP: ' + this.payLoadWrapper);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },
            state: {
                sacRecordId: this.payLoadWrapper.finaAccountData.Id,
                showOTPDefault: true
            }
        });
    }
    /*navigating to make-a-apyment page as part of 4531*/
    navigateToEasypayByDefault() {
        console.log('footer payload EZP: ' + this.payLoadWrapper);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "make-a-payment"
            },
            state: {
                sacRecordId: this.payLoadWrapper.finaAccountData.Id,
                showeasypay: true
            }
        });
    }

    navigatetoschedulepayments() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "manage-payment"
            },
            state: {
                sacRecordId: this.payLoadWrapper.finaAccountData.Id
            }
        });
    }
    /*  navigateToCorrespondance()
	  {
		  this[NavigationMixin.Navigate]({
			  type: "comm__namedPage",
			  attributes: {
				  pageName: 'correspondence'
			  },
			  state: {
				  sacRecordId: this.payLoadWrapper.finaAccountData.Id
			  }
		  });
	  }
	  navigateToDashboard()
	  {
		  this[NavigationMixin.Navigate]({
			  type: "comm__namedPage",
			  attributes: {
				  pageName: AHFC_Community_Named_Dashboard
			  }
			  
		  });
	  }
  
	  navigateToFinanceAccountDetails()
	  {
		  this[NavigationMixin.Navigate]({
			  type: "comm__namedPage",
			  attributes: {
				  pageName: 'finance-account-profile'
			  },
			  state: {
				  sacRecordId: this.payLoadWrapper.finaAccountData.Id
			  }
			  
		  });
	  }
	  navigateToStatements()
	  {
		  this[NavigationMixin.Navigate]({
			  type: "comm__namedPage",
			  attributes: {
				  pageName: 'singlestatement'
			  },
			  state: {
				  sacRecordId: this.payLoadWrapper.finaAccountData.Id
			  }
			  
		  });
	  }
	  navigateToPaymentOptions() {
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'paymentoptions'
            },
			state: {
				sacRecordId: this.payLoadWrapper.finaAccountData.Id
			}
        });
    } */
    navigatetoMyPaymentSource() {
        sessionStorage.setItem('salesforce_id', this.payLoadWrapper.finaAccountData.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: 'payment-source'
            }
        });

    }
    navigateToCommunicationPage() {
        sessionStorage.setItem('salesforce_id', this.payLoadWrapper.finaAccountData.Id);
        this[NavigationMixin.Navigate]({
            type: "comm__namedPage",
            attributes: {
                pageName: "communicationpreference"
            }
        });

    }



}