/*Apex Class Name   :   AHFC_EditFinanceAccount
* Description       :   This class is used to retrieve and update the finance account details information
* Modification Log   :
* --------------------------------------------------------------------------- 
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Kanagaraj                May 25 2021               Created
* Akash					   May 28 2021 				 Modified
* Akash                    Jun 01 2021               Modified
* Prabu					   Aug 29 2021               Modified
*********************************************************************************/

public without Sharing class AHFC_EditFinanceAccount {
    /* Method Name      :   getFinannceAccountHandler
* Description       :   This method will provide the finance account record Id based on the Customer Address
* Developer Name	: 	Kanagaraj
* Date				:	25-May-2021
* @params			:	FinId - will take finance account record Id	
*********************************************************************************/
    @AuraEnabled(cacheable=true)
    public static AHFC_DemographicsIntegrationHandler.DemographicsWrapper getFinannceAccountHandler(String financeAccNumber){        
        // Start - Record access check - Supriya Chakraborty 17-Nov-2021         
        if(!test.isRunningTest()){            
            boolean isUserAuth = UserSecurity.ValidateFinNumberInit(financeAccNumber);        
            if(!isUserAuth){
                throw new AuraHandledException('invalid access');            
            } 
        }
		// End - Record access check - Supriya Chakraborty 17-Nov-2021  
        
        AHFC_DemographicsIntegrationHandler.DemographicsWrapper objDemographics;        
        AHFC_DemographicsIntegrationHandler demographicsInteHandler = new AHFC_DemographicsIntegrationHandler();        
        objDemographics = demographicsInteHandler.handleGetDemographics(financeAccNumber);
        if(objDemographics.billToAddress==null){
            objDemographics.billToAddress = objDemographics.garagingAddress;
            objDemographics.billToAddress.isNullBillingAddress = true;
        }
        return objDemographics;
    }
    
    /* Method Name      :   updateFinannceAccountContactDetails
* Description       :   This method will update the finance account record Id based on the Customer OtherDemographics
* Developer Name	: 	Kanagaraj
* Date				:	25-May-2021
* @params			:	FinId - will take finance account record Id	and OtherDemographics Inputs.
*********************************************************************************/
    @AuraEnabled
    public static AHFC_DemographicsIntegrationUtil.responseDemographyWrapper updateFinannceAccountContactDetails(String financeAccNumber, string stringDemographicsBody){      
        // Start - Record access check - Supriya Chakraborty 17-Nov-2021         
        if(!test.isRunningTest()){            
            boolean isUserAuth = UserSecurity.ValidateFinNumberInit(financeAccNumber);        
            if(!isUserAuth){
                throw new AuraHandledException('invalid access');            
            } 
        }
		// End - Record access check - Supriya Chakraborty 17-Nov-2021  
        AHFC_DemographicsIntegrationHandler demographicsInteHandler = new AHFC_DemographicsIntegrationHandler();
        return demographicsInteHandler.handleUpdateOtherDemographics(financeAccNumber, stringDemographicsBody);
    }
    
    /* Method Name      :   getFinanceAccountDetails
* Description       :   This method will provide the finance account record Id based on the finance account record Id coming via dashboard as url parameters
* Developer Name	: 	Akash Solanki
* Date				:	28-May-2021
* @params			:	finId - will take finance account record Id	
*********************************************************************************/
    @AuraEnabled(cacheable=true)
    public static Finance_Account__c getFinanceAccountDetails(String finId){  
        Finance_Account__c finObj;        
        finObj = [SELECT id, recordtype.name,Finance_Account_Number__c ,AHFC_Product_Type__c, AHFC_Product_Division__c,Honda_Brand__c,Finance_Account_Number_Without_Zeroes__c ,Vehicle_Identification_Number__c ,AHFC_Web_Manage_Billing_Address__c,AHFC_Web_Manage_Garaging_Address__c,AHFC_Web_Account_Locked__c,AHFC_Fl_Archived__c,AHFC_Web_Manage_Phone__c,
                  Account_Type__c , AHFC_Product_Nickname__c,Customer_Name__c, AHFC_Product_Name__c, AHFC_Original_Finance_Amount__c,AHFC_APR__c,Term__c, Maturity_Date__c,AHFC_Current_YTD_Interest__c,AHFC_Previous_YTD_Interest__c 
                  FROM Finance_Account__c WHERE id =: finId];
        // Start - Record access check - Supriya Chakraborty 17-Nov-2021 
        if(!test.isRunningTest()){
            boolean isUserAuth = UserSecurity.ValidateFinNumberInit(finObj.Finance_Account_Number__c);
            if(!isUserAuth){
                throw new AuraHandledException('invalid access');
            }
        }
        // End - Record access check - Supriya Chakraborty 17-Nov-2021 
        return finObj;
    }
    
    
    /* Method Name      :   updateMessageAckDate
* Description       :   This method update or insert the Message_Ack_Date__c field for the US - 12186
* Developer Name	: 	Prabu Mohanasundaram
* Date				:	29-Aug-2021
* @params			:	finId - will take finance account record Id	
*********************************************************************************/
    @AuraEnabled
    public static Finance_Account__c updateMessageAckDate(String finId){        
        Finance_Account__c finAcc = [SELECT id,Message_Ack_Date__c FROM Finance_Account__c WHERE id =: finId];        
        finAcc.Message_Ack_Date__c = System.today();
        update finAcc;
        return finAcc;            
    }
    
    /* Method Name      :   closeCustomerFinanceAccount
* Description       :   This method will close the deactivate the customer finance record there by deactivating the finance account
* Developer Name	: 	Akash Solanki
* Date				:	01-June-2021
* @params			:	finAcctId - will take finance account record Id	
*********************************************************************************/
    @AuraEnabled
    public static String closeCustomerFinanceAccount(String finAcctId){
        String returnVar;
        // Start - Record access check - Supriya Chakraborty 17-Nov-2021        
        if(!test.isRunningTest()){
            List<Finance_Account__c> finList = [SELECT Id,Origination_Branch_Code__c,Honda_Brand__c,Account_Type__c,AHFC_Product_Type__c,Finance_Account_Number__c from Finance_Account__c where Id = :finAcctId  limit 1]; 
            boolean isUserAuth = UserSecurity.ValidateFinNumberInit(finList[0].Finance_Account_Number__c);        
            if(!isUserAuth){
                throw new AuraHandledException('invalid access');            
            } 
        }
		// End - Record access check - Supriya Chakraborty 17-Nov-2021  
        list<Customer_Finance_Account__c> cusFinAccList = new List<Customer_Finance_Account__c>();
        List<Customer_Finance_Account__c> custFinAccRec = [Select Id, Is_Active__c ,Finance_Account__c
                                                           from Customer_Finance_Account__c
                                                           where Finance_Account__c =: finAcctId and Is_Active__c = true];
        if(!custFinAccRec.isEmpty()){
            for(Customer_Finance_Account__c cfa: custFinAccRec){
                cfa.Is_Active__c = false;
                cusFinAccList.add(cfa);
            }
        }else{
            returnVar = 'Failure';
        }
        
        if(!cusFinAccList.isEmpty()&& Schema.sObjectType.Customer_Finance_Account__c.fields.Is_Active__c.isupdateable()){
            update cusFinAccList;
            returnVar='SUCCESS';
        }else{
            returnVar = 'Failure';
        }
        return returnVar;
    }
}