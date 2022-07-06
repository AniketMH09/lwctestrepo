public with sharing class CommunicationPreferenceInlineAgent {
    public string financeAccountId;
    public Communication_Preferences__c cp {
        get;
        set;
    }
    
    public string EmailAddress ;
    public String paperAndStmt;
    public List<Finance_Account__c> financeAccount;
    public Boolean isReadOnly{get;set;}
    
    public CommunicationPreferenceInlineAgent (ApexPages.StandardController controller) 
    {
        cp = (Communication_Preferences__c) controller.getRecord();
        isReadOnly = false;
        EmailAddress = cp.Email_Address__c;
        paperAndStmt = cp.Statements_Letters__c;
        financeAccount = [Select id,Honda_Brand__c,Finance_Account_Number__c from Finance_Account__c where id=:cp.Finance_Account_Number__c LIMIT 1 ];
        
    }
    
    public PageReference updateEdeliveryPreference() {
        System.debug('Inside Update Edelivery Preference');
        Boolean successFlag = false;
        if(cp.Statements_Letters__c == 'Paper')
        {
            cp.Paperless_Statements_Letters__c = false;
        }
        else if(cp.Statements_Letters__c == 'eDelivery')
        {
            cp.Paperless_Statements_Letters__c = true;
        }
        
        if (financeAccount.size() > 0 && (EmailAddress != cp.Email_Address__c || paperAndStmt != cp.Statements_Letters__c ))
        {
            UpdateEDeliveryPreferenceService edeliveryService = new UpdateEDeliveryPreferenceService();
            successFlag = edeliveryService.updateEDeliveryPreference(cp.Paperless_Statements_Letters__c,cp.Email_Address__c,financeAccount[0].Finance_Account_Number__c);
            System.debug('Boolean Flag'+successFlag);
        }
        // Successfully updated in the CASS system, so updating the same in SFDC
        if(successFlag  || (successFlag == false && (EmailAddress == cp.Email_Address__c && paperAndStmt == cp.Statements_Letters__c)))
        { 
            
            upsert(cp);
            isReadOnly = false;
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'EDelivery preferences has been updated successfully'));
            return null; 
        }
        
        // Update EDelivery preference is not successfull and showing the error msg , changes not saved.
        else
        {
            /* RSS 46325 - PG-Systematic outage recovery/SF resync process */
            RetryCallout.Retrycallout(cp.Email_Address__c,financeAccount[0].Finance_Account_Number__c,cp.Paperless_Statements_Letters__c,string.valueof(cp.id));
             /* RSS 46325 - PG-Systematic outage recovery/SF resync process */
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'EDelivery preferences is not updated successfully'));
            return null;
        }
        return null;
    }
    public PageReference updateReadOnly() 
    {
        System.debug('Inside Update Read Only');
        isReadOnly = true;
        return null;
    }
    
}