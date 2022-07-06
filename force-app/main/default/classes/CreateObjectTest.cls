/***********************************************
Author : Sajila Kadayaprath
Description : CreateObjectTest class is a Test handler class that 
contains utility methods for test data creation

************************************************/
@isTest
public class CreateObjectTest
{
    public static Id createpersonAccount()
    {
        RecordType recordType = [ select Id, Name, DeveloperName from RecordType where SObjectType = 'Account' and IsPersonType = true limit 1 ];
        Account newAccount = new Account( Salutation='Mr.', FirstName='Joe', LastName='Schmoe', RecordTypeId = recordType.id);
        insert newAccount;
        return newAccount.Id;
    }    
     
    public static Id createFinanceAccount(Id cfaId)
    {
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1000001';
        finacc.Honda_Brand__c='AFS';
        finacc.Customer__c=cfaId;
        insert finacc;
        return finacc.Id;
    }
    
    public static Id createCustomerFinanceAccount(Id newAccountId, Id finaccId)
    {
        Customer_Finance_Account__c cfa=new Customer_Finance_Account__c();
        cfa.Customer__c = newAccountId;
        cfa.Finance_Account__c = finaccId;
        insert cfa;
        return cfa.Id;
    } 
    
    public static Id createCommunicationPreferences(Id finaccId,Id newAccountId)
    {
        Communication_Preferences__c cPref=new Communication_Preferences__c();
        cPref.Finance_Account_Number__c=finaccId;
        cPref.Payment_Confirmations_via_Email__c=true;
        cPref.Payment_Reminders_via_Text__c=true;
        cPref.Payment_Confirmations_via_Text__c=true;
        cPref.EasyPay_Communications_via_Text__c =true;
        cPref.Text_Number__c='9992223334';
        cPref.Customer__c=newAccountId;
        cpref.Email_Address__c = 'testagent@gmail.com';
        insert cPref;
        return cPref.Id;
    }
    public static Id createPaymentSource(Id finaccId){
        Payment_Source__c psor = new Payment_Source__c();
        psor.Finance_Account_Number__c = finaccId; 
        psor.Bank_Name__c = 'ICICI';
        psor.Payment_Source_Nickname__c = 'Small Bank';
        psor.Bank_Account_Number__c = '1230000004560001';
        psor.Bank_Account_Type__c = 'Savings Account';
        psor.Bank_Routing_Number__c = 'ikbl00123';
        psor.Status__c='Active';
        psor.Last_4__c='test';
        insert psor;
        return psor.Id; 
    }  
    public static Id createChargentOrder(Id finaccId)
    {
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c();
        ch.Finance_Account_Number__c=finaccId;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        insert ch;
        return ch.Id;
    }
}