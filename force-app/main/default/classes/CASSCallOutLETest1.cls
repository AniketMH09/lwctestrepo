/* Apex Class Name   :    CASSCallOutLETest1
 * Description        :    Unit Test class for CASSCallOutLE
 * Modification Log   :
 * ---------------------------------------------------------------------------
 * Developer                             Date                   Description
 * ---------------------------------------------------------------------------
 * Narain Simha                      10th Nov 2021             Created
 * Prabu Mohanasundaram              19th Nov 2021             Modified
 *********************************************************************************/

@IsTest
public class CASSCallOutLETest1 {

    @IsTest private static void CASSLETest() {

        RecordType myRecordType = [select id from RecordType where SobjectType = 'Account'
            AND IsPersonType = false limit 1
        ];
        Account acc = new Account();
        acc.Name = 'AccName';
        acc.RecordTypeId = myRecordType.Id;
        insert acc;

        Customer_Finance_Account__c cfa = new Customer_Finance_Account__c();
        cfa.Customer__c = acc.Id;
        insert cfa;

        Contact c = new Contact();
        c.FirstName = 'Contact1';
        c.LastName = 'test1';
        c.AccountId = acc.Id;
        c.Email = 'varsha.patel@lntinfotech.com';
        insert c;

        Finance_Account__c f = new Finance_Account__c();
        f.Finance_Account_Number__c = '123123123';
        f.Due_On_Day__c = '24';
        f.Customer__c = cfa.Id;
        f.Contact__c = c.Id;
        //Date.newInstance(2016, 12, 9)
        f.First_Due_Date__c =Date.newInstance(date.today().year(), date.today().month(), 9); // date.today();
        f.Paid_to_Date__c = Date.newInstance(date.today().year(), date.today().month()-1, 8); // Date.newInstance(2021, 12, 9);
        f.Account_Type__c = 'Lease';
        f.Regular_Monthly_Payment__c = 34562.0;
        f.Honda_Brand__c = 'AFS';
        f.IsUpdated__c = true;
        f.Fl_Suppress_All_Notifications__c = true;
        f.Account_Type__c = 'Lease';
        f.Payment_Due_Date__c = date.today();
        f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
        f.Fl_Extend_Recurring_Payment_Today__c = true;
        f.Regular_Monthly_Payment__c = 200;
        f.Next_Due_Date__c = date.today();
        f.Past_Amount_Due__c = 0;
        f.Total_Fees_Due__c = 0;
        f.Maturity_Date__c = Date.newInstance(2021, 09, 9);
        insert f;
        system.debug(f.id);

        Communication_Preferences__c cPref = new Communication_Preferences__c();
        cPref.Finance_Account_Number__c = f.Id;

        insert cPref;

        CASSCallOut__c customsettings = new CASSCallOut__c();
        customsettings.Name = 'Test Settings';
        customsettings.BusinessId__c = 'Salesforce';
        customsettings.SiteId__c = 'Salesforce';
        customsettings.TimeOut__c = 60000;
        insert customsettings;

        //creating test user
        Profile profile1 = [Select Id from Profile where name = 'Customer'];
        String mockResponseBody = '{\"Header\":{\"Code\":\"200\",\"Status\":\"Success\",\"Errors\":null},\"Body\":{\"intErrorNumber\":0,\"strErrorMessage\":\"null\",\"strStatus\":\"OK\"}}';
        Continuation con;
        User uAdmin = [Select Id from User Where Id =: UserInfo.getUserId()];
        System.runAs(uAdmin) {
            Test.startTest();
            User u = new User();
            u.ProfileId = profile1.id;
            u.Username = 'orgTestUser@testuo.com';
            u.Alias = 'orgtu';
            u.Email = 'varsha.patel@lntinfotech.com';
            u.EmailEncodingKey = 'UTF-8';
            u.FirstName = 'Test All1';
            u.LastName = 'AllT';
            u.ContactId = c.Id;
            u.LanguageLocaleKey = 'en_US';
            u.LocaleSidKey = 'en_US';
            u.TimeZoneSidKey = 'America/Chicago';
            insert u;

            System.runAs(u) {
                con = (Continuation) CASSCalloutLE.callLEService(f.Id, 2);
            }
            Test.stopTest();
        }
        Map < String, HttpRequest > requests = con.getRequests();
        //System.assertEquals(3, requests.size(), 'The number of requests associated to the Continuation is not correct');

        // Create a mock response
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody(mockResponseBody);

        Test.setContinuationResponse(CASSCalloutLE.continuationLabel, response);

        List < String > labels = new List < String > {
            'Continuation-1'
        };
        /*LEDetails ld = new LEDetails(f.Id, 2);
        ld.FinAcctNbr = f.Finance_Account_Number__c;
        ld.maturityDate = f.Maturity_Date__c;
        ld.ExtLength = 2;
        ld.nextMaturityDate = f.Maturity_Date__c.addMonths(2);
        insert ld;*/
        system.debug('CASSCalloutLE.continuationState -- ' + CASSCalloutLE.continuationState);
        system.debug('labels --- ' + labels);
        CASSCalloutLE.processLEResponse(labels, CASSCalloutLE.continuationState);

        //String actualValue='SUCCESS';
        //System.assertEquals(result, actualValue, 'Continuation failed: response body not valid');
    }

    @IsTest private static void CASSLETesterror() {

        RecordType myRecordType = [select id from RecordType where SobjectType = 'Account'
            AND IsPersonType = false limit 1
        ];
        Account acc = new Account();
        acc.Name = 'AccName';
        //acc.FirstName = 'Test1';
        //acc.LastName = 'User1';
        //acc.Finance_Account__pc = f.Id;
        acc.RecordTypeId = myRecordType.Id;
        insert acc;

        Customer_Finance_Account__c cfa = new Customer_Finance_Account__c();
        cfa.Customer__c = acc.Id;
        //cfa.Finance_Account__c = f.Id;
        insert cfa;

        Contact c = new Contact();
        c.FirstName = 'Contact1';
        c.LastName = 'test1';
        c.AccountId = acc.Id;
        c.Email = 'varsha.patel@lntinfotech.com';
        insert c;

        Finance_Account__c f = new Finance_Account__c();
        f.Finance_Account_Number__c = '123123123';
        f.Due_On_Day__c = '24';
        f.Customer__c = cfa.Id;
        f.Contact__c = c.Id;
        //Date.newInstance(2016, 12, 9)
        f.First_Due_Date__c =Date.newInstance(date.today().year(), date.today().month(), 9); // date.today();
        f.Paid_to_Date__c = Date.newInstance(date.today().year(), date.today().month()-1, 8); // Date.newInstance(2021, 12, 9);
        f.Account_Type__c = 'Lease';
        f.Regular_Monthly_Payment__c = 34562.0;
        f.Honda_Brand__c = 'AFS';
        f.IsUpdated__c = true;
        f.Fl_Suppress_All_Notifications__c = true;
        f.Account_Type__c = 'Lease';
        f.Payment_Due_Date__c = date.today();
        f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
        f.Fl_Extend_Recurring_Payment_Today__c = true;
        f.Regular_Monthly_Payment__c = 200;
        f.Next_Due_Date__c = date.today();
        f.Past_Amount_Due__c = 0;
        f.Total_Fees_Due__c = 0;
        f.Maturity_Date__c = Date.newInstance(2021, 09, 9);
        insert f;
        system.debug(f.id);

        Communication_Preferences__c cPref = new Communication_Preferences__c();
        cPref.Finance_Account_Number__c = f.Id;

        insert cPref;

        CASSCallOut__c customsettings = new CASSCallOut__c();
        customsettings.Name = 'Test Settings';
        customsettings.BusinessId__c = 'Salesforce';
        customsettings.SiteId__c = 'Salesforce';
        customsettings.TimeOut__c = 60000;
        insert customsettings;

        //creating test user
        Profile profile1 = [Select Id from Profile where name = 'Customer'];
        String mockResponseBody = '{\"Header\":{\"Code\":\"201\",\"Status\":\"Success\",\"Errors\":null},\"Body\":{\"intErrorNumber\":0,\"strErrorMessage\":\"null\",\"strStatus\":\"OK\"}}';
        Continuation con;
        User uAdmin = [Select Id from User Where Id =: UserInfo.getUserId()];
        System.runAs(uAdmin) {
            Test.startTest();
            User u = new User();
            u.ProfileId = profile1.id;
            u.Username = 'orgTestUser@testuo.com';
            u.Alias = 'orgtu';
            u.Email = 'varsha.patel@lntinfotech.com';
            u.EmailEncodingKey = 'UTF-8';
            u.FirstName = 'Test All1';
            u.LastName = 'AllT';
            u.ContactId = c.Id;
            u.LanguageLocaleKey = 'en_US';
            u.LocaleSidKey = 'en_US';
            u.TimeZoneSidKey = 'America/Chicago';
            insert u;

            System.runAs(u) {
                con = (Continuation) CASSCalloutLE.callLEService(f.Id, 2);
            }
            Test.stopTest();
        }
        Map < String, HttpRequest > requests = con.getRequests();
        //System.assertEquals(3, requests.size(), 'The number of requests associated to the Continuation is not correct');

        // Create a mock response
        HttpResponse response = new HttpResponse();
        response.setStatusCode(201);
        response.setBody(mockResponseBody);

        Test.setContinuationResponse(CASSCalloutLE.continuationLabel, response);

        List < String > labels = new List < String > {
            'Continuation-2'
        };
        /*LEDetails ld = new LEDetails(f.Id, 2);
        ld.FinAcctNbr = f.Finance_Account_Number__c;
        ld.maturityDate = f.Maturity_Date__c;
        ld.ExtLength = 2;
        ld.nextMaturityDate = f.Maturity_Date__c.addMonths(2);
        insert ld;*/
        system.debug('CASSCalloutLE.continuationState -- ' + CASSCalloutLE.continuationState);
        system.debug('labels --- ' + labels);
        CASSCalloutLE.processLEResponse(labels, CASSCalloutLE.continuationState);

        //String actualValue='SUCCESS';
        //System.assertEquals(result, actualValue, 'Continuation failed: response body not valid');
    }



    @IsTest private static void testContinuationExceptionCaptured() {
        RecordType myRecordType = [select id from RecordType where SobjectType = 'Account'
            AND IsPersonType = false limit 1
        ];
        Account acc = new Account();
        acc.Name = 'AccName';
        //acc.FirstName = 'Test1';
        //acc.LastName = 'User1';
        //acc.Finance_Account__pc = f.Id;
        acc.RecordTypeId = myRecordType.Id;
        insert acc;

        Customer_Finance_Account__c cfa = new Customer_Finance_Account__c();
        cfa.Customer__c = acc.Id;
        //cfa.Finance_Account__c = f.Id;
        insert cfa;

        Contact c = new Contact();
        c.FirstName = 'Contact1';
        c.LastName = 'test1';
        c.AccountId = acc.Id;
        c.Email = 'varsha.patel@lntinfotech.com';
        insert c;

        Finance_Account__c f = new Finance_Account__c();
        f.Finance_Account_Number__c = '123123123';
        f.Due_On_Day__c = '24';
        f.Customer__c = cfa.Id;
        f.Contact__c = c.Id;
        //Date.newInstance(2016, 12, 9)
        f.First_Due_Date__c = date.today();
        f.Paid_to_Date__c = Date.newInstance(2021, 12, 9);
        f.Account_Type__c = 'Lease';
        f.Regular_Monthly_Payment__c = 34562.0;
        f.Honda_Brand__c = 'AFS';
        f.IsUpdated__c = true;
        f.Fl_Suppress_All_Notifications__c = true;
        f.Account_Type__c = 'Lease';
        f.Payment_Due_Date__c = date.today();
        f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
        f.Fl_Extend_Recurring_Payment_Today__c = true;
        f.Regular_Monthly_Payment__c = 200;
        f.Next_Due_Date__c = date.today();
        f.Past_Amount_Due__c = 0;
        f.Total_Fees_Due__c = 0;
        f.Maturity_Date__c = Date.newInstance(2021, 08, 9);
        insert f;
        system.debug(f.id);

        Communication_Preferences__c cPref = new Communication_Preferences__c();
        cPref.Finance_Account_Number__c = f.Id;

        insert cPref;

        CASSCallOut__c customsettings = new CASSCallOut__c();
        customsettings.Name = 'Test Settings';
        customsettings.BusinessId__c = 'Salesforce';
        customsettings.SiteId__c = 'Salesforce';
        customsettings.TimeOut__c = 60000;
        insert customsettings;

        //creating test user
        Profile profile1 = [Select Id from Profile where name = 'Customer'];

        //Continuation con = (Continuation) CASSCalloutLE.callLEService('a1e0q000001R9Zf',3);
        String mockResponseBody = '{\"Header\":{\"Code\":\"200\",\"Status\":\"Error\",\"Errors\":null},\"Body\":{\"intErrorNumber\":200,\"strErrorMessage\":\"AF in Next day Mode\",\"strStatus\":\"null\"}}';
        Continuation con;
        User uAdmin = [Select Id from User Where Id =: UserInfo.getUserId()];
        System.runAs(uAdmin) {
            Test.startTest();
            User u = new User();
            u.ProfileId = profile1.id;
            u.Username = 'orgTestUser@testuo.com';
            u.Alias = 'orgtu';
            u.Email = 'varsha.patel@lntinfotech.com';
            u.EmailEncodingKey = 'UTF-8';
            u.FirstName = 'Test All1';
            u.LastName = 'AllT';
            u.ContactId = c.Id;
            u.LanguageLocaleKey = 'en_US';
            u.LocaleSidKey = 'en_US';
            u.TimeZoneSidKey = 'America/Chicago';
            insert u;

            System.runAs(u) {
                con = (Continuation) CASSCalloutLE.callLEService(f.Id, 2);
            }
            Test.stopTest();
        }
        /*
                // Verify that the continuation has the correct number of requests
                Map<String, HttpRequest> requests = con.getRequests();
               // System.assertEquals(3, requests.size(), 'The number of requests associated to the Continuation is not correct');
         
                // Create a mock response
                HttpResponse response = new HttpResponse();
                response.setStatusCode(200);
                response.setBody(mockResponseBody);
                Test.setContinuationResponse(CASSCalloutLE.continuationLabel, response);
         
                List<String> labels = new List<String>{'Continuation-1'};
                LEDetails ld = new LEDetails(f.Id, 2);
                ld.FinAcctNbr = f.Finance_Account_Number__c;
                ld.maturityDate = f.Maturity_Date__c;
                ld.ExtLength = 2;
                ld.nextMaturityDate = f.Maturity_Date__c.addMonths(2);
               // insert ld;  
                CASSCalloutLE.continuationState = ld;
                String result = (String)CASSCalloutLE.processLEResponse(labels, CASSCalloutLE.continuationState);
                System.debug('result---'+result);
                String actualValue='Failed';
                System.assertEquals(result, actualValue, 'Continuation failed: response body not valid');  */
    }

    @IsTest private static void processManuallTest() {

        RecordType myRecordType = [select id from RecordType where SobjectType = 'Account'
            AND IsPersonType = false limit 1
        ];
        Account acc = new Account();
        acc.Name = 'AccName';
        //acc.FirstName = 'Test1';
        //acc.LastName = 'User1';
        //acc.Finance_Account__pc = f.Id;
        acc.RecordTypeId = myRecordType.Id;
        insert acc;

        Customer_Finance_Account__c cfa = new Customer_Finance_Account__c();
        cfa.Customer__c = acc.Id;
        //cfa.Finance_Account__c = f.Id;
        insert cfa;

        Contact c = new Contact();
        c.FirstName = 'Contact1';
        c.LastName = 'test1';
        c.AccountId = acc.Id;
        c.Email = 'varsha.patel@lntinfotech.com';
        insert c;

        Finance_Account__c f = new Finance_Account__c();
        f.Finance_Account_Number__c = '123123123';
        f.Due_On_Day__c = '24';
        f.Customer__c = cfa.Id;
        f.Contact__c = c.Id;
        //Date.newInstance(2016, 12, 9)
        f.First_Due_Date__c = Date.newInstance(2021, 12, 9);
        f.Paid_to_Date__c = Date.newInstance(2021, 12, 9);
        f.Account_Type__c = 'Lease';
        f.Regular_Monthly_Payment__c = 34562.0;
        f.Honda_Brand__c = 'AFS';
        f.IsUpdated__c = true;
        f.Fl_Suppress_All_Notifications__c = true;
        f.Account_Type__c = 'Lease';
        f.Payment_Due_Date__c = date.today();
        f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
        f.Fl_Extend_Recurring_Payment_Today__c = true;
        f.Regular_Monthly_Payment__c = 0;
        f.Next_Due_Date__c = date.today();
        f.Past_Amount_Due__c = 0;
        f.Total_Fees_Due__c = 0;
        insert f;
        system.debug(f.id);
        
        LEDetails led = new LEDetails((String)f.id,5);
        led.FinAcctNbr = f.Finance_Account_Number__c;
        led.oldDueDay = '2021-12-9';
        led.ProcessingType = 'Pending Payment';
        led.ValidationRslt = 'Process Manually';
        led.WebSvcResult = 'test';
        led.ContactId = f.Contact__c;
        led.newDueDate = f.First_Due_Date__c ;
        led.newLEDate = f.First_Due_Date__c ;
        led.maturityDate = Date.newInstance(2021, 12, 9);
        led.nextMaturityDate = Date.newInstance(2021, 12, 9);
        led.ErrorMessages = new List<String>{'test'};

        Communication_Preferences__c cPref = new Communication_Preferences__c();
        cPref.Finance_Account_Number__c = f.Id;

        insert cPref;

        CASSCallOut__c customsettings = new CASSCallOut__c();
        customsettings.Name = 'Test Settings';
        customsettings.BusinessId__c = 'Salesforce';
        customsettings.SiteId__c = 'Salesforce';
        customsettings.TimeOut__c = 60000;
        insert customsettings;

        //creating test user
        Profile profile1 = [Select Id from Profile where name = 'Customer'];
        String mockResponseBody = '{\"Header\":{\"Code\":\"200\",\"Status\":\"Success\",\"Errors\":null},\"Body\":{\"intErrorNumber\":0,\"strErrorMessage\":\"null\",\"strStatus\":\"OK\"}}';
        Continuation con;
        User uAdmin = [Select Id from User Where Id =: UserInfo.getUserId()];
        System.runAs(uAdmin) {
            Test.startTest();
            User u = new User();
            u.ProfileId = profile1.id;
            u.Username = 'orgTestUser@testuo.com';
            u.Alias = 'orgtu';
            u.Email = 'varsha.patel@lntinfotech.com';
            u.EmailEncodingKey = 'UTF-8';
            u.FirstName = 'Test All1';
            u.LastName = 'AllT';
            u.ContactId = c.Id;
            u.LanguageLocaleKey = 'en_US';
            u.LocaleSidKey = 'en_US';
            u.TimeZoneSidKey = 'America/Chicago';
            insert u;

            System.runAs(u) {
                con = (Continuation) CASSCalloutLE.callLEService((String)f.Id, 2);
            }
            Test.stopTest();
        }
        Map < String, HttpRequest > requests = con.getRequests();
        //System.assertEquals(3, requests.size(), 'The number of requests associated to the Continuation is not correct');

        // Create a mock response
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody(mockResponseBody);

        //Test.setContinuationResponse(CASSCalloutLE.continuationLabel, response);

        //List<String> labels = new List<String>{CASSCalloutLE.continuationLabel};

        //String result = (String)CASSCalloutLE.processManualRequest(labels, CASSCalloutLE.continuationState);
        
        Test.setContinuationResponse('test', response);
 
       	List<String> labels = new List<String>{'test'};
 
        String result = (String)CASSCalloutLE.processManualRequest(labels, led);

        //String actualValue='SUCCESS';
        //System.assertEquals(result, actualValue, 'Continuation failed: response body not valid');
    }

    /*    @IsTest private static void invalidRequestTest(){
                     
            RecordType myRecordType = [select id from RecordType where SobjectType='Account' AND IsPersonType=false limit 1];
            Account acc = new Account();
            acc.Name = 'AccName';
             //acc.FirstName = 'Test1';
             //acc.LastName = 'User1';
             //acc.Finance_Account__pc = f.Id;
             acc.RecordTypeId = myRecordType.Id;
             insert acc;
             
             Customer_Finance_Account__c cfa = new Customer_Finance_Account__c();
             cfa.Customer__c = acc.Id;
             //cfa.Finance_Account__c = f.Id;
             insert cfa;
             
             Contact c = new Contact();
             c.FirstName = 'Contact1';
             c.LastName = 'test1';
             c.AccountId = acc.Id;
             c.Email = 'varsha.patel@lntinfotech.com';
             insert c;
            
            Finance_Account__c f = new Finance_Account__c();
            f.Finance_Account_Number__c= '123123123' ;
            f.Due_On_Day__c = '24';
            f.Customer__c = cfa.Id;
    		f.Contact__c = c.Id; 
            //Date.newInstance(2016, 12, 9)
            f.First_Due_Date__c = Date.newInstance(2021, 12, 9);
            f.Paid_to_Date__c = Date.newInstance(2021, 12, 9);
            f.Account_Type__c = 'Lease';
            f.Regular_Monthly_Payment__c = 34562.0;
            f.Honda_Brand__c='AFS';
            f.IsUpdated__c=true;
            f.Fl_Suppress_All_Notifications__c = true;
            f.Account_Type__c = 'Lease' ;
            f.Payment_Due_Date__c = date.today();
            f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
            f.Fl_Extend_Recurring_Payment_Today__c = true ;
            f.Regular_Monthly_Payment__c=0;        
            //f.Next_Due_Date__c = date.today();
            f.Past_Amount_Due__c = 0;
            f.Total_Fees_Due__c = 0;
            f.Maturity_Date__c = Date.newInstance(2021, 08, 9);
            insert f;
            system.debug(f.id);
            
            Communication_Preferences__c cPref=new Communication_Preferences__c();
            cPref.Finance_Account_Number__c=f.Id;
            
            insert cPref;
            
            CASSCallOut__c customsettings = new CASSCallOut__c();
            customsettings.Name = 'Test Settings';
            customsettings.BusinessId__c = 'Salesforce';
            customsettings.SiteId__c = 'Salesforce';
            customsettings.TimeOut__c = 60000;
            insert customsettings;
            
            //creating test user
    		//Profile profile1 = [Select Id from Profile where name = 'Customer'];      
            String mockResponseBody = '{\"Header\":{\"Code\":\"200\",\"Status\":\"Success\",\"Errors\":null},\"Body\":{\"intErrorNumber\":0,\"strErrorMessage\":\"null\",\"strStatus\":\"OK\"}}';
            Continuation con;
            
            
            //System.runAs(u) {
            Test.startTest();
            con = (Continuation) CASSCalloutLE.callLEService(f.Id,5);
            //} 
            Test.stopTest();
              //  }       
            //Map<String, HttpRequest> requests = con.getRequests();
            //System.assertEquals(3, requests.size(), 'The number of requests associated to the Continuation is not correct');
     
            // Create a mock response
            HttpResponse response = new HttpResponse();
            response.setStatusCode(201);
            response.setBody(mockResponseBody);
     
            //Test.setContinuationResponse(CASSCalloutLE.continuationLabel, response);
     
            List<String> labels = new List<String>{'Continuation-3'};
     		system.debug('CASSCalloutLE.continuationState -- '+CASSCalloutLE.continuationState);
            system.debug('labels --- '+labels);
            CASSCalloutLE.processManualRequest(labels, CASSCalloutLE.continuationState);
                    
            //String actualValue='SUCCESS';
            //System.assertEquals(result, actualValue, 'Continuation failed: response body not valid');
        }*/
    /**
     * @description: Added the code for cover the Invalid Finance account in the ValidRequest method.
     * @author Prabu Mohanasundaram | Nov 19 2021
     **/
    @IsTest private static void invalidRequest() {
        Continuation con;
        String finAcc = null;
        con = (Continuation) CASSCalloutLE.callLEService(finAcc, 2);
        system.debug('connnn' + con);
        System.assertEquals(con, null, 'invalid Finance Account');
    }

    /**
     * @description: Added the code for cover the Invalid Lease Extension in the ValidRequest method.
     * @author Prabu Mohanasundaram | Nov 24 2021
     **/
    @IsTest private static void invalidExtLength() {

        RecordType myRecordType = [select id from RecordType where SobjectType = 'Account'
            AND IsPersonType = false limit 1
        ];
        Account acc = new Account();
        acc.Name = 'HondaSports';
        acc.RecordTypeId = myRecordType.Id;
        insert acc;

        Customer_Finance_Account__c cfa = new Customer_Finance_Account__c();
        cfa.Customer__c = acc.Id;
        insert cfa;

        Contact c = new Contact();
        c.FirstName = 'Honda';
        c.LastName = 'Marine';
        c.AccountId = acc.Id;
        c.Email = 'Honda.Marine@honda.com';
        insert c;

        Finance_Account__c f = new Finance_Account__c();
        f.Finance_Account_Number__c = '123123123';
        f.Due_On_Day__c = '24';
        f.Customer__c = cfa.Id;
        f.Contact__c = c.Id;
        f.First_Due_Date__c = Date.newInstance(2021, 12, 9);
        f.Paid_to_Date__c = Date.newInstance(2021, 12, 9);
        f.Account_Type__c = 'Lease';
        f.Regular_Monthly_Payment__c = 34562.0;
        f.Honda_Brand__c = 'AFS';
        f.IsUpdated__c = true;
        f.Fl_Suppress_All_Notifications__c = true;
        f.Account_Type__c = 'Lease';
        f.Payment_Due_Date__c = date.today();
        f.FI_Stop_Reinstate_Recurring_Payment__c = 'T';
        f.Fl_Extend_Recurring_Payment_Today__c = true;
        f.Regular_Monthly_Payment__c = 0;
        f.Next_Due_Date__c = date.today();
        f.Past_Amount_Due__c = 0;
        f.Total_Fees_Due__c = 0;
        insert f;

        Communication_Preferences__c cPref = new Communication_Preferences__c();
        cPref.Finance_Account_Number__c = f.Id;

        insert cPref;

        CASSCallOut__c customsettings = new CASSCallOut__c();
        customsettings.Name = 'Test Settings';
        customsettings.BusinessId__c = 'Salesforce';
        customsettings.SiteId__c = 'Salesforce';
        customsettings.TimeOut__c = 60000;
        insert customsettings;

        //creating test user
        Profile profile1 = [Select Id from Profile where name = 'Customer'];
        String mockResponseBody = '{\"Header\":{\"Code\":\"200\",\"Status\":\"Success\",\"Errors\":null},\"Body\":{\"intErrorNumber\":0,\"strErrorMessage\":\"null\",\"strStatus\":\"OK\"}}';
        Continuation con;
        User uAdmin = [Select Id from User Where Id =: UserInfo.getUserId()];
        System.runAs(uAdmin) {
            Test.startTest();
            User u = new User();
            u.ProfileId = profile1.id;
            u.Username = 'orgTestUser@testuo.com';
            u.Alias = 'orgtu';
            u.Email = 'varsha.patel@lntinfotech.com';
            u.EmailEncodingKey = 'UTF-8';
            u.FirstName = 'Test All1';
            u.LastName = 'AllT';
            u.ContactId = c.Id;
            u.LanguageLocaleKey = 'en_US';
            u.LocaleSidKey = 'en_US';
            u.TimeZoneSidKey = 'America/Chicago';
            insert u;
            Test.stopTest();
            System.runAs(u) {
                con = (Continuation) CASSCalloutLE.callLEService(f.Id, null);
                System.assertEquals(con, null, 'invalid Lease Extension');

            }

        }
    }
}