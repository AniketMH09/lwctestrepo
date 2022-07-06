public without sharing class AHFC_GETFinanceAccountNo {
    
@AuraEnabled(cacheable=true)
    public static  list<Finance_Account__c>  getFinanceAccount(String accountNumber, String last4Digits){
       
        list<Finance_Account__c> listFinAcct  = [SELECT id,Finance_Account_Number__c,AHFC_Last_4_SSN__c,AHFC_Web_Manage_Online__c 
                                                from Finance_Account__c
                                                where AHFC_Last_4_SSN__c =:last4Digits 
                                                AND Finance_Account_Number_Without_Zeroes__c =:accountNumber]; //querying finance account related to the inputs from UI add account page
return listFinAcct;
}
}