global class Dailymonitoring_scheduler implements Schedulable{
    public String query;
    public Integer todayError;
    public Integer todayPayment;
    public Integer todayUsercreated;
    public Integer todayBankaccnt;
    global void execute(SchedulableContext ctx){
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
            todayError = [SELECT count() FROM ErrorLog__c where createddate = today]; 
            todayPayment = [SELECT count() FROM ChargentOrders__ChargentOrder__c where createddate = today];
            todayUsercreated = [SELECT count() FROM user where createddate = today];
            todayBankaccnt = [SELECT count() FROM Payment_Source__c where createddate = today];
           		htmlBodyBatch +='<tr><td><b>Batch class</td><td><b>Batches Processed</td><td></td><td><b>Failures</td><tr>';
        		BatchApex +='Batch class,Batches Processed,,Failures\n';
            for(AggregateResult async:[SELECT ApexClass.Name apxclss,SUM(JobItemsProcessed) Processed,SUM(NumberOfErrors) Failures FROM AsyncApexJob WHERE CreatedDate = today  and JobType='BatchApex' GROUP BY ApexClass.Name]){
                Integer batchprocessed = Integer.valueOf((Decimal)async.get('Processed'));
                Integer batchfailures = Integer.valueOf((Decimal)async.get('Failures'));
                htmlBodyBatch += '<tr><td>'+(string)async.get('apxclss')+'</td><td>'+batchprocessed+'</td><td>'+System.today().format()+'</td><td>'+batchfailures+'</td></tr>';
                BatchApex += (string)async.get('apxclss')+','+batchprocessed+','+System.today().format()+','+batchfailures+'\n';                
            }
           
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setSubject('Daily Monitoring Report ('+System.today().format()+')');               
            
            string header = 'Task,, Date , Notes\n';
            string finalstr = header ;
            string todayErrors = 'Today\'s Errors '+',Apex Class,'+System.today().format()+','+todayError+'\n';
            finalstr = finalstr +todayErrors;
            for(AggregateResult aggr:[SELECT ClassName__c,count(id) FROM ErrorLog__c where createddate = today GROUP BY ClassName__c]){
                string subTable = ''+','+aggr.get('ClassName__c')+','+System.today().format()+','+aggr.get('expr0')+'\n';
                finalstr = finalstr +subTable;
                htmlerrorClass += +'<tr><td></td><td>'+aggr.get('ClassName__c')+'</td>'+'<td>'+System.today().format()+'</td>'+'<td>'+aggr.get('expr0')+'</td></tr>';
            }
            string todayPaymnts = 'Today\'s Payments '+',Payment Channels,'+System.today().format()+','+todayPayment+'\n';
            finalstr = finalstr +todayPaymnts;
            for(AggregateResult aggr:[SELECT Payment_Channel__c,count(id) FROM ChargentOrders__ChargentOrder__c where createddate = today GROUP BY Payment_Channel__c]){
                string subTable = ''+','+aggr.get('Payment_Channel__c')+','+System.today().format()+','+aggr.get('expr0')+'\n';
                finalstr = finalstr +subTable;
                htmlPayment += +'<tr><td></td><td>'+aggr.get('Payment_Channel__c')+'</td>'+'<td>'+System.today().format()+'</td>'+'<td>'+aggr.get('expr0')+'</td></tr>';
            }
            string newUsers = 'New Users Created '+',,'+System.today().format()+','+todayUsercreated+'\n';
            finalstr = finalstr +newUsers;
            string todayBankAccs = 'Today\'s Bank Account '+',,'+System.today().format()+','+todayBankaccnt+'\n';
            finalstr = finalstr +todayBankAccs;
            integer MCcount = 0;
            string htmlMCnotfic = '';
            string subTableofMC = '';
            for(AggregateResult aggr:[SELECT Count(id), Notification_Code__c, Finance_Account__r.Honda_Brand__c,Email_Processed__c,SMS_Processed__c FROM MC_Notification__c where Email_Processed_Date__c = today or SMS_Processed_Date__c = today GROUP BY Notification_Code__c,Finance_Account__r.Honda_Brand__c,Email_Processed__c,SMS_Processed__c]){
                MCcount = MCcount+(integer)aggr.get('expr0');
                string notificationCode = (string)aggr.get('Notification_Code__c');
                if((boolean)aggr.get('Email_Processed__c') && (boolean)aggr.get('SMS_Processed__c')){
                    notificationCode += ' Email & SMS Journey';   
                }else if((boolean)aggr.get('Email_Processed__c')){
                    notificationCode += ' Email Journey';        
                }else if((boolean)aggr.get('SMS_Processed__c')){
                    notificationCode += ' SMS Journey';   
                }
                string subTable = ''+','+notificationCode+' '+(string)aggr.get('Honda_Brand__c')+','+System.today().format()+','+aggr.get('expr0')+'\n';
                subTableofMC = subTableofMC+subTable;
                htmlMCnotfic +=  +'<tr><td></td><td>'+notificationCode+' '+(string)aggr.get('Honda_Brand__c')+'</td>'+'<td>'+System.today().format()+'</td>'+'<td>'+aggr.get('expr0')+'</td></tr>';
            }
            finalstr += 'MC Notification'+','+'Notification Code'+','+System.today().format()+','+MCcount+'\n' +subTableofMC; 
            htmlMCnotfic = +'<tr><td>MC Notification</td><td><b>Notification Code</td>'+'<td>'+System.today().format()+'</td>'+'<td>'+MCcount+'</td></tr>'+htmlMCnotfic;
            if(BatchApex != '')
                finalstr = finalstr +BatchApex;
            
            htmlBody += '<table width="100%" border="0" cellspacing="0" cellpadding="8" align="center" bgcolor="#F7F7F7" >'+
                +'<tr>'+'<td><b>Task</td><td></td>'+'<td><b>Date</td>'+'<td><b>Notes</td>'+
                +'</tr>'+
                +'<tr>'+
                +'<td>Today’s Errors </td><td><b>Apex Class</td><td>'+System.today().format()+'</td><td>'+todayError+'</td>'+
                +'</tr>'+htmlerrorClass
                +'<tr>'+
                +'<td>Today’s Payments </td><td><b>Payment Channel</td><td>'+System.today().format()+'</td><td>'+todayPayment+'</td>'+
                +'</tr>'+htmlPayment+'<tr>'
                +'<td>New Users Created </td><td></td><td>'+System.today().format()+'</td><td>'+todayUsercreated+'</td>'+
                +'</tr><tr>'+
                +'<td>Today’s Bank Account </td><td></td><td>'+System.today().format()+'</td><td>'+todayBankaccnt+'</td>'+
                +'</tr>';
            htmlBody+= htmlMCnotfic+htmlBodyBatch+'</table>';
            mail.sethtmlBody(htmlBody);

            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(finalstr);
            string csvname= 'Daily_Monitoring_Report ('+System.today().format()+ ').csv';
            csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);
            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            mails.add(mail);      
            
             if(mails.size()>0)
                Messaging.sendEmail(mails);
                     
            ContentVersion cv = new ContentVersion();
            cv.Title = 'Daily Monitoring Report ('+System.today().format()+ ')' ;//File title
            cv.PathOnClient = 'Daily_Monitoring_Report.csv';//File name
            cv.VersionData = csvBlob;//File body (Add content or body of uploaded file)
            cv.Description = 'Chatter Post Document';//File description
            insert cv;
             
        }catch(exception e){
            system.debug('ex>>>'+e+e.getLineNumber());
        }
    }  

}