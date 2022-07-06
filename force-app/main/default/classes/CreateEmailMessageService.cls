public class CreateEmailMessageService{

    public static void createEmailMessage(list<Map<string, String>> newEmailMapList){
    
    String finAccountNumber = ''; // TO PASS THE FINANCE ACCOUNT NUMBER IN ERROR LOG OBJECT.
    
    //Owner         : Senthil Kumar
    //Date          : 23/12/2015
    //Description   : This class will insert the relavant email notification records into Notification Message Object. all the infromation will get from PaymentEmailNotificationController class.

       List <Notification_Messages__c> lstMessage = new List <Notification_Messages__c>();

        Notification_Messages__c  message = new Notification_Messages__c();
        
        for(Map<string, String> newEmailMap:newEmailMapList){
        
      // message.Account_Last_4__c = newEmailMap.get('Account_Last_4__c');
          if(newEmailMap.containsKey('Confirmation_Number__c'))
              message.Confirmation_Number__c = (newEmailMap.get('Confirmation_Number__c'));
              message.Contact_Email__c = newEmailMap.get('Contact_Email__c');
              message.Contact_Lastname__c = newEmailMap.get('Contact_Lastname__c');
          if(newEmailMap.containsKey('Days_Prior_Reminder__c'))
              message.Days_Prior_Reminder__c = Decimal.valueof(newEmailMap.get('Days_Prior_Reminder__c'));
              message.Finance_Account_Number__c = newEmailMap.get('Finance_Account_Number__c');
              if (message.Finance_Account_Number__c != NULL)finAccountNumber += message.Finance_Account_Number__c +' '; // ADDING THE FINANCE ACCOUNT NUMBER WITH SPACE
               
          if(newEmailMap.containsKey('Next_Withdrawal_Date__c'))
              message.Next_Withdrawal_Date__c = Date.valueof(newEmailMap.get('Next_Withdrawal_Date__c'));              
              message.Notification_Template_Name__c = newEmailMap.get('Notification_Template_Name__c'); 
          if(newEmailMap.containsKey('Payment_Amount__c'))    
              message.Payment_Amount__c = Decimal.valueof(newEmailMap.get('Payment_Amount__c'));
          if(newEmailMap.containsKey('Payment_Effective_Date__c'))      
              message.Payment_Effective_Date__c = Date.valueof(newEmailMap.get('Payment_Effective_Date__c'));

        lstMessage.add(message);

    }
    try{
     insert lstMessage;
       // return res; 
       } 
       catch(Exception e){
       
       UtilityClass.logError('CreateEmailMessageService', 'Send Email confirmation Delivery failed', finAccountNumber, 'Email Delivery Failed');
       
       }
       
      }
}