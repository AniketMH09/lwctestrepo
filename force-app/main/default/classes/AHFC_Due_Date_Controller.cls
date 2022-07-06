/*=====================================================================
* (c) 2017 Appirio - A Wipro Company, Inc
* Name: AHFC_Due_Date_Controller.apex
* Description: Apex class for DatePickerUI component to get data from server
* Created Date: 
* Created By: Vivek Makkar (Appirio - A Wipro Company)
*  ===================================================================== */

public class AHFC_Due_Date_Controller {

    @AuraEnabled
    public static wrapDateClass getDDC(){
        wrapDateClass wrapC = new wrapDateClass();
        String daysNumber = '';
        List<daysUnderDDC__c> daysList = [SELECT id, Days__c FROM daysUnderDDC__c limit 1];
        if(!daysList.isEmpty()){
            wrapC.ddcDays = daysList[0].Days__c;
        }
        
        List<Finance_Account__c> financeList =   [SELECT id,First_Due_Date__c,Next_Due_Date__c FROM Finance_Account__c where OwnerId =:UserInfo.getUserId() ORDER BY CreatedDate];
        if(!financeList.isEmpty()){
           wrapC.nextDueDate = financeList[0].Next_Due_Date__c; 
           wrapC.firstDueDate = financeList[0].First_Due_Date__c; 
        }
        return wrapC;
    }
    
    // Creating an Wrapper to wrap data and return to component in single server call. @VM 10/22
    public class wrapDateClass {
        @AuraEnabled
        public Date firstDueDate{get;set;}
        @AuraEnabled
        public Date nextDueDate{get;set;}
        @AuraEnabled
        public String ddcDays{get;set;}
    }    
    
    
}