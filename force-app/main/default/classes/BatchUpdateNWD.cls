global with sharing class BatchUpdateNWD implements Database.Batchable < sObject > , Database.RaisesPlatformEvents,
Database.AllowsCallouts  {
    Global final DateTime LastRun;
    Global final Date LastExtDate;
    Global final Date LastNWD;
    Global final Date AF_Proc_Date;
    Global final Date NWDAdjMonday;
    Global final Date LastExtDateAdjMonday;
    Global final Integer stmtdays;
    
    
    global BatchUpdateNWD(){
        BatchUpdateNWDParams__c params = BatchUpdateNWDParams__c.getOrgDefaults();
        LastNWD = params.LastNWD__c;
        LastExtDate = params.LastExtDate__c;
        LastRun = params.LastRun__c;
        System.Debug(params);
        System.debug('LastRun' + LastRun);
       // System.debug('LastExtDate' + LastExtDate);
        System.debug('LastNWD' + LastNWD);
        
        String DayOfWeek = DateTime.now().format('u');
        
        NWDAdjMonday= DayOfWeek == '1' ? Date.today().Adddays(-1) : Date.today();
        system.debug('NWDAdjMonday = ' + NWDAdjMonday);
        
        LastExtDateAdjMonday = DayOfWeek == '1' ? Date.today().Adddays(-2) : Date.today().Adddays(-1);
        system.debug('LastExtDateAdjMonday = ' + LastExtDateAdjMonday);
        
        Honda_Finance__c hondaCT = Honda_Finance__c.getOrgDefaults();
        stmtdays = Integer.valueOf(hondaCT.No_of_Days__c) ;
        
        
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query = 'Select  ' +
            'Finance_Account_Number__c,  ' +
            'FA_Next_Withdrawal_Date__c, ' +
            'Paid_to_Date__c, ' +
            'CASS_LST_EXT_DATE__c, ' +
            'CASS_EXT_MNTHS__c ' +
            'From Finance_Account__c ' +
            'where SystemModstamp > :LastRun  ' +
            'AND FA_Next_Withdrawal_Date__c != null ' +  
            'AND CASS_LST_EXT_DATE__c >= :LastExtDateAdjMonday ' +
            'AND Paid_to_Date__c != null ' +
            'AND CASS_EXT_MNTHS__c > 0 '  ;
        
        system.debug('@@@@ query :'+ query);
        system.debug('@@@@ LastExtDateAdjMonday :' + LastExtDateAdjMonday);
        system.debug ('@@@@ LastRun :'+ LastRun);
        
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List < finance_account__c > faScope) {
        
        list < ChargentOrders__ChargentOrder__c > paysToUpdate = new list < ChargentOrders__ChargentOrder__c > ();
        Set < Id > finAccIdSet = new Set <Id> ();
        Map <id, finance_account__c> mapFA = new Map <id, finance_account__c>();
        
        system.debug ('@@@@ LastRun value in execute method :'+ LastRun);
        system.debug ('@@@@ fin accts passed to batch :' + faScope);
        
        try {      
            
            
            for (finance_account__c fa :faScope){
                if (fa.FA_Next_Withdrawal_Date__c.daysBetween(fa.Paid_to_Date__c )  > stmtdays) {
                    finAccIdSet.add(fa.id);
                    mapFa.put(fa.id,fa);
                }
                    
            }
            system.debug('@@@@ fin accts size where paid to date - nwd > 21 :' + finAccIdSet.size());
            system.debug('@@@@ fin accts where paid to date - nwd > 21 :' + mapFa);
            
			//Query Finance Account History Records
			//
			list<Finance_Account__History> lstfahistory = 
                [SELECT Id,ParentId,CreatedById,CreatedDate,Field,OldValue,NewValue 
                 FROM Finance_Account__History where 
                 parentId in :finAccIdSet 
                 and field  = 'FA_Next_Withdrawal_Date__c' 
                 and createddate > :LastRun
                 and createdbyid = :System.Label.BatchApexUserId ];
            
            system.debug('@@@@ History Records :' + lstfahistory);

			map<Id, Finance_Account__History> mapFaHistory = new map<Id, Finance_Account__History>();
            
            for(Finance_Account__History faHist :lstfahistory ){
                if (mapFaHistory.containsKey(faHist.ParentId) && mapFaHistory.get(faHist.ParentId) != null 
                    && (faHist.NewValue == null || faHist.NewValue == '') ){
                        
                       UtilitiyMethods.createErrorlogevt('More tha one FA History Record', 'INT 6B2', faHist.ParentId,faHist.ParentId,String.join(paysToUpdate, ','));
                    
                }
                else if (faHist.NewValue == null || faHist.NewValue == '')  {
                    
                    mapFaHistory.put(faHist.ParentId,faHist);
                    
                }
               
                
            }
            system.debug('@@@@ mapFaHistory :' + mapFaHistory);
            
            //query pending recurring payment records
            list<ChargentOrders__ChargentOrder__c> lstpendingEzpays = 
                [select id, Next_Withdrawal_Date__c, Finance_Account_Number__c
                 ,Finance_Account_Number__r.CASS_LST_EXT_DATE__c
                 ,Finance_Account_Number__r.CASS_EXT_MNTHS__c,ChargentOrders__Charge_Date__c
                 from ChargentOrders__ChargentOrder__c
                 
                 where createddate > :LastRun
                 and Finance_Account_Number__c in :finAccIdSet
                 and Payment_Display_Status__c = 'Pending' 
                 and recordtype.developername = 'Recurring_Payment'
                 and createdById = :System.Label.BatchApexUserId ];
            
            system.debug('@@@@ Number of possible ezpays : ' + lstpendingEzpays.size());
            system.debug('@@@@ Possible ezpays : ' + lstpendingEzpays);
            
            for (ChargentOrders__ChargentOrder__c ezpay : lstpendingEzpays){
                
                integer extMths = (Integer)ezpay.Finance_Account_Number__r.CASS_EXT_MNTHS__c;
                Integer withdrawOnDay = Integer.valueOf(ezpay.ChargentOrders__Charge_Date__c); 
                
                if (mapFaHistory.containsKey(ezpay.Finance_Account_Number__c)) {
                    Finance_Account__History faHist = mapFaHistory.get(ezpay.Finance_Account_Number__c);
                    Date oldNWD = (Date)(mapFaHistory.get(ezpay.Finance_Account_Number__c)).OldValue;
                   	Date Nextwithdrwl =  oldNWD.addMonths(extMths);
                    //ezpay.Next_Withdrawal_Date__c = oldNWD.addMonths(extMths);
                    system.debug('<<<oldNWD.addMonths(extMths)>>>>'+oldNWD.addMonths(extMths));
                    if (withdrawOnDay > Date.daysInMonth(Nextwithdrwl.year(), Nextwithdrwl.month())) {
                        ezpay.Next_Withdrawal_Date__c = oldNWD.addMonths(extMths);
                    }else {
                        ezpay.Next_Withdrawal_Date__c = Date.newInstance(Nextwithdrwl.year(), Nextwithdrwl.month(), withdrawOnDay);
                    }
                    system.debug('<<<ezpay.Next_Withdrawal_Date__c>>>>'+ezpay.Next_Withdrawal_Date__c);
                    if (ezpay.Next_Withdrawal_Date__c <= (mapFa.get(ezpay.Finance_Account_Number__c).Paid_to_Date__c)){
                        paysToUpdate.add(ezpay);
                    }
                    else {
                        UtilitiyMethods.createErrorlogevt('Computed NWD Greater than Paid to Date', 'INT 6B2', Null,
                                                          ezpay.Finance_Account_Number__c,null);
                    }
                    
                    
                }
                else {
					 UtilitiyMethods.createErrorlogevt('FA History Record Not Found', 'INT 6B2',
                                                       ezpay.Finance_Account_Number__c,ezpay.Finance_Account_Number__c,null);
                                        
                }
                
                
               
                
                
            }
            
            system.debug('ezpay updated :' + paysToUpdate.size());
            system.debug('@@@@ paysToUpdate :' + paysToUpdate);
               
            if (paysToUpdate.size()> 0) {
               update paysToUpdate;
            }
            
           
            
            
            
            
        } Catch ( Exception e ) {
/*******************************************************************************************************
* EXCEPTION HANDLING  - ANY EXCEPTION WILL BE LOGGED IN ERROR LOG OBJECT    
*******************************************************************************************************/
            List<Id> finAccs = new List<Id>(finAccIdSet);
            
            // UTILITY CLASS TO Publish LOG Event 
            UtilitiyMethods.createErrorlogevt(e.getmessage(), 'INT 6B2', Null,String.join(finAccs, ','),String.join(paysToUpdate, ','));
            
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
        try {
           BatchUpdateNWDParams__c params = BatchUpdateNWDParams__c.getOrgDefaults();
            params.LastNWD__c = LastNWD.AddDays(1);
            params.LastExtDate__c = LastExtDate.AddDays(1);
            params.LastRun__c = DateTime.now();
            try {
                update params;
            }
            catch (System.Exception ex) {
                
                // UTILITY CLASS TO CREATE ERROR LOG OBJECT RECORD 
                UtilitiyMethods.createErrorlogevt(ex.getmessage(), 'INT 6B2 FINISH Method', Null,Null,Null);
                
                
            }
            
            
            // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
            // Query the AsyncApexJob object to retrieve the current job's information.       
            AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id = : BC.getJobId()];
            //Send an email to the Apex job's submitter notifying of job completion.       
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            String emailLabel = Label.Batch_Notification_Emails;
            
            String[] toAddresses = new String[] {
                a.CreatedBy.Email
                    };
                        // Comma seperated values in Label Batch_Notification_Emails
                        // Add each value to the toAddresses 
                        for (String s: emailLabel.split(',')) {
                            toAddresses.add(s);
                        }
            
            // setToAddresses sends email to the email addresses in toAddresses 
            mail.setToAddresses(toAddresses);
            mail.setSubject('ChargentOrders__ChargentOrder__c Updated ' + a.Status);
            mail.setPlainTextBody('The Batch Apex job INT6B2 processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                mail
                    });
             
        } catch (System.Exception ex) {
            
            // UTILITY CLASS TO CREATE Publish Log Event 
            UtilitiyMethods.createErrorlogevt(ex.getmessage(), 'INT 6B2 FINISH Method', Null,Null,Null);
        
            
        }
    }
    
    
    
    
    
    
    
}