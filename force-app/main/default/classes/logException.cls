public class logException extends Exception {

    Public Static void debug(String SourceType,String SourceName, Exception e){
    
        System.Debug(' logException e ===> ' + e);
        
        try {
         
         /* 
         String CodeDetails = '';
         
         if ( SourceType == 'Page'){
             
            ApexPage PageDetails =  [SELECT ControllerKey,ControllerType,Markup,Name, LastModifiedById,LastModifiedDate
                                            FROM ApexPage 
                                            WHERE Name = : SourceName ];
            
            if ( PageDetails.ControllerType == '2' ) {
            
                ApexClass ClassDetails =  [SELECT LastModifiedById,LastModifiedDate , Name
                                            FROM ApexClass
                                            WHERE Name = : PageDetails.ControllerKey ];
                
                CodeDetails += 'Page Name : '+ PageDetails.Name + '<br/>  ';
                CodeDetails += 'Last ModifiedBy : ' + PageDetails.LastModifiedById + ' @ ' +  PageDetails.LastModifiedDate +' <br/>  ';
                                                
            }                                 
         
         }
         */               
        
         String CurrentUser = Userinfo.getUserName();
         String     Msg         = e.getMessage();
         Exception  Cause       = e.getCause();
         Integer    Linenumber  = e.getLineNumber();
         String     Stacktrace  = e.getStackTraceString();
         
         String ClassName = Stacktrace.SubstringBetween('Class.','.');
         String Method = Stacktrace.SubstringAfterLast('.');
         Method = Method.SubstringBefore(':');
         
         String EmailBody = '<b> Error has occurred. Please find the details below.   </b> <br/>';
         String EnvName = 'Production' ;
         if ( UserInfo.getUserName().substringAfterLast('.com') <> NULL ) {
             EnvName = 'Sandbox - ' + UserInfo.getUserName().substringAfterLast('.com') ;
         } 
         
         EmailBody += 'Org : '  + EnvName + ' <br/>';
         
         Map<String, String> PageParams = ApexPages.currentPage().getParameters();  
         if ( PageParams  <> NULL){
             EmailBody += '<b> VisualForce Page Parameters: </b> <br/>';
             
             for ( String a : PageParams.keyset() ) {
                 if ( !a.StartsWith('j_id0') && !a.StartsWith('com.salesforce') ) {
                     EmailBody += a + ' == ' + PageParams.get(a) + ' <br/>';
                 }
             } 
         
         }
         
         
         EmailBody += 'User : ' + CurrentUser + '<br/>';
         EmailBody += 'Message : ' + Msg + ' <br/>';
         EmailBody += 'Exception Type: ' + e.getTypeName() + ' <br/>';
         EmailBody += 'Cause : ' + Cause + ' <br/>';
         EmailBody += 'ClassName : ' + ClassName  + '<br/>';
         EmailBody += 'Method : ' + Method   + ' <br/>';
         EmailBody += 'Linenumber : ' + Linenumber  + ' <br/>';
         //EmailBody += 'CodeDetails :' + CodeDetails  + ' <br/>';
            
         System.Debug(' EmailBody ==> '+ EmailBody );    
         
         List<String> toAddresses = New List<String> ();
         //toAddresses.add('saravanan.cho@accenture.com');
         toAddresses.add('rajesh.krishnamohan@accenture.com');
         toAddresses.add('a.c.ramalingam@accenture.com');
         //toAddresses.add('mariappan.perumal@accenture.com');
         toAddresses.add('sumit.v.kuma@accenture.com');
         
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         mail.setToAddresses(toAddresses);
         mail.setSenderDisplayName('System Admin');
         mail.setSubject( SourceType +' : '+ SourceName + ' Error has occured');
         mail.setHtmlBody(EmailBody );
        // Messaging.sendEmail(new Messaging.Email[] { mail });
         
         
         System.Debug(' Stacktrace   ===> ' + Stacktrace  ); 
          
         } catch (exception e2){
             
             String[] toAddrs = new String[]{'saravanan.cho@accenture.com'};
         
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
             mail.setToAddresses(toAddrs);
             mail.setSenderDisplayName('System Admin');
             mail.setSubject( ' Error has occured in Error Handling Class');
             mail.setHtmlBody(e2.getmessage());
           //  Messaging.sendEmail(new Messaging.Email[] { mail });
         
         }
    }

}