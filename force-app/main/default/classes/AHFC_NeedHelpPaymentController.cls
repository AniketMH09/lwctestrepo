/* Apex Class Name   :    AHFC_NeedHelpPaymentController
* Description        :    This Class is used to retrieve all the Eligiblity flag values (DueDate Change, Lease Extension, Already Made a Payment)
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Prabu Mohanasundaram               May 31 2021             Created
* Prabu Mohanasundaram               Jun 24 2021             Modified
*********************************************************************************/

/**
* @description: This method will retrieve all the Eligiblity flag values (DueDate Change, Lease Extension, Already Made a Payment)
* @author Prabu Mohanasundaram | May 31 2021
* @return finance records
* @param
**/

public without sharing class AHFC_NeedHelpPaymentController {    
    //Modified for US#4354  by Prabu -start
    /**
     *  created eligibiltyFlagRetrieve method to pass the Finance Account ID and retreive the Duedate change , Lease Extension and Already Made Payment Flags
     *  Input : Finance Account Id
     */
    
    @AuraEnabled(cacheable = true)
    public static NeedHelpWrapper eligibiltyFlagRetrieve(String FinanceId){  
        Boolean isPastDue = false;
        NeedHelpWrapper needWrapper = new NeedHelpWrapper();
        System.debug('ApexClassEntry');
        system.debug('FinanceIdssssssssssss-->'+FinanceId);                
        List<Finance_Account__c> finAcc = [select id,Name,Fl_DDC_Eligibility__c,FL_LE_Eligibility__c,AHFC_Product_Nickname__c,AHFC_Total_days_past_due__c,Finance_Account_Number__c from 
                                           Finance_Account__c where id = :FinanceId];
        system.debug('FinLst-->'+finAcc);    
        if(finAcc!=null && !finAcc.isEmpty() && finAcc.size()>0 )
        {
            if(finAcc[0].AHFC_Total_days_past_due__c >= 2 && finAcc[0].AHFC_Total_days_past_due__c <=30 )
            {
                isPastDue = true;
            }
            else
            {
                isPastDue =false;
            }
        }       
        
        needWrapper.FinId = finAcc[0].id;
        needWrapper.DueDateChange = finAcc[0].Fl_DDC_Eligibility__c;
        needWrapper.LeaseExtension = finAcc[0].FL_LE_Eligibility__c;
        needWrapper.TotalPastDue = isPastDue;
        needWrapper.FinanceAccNo =finAcc[0].Finance_Account_Number__c;        
        needWrapper.ProductNickname =finAcc[0].AHFC_Product_Nickname__c;   
        return needWrapper;
    }
    
    //Modified for US#4354  by Prabu -END
    
    //wrapper class
    
    public without sharing class NeedHelpWrapper{
        @AuraEnabled
        public String FinId {get;set;}
        @AuraEnabled
        public Boolean DueDateChange {get;set;}
        @AuraEnabled
        public Boolean LeaseExtension{get;set;}        
        @AuraEnabled
        public Boolean TotalPastDue{get;set;}    
         @AuraEnabled
        public String FinanceAccNo{get;set;} 
         @AuraEnabled
        public String ProductNickname{get;set;} 
    }    
}