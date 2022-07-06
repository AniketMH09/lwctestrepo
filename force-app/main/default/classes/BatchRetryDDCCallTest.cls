@istest
private class BatchRetryDDCCallTest {
    
    @isTest static void testBatchRetryDDCCallSuccess() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockDDCSuccessfulResponse());
        
         // CREATE CUSTOM SETTING RECORD
         CASSCallOut__c cs = new CASSCallOut__c ();
            cs.Name            = 'CassCallOut' ;
            cs.SiteId__c       = 'Salesforce' ;
            cs.BusinessId__c   = 'Salesforce' ;
            cs.TimeOut__c      = 60000 ;
         insert cs;
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        Contact con =new Contact();
        con.LastName='TestName';
        con.AccountId=a.Id;
        con.Email='test@123.com';
        insert con;
        Profile pff =[SELECT p.Name,p.Id from Profile p where p.Name='System Administrator' limit 1];
        User u = new User();
    	u.Username='ashok.raparthi@gmail.com';	
    	u.Email='ashok.raparthi@gmail.com';
    	u.LastName='test';
    	u.TimeZoneSidKey='America/New_York';
        u.LocaleSidKey='en_US';
        u.EmailEncodingKey='ISO-8859-1';
        u.ProfileId=pff.Id;
        u.LanguageLocaleKey='en_US';
        u.Alias='testt1';  
        u.FirstName='Test234';
    	 insert u; 	   
         ID UserId=u.Id;
        
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Honda_Brand__c='AFS';
        //finacc.Customer__c=cfa.Id;
        finacc.AHFC_Last_Active_User__c=UserId;
        finacc.IsUpdated__c=true;
        
        insert finacc;
        
        //create case with next day mode error
        DDCDetails ddcdetails = new ddcdetails(finacc.id, 25); 
        ddcdetails.oldDueDay = '18';
        ddcdetails.ContactId = con.id;
        
        ddcdetails.FinAcctId = finacc.id ;
        ddcdetails.DueDay = 25;
        ddcdetails.newDueDate = Date.Today();
        
       
        
        String ProcessingType = 'Pending - Retry';
        String WebSvcResult = 'Next Day Mode';
        
        InsertCase( ddcdetails, ProcessingType, WebSvcResult);
        
        list<case> lstcse = [select id, Processing_Type__c, WebService_Result__c,Requested_Next_Due_Dte__c  from case];
        system.debug(lstcse);
        //call batchclass
        Test.startTest();
        Database.executeBatch(new BatchRetryDDCCall(), 10);
        Test.stopTest();
        lstcse = [select id, status,Processing_Type__c, WebService_Result__c,Requested_Next_Due_Dte__c  from case];
        system.debug(lstcse);
       // system.assertEquals('Closed',  lstcse[0].status);
        //system.assertEquals('Automatic - Successful', lstcse[0].Processing_Type__c);
        
        //verify case status
    }
   /* @isTest static void testBatchRetryDDCCallSuccess1() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockDDCSuccessfulResponse());
        
         // CREATE CUSTOM SETTING RECORD
         CASSCallOut__c cs = new CASSCallOut__c ();
            cs.Name            = 'CassCallOut' ;
            cs.SiteId__c       = 'Salesforce' ;
            cs.BusinessId__c   = 'Salesforce' ;
            cs.TimeOut__c      = 60000 ;
         insert cs;
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        Contact con =new Contact();
        con.LastName='TestName';
        con.AccountId=a.Id;
        con.Email='test@123.com';
        insert con;
        
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Honda_Brand__c='AFS';
        //finacc.Customer__c=cfa.Id;
        finacc.IsUpdated__c=true;
        finacc.Next_Due_Date__c = system.today();
        finacc.Paid_to_Date__c = system.today().addMonths(1);
        insert finacc;
        
        //create case with next day mode error
        DDCDetails ddcdetails = new ddcdetails(finacc.id, 25); 
        ddcdetails.oldDueDay = '18';
        ddcdetails.ContactId = con.id;
        
        ddcdetails.FinAcctId = finacc.id ;
        ddcdetails.DueDay = 25;
        ddcdetails.newDueDate = Date.Today();
        
       
        
        String ProcessingType = 'Pending Payment';
        String WebSvcResult = 'Next Day Mode';
        
        InsertCase( ddcdetails, ProcessingType, WebSvcResult);
        
        list<case> lstcse = [select id, Processing_Type__c, WebService_Result__c,Requested_Next_Due_Dte__c  from case];
        system.debug(lstcse);
        //call batchclass
        Test.startTest();
        Database.executeBatch(new BatchRetryDDCCall(), 10);
        Test.stopTest();
        lstcse = [select id, status,Processing_Type__c, WebService_Result__c,Requested_Next_Due_Dte__c  from case];
        system.debug(lstcse);
        //system.assertEquals('Closed',  lstcse[0].status);
        //system.assertEquals('Automatic - Successful', lstcse[0].Processing_Type__c);
        
        //verify case status
    }*/
    
    @isTest static void testBatchRetryDDCCallFailure() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockDDCSuccessfulResponse());
        
         // CREATE CUSTOM SETTING RECORD
         CASSCallOut__c cs = new CASSCallOut__c ();
            cs.Name            = 'CassCallOut' ;
            cs.SiteId__c       = 'Salesforce' ;
            cs.BusinessId__c   = 'Salesforce' ;
            cs.TimeOut__c      = 60000 ;
         insert cs;
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        Contact con =new Contact();
        con.LastName='TestName';
        con.AccountId=a.Id;
        con.Email='test@123.com';
        insert con;
        
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='111122222';
        finacc.Honda_Brand__c='AFS';
        //finacc.Customer__c=cfa.Id;
        finacc.IsUpdated__c=true;
        insert finacc;
        
        //create case with next day mode error
        DDCDetails ddcdetails = new ddcdetails(finacc.id, 25); 
        ddcdetails.oldDueDay = '10';
        ddcdetails.ContactId = con.id;
        
        ddcdetails.FinAcctId = finacc.id ;
        ddcdetails.DueDay = 15;
        ddcdetails.newDueDate = Date.Today();
        
       
        
        String ProcessingType = 'Pending Payment';
        String WebSvcResult = 'Next Day Mode';
        
        InsertCase( ddcdetails, ProcessingType, WebSvcResult);
        
        list<case> lstcse = [select id, Processing_Type__c, WebService_Result__c,Requested_Next_Due_Dte__c  from case];
        system.debug(lstcse);
        //call batchclass
        Test.startTest();
        Database.executeBatch(new BatchRetryDDCCall(), 10);
        Test.stopTest();
        lstcse = [select id, status,Processing_Type__c, WebService_Result__c,Requested_Next_Due_Dte__c  from case];
        system.debug(lstcse);
    }
    
     @isTest static void testBatchRetryDDCCallFailure1() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockDDCSuccessfulResponse());
        
         // CREATE CUSTOM SETTING RECORD
         CASSCallOut__c cs = new CASSCallOut__c ();
            cs.Name            = 'CassCallOut' ;
            cs.SiteId__c       = 'Salesforce' ;
            cs.BusinessId__c   = 'Salesforce' ;
            cs.TimeOut__c      = 60000 ;
         insert cs;
        
        Account a=new Account();
        a.Name='Test';
        insert a;
        
        Contact con =new Contact();
        con.LastName='TestName';
        con.AccountId=a.Id;
        con.Email='test@123.com';
        insert con;
        
        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='111122222';
        finacc.Honda_Brand__c='AFS';
        //finacc.Customer__c=cfa.Id;
        finacc.IsUpdated__c=true;
        insert finacc;
        
        //create case with next day mode error
        DDCDetails ddcdetails = new ddcdetails(finacc.id, 35); 
        ddcdetails.oldDueDay = '10';
        ddcdetails.ContactId = con.id;
        
        ddcdetails.FinAcctId = finacc.id ;
        //ddcdetails.DueDay = 15;
        //ddcdetails.newDueDate = Date.Today();
        
       
        
        String ProcessingType = 'Automatic - Failed';
        String WebSvcResult = 'Error';
        
        InsertCase( ddcdetails, ProcessingType, WebSvcResult);
        
        list<case> lstcse = [select id, Processing_Type__c, WebService_Result__c,Requested_Next_Due_Dte__c  from case];
        system.debug(lstcse);
        //call batchclass
        Test.startTest();
        Database.executeBatch(new BatchRetryDDCCall(), 10);
        Test.stopTest();
        lstcse = [select id, status,Processing_Type__c, WebService_Result__c,Requested_Next_Due_Dte__c  from case];
        system.debug(lstcse);
    }

    
    Private  Static void InsertCase( DDCDetails ddcdetails, String ProcessingType, String WebSvcResult){
        system.debug ('@@@@ddcdetails' + ddcdetails);
        String casestatus = 'New';
        String ContentNoteTemplate;
        String CustomerContactId;
        String currentDateTime = (DateTime.Now()).format('MM/dd/yyyy hh:mm:ss aaa', 'America/Los_Angeles'); //"yyyy.MM.dd G 'at' hh:mm:ss "
        ContentNoteTemplate = '<p><strong>Date/Time Received:</strong> ' + currentDateTime + ' </p> ';
        
        
        //check if case was created withing last x seconds
        
        DateTime lstCreateddatetime = (DateTime.Now()).addSeconds(-15);
        system.debug ('@@@@ lstCreateddatetime : ' + lstCreateddatetime);
        system.debug ('@@@@ now : ' + DateTime.Now());
        Case cse = new case();
        
        list<case> lstExistingCase = [select id from case where
                                      createddate > :lstCreateddatetime
                                      and Finance_Account__c = :ddcdetails.FinAcctId
                                      and type = 'Due Date Change'
                                      and Origin = 'Web'
                                     ];
        
        
        
        switch on ProcessingType{
            when 'Manual'{
                casestatus = 'New';
                cse.ownerid = system.label.unassigned_queue_id;
                
                
            }
            when 'Automatic - Successful'{
                casestatus = 'Closed';
                cse.ownerid = system.label.Closed_Queue_Id;
                
            }
            when 'Automatic - Failed'{
                casestatus = 'New';
                cse.ownerid = system.label.unassigned_queue_id;
                
            }
            when 'Pending - Retry'{
                casestatus = 'New';
                cse.ownerid = system.label.DDC_Retry_Queue_Id;
                
            }
            
        }
        
        
        cse.ContactId = ddcdetails.ContactId;
        cse.Finance_Account__c = ddcdetails.FinAcctId;
        cse.Origin = 'Web';
        cse.Requested_Next_Due_Date_Day__c = String.valueOf(ddcdetails.DueDay);
        cse.Requested_Next_Due_Dte__c = ddcdetails.newDueDate;
        cse.Service_Request__c = ContentNoteTemplate;
        cse.Subject = 'Due Date Change Request' ;
        cse.type = 'Due Date Change' ;   
        cse.Processing_Type__c = ProcessingType;
        cse.WebService_Result__c = WebSvcResult;
        cse.Status = casestatus;
        if (cse.Status == 'Closed') cse.Case_Reason__c = 'Resolved';
        cse.Service_Request__c = ContentNoteTemplate;
        if (lstExistingCase.size() == 0)   insert cse;
        
    }
}