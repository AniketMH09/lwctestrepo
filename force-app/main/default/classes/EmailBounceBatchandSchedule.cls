global class EmailBounceBatchandSchedule implements Database.Batchable<sObject>, Database.Stateful,  Schedulable {
     
     global List<Account> Accounts = New List<Account>();
     
     
     global EmailBounceBatchandSchedule(){
         // Batch Constructor
           
     }
   
     // Start Method
     global Database.QueryLocator start(Database.BatchableContext BC){
         
        return Database.getQueryLocator('SELECT Id, PersonEmail FROM Account WHERE PersonEmailBouncedDate <> NULL ');
     }
   
     // Execute Logic
     global void execute(Database.BatchableContext BC, List<Account> Accs){
        
        try {  

            SYSTEM.DEBUG(' ENETRING EMAIL BOUNCE BACK ==> '  );
            if ( !Accs.Isempty() ){
                 
                 Accounts = accs ;
                 List<Id> AccIds = New List<Id>();
                 List<String> AccEmails = New List<String>();
                 for( Account a :Accs  ){
                     AccIds.add(a.id);
                     AccEmails.add(a.PersonEmail );
                     a.PersonEmail = a.PersonEmail + 'BOUNCED';
                 }
                 
                 Map<Id,Communication_Preferences__c> CommPreferences = New Map<Id,Communication_Preferences__c> ([SELECT Id, Email_BounceBack_Count__c, Customer__r.PersonEmail,
                                                                                     Payment_Confirmations_via_Email__c, Payment_Profile_Updates_via_Email__c, Payment_Reminders_via_Email__c, EasyPay_Communications_via_Email__c,
                                                                                     Payment_Confirmations_via_Text__c,  Payment_Profile_Updates_via_Text__c,  Payment_Reminders_via_Text__c, EasyPay_Communications_via_Text__c,
                                                                                     Unsubscribe_from_all__c, SMS_Bounce_Back_Count__c,Is_Comm_Pref_Set__c, Statements_Letters__c,Paperless_Statements_Letters__c                         
                                                                                 FROM Communication_Preferences__c 
                                                                                 WHERE Customer__c IN :AccIds  AND Email_Address__c IN :AccEmails ]); 
                
                if ( !CommPreferences.Isempty() ){
                    
                    for( Communication_Preferences__c c :CommPreferences.values()  ){
                        
                        SYSTEM.DEBUG(' c ==> ' + c );
                        //INCREASE THE COUNT
                        c.Email_BounceBack_Count__c += 1 ;
                        c.IsEmailBounced__c = True ;
                        c.Is_Comm_Pref_Set__c = True ;
                        
                        // SET FLAG TO FALSE WHEN EMAIL BOUNCED 3 TIMES
                        if ( c.Email_BounceBack_Count__c >= 3  ) {
                             
                             c.Payment_Confirmations_via_Email__c = False ;
                             c.Payment_Profile_Updates_via_Email__c = False ;
                             c.Payment_Reminders_via_Email__c = False ;
                             c.EasyPay_Communications_via_Email__c = False ;
                             
                             if ( c.SMS_Bounce_Back_Count__c >= 3 ||
                                 ( !c.Payment_Confirmations_via_Text__c && !c.Payment_Profile_Updates_via_Text__c && !c.Payment_Reminders_via_Text__c && !c.EasyPay_Communications_via_Text__c ) ) {
                                 c.Is_Comm_Pref_Set__c = False ;
                                 c.Unsubscribe_from_all__c = True ;
                                  c.Paperless_Statements_Letters__c = False;
                                  c.Statements_Letters__c = 'Paper' ;
                                 
                             }
                        } 
                        
                        c.Customer__r.PersonEmail = c.Customer__r.PersonEmail + 'BOUNCED' ;
                    }
                    // UPDATE THE COMMUNICATION PREFERENCES AND ACCOUNT EMAIL
                    Update CommPreferences.values() ;
                    Update Accs ;
                }
                
            }
          // EXCEPTION HANDLER  
          } Catch ( Exception e ) {
          
              SYSTEM.DEBUG(' EXCEPION OCCURED IN EMAIL BOUNCE CLASS ==> ' + e.getMessage() );
              SYSTEM.DEBUG(' LINE NUMBER ==> ' + e.getLineNumber() );
              SYSTEM.DEBUG(' CAUSE ==> ' + e.getCause() );
              SYSTEM.DEBUG(' TRACE STRING ==> ' + e.getStackTraceString() );
          }      
   
     }
   
     global void finish(Database.BatchableContext BC){
         SYSTEM.DEBUG(' EMAIL BOUNCE CLASS FINSH ==> ' + Accounts);
         for ( Account a :Accounts){
             String PersonEmail = a.PersonEmail ;
             if ( PersonEmail.Contains('BOUNCED') ){
                 a.PersonEmail = PersonEmail.remove('BOUNCED') ;
             }
         }
         Update Accounts;
         
          
         // SCHEDULE FOR EVERY 1 HOUR RUN
          System.schedule('EMAIL BOUNCE CHECK BATCH', '0 10 * * * ?', new EmailBounceBatchandSchedule());
          

     }
     
     global void execute(SchedulableContext sc) {
           Database.executeBatch(new EmailBounceBatchandSchedule(), 2000);
     }
   
}