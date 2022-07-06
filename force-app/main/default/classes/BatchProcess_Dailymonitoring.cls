/*******************************************************************************************************
    * @author  : Kanagaraj S
    * @Company : LTI
    * @description : RSS 51631 Daily monitoring reports need to run daily
    * Note: This is deployed from LEauto org to webprj for le and scra retrofit -- Narain, Suprio
********************************************************************************************************/

global class BatchProcess_Dailymonitoring implements Database.batchable<sObject>{
    global String query;
    global Integer todayError;
    global Integer todayPayment;
    global Integer todayUsercreated;
    global Integer todayBankaccnt;
    
    global Integer count = 0;
    global String errorMessageString = '';
    global String exceptionMessage = '';
 
    global Database.Querylocator start (Database.BatchableContext SC){ 
        query = 'SELECT Id FROM Finance_Account__c Limit 1';         
        return Database.getQueryLocator(query);
    }     

   global void execute(Database.BatchableContext SC,List<Finance_Account__c> finacclst){
       try{
            String htmlBodyBatch = '';
            String BatchApex='';
            string htmlerrorClass = '';
            string htmlPayment = '';
            String emailLabel = Label.Daily_Monitoring_Automate_Notifier;
            list<string> toAddresses = new list<string>();
            String htmlBody = '';
            for(String s : emailLabel.split(',')){
                toAddresses.add(s);
            }
            todayError = [SELECT count() FROM ErrorLog__c where createddate = yesterday]; 
            todayPayment = [SELECT count() FROM ChargentOrders__ChargentOrder__c where createddate = yesterday];
            todayUsercreated = [SELECT count() FROM user where createddate = yesterday];
            todayBankaccnt = [SELECT count() FROM Payment_Source__c where createddate = yesterday];
               htmlBodyBatch +='<tr><td><b>Batch class</td><td><b>Batches Processed</td><td></td><td><b>Failures</td><tr>';
            BatchApex +='Batch class,Batches Processed,,Failures\n';
            for(AggregateResult async:[SELECT ApexClass.Name apxclss,SUM(JobItemsProcessed) Processed,SUM(NumberOfErrors) Failures FROM AsyncApexJob WHERE CreatedDate = yesterday and JobType='BatchApex' GROUP BY ApexClass.Name]){
                Integer batchprocessed = Integer.valueOf((Decimal)async.get('Processed'));
					system.debug('batchprocessed ' + batchprocessed);
                Integer batchfailures = Integer.valueOf((Decimal)async.get('Failures'));
					system.debug('batchfailures ' + batchfailures);
                htmlBodyBatch += '<tr><td>'+(string)async.get('apxclss')+'</td><td>'+batchprocessed+'</td><td>'+System.today().adddays(-1).format()+'</td><td>'+batchfailures+'</td></tr>';
                BatchApex += (string)async.get('apxclss')+','+batchprocessed+','+System.today().adddays(-1).format()+','+batchfailures+'\n';  
					system.debug('BatchApex ' + BatchApex);
            }
           
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSubject('Daily Monitoring Report ('+System.today().adddays(-1).format()+')');               
            
            string header = 'Task,, Date , Notes\n';
            string finalstr = header ;
            string todayErrors = 'Today\'s Errors '+',Apex Class,'+System.today().adddays(-1).format()+','+todayError+'\n';
					system.debug('todayErrors ' + todayErrors);
            finalstr = finalstr +todayErrors;
            for(AggregateResult aggr:[SELECT ClassName__c,count(id) FROM ErrorLog__c where createddate = yesterday GROUP BY ClassName__c]){
                string subTable = ''+','+aggr.get('ClassName__c')+','+System.today().adddays(-1).format()+','+aggr.get('expr0')+'\n';
                finalstr = finalstr +subTable;
                htmlerrorClass += +'<tr><td></td><td>'+aggr.get('ClassName__c')+'</td>'+'<td>'+System.today().adddays(-1).format()+'</td>'+'<td>'+aggr.get('expr0')+'</td></tr>';
					system.debug('htmlerrorClass '+ htmlerrorClass);
            }
            string todayPaymnts = 'Today\'s Payments '+',Payment Channels,'+System.today().adddays(-1).format()+','+todayPayment+'\n';
            finalstr = finalstr +todayPaymnts;
            for(AggregateResult aggr:[SELECT Payment_Channel__c,count(id) FROM ChargentOrders__ChargentOrder__c where createddate = yesterday GROUP BY Payment_Channel__c]){
                string subTable = ''+','+aggr.get('Payment_Channel__c')+','+System.today().adddays(-1).format()+','+aggr.get('expr0')+'\n';
                finalstr = finalstr +subTable;
                htmlPayment += +'<tr><td></td><td>'+aggr.get('Payment_Channel__c')+'</td>'+'<td>'+System.today().adddays(-1).format()+'</td>'+'<td>'+aggr.get('expr0')+'</td></tr>';
					system.debug('htmlPayment '+ htmlPayment);
            }
            string newUsers = 'New Users Created '+',,'+System.today().adddays(-1).format()+','+todayUsercreated+'\n';
           	 system.debug('newUsers '+ newUsers);

            finalstr = finalstr +newUsers;
            string todayBankAccs = 'Today\'s Bank Account '+',,'+System.today().adddays(-1).format()+','+todayBankaccnt+'\n';
            finalstr = finalstr +todayBankAccs;
            integer MCcount = 0;
            string htmlMCnotfic = '';
            string subTableofMC = '';
            for(AggregateResult aggr:[SELECT Count(id), Notification_Code__c, Finance_Account__r.Honda_Brand__c,Email_Processed__c,SMS_Processed__c FROM MC_Notification__c where Email_Processed_Date__c = yesterday or SMS_Processed_Date__c = yesterday GROUP BY Notification_Code__c,Finance_Account__r.Honda_Brand__c,Email_Processed__c,SMS_Processed__c]){
                MCcount = MCcount+(integer)aggr.get('expr0');
                string notificationCode = (string)aggr.get('Notification_Code__c');
                if((boolean)aggr.get('Email_Processed__c') && (boolean)aggr.get('SMS_Processed__c')){
                    notificationCode += ' Email & SMS Journey';   
                }else if((boolean)aggr.get('Email_Processed__c')){
                    notificationCode += ' Email Journey';        
                }else if((boolean)aggr.get('SMS_Processed__c')){
                    notificationCode += ' SMS Journey';   
                }
                string subTable = ''+','+notificationCode+' '+(string)aggr.get('Honda_Brand__c')+','+System.today().adddays(-1).format()+','+aggr.get('expr0')+'\n';
                subTableofMC = subTableofMC+subTable;
                htmlMCnotfic +=  +'<tr><td></td><td>'+notificationCode+' '+(string)aggr.get('Honda_Brand__c')+'</td>'+'<td>'+System.today().adddays(-1).format()+'</td>'+'<td>'+aggr.get('expr0')+'</td></tr>';
            }
            finalstr += 'MC Notification'+','+'Notification Code'+','+System.today().adddays(-1).format()+','+MCcount+'\n' +subTableofMC; 
            htmlMCnotfic = +'<tr><td>MC Notification</td><td><b>Notification Code</td>'+'<td>'+System.today().adddays(-1).format()+'</td>'+'<td>'+MCcount+'</td></tr>'+htmlMCnotfic;
                     
		 	 system.debug('BatchApex '+ BatchApex);
           if(BatchApex != '')
           {
                finalstr = finalstr +BatchApex;
           }
           
            htmlBody += '<table width="100%" border="0" cellspacing="0" cellpadding="8" align="center" bgcolor="#F7F7F7" >'+
                +'<tr>'+'<td><b>Task</td><td></td>'+'<td><b>Date</td>'+'<td><b>Notes</td>'+
                +'</tr>'+
                +'<tr>'+
                +'<td>Today’s Errors </td><td><b>Apex Class</td><td>'+System.today().adddays(-1).format()+'</td><td>'+todayError+'</td>'+
                +'</tr>'+htmlerrorClass
                +'<tr>'+
                +'<td>Today’s Payments </td><td><b>Payment Channel</td><td>'+System.today().adddays(-1).format()+'</td><td>'+todayPayment+'</td>'+
                +'</tr>'+htmlPayment+'<tr>'
                +'<td>New Users Created </td><td></td><td>'+System.today().adddays(-1).format()+'</td><td>'+todayUsercreated+'</td>'+
                +'</tr><tr>'+
                +'<td>Today’s Bank Account </td><td></td><td>'+System.today().adddays(-1).format()+'</td><td>'+todayBankaccnt+'</td>'+
                +'</tr>';
            htmlBody+= htmlMCnotfic+htmlBodyBatch+'</table>';
             system.debug('htmlBody '+ htmlBody);

            mail.sethtmlBody(htmlBody);

            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(finalstr);
            string csvname= 'Daily_Monitoring_Report ('+System.today().adddays(-1).format()+ ').csv';
            csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            mails.add(mail);      
             system.debug('mails '+ mails);

             if(mails.size()>0)
             {
               Messaging.sendEmail(mails);
                system.debug('mails size '+ mails.size());

             }
           		 
                     
            ContentVersion cv = new ContentVersion();
            cv.Title = 'Daily Monitoring Report ('+System.today().adddays(-1).format()+ ')' ;//File title
            cv.PathOnClient = 'Daily_Monitoring_Report.csv';//File name
            cv.VersionData = csvBlob;//File body (Add content or body of uploaded file)
            cv.Description = 'Chatter Post Document';//File description
           
            Database.SaveResult sr = Database.insert(cv, false);
 					if (!sr.isSuccess()){
                   		 //count += 1;
                         exceptionMessage = sr.getErrors() + ' : ' + sr.errors;
                    }
                
           // insert cv;
   
        }
    catch(exception e){
            system.debug('ex>>>'+e+e.getLineNumber());
                                   
            ErrorLog__c errorLog = UtilityClass.errorLogDetails('BatchProcess_Dailymonitoring',e.getMessage(),'','');
            errorLog.ExceptionErrorMessage__c =exceptionMessage;
            insert errorLog;

        }
    }
    
   global void finish(Database.BatchableContext SC){
        try
        {
            // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
            // Query the AsyncApexJob object to retrieve the current job's information.       
            AsyncApexJob a = [  Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:SC.getJobId()];
            //Send an email to the Apex job's submitter notifying of job completion.       
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();      
            
            
            String emailLabel = Label.Daily_Monitoring_Automate_Notifier;

            String[] toAddresses = new String[] {a.CreatedBy.Email};
            // Comma seperated values in Label testemails
            // Add each value to the toAddresses 
            for(String s : emailLabel.split(','))
            {
                toAddresses.add(s);
            }
            
            // setToAddresses sends email to the email addresses in toAddresses 
            mail.setToAddresses(toAddresses); 
            mail.setSubject('BatchProcess_Dailymonitoring Processed ' + a.Status);
            mail.setPlainTextBody('The Batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            
                        

        }
        catch(System.Exception ex)
        {
               system.debug('ex>>>'+ex+ex.getLineNumber());
				       
            ErrorLog__c errorLog = UtilityClass.errorLogDetails('BatchProcess_Dailymonitoring finish method',ex.getMessage(),'','');
            insert errorLog;
        }   
   } 
}