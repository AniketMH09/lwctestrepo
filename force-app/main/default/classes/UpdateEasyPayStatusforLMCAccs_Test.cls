@isTest
public class UpdateEasyPayStatusforLMCAccs_Test{

private static TestMethod void TestMethod1(){
Finance_Account__c FA = new Finance_Account__c ();
ChargentOrders__ChargentOrder__c CC= new ChargentOrders__ChargentOrder__c();
FA.Finance_Account_Number__c = '156674567';
FA.Region_Code__c = 'LMC';
FA.Payment_Due_Date__c = Date.newInstance(4000 , 12 ,31);
insert FA;
CC.Finance_Account_Number__c = FA.id;
CC.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
CC.ChargentOrders__Payment_Frequency__c = 'Once';
CC.ChargentOrders__Charge_Amount__c = 150;
CC.ChargentOrders__Payment_Start_Date__c  = system.today().addDays(+20);
system.debug('RecordType==>'+ CC.RecordTypeId);
system.debug('FA==>'+ CC.Finance_Account_Number__c);
insert CC;


Test.startTest();

UpdateEasyPayStatusforLMCAccs Ur=new UpdateEasyPayStatusforLMCAccs();
List<ChargentOrders__ChargentOrder__c> ListOfPayments = new List<ChargentOrders__ChargentOrder__c>();
ListOfPayments.add(CC);
system.debug('ListOfPayments==>'+ ListOfPayments);
Database.executeBatch(Ur);
ID batchprocessid = Database.executeBatch(Ur,200);
Test.stopTest();
}


private static TestMethod void TestMethod2(){
Test.startTest();
Finance_Account__c FA = new Finance_Account__c ();
ChargentOrders__ChargentOrder__c CC= new ChargentOrders__ChargentOrder__c();
FA.Finance_Account_Number__c = '12367867';
FA.Region_Code__c = 'LMC';
FA.Payment_Due_Date__c = Date.newInstance(4000 , 12 ,31);
insert FA;
CC.Finance_Account_Number__c = FA.id;
CC.RecordTypeId = Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
CC.ChargentOrders__Payment_Frequency__c = 'Once';
CC.ChargentOrders__Charge_Amount__c = 150;
CC.ChargentOrders__Payment_Start_Date__c  = system.today().addDays(+20);
system.debug('RecordType==>'+ CC.RecordTypeId);
system.debug('FA==>'+ CC.Finance_Account_Number__c);

UpdateEasyPayStatusforLMCAccs Ur=new UpdateEasyPayStatusforLMCAccs();
List<ChargentOrders__ChargentOrder__c> ListOfPayments = new List<ChargentOrders__ChargentOrder__c>();
ListOfPayments.add(CC);
insert CC;


//Database.QueryLocator ql = Ur.start(null);
//Database.executeBatch(Ur,200);
Ur.execute(null,ListOfPayments);
//Ur.Finish(null);


Test.stopTest();
}


}