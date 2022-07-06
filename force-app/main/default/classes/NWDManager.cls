/*
    File Name       :   NWDManager
    Author          :   iConnect DEV Team
    Datetime        :   12th NOV 2016
    Description     :   The NWDManager is a helper class that holds the business rules to calculate next withdrawal date for easypay when created, reinstated and deferred
    */
public class NWDManager {
    
    /*
    Method Name     :   calculateNWD
    Param           :   easypay < ChargentOrders__ChargentOrder__c > - The chargent order for which next withdrawal date is to be calculated
    Param           :   newStartDate < Date > - the start date to be used for next withdrawal date calculation
    Param           :   skipFirstMonth < Boolean > - is TRUE when agent selects to skip the first next withdrawal date month
    Return          :   Date < nextWithdrawal date > - calculated next withdrawal date
    Description     :   afterInsertRules method applies all the business rules as part of After Insert context. E.g - syncing the payment amount on Finance Account 
    */
    public static Date calculateNWD(ChargentOrders__ChargentOrder__c easypay, Date newStartDate, Boolean skipFirstMonth) {
        
        Honda_Finance__c hfc = Honda_Finance__c.getOrgDefaults();
        
        // Date placeholder to store the calculated next withdrawal date (NWD)
        Date newNWD;
        
        // withdrawOnDay is the payment draft day of every month that Customer has selected
        Integer withdrawOnDay = Integer.valueOf(easypay.ChargentOrders__Charge_Date__c); 
        
        // Attempt to calculate a valid NWD from current month
        /* NWD will be calculated using last day of the current month if withdrawOnDay is not available in the current month
         * Else, the NWD will be calculated using the withdrawOnDay of the current month. E.g. if WoD = 31, NWD in Feb will 2/28 or NWD in Mar will be 3/31
         */
        if (withdrawOnDay > Date.daysInMonth(newStartDate.year(), newStartDate.month())) {
            newNWD = Date.newInstance(newStartDate.year(), newStartDate.month(), Date.daysInMonth(newStartDate.year(), newStartDate.month()));
        }
        else {
            newNWD = Date.newInstance(newStartDate.year(), newStartDate.month(), withdrawOnDay);
        }
        
        // Check if calculated NWD is in future of the processing Date. If not, the NWD should be calculated for next month
        
       // Defect 114480 fixes by AMS team:  prevents NWD from assigning a date in the past
        if (newNWD < newStartDate || newNWD <  Date.TODAY() || (newNWD == System.today() && System.now().time() > hfc.CutOff_Time__c.time())) {
            system.debug('defer 8 - newNWD is ' + newNWD + ' and newStartDate is ' + newStartDate);
            // Check if withdrawOnDay is available in the next month, otherwise use the last day of next month to calculated NWD
            if (withdrawOnDay > Date.daysInMonth(newStartDate.year(), newStartDate.addmonths(1).month()) ) {
                newNWD = Date.newInstance(newStartDate.year(), newStartDate.month()+1, Date.daysInMonth(newStartDate.year(), newStartDate.addmonths(1).month()));
            }
            else {
                newNWD = Date.newInstance(newStartDate.year(), newStartDate.month()+1, withdrawOnDay);
            }       
        }
        
        // Check if user has requested for first NWD to be skipped. If skipped, then calculate NWD for the next month
        if (skipFirstMonth) {
            if (withdrawOnDay > Date.daysInMonth(newNWD.year(), newNWD.addmonths(1).month()) ) {
                newNWD = Date.newInstance(newNWD.year(), newNWD.month()+1, Date.daysInMonth(newNWD.year(), newNWD.addmonths(1).month()));
            }
            else {
                newNWD = Date.newInstance(newNWD.year(), newNWD.month()+1, withdrawOnDay);
            }
        }
        
        System.debug('Calculated Next Withdrawal Date ' + newNWD);
           
        // Now that NWD is calculated, check if the calculated NWD is not crossing the Payment End Date        
        if (newNWD != null && easypay.ChargentOrders__Payment_Stop__c == 'Date' && newNWD > easypay.ChargentOrders__Payment_End_Date__c) {
            newNWD = easypay.Next_Withdrawal_Date__c;
            
        }
        else if (newNWD != null && easypay.ChargentOrders__Payment_Stop__c == 'Count' && easypay.Extracted_Payment_Count__c >= easypay.ChargentOrders__Payment_Count__c) {
            newNWD = easypay.Next_Withdrawal_Date__c;
            
        }
        return newNWD;
    }

}