@isTest
public class SuspenseCallOut_Test {
    Private static TestMethod void Method1(){
        CASSCallOut__c cs = new CASSCallOut__c ();
        cs.Name            = 'SuspenseCallOut' ;
        cs.SiteId__c       = 'Salesforce' ;
        cs.BusinessId__c   = 'Salesforce' ;
        cs.TimeOut__c      = 60000 ;
        insert cs;      
        
        Suspense__c sus = new Suspense__c();       
        
        sus.Account_Number__c = '00000123456789';
        sus.Account_Number1__c = '00000123456789';
        sus.Account_Number2__c = '00000123456789';
        sus.Action_Taken__c = 'Account';
        sus.CkReqCaseNum__c = '54321';
        sus.Operator_Action_Taken__c = 'Account';
        sus.Cleared_Action_Taken_1__c = 'Account';
        sus.Cleared_Action_Taken_2__c = 'Account';
        sus.Comment_Date__c = System.Today();
        sus.Comments__c = 'This is a test';
        //sus.Completed_By__c = '';
        sus.Completed_Date__c = System.Today();
        sus.ConfirmDate__c = System.Today();
        //sus.Debit_Indicator__c = '';
        sus.Effective_Date__c = System.Today();
        sus.Error_Description__c = 'STOP PAYMENT IND';
        sus.ErrorNum__c = '987654';
        //sus.Expense_Amt__c = 0.00;
        sus.Expense_Comment__c = 'Test Comment';
        sus.Origin_Code__c = 'F26';
        sus.Pending_Date__c = System.Today();
        //sus.User__c = 'Test User';
        //sus.Process_Status__c = 'CTP';
        sus.Process_Date__c = System.Today();
        sus.Expense_Action_Taken__c = 'Suspense to Expense';
        sus.RefNum__c = '76543';
        //sus.Refund_Amt__c = 0.00;
        sus.Refund_Comments__c = 'Test Comment';
        sus.Sequence_Number__c = '98765';
        //sus.Sr_Analyst__c = '';
        //sus.Supervisor_Name__c = '';
        sus.Tran_Amount__c = 3.06;
        sus.TranAmountText__c = '3.06';
        sus.TranCode__c = '8080';
        sus.TranDesc__c = 'Account NOT FOUND';
        sus.TranSign__c = 3.06;
        
        insert sus;
         try
        {
             Type t = Type.forName('SuspenseAutoAssign_StopPayment');
        Object obj = t.newInstance();
            Database.executeBatch((SuspenseAutoAssign_StopPayment)obj, 20);
        }
        catch (Exception e)
        {
            
        }
        
        sus.Operator_Action_Taken__c='';
        sus.Sequence_Number__c='8765';
        sus.RefNum__c='9987';
        update sus;
        
        sus.Account_Number1__c='987656789';
        sus.Operator_Action_Taken__c=null;
        sus.Transaction_Amount_Split_2__c=null;
        sus.Refund_Comments__c='Updated Comments';
        sus.Expense_Comment__c='Updated Comments';
        update sus;
        
       
        
        sus.Operator_Action_Taken__c='Splits';
        sus.Transaction_Amount_Split_1__c = 1.06;
        sus.Transaction_Amount_Split_2__c = 2.00;    
        update sus;
        
        sus.Refund_Comments__c=null;
        sus.RefNum__c=null;
        sus.Expense_Comment__c=null;
        sus.Sequence_Number__c=null;
        update sus;
        
        Test.setMock(HttpCalloutMock.class, new CASSCallOut_Mock());
        SuspenseCallOut.makeHttpCallforSuspense(sus.Id);
         SuspenseCallOut.makeHttpCallforSuspense('1');
        SuspenseCallOut.makeHttpCallforSuspenseBatch(sus.Id);
        
        //  Http h = new Http();
        HttpRequest request = new HttpRequest();
        SuspenseCallOut.getRequestHeader(request);
        
         List<User> uu = [select id from user where isactive = true AND Profile.Name like '%System Admin%' limit 2];
        
        try{
            SuspenseCallOut.getLastModifiedBy(uu[0].Id);
        }
        catch(Exception e)
        {
            
        }
        
        try
        {
             Type t = Type.forName('SuspenseAutoAssign_NonHondaPayoff');
        Object obj = t.newInstance();
            Database.executeBatch((SuspenseAutoAssign_NonHondaPayoff)obj, 20);
        }
        catch (Exception e)
        {
            
        }
        
         try
        {
             Type t = Type.forName('SuspenseAutoAssign');
        Object obj = t.newInstance();
            Database.executeBatch((SuspenseAutoAssign)obj, 20);
        }
        catch (Exception e)
        {
            
        }
        
         try
        {
             Type t = Type.forName('SuspenseAutoAssign_StopPayment');
        Object obj = t.newInstance();
            Database.executeBatch((SuspenseAutoAssign_StopPayment)obj, 20);
        }
        catch (Exception e)
        {
            
        }
        
         try
        {
             Type t = Type.forName('SuspenseAutoAssign_MMS');
        Object obj = t.newInstance();
            Database.executeBatch((SuspenseAutoAssign_MMS)obj, 20);
        }
        catch (Exception e)
        {
            
        }
        
         try
        {
            sus.Origin_Code__c='A01';
        
        update sus;
             Type t = Type.forName('SuspenseAutoAssign_OriginCodes');
        Object obj = t.newInstance();
            Database.executeBatch((SuspenseAutoAssign_OriginCodes)obj, 20);
        }
        catch (Exception e)
        {
            
        }
        
        
        try
        {
            delete sus;
        }
        catch (Exception e)
        {
            //Boolean expectedExceptionThrown =  e.getMessage().contains('My Error Message') ? true : false;
            //System.AssertEquals(expectedExceptionThrown, true);
        }
        try
        {
        sus.OwnerId=uu[0].Id;
        update sus;
        sus.User__c=uu[0].Id;
        update sus;
           
        }
        catch (Exception e)
        {
            
        }
        
        
        
    }
}