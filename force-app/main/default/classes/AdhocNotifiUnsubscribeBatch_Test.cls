/*******************************************************************************************************
* @author      : Needa Shaikh - 9th March 2022.
* @Company     : LTI
* @description : Test Class for AdhocNotifiUnsubscribeBatch Batch job.
                 5 different lengths of Finance Account Numbers are used in adhoc records.Hence 5 test records are created each for following objects:
                 1.Finance Account.
                 2.Communiication Preferences.
                 3.Adhoc Notification.  
********************************************************************************************************/
@istest
public  class AdhocNotifiUnsubscribeBatch_Test {
    @istest static void AdhocNotifiUnsubscribeBatch_Test1() {

        List<Finance_Account__c> finAccList = new List<Finance_Account__c>();
        List<Communication_Preferences__c> comPrefList = new List<Communication_Preferences__c>();

        List<Adhoc_Notification__c> adhocList = new List<Adhoc_Notification__c>();
        Integer n = 5;

        try{
            for(Integer i = 0; i<n;i++){
                String s = String.valueOf(i);
                Finance_Account__c finAccRec = new Finance_Account__c(Name  = '0000040002616'+s,Finance_Account_Number__c = '0000040002616'+s);
                finAccList.add(finAccRec);
            }

            insert finAccList;

            for(Integer i = 0; i<finAccList.size();i++){
                Communication_Preferences__c comPrefRec = new Communication_Preferences__c(Finance_Account_Number__c = finAccList.get(i).Id);
                comPrefList.add(comPrefRec);
            }

            insert comPrefList;

            for(Integer i = 0; i<finAccList.size();i++){
                Adhoc_Notification__c adhocRec = new Adhoc_Notification__c(Finance_Account__c = finAccList.get(i).Finance_Account_Number__c.substring(n-i,14));
                adhocList.add(adhocRec);
            }

            insert adhocList;
        }
        catch(Exception e){
            System.debug(e);
        }

        Test.startTest();
        AdhocNotifiUnsubscribeBatch anub = new AdhocNotifiUnsubscribeBatch();
        anub.count = 1;
        Database.executeBatch(anub);
        Test.stopTest();

    }

    //8 digit finance accounts with 6 leading 0's are created
    @istest static void AdhocNotifiUnsubscribeBatch_Test2() {
        List<Finance_Account__c> finAccList = new List<Finance_Account__c>();
        List<Communication_Preferences__c> comPrefList = new List<Communication_Preferences__c>();

        List<Adhoc_Notification__c> adhocList = new List<Adhoc_Notification__c>();
        Integer n = 6;

        try{
            for(Integer i = 0; i<2;i++){
                String s = String.valueOf(i);
                Finance_Account__c finAccRec = new Finance_Account__c(Name  = '0000005002616'+s,Finance_Account_Number__c = '0000005002616'+s);
                finAccList.add(finAccRec);
            }
            
            insert finAccList;

            for(Integer i = 0; i<finAccList.size();i++){
                Communication_Preferences__c comPrefRec = new Communication_Preferences__c(Finance_Account_Number__c = finAccList.get(i).Id);
                comPrefList.add(comPrefRec);
            }

            insert comPrefList;
            for(Integer i = 0; i<finAccList.size();i++){
                Adhoc_Notification__c adhocRec = new Adhoc_Notification__c(Finance_Account__c = finAccList.get(i).Finance_Account_Number__c.substring(n-i,14));
                adhocList.add(adhocRec);    
            }
			
            insert adhocList;
        }
        catch(Exception e){
            System.debug(e);
        }

        Test.startTest();
        AdhocNotifiUnsubscribeBatch anub = new AdhocNotifiUnsubscribeBatch();
        anub.count = 1;
        Database.executeBatch(anub);
        Test.stopTest();

    }

}