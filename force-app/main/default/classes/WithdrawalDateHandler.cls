public class WithdrawalDateHandler
{
 public static Map<Id,ChargentOrders__ChargentOrder__c > financeAccMap = new Map <Id,ChargentOrders__ChargentOrder__c >();  
 
 // After Insert 
   
    public static void onAfterInsert(List<ChargentOrders__ChargentOrder__c> orderNewList)
    {
        Map<String,RecordType>  orderRTMap = RecordTypeUtility.getOrderRecordTypes();
        
        if(orderRTMap.containskey('Recurring_Payment')){
            For(ChargentOrders__ChargentOrder__c neworder: orderNewList)
            {
                if(neworder.Next_Withdrawal_Date__c != null && neworder.recordtypeId == orderRTMap.get('Recurring_Payment').Id && neworder.Finance_Account_Number__c != null )
                {
                    financeAccMap.put(neworder.Finance_Account_Number__c,neworder);
                }
            }
            UpdateWithdrawalDate(financeAccMap);
        }
        
        
    }
 
 //After Update
 
    public static void onAfterUpdate(List<ChargentOrders__ChargentOrder__c> orderNewList,Map<Id, ChargentOrders__ChargentOrder__c> orderOldMap)
    {
        Map<String,RecordType>  orderRTMap = RecordTypeUtility.getOrderRecordTypes();
        
        if(orderRTMap.containskey('Recurring_Payment')){
            For(ChargentOrders__ChargentOrder__c neworder: orderNewList)
            {
                ChargentOrders__ChargentOrder__c oldOrder = orderOldMap.get(neworder.id);
                if(neworder.Next_Withdrawal_Date__c != null && neworder.recordtypeId == orderRTMap.get('Recurring_Payment').Id && oldOrder.Next_Withdrawal_Date__c != neworder.Next_Withdrawal_Date__c && neworder.Finance_Account_Number__c != null)
                {
                    financeAccMap.put(neworder.Finance_Account_Number__c,neworder);
                }
            }
            UpdateWithdrawalDate(financeAccMap);
        }
    }
    public  static void UpdateWithdrawalDate(Map<Id,ChargentOrders__ChargentOrder__c> finAccMap)
    {
        List<Finance_Account__c> financeAccountList = new List<Finance_Account__c>();
        
        
        For(Id financeAccount : finAccMap.keySet())
        {
            Finance_Account__c financeAccountInstance = new Finance_Account__c();
            financeAccountInstance.id = financeAccount;
            financeAccountInstance.FA_Next_Withdrawal_Date__c = finAccMap.get(financeAccount).Next_Withdrawal_Date__c;
            financeAccountList.add(financeAccountInstance);
        }
        if(financeAccountList.size() > 0)
        {
            try
            {
                Database.update(financeAccountList,false);
            }
            Catch(DMLException e){
                
                errorLogMethod(e);
                
            }
        }
        
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