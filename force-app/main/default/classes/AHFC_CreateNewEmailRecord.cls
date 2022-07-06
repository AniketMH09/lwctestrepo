//
// Class Name : AHFC_CreateNewEmailRecord 
// Apex Class Called from Process Builder
// 27 Dec, 2018    Karunakar Pulkam    Original

public class AHFC_CreateNewEmailRecord {
    
    //I-362256: Custom labels AHFC_CreateNew_Status & AHFC_ClassName added to replace hardcoded values
    static final string status = Label.AHFC_CreateNew_Status;
    static final string className = Label.AHFC_ClassName;
    
    @InvocableMethod
    public static List<String> getEmailRecords(List<Id> CaseId) {
   
        // Storing Template name in Case.Email_Template_Name__c Text field
        List<String> templateName = new List<String>();
        for(Case cs : [SELECT Id,Email_Template_Name__c FROM Case WHERE Id IN :CaseId]){
            templateName.add(cs.Email_Template_Name__c);
        }
        try{
        //I-362256: Sql query changed from --> List<EmailTemplate> et = [SELECT Id,Name,Subject,Body,HtmlValue FROM EmailTemplate WHERE Name =:templateName[0]];    
        List<EmailTemplate> et = [SELECT Id,Name,Subject,Body,HtmlValue FROM EmailTemplate WHERE Name In :templateName];
        
        EmailMessage emailMessage = new EmailMessage();
        //I-362256: Hardcode value removed from --> emailMessage.Status = '3';
        emailMessage.Status = status;
        emailMessage.ParentId = CaseId[0];
        emailMessage.HtmlBody = et[0].HtmlValue;
        emailMessage.Subject = et[0].Subject;
        
        insert emailMessage;
        }catch (Exception e) {
                System.debug(e.getMessage());
                ErrorLog__c errorLog = new ErrorLog__c();
            	//I-362256: Hardcode value removed from -->  errorLog.ClassName__c = 'AHFC_CreateNewEmailRecord';
                errorLog.ClassName__c = className;
                errorLog.ExceptionMsg__c = e.getMessage();
                //errorLog.AffectedId__c = cs.Id;
                //errorLog.RequestBody__c = e.getMessage();
                insert errorLog;
            }
       
        return null;   
    }
    
    //@InvocableMethod
    public static void updateCaseEmail(List<Id> CaseId) {
        
    }
}