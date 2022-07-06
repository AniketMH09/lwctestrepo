@isTest
public class Test_AHFC_AddPaymentSourceClass {
    @isTest static void insertdetails()
    {
		Account testaccount = new Account(Name='sai');
		Finance_Account__c testfinance = new Finance_Account__c(Name='32943357');
        insert testaccount;
		insert testfinance;
}
}