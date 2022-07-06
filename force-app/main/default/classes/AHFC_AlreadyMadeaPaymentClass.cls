public without sharing class AHFC_AlreadyMadeaPaymentClass {
    
    @AuraEnabled
    public static Finance_Account__c getFinanceAccountDetails(string selectedFinAcc){
        system.debug('<<<>>>>'+selectedFinAcc);
        String strServAccQuery = 'SELECT Name, Finance_Account_Number__c, Fl_Payoff_Payment_Eligible_Web__c, Fl_Payoff_Payment_Eligible_Agent__c, RecordType.Name,'
                +'Fl_OneTime_Payment_Eligible_Web__c,Fl_Recurring_Payment_Eligible_Agent__c,Principal_Balance_Amount__c,AHFC_Number_of_Payments_Remaining__c,createddate,AHFC_Original_Finance_Amount__c,'
                +'Fl_Future_OneTime_Payment_Eligible_Web__c,AHFC_Total_Payments__c,  Fl_Future_OneTime_Payment_Eligible_Agent__c,Fl_OneTime_Payment_Eligible_Agent__c, Current_Amount_Due__c,'
                +'Payment_Due_Date__c, Total_Fees_Due__c, Scheduled_EasyPay_Amount__c, Fl_Refinanced__c,Honda_Brand__c,Maturity_Date__c,'
                +'AHFC_Last_Payment_Date__c, Total_Amount_Due__c, AHFC_Last_Payment_Amount__c, Remaining_Amount_Due__c, Next_Due_Date__c, Fl_Recurring_Payment_Eligible_Web__c,AHFC_Contract_Start_Date__c,'
                +'Regular_Monthly_Payment__c,Payoff_Amount__c,Account_Type__c,FA_Next_Withdrawal_Date__c, AHFC_Product_Nickname__c,Term__c,AHFC_Total_days_past_due__c,'
                +'AHFC_Vehicle_Model__c,Vehicle_Identification_Number__c,AHFC_Vehicle_Year__c,Past_Amount_Due__c '
                +'FROM Finance_Account__c '
                +'WHERE Id =:selectedFinAcc';

                return Database.query(strServAccQuery);
    }
}