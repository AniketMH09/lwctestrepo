@isTest
public class ErrorLogEmailNotificationctrl_Test {
    @testVisible 
    Public static List<Daily_Error_Log_Notification__mdt> customMetadata { 
    get {
        if ( customMetadata == null )
            customMetadata = [ SELECT MasterLabel, Threshold_Level__c FROM Daily_Error_Log_Notification__mdt ]; 
        return customMetadata;
    } set; 
    }
    public static TestMethod void testErrorLogEmailNotificationctrl(){
        ErrorLogEmailNotificationctrl errorlog = new ErrorLogEmailNotificationctrl();
        ErrorLogEmailNotificationctrl_Test.customMetadata  = (List<Daily_Error_Log_Notification__mdt>) JSON.deserialize( '[{"Threshold_Level__c ":"2","MasterLabel":"INT 32","DeveloperName":"INT_32"}]', List<Daily_Error_Log_Notification__mdt>.class );
        List<ErrorLog__c> errorlognewlist =new List<ErrorLog__c>();
        ErrorLog__c  errorlognew = new ErrorLog__c();    
        errorlognew.ClassName__c ='INT 32';
        errorlognewlist.add(errorlognew);
        
        ErrorLog__c  errorlognew1 = new ErrorLog__c();    
        errorlognew1.ClassName__c ='INT 32';
        errorlognewlist.add(errorlognew1);
        
        ErrorLog__c  errorlognew2 = new ErrorLog__c();    
        errorlognew2.ClassName__c ='INT 32';
        errorlognewlist.add(errorlognew2);
        insert errorlognewlist;
    }
}