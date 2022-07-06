/*******************************************************************************************************
    * @author  : Accenture
    * @date    :  
    * @modified : 09 MAR 2016 
    * @group    :  
    * @group-content : 
    * @description : HELPER CLASS FOR COMMUNICATION PREFERENCE TRIGGERS, PURPOSE : UPDATE MAIL IDS OF CUSTOMERS.
    * @update history : Defect # 113976 UPDATE ONLY EMAIL IF LAST 12 DIGIT OF CUSTOMER ID MATCHES THE FINANCE ACCOUNT NUMBER
    *                   Defect # 114093 - Email notifications being sent to wrong email address.    
    *
********************************************************************************************************/
public class UpdateContactEmailTriggerHandler{

    public static void onBeforeActions(List<Communication_Preferences__c> cpList){
        /* ******************************************************************************************************
         COLLECT ALL THE VALID COMMUNICATION PREFERECNES FROM THE LIST   
        ******************************************************************************************************  */
        for(Communication_Preferences__c cp: cpList){
            cp.Payment_Profile_Updates_via_Email__c = cp.Payment_Confirmations_via_Email__c || cp.Payment_Reminders_via_Email__c || cp.EasyPay_Communications_via_Email__c || cp.Paperless_Statements_Letters__c || cp.Account_Status_Updates_via_Email__c; //New DSX Field check added on 09/04/2018
            cp.Payment_Profile_Updates_via_Text__c = cp.EasyPay_Communications_via_Text__c || cp.Payment_Confirmations_via_Text__c || cp.Payment_Reminders_via_Text__c || cp.Account_Status_Updates_via_Text__c; //New DSX Field check added on 09/04/2018

            Communication_Preferences__c oldVal = (Communication_Preferences__c) Trigger.oldMap.get(cp.Id);
            //	First time when email is updated, it will be 
            if (cp.IsEmailBounced__c == true && (oldVal.Email_Address__c != cp.Email_Address__c)) {
                cp.IsEmailBounced__c = false;
                cp.Email_BounceBack_Count__c = 0;
            }
            // Added for SMS text number updation
            if (oldVal.Text_Number__c != cp.Text_Number__c) {
                cp.Is_SMS_Bounced_Back__c = false;
                cp.SMS_Bounce_Back_Count__c = 0;
                cp.Need_To_Check_Delivery__c = false;
            }
        }
    }     
}