/*******************************************************************************************************
    * @author  : Kanagaraj 
    * @description :  RSS 46325 - PG-Systematic outage recovery/SF resync process.
********************************************************************************************************/
public class RetryCallout{
  //Public Static Integer   TIME_OUT ;
    
    public static void Retrycallout(String commEmail,string financeAcccountNumber,boolean PaperlessStatements,string AffectedId){
        try{
            Profile profileObj = [Select Name from Profile where Id =: userinfo.getProfileid()];
            String profilename = profileObj.name;
            system.debug('<<<profilename>>>>'+profilename);
            string RetryNotAllowed = Label.Retry_not_allowed_profiles;
            set<string> NotAllowedProfileSet = new set<string>();
            for(String s : RetryNotAllowed.split(',')){
            	string labelVal = s.trim();
           		if(labelVal != null & labelVal != '')
               		NotAllowedProfileSet.add(labelVal);
            }
            system.debug('<<<NotAllowedProfileSet>>>>'+NotAllowedProfileSet);
            if(!NotAllowedProfileSet.contains(profilename)){
                system.debug('<<<enter---->>>>');
                Retry_Callout__c RetryObj = new Retry_Callout__c();
                RetryObj.Email_Address__c = commEmail;
                RetryObj.Finance_Account_Number__c = financeAcccountNumber;
                RetryObj.Paperless_Statements_Letters__c = PaperlessStatements;
                RetryObj.ClassName__c = 'INT 32';
                RetryObj.AffectedId__c = AffectedId;
                RetryObj.Number_of_Attempted__c = 0;
                insert RetryObj; 
            }
        }catch(exception e){
            system.debug('e---->>>'+e.getLineNumber()+'<<<>>>'+e.getMessage());
        }
    }
    public static void RetrycalloutCreationfromCASScallout(string endpoint ,string method,string body,string BusinessId,string siteid,Integer timeout,string AffectedId,string Erroredclassname,string response,string CalloutRequest,string Content_Type,string collectionTimeStamp){
        try{
            Retry_Callout__c RetryObj = new Retry_Callout__c();
            RetryObj.Request_Endpoint__c = endpoint;
            RetryObj.Request_Method__c  = method;
            RetryObj.HTTP_Request_Body__c = body;
            RetryObj.BusinessId__c  = BusinessId;
            RetryObj.SiteId__c  = siteid;
            RetryObj.TimeOut__c  = timeout;
            RetryObj.AffectedId__c = AffectedId;
            RetryObj.Number_of_Attempted__c = 0;
            RetryObj.HTTP_Responce__c= response;
            RetryObj.ClassName__c = Erroredclassname;
            RetryObj.HTTP_Request__c = CalloutRequest;
            RetryObj.Content_Type__c = Content_Type;
            RetryObj.collectionTimeStamp__c = collectionTimeStamp;
            insert RetryObj; 
        }catch(exception e){
            system.debug('e---->>>'+e.getLineNumber()+'<<<>>>'+e.getMessage());
        }
    }
}