/* Apex Class Name   :    BatchRetryLECallTest
 * Description        :    Unit test class of BatchRetryLECall
 * Modification Log   :
 * ---------------------------------------------------------------------------
 * Developer                             Date                   Description
 * ---------------------------------------------------------------------------
 * Narain Simha                     10th Nov 2021                 Created
 * Prabu Mohanasundaram			   23rd Nov 2021                 Modified
 *********************************************************************************/

@istest
public class BatchRetryLECallTest {
    @isTest static void testBatchPendingRetry() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockDDCSuccessfulResponse());

        // CREATE CUSTOM SETTING RECORD
        CASSCallOut__c cs = new CASSCallOut__c();
        cs.Name = 'CassCallOut';
        cs.SiteId__c = 'Salesforce';
        cs.BusinessId__c = 'Salesforce';
        cs.TimeOut__c = 60000;
        insert cs;

        Account a = new Account();
        a.Name = 'Test';
        insert a;

        Contact con = new Contact();
        con.LastName = 'TestName';
        con.AccountId = a.Id;
        con.Email = 'test@123.com';
        insert con;

        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c = '1111';
        finacc.Honda_Brand__c = 'AFS';
        //finacc.Customer__c=cfa.Id;
        finacc.IsUpdated__c = true;

        insert finacc;

        //create case with next day mode error
        LEDetails ledetails = new LEDetails(finacc.id, 25);
        ledetails.oldDueDay = '18';
        ledetails.ContactId = con.id;

        ledetails.FinAcctId = finacc.id;
        //ledetails.DueDay = 25;
        ledetails.newDueDate = Date.Today();



        String ProcessingType = 'Pending - Retry';
        String WebSvcResult = 'SUCCESS';

        InsertCase(ledetails, ProcessingType, WebSvcResult);

        list <
            case >lstcse = [select id, Processing_Type__c, WebService_Result__c, Requested_Next_Due_Dte__c from
                case
            ];
        system.debug(lstcse);
        //call batchclass
        Test.startTest();
        BatchRetryLECall le = new BatchRetryLECall();
        Id jobid = Database.executeBatch(le, 10);
        //Database.executeBatch(new BatchRetryLECall(), 10);
        Test.stopTest();
        lstcse = [select id, status, Processing_Type__c, WebService_Result__c, Requested_Next_Due_Dte__c from
            case
        ];
        system.debug(lstcse);
        //system.assertEquals('Closed',  lstcse[0].status);
        //system.assertEquals('Automatic - Successful', lstcse[0].Processing_Type__c);

        //verify case status
    }
    /**
     * @description: Added the code for cover the failure Response.
     * @author Prabu Mohanasundaram | Nov 23 2021
     **/
    @isTest static void failureLEResponse() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockLEFailureResponse());

        // CREATE CUSTOM SETTING RECORD
        CASSCallOut__c cs = new CASSCallOut__c();
        cs.Name = 'CassCallOut';
        cs.SiteId__c = 'Salesforce';
        cs.BusinessId__c = 'Salesforce';
        cs.TimeOut__c = 60000;
        insert cs;

        Account a = new Account();
        a.Name = 'Honda';
        insert a;

        Contact con = new Contact();
        con.LastName = 'HondaMarine';
        con.AccountId = a.Id;
        con.Email = 'HondaMarine@honda.com';
        insert con;

        Finance_Account__c finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c = '0000040050020';
        finacc.Honda_Brand__c = 'AFS';
        //finacc.Customer__c=cfa.Id;
        finacc.IsUpdated__c = true;
        finacc.Next_Due_Date__c = Date.newInstance(2021, 06, 07);
        finacc.Paid_to_Date__c = Date.newInstance(2021, 09, 07);
        insert finacc;

        //create case with next day mode error
        LEDetails ledetails = new LEDetails(finacc.id, 25);
        ledetails.oldDueDay = '18';
        ledetails.ContactId = con.id;
        ledetails.FinAcctId = finacc.id;
        ledetails.newDueDate = Date.Today();

        String ProcessingType = 'Pending - Retry';
        String WebSvcResult = 'Next Day Mode';

        InsertCase(ledetails, ProcessingType, WebSvcResult);
        //call batchclass
        Test.startTest();
        BatchRetryLECall le = new BatchRetryLECall();
        Id jobid = Database.executeBatch(le, 10);
        Test.stopTest();
        List <
            case >lstcse = [select id, status, Processing_Type__c, WebService_Result__c, Requested_Next_Due_Dte__c from
                case
            ];
        system.assertEquals('Pending - Retry', lstcse[0].Processing_Type__c, 'Case Processing Type should be Pending - Retry');
    }
    Private Static void InsertCase(LEDetails ledetails, String ProcessingType, String WebSvcResult) {
        system.debug('@@@@LEEEdetails' + LEdetails);
        String casestatus = 'New';
        String ContentNoteTemplate;
        String CustomerContactId;
        String currentDateTime = (DateTime.Now()).format('MM/dd/yyyy hh:mm:ss aaa', 'America/Los_Angeles'); //"yyyy.MM.dd G 'at' hh:mm:ss "
        ContentNoteTemplate = '<p><strong>Date/Time Received:</strong> ' + currentDateTime + ' </p> ';


        //check if case was created withing last x seconds

        DateTime lstCreateddatetime = (DateTime.Now()).addSeconds(-15);
        Case cse = new
        case ();

        list <
        case >lstExistingCase = [select id from
            case where
            createddate > :
                lstCreateddatetime
                and Finance_Account__c =: ledetails.FinAcctId
                and type = 'Lease Extension'
                and Origin = 'Web'
        ];



        switch on ProcessingType {
            when 'Manual' {
                casestatus = 'New';
                cse.ownerid = system.label.unassigned_queue_id;


            }
            when 'Automatic - Successful' {
                casestatus = 'Closed';
                cse.ownerid = system.label.Closed_Queue_Id;

            }
            when 'Automatic - Failed' {
                casestatus = 'New';
                cse.ownerid = system.label.unassigned_queue_id;

            }
            when 'Pending - Retry' {
                system.debug('PendingRetriess');
                casestatus = 'New';
                cse.ownerid = system.label.DDC_Retry_Queue_Id;

            }

        }


        cse.ContactId = ledetails.ContactId;
        cse.Finance_Account__c = ledetails.FinAcctId;
        //cse.Finance_Account__r.Finance_Account_Number__c = ledetails.FinAcctId;
        cse.Origin = 'Web';
        cse.Requested_Months__c = 6.0;
        //cse.Requested_Next_Due_Date_Day__c = String.valueOf(ledetails.DueDay);
        cse.Requested_Next_Due_Dte__c = Date.newInstance(2021, 12, 9);
        cse.Requested_Next_Due_Date_Day__c = '22';
        //cse.Finance_Account__r.Next_Due_Date__c = Date.newInstance(2021, 06, 07);
        //cse.Finance_Account__r.Paid_to_Date__c = Date.newInstance(2021, 08, 07);
        cse.Processing_Type__c = 'Pending - Retry';
        cse.Reason = 'Complex functionality';
        cse.Service_Request__c = ContentNoteTemplate;
        cse.Subject = 'Lease Extension Change Request';
        cse.type = 'Lease Extension';
        cse.DDC_Retry_Callout_Count__c = 0;
        cse.Processing_Type__c = ProcessingType;
        cse.WebService_Result__c = WebSvcResult;
        cse.Status = casestatus;
        system.debug('CaseStatussss-->' + cse.Status);
        system.debug('WebSvcResultsssss-->' + WebSvcResult);
        if (cse.Status == 'Closed') cse.Case_Reason__c = 'Resolved';
        cse.Service_Request__c = ContentNoteTemplate;
        system.debug('LstofCasess-->' + lstExistingCase);
        if (lstExistingCase.size() == 0) insert cse;

    }

}