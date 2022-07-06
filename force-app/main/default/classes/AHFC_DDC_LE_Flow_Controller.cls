/* Apex Class Name   :    AHFC_DDC_LE_Flow_Controller
* Description        :    This Class is a cloned version of AHFC_Flow_Controller class.
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                           Date                   Description 
* ---------------------------------------------------------------------------
* Prabu Mohanasundaram              27th July 2021             Created
*********************************************************************************/
/**
* @description: This method will pass the Finance Account Number as a input parameter to check the user is valid User or Not
* @author Prabu Mohanasundaram | Jul 27th 2021
* @return Finance Account Number
* @param
**/
public without sharing class AHFC_DDC_LE_Flow_Controller {
    //Modified for US#2247  by Prabu -start
    /**
*  Passing the Finance Account Number as a input parameter to check the user is valid User or Not
*  Input : Finance Account Number
*/
    @AuraEnabled
    public static string getFinanceAccountNumber(String fNumber){               
        Boolean isValiduser = false;
        string contactId = null;
        String accountId = null;
        Finance_Account__c financeAccount = null;
        boolean isUpdate = false;
        for(User user : [Select Id, contactID,contact.AccountId from User Where Id = :UserInfo.getUserId()]){
            contactId = user.contactID;
            if(user.contactId != null) {
                accountId = user.contact.AccountId;                
            }
        }
        if(fNumber == '') {
            return fNumber;
        }
        for(Finance_Account__c fAccount : [ Select Id, Customer__c, Contact__c, Finance_Account_Number__c from Finance_Account__c 
                                           Where Finance_Account_Number__c = :fNumber ]){                                               
                                               financeAccount = fAccount;
                                               
                                               if(fAccount.Contact__c != contactId){
                                                   fAccount.Contact__c =  contactId;                                                   
                                                   isUpdate = true;
                                               }
                                           }     
        
        if(financeAccount == null){
            return '';
        }
        for(Customer_Finance_Account__c cFinanceAcc: [SELECT id,Finance_Account__c,Customer__c FROM Customer_Finance_Account__c
                                                      WHERE Finance_Account__c =: financeAccount.Id]) {                                                          
                                                          if(cFinanceAcc.Customer__c == accountId) 
                                                          {                                                              
                                                              isValidUser = True;
                                                          }                                                          
                                                      }       
        
        if(!isValidUser) 
        {            
            fNumber =  'INVALID_USER';
            return fNumber;
        }
        // Update contact on finance account if there is contact changed
        try{  
            if(isUpdate)
            {                
                update financeAccount;                
            }            
        }
        catch (Exception e) 
        {
            String exdetails = e.getCause()+' ; '+e.getLineNumber() + ' ; '+e.getMessage()+' ; '+e.getStackTraceString();
            throw new AuraHandledException(exdetails); 
        }
        return fNumber;
    }
}