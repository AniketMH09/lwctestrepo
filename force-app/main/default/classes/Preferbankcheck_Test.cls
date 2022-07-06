/*
Author      :  Sajila Kadayaprath
Description :  Test class for Preferbankcheck
*/
@isTest
public class Preferbankcheck_Test{
    private static TestMethod void testPreferbankcheck(){
    
    Finance_Account__c finacc0 = new Finance_Account__c();
    finacc0.Finance_Account_Number__c='4324';
    finacc0.Honda_Brand__c='AFS';
    insert finacc0;
    
    Account a=new Account();
    a.Name='Test';
    insert a;
    
    Communication_Preferences__c cPref=new Communication_Preferences__c();
    cPref.Finance_Account_Number__c=finacc0.Id;
    cPref.Customer__c=a.Id;
    cPref.Payment_Confirmations_via_Email__c=true;
    cPref.Payment_Reminders_via_Text__c=true;
    cPref.Text_Number__c='9992223334';
    insert cPref;
    
    Payment_Source__c paysourcerecord = new Payment_Source__c();
    paysourcerecord.Finance_Account_Number__c = finacc0.Id;
    paysourcerecord.Status__c='Active';
    paysourcerecord.Bank_Name__c='TestCitiBank';
    paysourcerecord.Payment_Source_Nickname__c='TestABC';
    paysourcerecord.Bank_Account_Type__c='TestSaving';
    paysourcerecord.Preferred_Payment_Source__c=true;
    paysourcerecord.Bank_Account_Number__c='Test1234567';
    
    insert paysourcerecord;
    
    paysourcerecord.Preferred_Payment_Source__c=false;
    update paysourcerecord; 
    
    paysourcerecord.Preferred_Payment_Source__c=true;
    update paysourcerecord; 
    
    paysourcerecord.Status__c='Deleted';
    update paysourcerecord; 
    
    }
    
       private static TestMethod void testPreferbankcheck1(){
    
    Finance_Account__c finacc0 = new Finance_Account__c();
    finacc0.Finance_Account_Number__c='4324';
    finacc0.Honda_Brand__c='AFS';
    insert finacc0;
    
    Account a=new Account();
    a.Name='Test';
    insert a;
    
    Communication_Preferences__c cPref=new Communication_Preferences__c();
    cPref.Finance_Account_Number__c=finacc0.Id;
    cPref.Customer__c=a.Id;
    cPref.Payment_Confirmations_via_Email__c=true;
    cPref.Payment_Reminders_via_Text__c=true;
    cPref.Text_Number__c='9992223334';
    insert cPref;
    
    Payment_Source__c paysourcerecord = new Payment_Source__c();
    paysourcerecord.Finance_Account_Number__c = finacc0.Id;
    paysourcerecord.Status__c='Active';
    paysourcerecord.Bank_Name__c='TestCitiBank';
    paysourcerecord.Payment_Source_Nickname__c='TestABC';
    paysourcerecord.Bank_Account_Type__c='TestSaving';
    paysourcerecord.Preferred_Payment_Source__c=true;
    paysourcerecord.Bank_Account_Number__c='Test1234567';
    
    insert paysourcerecord;
    Delete paysourcerecord;
    
    Payment_Source__c paysourcerecord1 = new Payment_Source__c();
    paysourcerecord1.Finance_Account_Number__c = finacc0.Id;
    paysourcerecord1.Status__c='Active';
    paysourcerecord1.Bank_Name__c='TestCitiBank';
    paysourcerecord1.Payment_Source_Nickname__c='TestABC';
    paysourcerecord1.Bank_Account_Type__c='TestSaving';
    paysourcerecord1.Preferred_Payment_Source__c=true;
    paysourcerecord1.Bank_Account_Number__c='Test1234567';
    insert paysourcerecord1;
    paysourcerecord1.Preferred_Payment_Source__c = true;
    update paysourcerecord1;
    System.assertNotEquals(paysourcerecord1.Finance_Account_Number__c,Null);
    
   
     }
private static TestMethod void testPreferbankcheck2(){
    
    Finance_Account__c finacc0 = new Finance_Account__c();
    finacc0.Finance_Account_Number__c='4324';
    finacc0.Honda_Brand__c='AFS';
    insert finacc0;
    
    Account a=new Account();
    a.Name='Test';
    insert a;
    
    Communication_Preferences__c cPref=new Communication_Preferences__c();
    cPref.Finance_Account_Number__c=finacc0.Id;
    cPref.Customer__c=a.Id;
    cPref.Payment_Confirmations_via_Email__c=true;
    cPref.Payment_Reminders_via_Text__c=true;
    cPref.Text_Number__c='9992223334';
    insert cPref;
    
    Test.startTest();
    Payment_Source__c paysourcerecord = new Payment_Source__c();
    paysourcerecord.Finance_Account_Number__c = finacc0.Id;
    paysourcerecord.Status__c='Active';
    paysourcerecord.Bank_Name__c='TestCitiBank';
    paysourcerecord.Payment_Source_Nickname__c='TestABC';
    paysourcerecord.Bank_Account_Type__c='TestSaving';
    paysourcerecord.Preferred_Payment_Source__c=true;
    paysourcerecord.Bank_Account_Number__c='Test1234567';
    insert paysourcerecord;
  
  //Creating bank account record for same finance account number  
    Payment_Source__c paysourcerecord1 = new Payment_Source__c();
    paysourcerecord1.Finance_Account_Number__c = finacc0.Id;
    paysourcerecord1.Status__c='Active';
    paysourcerecord1.Bank_Name__c='TestCitiBank';
    paysourcerecord1.Payment_Source_Nickname__c='TestABC';
    paysourcerecord1.Bank_Account_Type__c='TestSaving';
    paysourcerecord1.Preferred_Payment_Source__c=true;
    paysourcerecord1.Bank_Account_Number__c='Test1234567';
    insert paysourcerecord1;
    
    List<Payment_Source__c> paysourcerecord2 = new List<Payment_Source__c>();
    for(Payment_Source__c paySour: paysourcerecord2){
    paySour.Finance_Account_Number__c = finacc0.Id;
    paySour.Status__c='Active';
    paySour.Bank_Name__c='TestCitiBank';
    paySour.Payment_Source_Nickname__c='TestABC';
    paySour.Bank_Account_Type__c='TestSaving';
    paySour.Preferred_Payment_Source__c=true;
    paySour.Bank_Account_Number__c='Test1234567';
    paysourcerecord2.add(paySour);
    insert paysourcerecord2;
    }
    if(paysourcerecord2.size() > 0){
    paysourcerecord2[0].Bank_Account_Type__c = 'TestingBankAccount1234';
    update paysourcerecord2[0];
    }
    Test.stopTest();
}

private static TestMethod void testPreferbankcheck3(){
    
    Finance_Account__c finacc0 = new Finance_Account__c();
    finacc0.Finance_Account_Number__c='4324';
    finacc0.Honda_Brand__c='AFS';
    insert finacc0;
    
    Account a=new Account();
    a.Name='Test';
    insert a;
    
    Communication_Preferences__c cPref=new Communication_Preferences__c();
    cPref.Finance_Account_Number__c=finacc0.Id;
    cPref.Customer__c=a.Id;
    cPref.Payment_Confirmations_via_Email__c=true;
    cPref.Payment_Reminders_via_Text__c=true;
    cPref.Text_Number__c='9992223334';
    insert cPref;
    
    Test.startTest();
    Payment_Source__c paysourcerecord = new Payment_Source__c();
    paysourcerecord.Finance_Account_Number__c = finacc0.Id;
    paysourcerecord.Status__c='Active';
    paysourcerecord.Bank_Name__c='TestCitiBank';
    paysourcerecord.Payment_Source_Nickname__c='TestABC';
    paysourcerecord.Bank_Account_Type__c='TestSaving';
    paysourcerecord.Preferred_Payment_Source__c=true;
    paysourcerecord.Bank_Account_Number__c='Test1234567';
    insert paysourcerecord;
  
  //Creating bank account record for same finance account number  
    Payment_Source__c paysourcerecord1 = new Payment_Source__c();
    paysourcerecord1.Finance_Account_Number__c = finacc0.Id;
    paysourcerecord1.Status__c='Active';
    paysourcerecord1.Bank_Name__c='TestCitiBank';
    paysourcerecord1.Payment_Source_Nickname__c='TestABC';
    paysourcerecord1.Bank_Account_Type__c='TestSaving';
    paysourcerecord1.Preferred_Payment_Source__c=true;
    paysourcerecord1.Bank_Account_Number__c='Test1234567';
    insert paysourcerecord1;
    
    Payment_Source__c paySour= new Payment_Source__c();
   // for(Payment_Source__c paySour: paysourcerecord2){
    paySour.Finance_Account_Number__c = finacc0.Id;
    paySour.Status__c='Active';
    paySour.Bank_Name__c='TestCitiBank';
    paySour.Payment_Source_Nickname__c='TestABC';
    paySour.Bank_Account_Type__c='TestSaving';
    paySour.Preferred_Payment_Source__c=true;
    paySour.Bank_Account_Number__c='Test1234567';
  //  paysourcerecord2.add(paySour);
    insert paySour;
    
    
  //  if(paysourcerecord2.size() > 0){
  //  paysourcerecord2[0].Bank_Account_Type__c = 'TestingBankAccount1234';
//    update paysourcerecord2[0];
 //   } 
   // system.assertEquals(paysourcerecord2[0].Bank_Account_Type__c , 'TestingBankAccount1234');
    Test.stopTest();
}



}