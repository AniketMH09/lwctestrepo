public with sharing class LWC_Test_Finacclist { 
    @AuraEnabled(cacheable=true)
    public static List<Finance_Account__c> getAccounts() {
        return [
            SELECT Id,Name
            FROM Finance_Account__c
            ORDER BY Name
        ];
    }
}