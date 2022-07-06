/*=====================================================================
* (c) 2017 Appirio - A Wipro Company, Inc
* Name: AHFC_DatePickerUIController.apex
* Description: Apex class for AHFC_Due_Date_Screen component to get data from server
* Created Date: 17th Oct 2018
* Created By: Vivek Makkar (Appirio - A Wipro Company)
*  ===================================================================== */

public class AHFC_DatePickerUIController {
     //T-749443 
    @AuraEnabled
    public static String getDDC(){
        String daysNumber = '';
        List<daysUnderDDC__c> daysList = [SELECT id, Days__c FROM daysUnderDDC__c limit 1];
        if(!daysList.isEmpty()){
            daysNumber = daysList[0].Days__c;
        }
        return daysNumber;
    }
    
    @AuraEnabled
    public static wrapDateClass getNext25Days(String financeAccNumber){
        wrapDateClass wrapObj = new wrapDateClass();
        List<Finance_Account__c> daysList = [SELECT id, Next_Due_Date__c,First_Due_Date__c,Paid_to_Date__c FROM Finance_Account__c WHERE Finance_Account_Number__c =:financeAccNumber];
        if(!daysList.isEmpty()){
         wrapObj.grtOfnextDuePaidToDate = ( daysList.get(0).Paid_to_Date__c == null ||daysList.get(0).Next_Due_Date__c >= daysList.get(0).Paid_to_Date__c)? daysList.get(0).Next_Due_Date__c:daysList.get(0).Paid_to_Date__c;
         wrapObj.eligibleDay = wrapObj.grtOfnextDuePaidToDate.addDays(25).day();
         return wrapObj;
        }
        return null;
    }
    // Creating an Wrapper to wrap data and return to component in single server call. @VM 10/22
    public class wrapDateClass {
        @AuraEnabled
        public Date grtOfnextDuePaidToDate{get;set;}
        @AuraEnabled
        public Integer eligibleDay{get;set;}
    }    
}