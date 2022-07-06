/*
File Name       :   ManagePaymentService
Author          :   iConnect DEV Team
Datetime        :   28th SEP 2016
Last Modified   :   17 Dec 2019 
LastModified by :   Gufran Usmani, LTI
Description     :   The ManagePaymentService is a helper class that holds all the business rules to be executed part of Trigger execution on Chargent Order object.  
update history  :  1. RSS :- 46048 - The customer opts to extend the lease or balloon type of accounts, A new EasyPay record has to be created systematically 
                         when the Finance Account is processed for extension in CASS. when the NWD date cross the Final Payment Date, the EZPay status changed to Complete. 
                         If the customer decides to extend the lease, the EZPay needs to be manually reinstaiated. In order to automate the process, need to move the status to 'Stopped', 
                         so that 6B integraion existing code will move the status to EZPay recurring when EOT Extension is processed.

                   2.RSS :- 41446 - when a One Time Payment  is scheduled on an account with a Recurring Payment in "Stopped" status its Change the Status To Cancelled.
                                   update the logic so that OTPs do not cancel Recurring Payments that are in a "Stopped" state. 
*/
public class ManagePaymentService {
        
    private static Map <String,RecordType>  orderRTMap = RecordTypeUtility.getOrderRecordTypes(); // map holding all the record types of Chargent Order
    
    private static Map <Id, ChargentOrders__ChargentOrder__c> ordersToUpdate = new Map <Id, ChargentOrders__ChargentOrder__c> (); // list of orders that are updated through the triggers
    
    private static Map <id, Finance_Account__c> mapaccsToUpdate = new Map <id, Finance_Account__c> ();
    
    private static Set <String> bypassFinIdForDeferral = new Set <String>();
    
    @testvisible
    private static Date processingDate;
    
    /*
    Method Name     :   afterInsertRules
    Param           :   orders - list of payments from Trigger.new context
    Return          :   void
    Description     :   afterInsertRules method applies all the business rules as part of After Insert context. E.g - syncing the payment amount on Finance Account 
    */
    public static void afterInsertRules (List <SObject> orders) {
        
        for (SObject item: orders) {            
            ChargentOrders__ChargentOrder__c order = (ChargentOrders__ChargentOrder__c)item;
            if(order.RecordTypeId == orderRTMap.get('Recurring_Payment').Id) {
                // After creating new easypay, must update the FA_Next_Withdrawal_Date__c and Scheduled_Easypay_Amount__c on finance account
                updateFinanceAccounts(order.Finance_Account_Number__c, order.Next_Withdrawal_Date__c, order.ChargentOrders__Charge_Amount__c, false);
            }
        }
        
        // Commit all updates made to Orders
        if(!ordersToUpdate.isEmpty()) {
            Database.update(ordersToUpdate.values(), false);
        }
      
        if(mapaccsToUpdate.size() > 0) {
            update mapaccsToUpdate.values();
        }        
    }
    
    /* 
    Method Name     :   beforeInsertRules
    Param           :   orders - list of payments from Trigger.new context
    Return          :   void
    Description     :   beforeInsertRules method applies all the business rules as part of before Insert context.
    */
 
    public static void beforeInsertRules (List <ChargentOrders__ChargentOrder__c> orders) {
        set<id> financeid = new set<id>(); 
	/*RSS 41446 start*/
        /*Create New Map variable to store the Recurring Payment record types */
        Map <Id, ChargentOrders__ChargentOrder__c> newEZPRecordMap = new Map <Id,ChargentOrders__ChargentOrder__c>();
    /*RSS 41446 end*/
        list<ChargentOrders__ChargentOrder__c> OrderToUpdate = new list<ChargentOrders__ChargentOrder__c>();
        String RecurringRecordTypeId = Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
    /*--RSS 41446 Starts--*/
                //Check if record Tyepe is Recurring Payment then Store the value in newEZPRecordMap map
        for(ChargentOrders__ChargentOrder__c chargentOrderRecord :orders)
            {       
                financeid.add(chargentOrderRecord.Finance_Account_Number__c);
                if (chargentOrderRecord.RecordTypeId != RecurringRecordTypeId ) {                   
                    chargentOrderRecord.Next_Withdrawal_Date__c = chargentOrderRecord.ChargentOrders__Payment_Start_Date__c;  
                }
                  if (chargentOrderRecord.RecordTypeId == RecurringRecordTypeId )
                     newEZPRecordMap.put(chargentOrderRecord.Finance_Account_Number__c,chargentOrderRecord); 
               /*--RSS 41446 Ends--*/                               
            }
      /*--RSS 41446 Ends--*/                               
         
        for(ChargentOrders__ChargentOrder__c  pso :[select id,Payment_Display_Status__c,ChargentOrders__Payment_Status__c,Duplicate_Key_Tracker__c,Finance_Account_Number__r.Finance_Account_Number__c from ChargentOrders__ChargentOrder__c where Payment_Display_Status__c = 'Stopped' and Finance_Account_Number__c in:financeid and recordtype.developername = 'Recurring_Payment']){
                // Added by Mariappan for defect 112904 , above chargent status and our local status should be updated as per the latest PCD
                /*--RSS 41446 Starts--*/
               //Check if the Map Contains Key Related to Recurring_Payment then Change the Status
               
               System.debug('I am in 93'+newEZPRecordMap);
               System.debug('pso.Finance_Account_Number__c---->>>'+pso.Finance_Account_Number__c);                                        
               if(newEZPRecordMap.containsKey(pso.Finance_Account_Number__c)){                    
                pso.ChargentOrders__Payment_Status__c = 'Complete';
                pso.Payment_Display_Status__c = 'Cancelled';
                pso.Duplicate_Key_Tracker__c = pso.Finance_Account_Number__r.Finance_Account_Number__c + 'Recurring_Payment' + 'INACTIVE' + Datetime.now();
                OrderToUpdate.add(pso);
                bypassFinIdForDeferral.add(pso.Finance_Account_Number__c);
        }
               /*--RSS 41446 Ends--*/
        
             }             
       System.debug('OrderToUpdate--size-->>>'+OrderToUpdate.size());
        if(OrderToUpdate.size()>0){
            try{
               update OrderToUpdate;
            }
            catch(Exception ex){
                system.debug(ex.getMessage());
            }
        } 
    }
    
    /*
    Method Name     :   beforeUpdateRules
    Param           :   newOrderMap - list of payments from Trigger.newMap context, oldOrderMap - list of old version of the payments from the Trigger.oldMap context
    Return          :   void
    Description     :   beforeUpdateRules method holds all the business rules to be executed as part of Before Update process 
    */
    public static void beforeUpdateRules (Map <Id, SObject> newOrderMap, Map <Id, SObject> oldOrderMap) {
        
        for (Id orderId: newOrderMap.keySet()) {
            ChargentOrders__ChargentOrder__c order = (ChargentOrders__ChargentOrder__c)newOrderMap.get(orderId);
            ChargentOrders__ChargentOrder__c oldOrder = (ChargentOrders__ChargentOrder__c)oldOrderMap.get(order.Id);
            String RecurringRecordTypeId = Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            
            if (order.RecordTypeId != RecurringRecordTypeId ) {
                    order.Next_Withdrawal_Date__c  =   order.ChargentOrders__Payment_Start_Date__c;
                }
                
            if (order.RecordTypeId == orderRTMap.get('Recurring_Payment').Id && order.Last_Extraction_Date__c != oldOrder.Last_Extraction_Date__c) {
                
                if(order.ChargentOrders__Payment_Stop__c == 'Count') {
                    incrementPymtCount(order); // increment extracted payment count for Count based easypay post payment extraction
                }
                
                updateNextWithdrawalDate(order); // to update NWD and display status to Complete if required
                
                
            }
            
            else if (order.RecordTypeId == orderRTMap.get('Recurring_Payment').Id && order.ChargentOrders__Charge_Amount__c != oldOrder.ChargentOrders__Charge_Amount__c) {
                // Any amount change in the Active easypay must reflect the updated amount on the Scheduled_Easypay_Amount__c
                updateFinanceAccounts(order.Finance_Account_Number__c, null, order.ChargentOrders__Charge_Amount__c, false);
            }
            
            else if ((order.RecordTypeId == orderRTMap.get('Recurring_Payment').Id) && ((order.Next_Withdrawal_Date__c != oldOrder.Next_Withdrawal_Date__c) || (oldOrder.Payment_Display_Status__c == status.Stopped.name() && Order.Payment_Display_Status__c == Status.Pending.name()))) {
                // When easypay is stopped, FA_Next_Withdrawal_Date__c and Scheduled_Easypay_Amount__c on finance account must be updated to NULL and 0.0 resp.
                updateFinanceAccounts(order.Finance_Account_Number__c, order.Next_Withdrawal_Date__c, order.ChargentOrders__Charge_Amount__c, false);
            }
 
            else if (order.RecordTypeId == orderRTMap.get('Recurring_Payment').Id && order.Payment_Display_Status__c != Status.Pending.name() && oldOrder.Payment_Display_Status__c == Status.Pending.name()) {
                // When easypay is cancelled, FA_Next_Withdrawal_Date__c and Scheduled_Easypay_Amount__c on finance account must be updated to NULL and 0.0 resp.
                updateFinanceAccounts(order.Finance_Account_Number__c, null, 0.0, true);
            }
 
            /* Move the previous display status to Last Payment Display Status field when display status has changed. 
             * Last_Payment_Display_Status__c will be used in the daily payment extract criteria to select same day easypays that has been updated after cutoff.
             */
            if (order.Payment_Display_Status__c != oldOrder.Payment_Display_Status__c) {
                order.Last_Payment_Display_Status__c = oldOrder.Payment_Display_Status__c;
            }            
        }
        
        
        if(mapaccsToUpdate.size() > 0) {
            update mapaccsToUpdate.values();
        } 
    }
    
     /*
    Method Name     :   beforeUpdateRulesForUsers
    Param           :   newOrderMap - list of payments from Trigger.newMap context, oldOrderMap - list of old version of the payments from the Trigger.oldMap context
    Return          :   void
    Description     :   beforeUpdateRulesForUsers method holds the business rules to be executed as part of Before Update process in UserSession.
    */
    public static void beforeUpdateRulesForUsers (Map <Id, SObject> newOrderMap, Map <Id, SObject> oldOrderMap) {
        
        for (Id orderId: newOrderMap.keySet()) {
            ChargentOrders__ChargentOrder__c order = (ChargentOrders__ChargentOrder__c)newOrderMap.get(orderId);
            ChargentOrders__ChargentOrder__c oldOrder = (ChargentOrders__ChargentOrder__c)oldOrderMap.get(order.Id);
            String RecurringRecordTypeId = Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
            
            if (order.RecordTypeId != RecurringRecordTypeId ) {
                    order.Next_Withdrawal_Date__c  =   order.ChargentOrders__Payment_Start_Date__c;
            }
                
            if (order.RecordTypeId == orderRTMap.get('Recurring_Payment').Id && order.ChargentOrders__Charge_Amount__c != oldOrder.ChargentOrders__Charge_Amount__c) {
                // Any amount change in the Active easypay must reflect the updated amount on the Scheduled_Easypay_Amount__c
                updateFinanceAccounts(order.Finance_Account_Number__c, null, order.ChargentOrders__Charge_Amount__c, false);
            }
            
            else if ((order.RecordTypeId == orderRTMap.get('Recurring_Payment').Id) && ((order.Next_Withdrawal_Date__c != oldOrder.Next_Withdrawal_Date__c) || (oldOrder.Payment_Display_Status__c == status.Suspended.name() && Order.Payment_Display_Status__c == Status.Pending.name()))) {
                // When easypay is stopped, FA_Next_Withdrawal_Date__c and Scheduled_Easypay_Amount__c on finance account must be updated to NULL and 0.0 resp.
                updateFinanceAccounts(order.Finance_Account_Number__c, order.Next_Withdrawal_Date__c, order.ChargentOrders__Charge_Amount__c, false);
            }
            
            else if (order.RecordTypeId == orderRTMap.get('Recurring_Payment').Id && order.Payment_Display_Status__c != Status.Pending.name() && oldOrder.Payment_Display_Status__c == Status.Pending.name()) {
                // When easypay is cancelled, FA_Next_Withdrawal_Date__c and Scheduled_Easypay_Amount__c on finance account must be updated to NULL and 0.0 resp.
                updateFinanceAccounts(order.Finance_Account_Number__c, null, 0.0, true);
            } 
            
            /* Move the previous display status to Last Payment Display Status field when display status has changed. 
             * Last_Payment_Display_Status__c will be used in the daily payment extract criteria to select same day easypays that has been updated after cutoff.
             */
            if (order.Payment_Display_Status__c != oldOrder.Payment_Display_Status__c) {
                order.Last_Payment_Display_Status__c = oldOrder.Payment_Display_Status__c;
            }
        }
        
       if(mapaccsToUpdate.size() > 0) {
            update mapaccsToUpdate.values();
        }
    }
    
    /*
    Method Name     :   afterUpdateRules
    Param           :   newOrderMap - list of payments from Trigger.newMap context, oldOrderMap - list of old version of the payments from the Trigger.oldMap context
    Return          :   void
    Description     :   afterUpdateRules method holds all the business rules to be executed as part of After Update process
    */
    public static void afterUpdateRules (Map <Id, SObject> newOrderMap, Map <Id, SObject> oldOrderMap) {
        
    }
    
    /*
    Method Name     :   updateNextWithdrawalDate
    Param           :   easypay - recurring order record for which the NWD to be updated based on the update on Last_Extraction_Date__c
    Return          :   void
    Description     :   updateNextWithdrawalDate method is responsible to calculate the next available next withdrawal date based on the easy pay setup data on the order record
    */
    public static void updateNextWithdrawalDate(ChargentOrders__ChargentOrder__c easypay) {
        
        // Date placeholder to store the calculated next withdrawal date (NWD)
        Date newNWD;
        
        /* Storing the TODAY in a variable so that the processingDate variable can be initialized to any day in past or future through test methods. 
         * In runtime, processingDate will always be initialized with TODAY */
        if (processingDate == null) {
            processingDate = Date.today();
        }
        
        Integer withdrawOnDay = Integer.valueOf(easypay.ChargentOrders__Charge_Date__c); 
        
        // Attempt to calculate a valid NWD from current month
        /* NWD will be calculated using last day of the current month if withdrawOnDay is not available in the current month
         * Else, the NWD will be calculated using the withdrawOnDay of the current month. E.g. if WoD = 31, NWD in Feb will 2/28 or NWD in Mar will be 3/31
         */
        if (withdrawOnDay > Date.daysInMonth(processingDate.year(), processingDate.month())) {
            newNWD = Date.newInstance(processingDate.year(), processingDate.month(), Date.daysInMonth(processingDate.year(), processingDate.month()));
        }
        else {
            newNWD = Date.newInstance(processingDate.year(), processingDate.month(), withdrawOnDay);
        }
        
        // Check if calculated NWD is in future of the processing Date. If not, the NWD should be calculated for next month
        if (newNWD <= processingDate) {
            // Check if withdrawOnDay is available in the next month, otherwise use the last day of next month to calculated NWD
            if (withdrawOnDay > Date.daysInMonth(processingDate.year(), processingDate.addmonths(1).month()) ) {
                newNWD = Date.newInstance(processingDate.year(), processingDate.month()+1, Date.daysInMonth(processingDate.year(), processingDate.addmonths(1).month()));
            }
            else {
                newNWD = Date.newInstance(processingDate.year(), processingDate.month()+1, withdrawOnDay);
            }       
        }
        System.debug(' RSS 46048 - Easy Pay Account Number --> '+easypay.Finance_Account_Number__c);
        System.debug('RSS 46048 - Current Withdrawal Date ' + easypay.Next_Withdrawal_Date__c);
        System.debug('Calculated Next Withdrawal Date ' + newNWD);
                   
        // Now that NWD is calculated, check if the calculated NWD is not crossing the Payment End Date        
        if (newNWD != null && easypay.ChargentOrders__Payment_Stop__c == 'Date') {
            
            // the NWD will keep on advancing as long as the NWD is not past Payment End Date
            if (newNWD <= easypay.ChargentOrders__Payment_End_Date__c) {
                easypay.Next_Withdrawal_Date__c = newNWD;
                
                // Only update the FA_Next_Withdrawal_Date__c on the finance account
                updateFinanceAccounts(easypay.Finance_Account_Number__c, easypay.Next_Withdrawal_Date__c, null, false);
                
            }
            // the easypay status is marked as Complete when NWD has reached the final payment date and cannot avance more than Payment End Date
            else
            {            				
				System.debug('RSS 46048 - Easy Pay Account Type --> '+easypay.Account_Type__c);
				System.debug('RSS 46048 - Easy Pay Account Refinanced? --> '+easypay.Fl_Refinanced__c);
				System.debug('RSS 46048 - Easy Pay Account Display Status --> '+easypay.Payment_Display_Status__c);				
                
                // RSS 46048 Change Starts 
                //  NWD has reached or crossed the Final payment date, change the status to Stopped for the below condition               
                if((easypay.Account_Type__c=='Balloon'&& easypay.Fl_Refinanced__c==false)
                   || easypay.Account_Type__c=='Lease')
                {
                    easypay.Payment_Display_Status__c = Status.Stopped.name();                    
                    easypay.ChargentOrders__Payment_Status__c = Status.Stopped.name();
                    System.debug('Easy Pay Account Status - Stopped by RSS 46048'); 
                }           
                else // Keep the original code to set the status to Complete if none of the condition matches
                {   
                     easypay.Payment_Display_Status__c = Status.Complete.name();
                     easypay.ChargentOrders__Payment_Status__c = Status.Complete.name();
                     easypay.Duplicate_Key_Tracker__c = easypay.Finance_Account_Number__c + 'Recurring_Payment' + 'INACTIVE' + Datetime.now();
                     System.debug('Easy Pay Account Status - Complete'); 
                }   
                // RSS 46048 Change Ends                
            }
        }
        else if (newNWD != null && easypay.ChargentOrders__Payment_Stop__c == 'Count') {
            
            // the NWD will keep on advancing as long as the extracted payment count has not reached the total payment count
            if (easypay.Extracted_Payment_Count__c < easypay.ChargentOrders__Payment_Count__c) {
                easypay.Next_Withdrawal_Date__c = newNWD;
                
                // Only update the FA_Next_Withdrawal_Date__c on the finance account
                updateFinanceAccounts(easypay.Finance_Account_Number__c, easypay.Next_Withdrawal_Date__c, null, false);
              
            }
            // the easypay status is marked as Complete when the extracted payment count reaches the total payment count
            else
            {
              easypay.Payment_Display_Status__c = Status.Complete.name();
              easypay.ChargentOrders__Payment_Status__c = Status.Complete.name();
              easypay.Duplicate_Key_Tracker__c = easypay.Finance_Account_Number__c + 'Recurring_Payment' + 'INACTIVE' + Datetime.now();
            }            
        }
    }
    
/*
    public static void updateFinanceAccEPAmount(ChargentOrders__ChargentOrder__c easypay) {
       /* Finance_Account__c finAcc = new Finance_Account__c();
        finAcc.Id = easypay.Finance_Account_Number__c;
        finAcc.Scheduled_EasyPay_Amount__c = easypay.ChargentOrders__Charge_Amount__c;
        accsToUpdate.add(finAcc);
        updateFinanceAccounts(easypay.Finance_Account_Number__c,null,easypay.ChargentOrders__Charge_Amount__c);
    }
    
    public static void updateFinanceAccEPAmountAndNWD(ChargentOrders__ChargentOrder__c easypay) {
       /* Finance_Account__c finAcc = new Finance_Account__c();
        finAcc.Id = easypay.Finance_Account_Number__c;
        finAcc.Scheduled_EasyPay_Amount__c = easypay.ChargentOrders__Charge_Amount__c;
        finAcc.FA_Next_Withdrawal_Date__c = easypay.Next_Withdrawal_Date__c;
        accsToUpdate.add(finAcc);
        system.debug('FA Id :'+easypay.Finance_Account_Number__c+'NWD :'+easypay.Next_Withdrawal_Date__c);
        updateFinanceAccounts(easypay.Finance_Account_Number__c,easypay.Next_Withdrawal_Date__c,easypay.ChargentOrders__Charge_Amount__c);
    
    } */
    
    public static void updateFinanceAccounts(id finnumber,date NWDdate, decimal ChargeAmount, boolean isCancelled){
        //Finance account object exists in the Map
        Finance_Account__c finAcc;  
        if(mapaccsToUpdate.containsKey(finnumber)){
            finAcc = mapaccsToUpdate.get(finnumber);
        }
        //Finance account object doesn't exist in the Map, create New
        else {
            finAcc = new Finance_Account__c();
            finAcc.Id = finnumber;
        }
        
        // Set the values
        if(ChargeAmount != null && !isCancelled)
                finAcc.Scheduled_EasyPay_Amount__c = ChargeAmount;
        if(NWDdate != null && !isCancelled)
                finAcc.FA_Next_Withdrawal_Date__c = NWDdate;
        
        if(isCancelled && !bypassFinIdForDeferral.contains(finAcc.Id)) {
            finAcc.Scheduled_EasyPay_Amount__c = 0.0;
            finAcc.FA_Next_Withdrawal_Date__c = null;
        }
            system.debug('ManagePaymentService | updateFinanceAccounts | finId - ' + finAcc.Id + ' | NWD - ' + finAcc.FA_Next_Withdrawal_Date__c + ' | Amt - ' + finAcc.Scheduled_EasyPay_Amount__c + ' | isCancelled - ' + isCancelled);
            mapaccsToUpdate.put(finAcc.Id,finAcc);
    
    }
 
    public static void incrementPymtCount(ChargentOrders__ChargentOrder__c easypay) {
        if (easypay.Extracted_Payment_Count__c != null) {
            easypay.Extracted_Payment_Count__c = easypay.Extracted_Payment_Count__c + 1;
        }
        else
        {
            easypay.Extracted_Payment_Count__c = 1;
        }
        
    }
    /*
    public static void cancelFinanceAccEPAmount(ChargentOrders__ChargentOrder__c easypay) {
       /* Finance_Account__c finAcc = new Finance_Account__c();
        finAcc.Id = easypay.Finance_Account_Number__c;
        finAcc.Scheduled_EasyPay_Amount__c = 0;
        finAcc.FA_Next_Withdrawal_Date__c = null;
        accsToUpdate.add(finAcc);
        system.debug('Cancel Easy Pay :'+ easypay);
        updateFinanceAccounts(easypay.Finance_Account_Number__c,null,0);
    }    */
    
    public enum Status { Pending, Processing, Complete, Suspended, Stopped }
}