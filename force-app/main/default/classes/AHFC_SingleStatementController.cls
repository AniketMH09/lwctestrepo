/* Apex Class Name   :    aHFC_singleStatementController
    * Description        :    class used by aHFC_singleStatement lwc component to fetch default values required for the components
    * Modification Log   :
    * ------------------------------------------------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ------------------------------------------------------------------------------------------------------------------
    * Vishnu            		JUN 21 2021             	Created
    * Sagar                     Sep 15 2021                 modified for US-7638 (added fields in query product
    *                                                       division and product type  )
************************************************************************************************************************/
public without sharing class AHFC_SingleStatementController {
    
    /**
     * @author Vishnu JUN 21 2021
     * @description method to fetch value from database and assign to wrapper variable and return as value
     * @param recID:Finance_Account__c recId to retrive Finance_Account__c account record
     * @return object reference : wrapper class singleStatementDetails
	**/
    @AuraEnabled(cacheable=true)
    public static singleStatementDetails fetchFinanceAccountDetails(string recID){
        singleStatementDetails singleStatementRec =  new singleStatementDetails();
                
		// fetching finance account details
        list <Finance_Account__c> financeAccList = [Select Id,Honda_Brand__c,Account_Type__c,AHFC_Product_Nickname__c,AHFC_Web_Manage_Comm_Pref__c,Finance_Account_Number__c,AHFC_Product_Type__c,AHFC_Product_Division__c
                                                    FROM Finance_Account__c Where Id =:recID];
        // fetching communication prfernce details
        list <Communication_Preferences__c> commprefObj = [SELECT Email_Address__c,Statements_Letters__c
                                                           from Communication_Preferences__c where Finance_Account_Number__c = :recID AND Statements_Letters__c =: AHFC_GlobalConstans.EnrollEDillevery ORDER BY CreatedDate ASC limit 1];
        if(commprefObj != null && commprefObj.size()>0){
        	singleStatementRec.emailId = commprefObj[0].Email_Address__c;
            singleStatementRec.enrollEdilivery = true;
          }       
        
        if(financeAccList != null && financeAccList.size()>0){
            singleStatementRec.accName = financeAccList[0].AHFC_Product_Nickname__c != null ? financeAccList[0].AHFC_Product_Nickname__c : '';
            singleStatementRec.accNo = financeAccList[0].Finance_Account_Number__c;
            singleStatementRec.productType = financeAccList[0].AHFC_Product_Type__c;
            singleStatementRec.productDivision = financeAccList[0].AHFC_Product_Division__c;
            if(String.isNotBlank(financeAccList[0].Honda_Brand__c) && financeAccList[0].Honda_Brand__c.equalsIgnoreCase('AFS')){
                singleStatementRec.isAcura = true;
            } 
            if(String.isNotBlank(financeAccList[0].Honda_Brand__c) && financeAccList[0].Honda_Brand__c.equalsIgnoreCase('HFS')){
                singleStatementRec.isHonda = true;
            }
            
            if(financeAccList[0].Account_Type__c == AHFC_GlobalConstans.AcctTypeLease){
                singleStatementRec.isLeaseAccount = true;   
            }
            
            if(financeAccList[0].Account_Type__c == AHFC_GlobalConstans.AcctTypeRetail)
            {
                singleStatementRec.isRetailAccount = true; 
            }
            singleStatementRec.accClosed = false;
            if(financeAccList[0].AHFC_Web_Manage_Comm_Pref__c == 'NE'){
                singleStatementRec.accClosed = true;
            }
        }
       
        return singleStatementRec;
    }
    
    /**
     * @author Vishnu JUN 21 2021
     * @description wrapper class for holding default values
	**/
    public class singleStatementDetails{
        @AuraEnabled public boolean isHonda;
        @AuraEnabled public boolean enrollEdilivery = false;
        @AuraEnabled public string emailId = '';
        @AuraEnabled public boolean isAcura;
        @AuraEnabled public string accName;
        @AuraEnabled public string accNo;
        @AuraEnabled public boolean isLeaseAccount;  
        @AuraEnabled public boolean isRetailAccount;
        @AuraEnabled public string productType;
        @AuraEnabled public string productDivision;
        @AuraEnabled public boolean accClosed;
        
    }
}