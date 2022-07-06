public class ChargentOrderTriggerHandler
{
    public static Map<Id,ChargentOrders__ChargentOrder__c > financeAccountMap = new Map <Id,ChargentOrders__ChargentOrder__c >();
    public static Map<Id,ChargentOrders__ChargentOrder__c > financeAccountMapEP = new Map <Id,ChargentOrders__ChargentOrder__c >();
    Public Static String RecurringRecordTypeId = Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
    
    
    public static void onBeforeInsert(List<ChargentOrders__ChargentOrder__c> orderNewList)
    {
        Set<Id> financeAccountId = new Set<Id>();
        For(ChargentOrders__ChargentOrder__c order : orderNewList)
        {
            if(order.Finance_Account_Number__c != null)
            {
                financeAccountId.add(order.Finance_Account_Number__c);
            }
            
            // Populate Default Gateway Value
            /*
            if ( order.ChargentOrders__Gateway__c == NULL ) {
                order.ChargentOrders__Gateway__c = QueryGateway().Id;
            } */
            
        }
        List<Finance_Account__c> financeAccountList = [SELECT Id, Customer__r.customer_id__c FROM Finance_Account__c where id IN : financeAccountId];
        Map<Id,Id> financeAccCustomerMap = new Map <Id,Id>();
        For(Finance_Account__c finAcc : financeAccountList)
        {
            if(finAcc.Customer__r.customer_id__c != null)
            {
                financeAccCustomerMap.put(finAcc.id,finAcc.Customer__r.customer_id__c);
            }
        }
        For(ChargentOrders__ChargentOrder__c order : orderNewList)
        {
            if(financeAccCustomerMap.containskey(order.Finance_Account_Number__c))
            {
                order.ChargentOrders__Account__c = financeAccCustomerMap.get(order.Finance_Account_Number__c);
            }
            
            if ( Order.RecordTypeId != RecurringRecordTypeId ) {
               // Order.Next_Withdrawal_Date__c  =   ConvertDatetoPST(Order.ChargentOrders__Payment_Start_Date__c) ;  
               // Aravind changed after NWD field type is changed
                Order.Next_Withdrawal_Date__c  =   Order.ChargentOrders__Payment_Start_Date__c;  
            }
                
        }
        
    }
    
    // BEFORE UPDATE 
    
    public static void onBeforeUpdate(List<ChargentOrders__ChargentOrder__c> orderNewList)
    {
        For(ChargentOrders__ChargentOrder__c order : orderNewList)
        {
            
            // Populate Default Gateway Value
            /*
            if ( order.ChargentOrders__Gateway__c == NULL ) {
                order.ChargentOrders__Gateway__c = QueryGateway().Id;
            } */
            
            if ( Order.RecordTypeId != RecurringRecordTypeId ) {
                
              //  Order.Next_Withdrawal_Date__c  =   ConvertDatetoPST(Order.ChargentOrders__Payment_Start_Date__c) ;   
              // Aravind changed after NWD field type is changed
                Order.Next_Withdrawal_Date__c  =   Order.ChargentOrders__Payment_Start_Date__c;   
            }
            
        }
         
        
    }
    
    Public Static Datetime ConvertDatetoPST(Date inpDate){
         datetime tmp1  = datetime.newInstance(inpDate.year(), inpDate.month(), inpDate.day());
         String tmpDatetime = Datetime.valueof(tmp1).format('yyyy-MM-dd HH:mm:ss', 'PST'); 
                      
        
        return Datetime.valueof(tmpDatetime);
    }
    
    public static void onAfterInsert(List<ChargentOrders__ChargentOrder__c> orderNewList)
    {
        Map<String,RecordType>  orderRTMap = RecordTypeUtility.getOrderRecordTypes();
        
        if(orderRTMap.containskey('Recurring_Payment')){
            For(ChargentOrders__ChargentOrder__c order: orderNewList)
            {
                if(order.ChargentOrders__Charge_Amount__c != null && order.recordtypeId == orderRTMap.get('Recurring_Payment').Id && order.Finance_Account_Number__c != null )
                {
                    financeAccountMap.put(order.Finance_Account_Number__c,order);
                }
            }
            scheduleAmountUdateProcess(financeAccountMap);
        }
        
        //system.debug();
        
        
        
        
        
    }
    public static void onAfterUpdate(List<ChargentOrders__ChargentOrder__c> orderNewList,Map<Id, ChargentOrders__ChargentOrder__c> orderOldMap)
    {
        Map<String,RecordType>  orderRTMap = RecordTypeUtility.getOrderRecordTypes();
        
        if(orderRTMap.containskey('Recurring_Payment')){
            For(ChargentOrders__ChargentOrder__c order: orderNewList)
            {
                ChargentOrders__ChargentOrder__c oldOrder = orderOldMap.get(order.id);
                if(order.ChargentOrders__Charge_Amount__c != null && order.recordtypeId == orderRTMap.get('Recurring_Payment').Id && (order.ChargentOrders__Payment_Status__c == 'Recurring' || oldOrder.ChargentOrders__Charge_Amount__c != order.ChargentOrders__Charge_Amount__c) && order.Finance_Account_Number__c != null)
                {
                    financeAccountMap.put(order.Finance_Account_Number__c,order);
                }
                else if(order.recordtypeId == orderRTMap.get('Recurring_Payment').Id && order.ChargentOrders__Payment_Status__c != 'Recurring' && order.Finance_Account_Number__c != null)
                {
                    financeAccountMapEP.put(order.Finance_Account_Number__c,order);
                }
            }
            scheduleAmountUdateProcess(financeAccountMap);
            updateEasyPayAmount(financeAccountMapEP); 
        }
        
        
    }
    public  static void scheduleAmountUdateProcess(Map<Id,ChargentOrders__ChargentOrder__c> financeAccMap)
    {
        List<Finance_Account__c> financeAccountList = new List<Finance_Account__c>();
        System.debug('Finance Account Map'+financeAccMap.keySet());
        
        For(Id financeAccount : financeAccMap.keySet())
        {
            Finance_Account__c financeAccountInstance = new Finance_Account__c();
            financeAccountInstance.id = financeAccount;
            financeAccountInstance.Scheduled_EasyPay_Amount__c = financeAccMap.get(financeAccount).ChargentOrders__Charge_Amount__c ;
            financeAccountList.add(financeAccountInstance);
        }
        if(financeAccountList.size() > 0)
        {
            try
            {
                Database.update(financeAccountList,false);
            }
            Catch(DMLException e){errorLogMethod(e);}
        }
        
    }
    
    // Update EasyPay amount to 0 when status updated to Stopped,Error,Complete
    
    public  static void updateEasyPayAmount(Map<Id,ChargentOrders__ChargentOrder__c> financeAccMapEP)
    {
        List<Finance_Account__c> financeAccountListEP = new List<Finance_Account__c>();
        System.debug('Finance Account Map'+financeAccMapEP.keySet());
        
        For(Id financeAccount : financeAccMapEP.keySet())
        {
            Finance_Account__c fin = new Finance_Account__c();
            fin.id = financeAccount;
            fin.Scheduled_EasyPay_Amount__c = 0;
            financeAccountListEP.add(fin);
        }
        if(financeAccountListEP.size() > 0)
        {
            try
            {
                Database.update(financeAccountListEP,false);
            }
            Catch(DMLException e){errorLogMethod(e);}
        }
        
    }
    
    Public Static ChargentBase__Gateway__c QueryGateway() {
        
        ChargentBase__Gateway__c[] gateway = [SELECT Id, Name
                                                FROM ChargentBase__Gateway__c
                                                WHERE Name = 'Cybersource' LIMIT 1];
        
        if ( !gateway.isEmpty() ) {
            return gateway[0];
        } 
        
        return null;    
    }
    
    public static void errorLogMethod(Exception e){
            try {    
                String Stacktrace  = e.getStackTraceString();
                String ClassName = Stacktrace.SubstringBetween('Class.','.');
                String Method = Stacktrace.SubstringAfterLast('.');
                Integer Linenumber  = e.getLineNumber();
                ErrorLog__c eLog = new ErrorLog__c();
                eLog.ClassName__c = ClassName + ':' + Method  + ':' + Linenumber ;
                eLog.ExceptionMsg__c = e.getMessage();
                insert eLog;
            }
            catch(DMLException eMsg) {
                
            }     
   
   }
    
     
}