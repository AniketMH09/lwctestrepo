public class ErrorLogEmailNotificationctrl {
    public ErrorLogEmailNotificationctrl(){}
    Public static void Emailnotification(List<ErrorLog__c> newErrorloglist){
        List <Notification_Messages__c> lstMessage  = new List <Notification_Messages__c>();
        set<string> errorctrl                       = new set<string>();
        //set<string> Earlyerrorctrl                  = new set<string>();
        boolean crossinThresholdlevel = false;
        for(ErrorLog__c error:newErrorloglist){
            errorctrl.add(error.ClassName__c);
        }
        Map<string,Decimal> errorthresholdlevel = new Map<string,Decimal>();
        Map<string,Decimal> errorEarlyThresholdlevel = new Map<string,Decimal>();
        Daily_Error_Log_Notification__mdt[] errorlognotfy = [SELECT MasterLabel,Hourly_Threshold_Level__c,Threshold_Level__c FROM Daily_Error_Log_Notification__mdt];
        for (Daily_Error_Log_Notification__mdt errorlog : errorlognotfy) {
            errorthresholdlevel.put(errorlog.MasterLabel,errorlog.Threshold_Level__c);
            errorEarlyThresholdlevel.put(errorlog.MasterLabel,errorlog.Hourly_Threshold_Level__c);
        }
        for(AggregateResult aggr:[select count(id)bucketcnt,ClassName__c clss from ErrorLog__c where Createddate = today and ClassName__c IN: errorctrl GROUP BY ClassName__c]){
            if((Decimal)aggr.get('bucketcnt') >= errorthresholdlevel.get((string)aggr.get('clss'))){
                Notification_Messages__c  message = new Notification_Messages__c();
                message.Notification_Template_Name__c = 'Notify Error Log';
                message.Error_log_Control__c  = (string)aggr.get('clss');
                message.Error_log_Count__c  = (Integer)aggr.get('bucketcnt') ;
               // crossinThresholdlevel = true;
               // Earlyerrorctrl.add((string)aggr.get('clss'));
                lstMessage.add(message);
            }
        }
        //if(crossinThresholdlevel){
        //    datetime earlyHour = system.now()- (1/24.0);
           for(AggregateResult aggr:[select count(id)bucketcnt,ClassName__c clss from ErrorLog__c where Createddate <=: system.now() and Createddate >=:(system.now()- (1/24.0)) GROUP BY ClassName__c]){
                if((Decimal)aggr.get('bucketcnt') >= errorEarlyThresholdlevel.get((string)aggr.get('clss'))){
                    system.debug('---earlynotification--->>');
                    Notification_Messages__c  message = new Notification_Messages__c();
                    message.Notification_Template_Name__c = 'Notify Error Log-Hourly Threshold';
                    message.Error_log_Control__c  = (string)aggr.get('clss');
                    message.Error_log_Count__c  = (Integer)aggr.get('bucketcnt') ;
                    lstMessage.add(message);
                }
           }  
        //}
        try{
            if(lstMessage.size() > 0)
                Insert lstMessage;
        }catch(exception e){
            system.debug('e---->>>'+e);
        }
        
    }
}