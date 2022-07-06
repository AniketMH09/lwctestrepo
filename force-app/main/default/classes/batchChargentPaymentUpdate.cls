/*******************************************************************************************************
    * @author  : SARAVANAN C
    * @date    :  
    * @modified : 15 APR 2019 
    * @modified by : Rajeshwar Patel
    * @Company : Capgemini
    * @group    :  
    * @group-content : 
    * @description : INTEGRATION 6B, PURPOSE : RUN PCD (PAYMENT CONFIGURATION DOCUMENT) RULES AND UPDATE PAYMENT RECORDS.
    * @update history : 
    *    1. Defect 114006 - Updated Rule 39 & 40 NUll Check Condition
    *    2. Defect 114468 - Added Rule 34(a), updated Rule 35&36; renamed rule 34 to 34(b) 
    *    3. RSS: 41524 -  EasyPay Amount Noy adjusting Correctly in Final Payment on retail and balloon refi accounts
    * 
********************************************************************************************************/

global with sharing class batchChargentPaymentUpdate implements Database.Batchable < sObject > , Database.AllowsCallouts  {
 global list < ChargentOrders__ChargentOrder__c > paymentList = new list < ChargentOrders__ChargentOrder__c > ();
 global list < ChargentOrders__ChargentOrder__c > paysToInsert = new list < ChargentOrders__ChargentOrder__c > ();


 global batchChargentPaymentUpdate() {

 }

 global Database.QueryLocator start(Database.BatchableContext BC) {
  /*
          //Before the batch starts, make sure insert is made in the Batch_Schedule_Tracking__c object 
          Batch_Schedule_Tracking__c newBtchSchTracking = new Batch_Schedule_Tracking__c();
              newBtchSchTracking.Batch_Name__c = 'Batch Chargent Payment Update';
              newBtchSchTracking.Start_Date__c = system.today();
              newBtchSchTracking.Start_Date_Time__c = system.now();
              newBtchSchTracking.Status__c = 'In Progress';
              newBtchSchTracking.JobId__c = BC.getJobId();

          insert newBtchSchTracking;
   */
  String query = 'Select Id, Name, recordtype.developername, ' +
   'Bank_Account_Nick_Name__c, ' +
   'ChargentOrders__Charge_Amount__c, ' +
   'ChargentOrders__Payment_Start_Date__c, ' +
   'ChargentOrders__Charge_Date__c, ' +
   'Deficiency_Account__c, ' +
   'ChargentOrders__Payment_Count__c, ' +
   'ChargentOrders__Manual_Charge__c, ' +
   'ChargentOrders__Payment_Method__c, ' +
   'ChargentOrders__Payment_Status__c, ' +
   'Payment_Display_Status__c, ' +
   'ChargentOrders__Payment_Frequency__c, ' +
   'ChargentOrders__Payment_Stop__c, ' +
   'ChargentOrders__Payment_End_Date__c, ' +
   'Payment_Type__c, ' +
   'Payment_Channel__c, ' +
   'Next_Withdrawal_Date__c, ' +
   'Payment_Source_Nickname__r.Bank_Name__c, ' +
   'Payment_Source_Nickname__r.ChargentOrders_Tokenization__c, ' +
   'Finance_Account_Number__r.IsUpdated__c, ' +
   'Finance_Account_Number__r.Fl_Cancel_One_Time_Payments__c, ' +
   'Finance_Account_Number__r.FI_Stop_Reinstate_Recurring_Payment__c, ' +
   'Finance_Account_Number__r.Fl_Extend_Recurring_Payment_Today__c, ' +
   'Finance_Account_Number__r.Fl_Defer_Recurring_Payment_Today__c, ' +
   'Finance_Account_Number__r.Account_Type__c, ' +
   'Finance_Account_Number__r.Total_Amount_Due__c, ' +
   'Finance_Account_Number__r.Scheduled_EasyPay_Amount__c, ' +
   'Finance_Account_Number__r.Payoff_Amount__c, ' +
   'Finance_Account_Number__r.Payment_Due_Date__c, ' +
   'Finance_Account_Number__r.Fl_Refinanced__c, ' +
   'Finance_Account_Number__r.Final_Due_Date__c,' +
   'Finance_Account_Number__r.Id,' +
   'Finance_Account_Number__r.Regular_Monthly_Payment__c, ' +
   'Finance_Account_Number__r.Old_Regular_Monthly_Payment__c, ' +
   'Finance_Account_Number__r.Maturity_Date__c, ' +
   'Finance_Account_Number__r.Region_Code__c, ' +
   'Finance_Account_Number__r.Finance_Account_Number__c, ' +
   'Finance_Account_Number__c  ' +
   'From ChargentOrders__ChargentOrder__c ' +
   'where Finance_Account_Number__r.IsUpdated__c = true ' +
   'and ((ChargentOrders__ChargentOrder__c.Payment_Display_Status__c = \'Pending\' and (recordtype.developername = \'One_Time_Payment\' or recordtype.developername = \'Principal_One_Time_Payment\')) or (recordtype.developername = \'Recurring_Payment\'))';

     system.debug('Query Locator:-'+query);
  return Database.getQueryLocator(query);
 }

 global void execute(Database.BatchableContext BC, List < ChargentOrders__ChargentOrder__c > paymentScope) {
     
      list < ChargentOrders__ChargentOrder__c > paysToUpdate = new list < ChargentOrders__ChargentOrder__c > ();
      Set < Id > finAccIdSet = new Set < Id > ();
          
     try {      
          system.debug('paymentScope-->'+paymentScope);
          for (ChargentOrders__ChargentOrder__c p: paymentScope) {
          system.debug('type is ' + p.Payment_Display_Status__c + ' and charge amount is ' + p.ChargentOrders__Charge_Amount__c);
           // Add the Finance Account Id into finAccIdSet
           // The below Set finAccIdSet will only have the unique p.Finance_Account_Number__r.Id
           // Any attempt to add the duplicate value of p.Finance_Account_Number__r.Id will return false 
           // and hence Set will not contain that value for the second time
           finAccIdSet.add(p.Finance_Account_Number__r.Id);
        
           // Update conditions and scenarios go here
            /*******************************************************************************************************
                 RULE 32 : Systematically Cancel Pending One-Time Payment    
            *******************************************************************************************************/
            //Below line change added to the defect 114223 by Jayashree
           if (p.recordtype.developername == 'One_Time_Payment' || p.recordtype.developername == 'Principal_One_Time_Payment') {
            if (p.Finance_Account_Number__r.Fl_Cancel_One_Time_Payments__c == true) {
             p.ChargentOrders__Payment_Status__c = 'Complete';
             p.Payment_Display_Status__c = 'Cancelled';
             CASSCallOut.MakeHttpCallRealTime(p.Id);
            }
           } else if (p.recordtype.developername == 'Recurring_Payment') {
            Date dateToday = Date.today();
        
             
            /*******************************************************************************************************
                 RULE 33 : Systematically Stop Recurring Payment  
            *******************************************************************************************************/
            if (p.Finance_Account_Number__r.FI_Stop_Reinstate_Recurring_Payment__c == 'S' && p.Payment_Display_Status__c == 'Pending') {
             p.ChargentOrders__Payment_Status__c = 'Stopped';
             p.Payment_Display_Status__c = 'Stopped';
             p.Payment_Display_Status_Date__c = Datetime.now();
            }
            
            /*******************************************************************************************************
                RULE 34 (a) : Update payment end date when 'Stopped', 'Lease OR Balloon' account is re-instated 
                Added as part of Defect# 114468
            *******************************************************************************************************/
            else if (p.Finance_Account_Number__r.FI_Stop_Reinstate_Recurring_Payment__c == 'R' && p.Payment_Display_Status__c == 'Stopped' 
            && p.Finance_Account_Number__r.Fl_Extend_Recurring_Payment_Today__c == true 
            && (p.Finance_Account_Number__r.Account_Type__c == 'Lease' || p.Finance_Account_Number__r.Account_Type__c == 'Balloon')) {
                
                p.ChargentOrders__Payment_Status__c = 'Recurring';
                p.Payment_Display_Status__c = 'Pending';
                p.Payment_Display_Status_Date__c = Datetime.now();
                p.ChargentOrders__Payment_End_Date__c = p.Finance_Account_Number__r.Final_Due_Date__c;
                
                // Also update the NWD as reinstate might have happened after the current NWD date
                if(p.ChargentOrders__Charge_Date__c <> null)
                {
                    try
                    {
                        // Set the new next withdrawal date for reinstatement - QC 114428
                        p.Next_Withdrawal_Date__c = NWDManager.calculateNWD(p, Date.today(), false);
                        
                    }
                    catch(Exception e)
                    {
                        Utilityclass.logError('batchChargentPaymentUpdate', 'Exception occurred when calculating NWD', p.Finance_Account_Number__r.Id, e.getStackTraceString());
                    }
                }
                
            }
             
            /*******************************************************************************************************
                 RULE 34 (b) : Systematically Reinstate Recurring Payment    
            *******************************************************************************************************/
            else if (p.Finance_Account_Number__r.FI_Stop_Reinstate_Recurring_Payment__c == 'R' && p.Payment_Display_Status__c == 'Stopped') {
                p.ChargentOrders__Payment_Status__c = 'Recurring';
                p.Payment_Display_Status__c = 'Pending';
                p.Payment_Display_Status_Date__c = Datetime.now();
                
                // Also update the NWD as reinstate might have happened after the current NWD date
                if(p.ChargentOrders__Charge_Date__c <> null)
                {
                    try
                    {
                        // Set the new next withdrawal date for reinstatement - QC 114428
                        p.Next_Withdrawal_Date__c = NWDManager.calculateNWD(p, Date.today(), false);
                        
                    }
                    catch(Exception e)
                    {
                        Utilityclass.logError('batchChargentPaymentUpdate', 'Exception occurred when calculating NWD', p.Finance_Account_Number__r.Id, e.getStackTraceString());
                    }
                }
                
            }
             
            /*******************************************************************************************************
                 RULE 35 AND 36:  35 - Systematically Extend Recurring Payment Before Completion (Traditional EasyPay) [Lease and Balloon Accounts]  
                                  36 - Systematically Extend Recurring Payment After Completion (Traditional EasyPay)
            *******************************************************************************************************/
            // Fix :Do not update if Regular Mothly Payment is 0$
            else if (p.Finance_Account_Number__r.Fl_Extend_Recurring_Payment_Today__c == true && (p.Finance_Account_Number__r.Account_Type__c == 'Lease' || p.Finance_Account_Number__r.Account_Type__c == 'Balloon') &&
            (p.Payment_Display_Status__c == 'Pending') &&
            (p.Finance_Account_Number__r.Regular_Monthly_Payment__c <> null && p.Finance_Account_Number__r.Regular_Monthly_Payment__c <> 0)){
                
            // Defect# 114468: ChargentOrders__Payment_End_Date__c is set to Final_Due_Date__c instead of Maturity_Date__c
                p.ChargentOrders__Payment_End_Date__c = p.Finance_Account_Number__r.Final_Due_Date__c;
                p.ChargentOrders__Charge_Amount__c = p.Finance_Account_Number__r.Regular_Monthly_Payment__c;
                p.Charge_Amount_Date__c = Datetime.now();
                p.Next_Withdrawal_Updated_Date__c = Datetime.now();
            }
           
           
           /*******************************************************************************************************
                 RULE 37:  Systematically Defer Recurring Payment On a Lease or Balloon Account / Systematically "Extend" Recurring Payment On a Retail Account
            *******************************************************************************************************/
          //Changes added to the defect 114041 by Jayashree  
           else if (p.Finance_Account_Number__r.Fl_Defer_Recurring_Payment_Today__c == true && p.Payment_Display_Status__c == 'Pending' && (p.Finance_Account_Number__r.Account_Type__c == 'Retail' || p.Finance_Account_Number__r.Account_Type__c == 'Lease' )) {
        
             p.ChargentOrders__Payment_Status__c = 'Complete';
             p.Payment_Display_Status__c = 'Cancelled';
             //Below Line Change added to the defect 114165 by Jayashree
             p.Duplicate_Key_Tracker__c = p.Finance_Account_Number__r.Finance_Account_Number__c + 'Recurring_Payment' + 'INACTIVE' + Datetime.now();
             p.Payment_Display_Status_Date__c = Datetime.now();
             
             //Insert New Recurring Payment
             
             createRP(p);
             
           }
           
           // End of defect 114041
           
           /*******************************************************************************************************
                 RULE 38:  Systematically Update ChargentOrders__Charge_Amount__c On Recurring Payment
            *******************************************************************************************************/
            // Fix :Do not update if Regular Mothly Payment is 0$
           else if ((p.Finance_Account_Number__r.Old_Regular_Monthly_Payment__c != p.Finance_Account_Number__r.Regular_Monthly_Payment__c) &&
            (p.Finance_Account_Number__r.Account_Type__c == 'Lease' && p.Finance_Account_Number__r.Region_Code__c <> 'NRC') &&
            (p.Finance_Account_Number__r.Regular_Monthly_Payment__c <> null && p.Finance_Account_Number__r.Regular_Monthly_Payment__c <> 0)) {
                p.ChargentOrders__Charge_Amount__c = p.Finance_Account_Number__r.Regular_Monthly_Payment__c;
                p.Charge_Amount_Date__c = Datetime.now();
           }
            
           /*******************************************************************************************************
                 RULE 39:  Systematically Update ChargentOrders__Charge_Amount__c On Recurring Payment when Paid Ahead 
                           During Final Month of Schedule (Account Type = "Retail", update to Total Amount Due)
            *******************************************************************************************************/
            // Defect 114006 - Total Amount Due Null and 0 Check 
            //RSS-41524 :Rule#39 out of scope 
            /*
           else if ((p.Finance_Account_Number__r.Account_Type__c == 'Retail') &&
            (p.Payment_Display_Status__c == 'Pending') &&
            (p.Finance_Account_Number__r.Total_Amount_Due__c <> null && p.Finance_Account_Number__r.Total_Amount_Due__c <> 0) &&
            (p.ChargentOrders__Charge_Amount__c <> null) &&
            (p.Finance_Account_Number__r.Total_Amount_Due__c < p.ChargentOrders__Charge_Amount__c) &&
            (p.Finance_Account_Number__r.Payoff_Amount__c < p.ChargentOrders__Charge_Amount__c) &&
            (p.Finance_Account_Number__r.Payment_Due_Date__c >= p.Next_Withdrawal_Date__c)) {
                p.ChargentOrders__Charge_Amount__c = p.Finance_Account_Number__r.Total_Amount_Due__c;
                p.Charge_Amount_Date__c = Datetime.now();
           } */
            
           /*******************************************************************************************************
                 RULE 40:  Systematically Update ChargentOrders__Charge_Amount__c On Recurring Payment when Paid Ahead 
                           During Final Month of Schedule (Account Type = "Balloon" AND Refinanced = "True", update to Total Amount Due)
            *******************************************************************************************************/
            // Defect 114006 - Total Amount Due Null and 0 Check 
           //RSS-41524 :Rule#40 out of scope
           /*else if ((p.Finance_Account_Number__r.Account_Type__c == 'Balloon') &&
            (p.Finance_Account_Number__r.Fl_Refinanced__c == true) &&
            (p.Payment_Display_Status__c == 'Pending') &&
            (p.Finance_Account_Number__r.Total_Amount_Due__c <> null && p.Finance_Account_Number__r.Total_Amount_Due__c <> 0) &&
            (p.ChargentOrders__Charge_Amount__c <> null) &&
            (p.Finance_Account_Number__r.Total_Amount_Due__c < p.ChargentOrders__Charge_Amount__c) &&
            (p.Finance_Account_Number__r.Payoff_Amount__c < p.ChargentOrders__Charge_Amount__c) &&
            (p.Finance_Account_Number__r.Payment_Due_Date__c >= p.Next_Withdrawal_Date__c)) {
                p.ChargentOrders__Charge_Amount__c = p.Finance_Account_Number__r.Total_Amount_Due__c;
                p.Charge_Amount_Date__c = Datetime.now();
           } */
               
            
         /*******************************************************************************************************
         Charge Amount is not adjusting correctly for final EasyPay payment on retail and balloon refi accounts
         ((Account Type = RETAIL) OR (Account Type = BALLOON AND Refinanced Flag = TRUE)) AND (Account owner <>NRC)
          then update to Chargent Order amount as payoff amount
         *******************************************************************************************************/
         //RSS-41524--Changes Start :New Rule
               
        else if (
                  (
                        (p.Finance_Account_Number__r.Account_Type__c == 'Retail') ||
                        (p.Finance_Account_Number__r.Account_Type__c == 'Balloon' && p.Finance_Account_Number__r.Fl_Refinanced__c)
                  ) 
                     && (p.Finance_Account_Number__r.Region_Code__c <> 'NRC')
                     && (p.recordtype.developername == 'Recurring_Payment')
                     && (p.Payment_Display_Status__c =='Pending')  
                     && (p.Finance_Account_Number__r.Payoff_Amount__c < p.ChargentOrders__Charge_Amount__c)
                     && (p.Next_Withdrawal_Date__c<=System.today())            
                )            
               {
               system.debug('Condition match--41524');      
               p.ChargentOrders__Charge_Amount__c = p.Finance_Account_Number__r.Payoff_Amount__c;               
               p.Charge_Amount_Date__c = Datetime.now();
               }               
               system.debug('Finance Account#' + p.Finance_Account_Number__r.Finance_Account_Number__c);
               system.debug('Chargent Amount--->'+p.ChargentOrders__Charge_Amount__c);
               system.debug('Refinanced detail-->'+p.Finance_Account_Number__r.Fl_Refinanced__c);
               system.debug('NWD-->'+p.Next_Withdrawal_Date__c);
               system.debug('PayOff Amount-->'+p.Finance_Account_Number__r.Payoff_Amount__c);
               system.debug('Chargent Order Amount-->'+p.ChargentOrders__Charge_Amount__c);    
              
         //  RSS-41524--Changes Ends
       
           /* Rule 41 is out of scope
           // 41
           else if((date.today() < p.ChargentOrders__Payment_End_Date__c) &&
                   (monthToday == monthPaymentEndDate) &&
                   ((p.Finance_Account_Number__r.Account_Type__c == 'Retail') &&
                   (p.Finance_Account_Number__r.Total_Amount_Due__c >= p.Finance_Account_Number__r.Scheduled_EasyPay_Amount__c) &&
                   (p.Finance_Account_Number__r.Payoff_Amount__c >= p.Finance_Account_Number__r.Scheduled_EasyPay_Amount__c) &&
                   (p.Finance_Account_Number__r.Payment_Due_Date__c >= p.Next_Withdrawal_Date__c))
                   )
           {
               
           } */
        
           /* Rule 42 is out of scope
           // 42
           else if((date.today() < p.ChargentOrders__Payment_End_Date__c) &&
                   (p.Finance_Account_Number__r.Account_Type__c == 'Balloon') &&
                   (p.Finance_Account_Number__r.Fl_Refinanced__c == true) && 
                   (p.Finance_Account_Number__r.Total_Amount_Due__c >= p.Finance_Account_Number__r.Scheduled_EasyPay_Amount__c) &&
                   (p.Finance_Account_Number__r.Payoff_Amount__c >= p.Finance_Account_Number__r.Scheduled_EasyPay_Amount__c) &&
                   (p.Finance_Account_Number__r.Payment_Due_Date__c >= p.Next_Withdrawal_Date__c))
           {
               //p. = p.ChargentOrders__Charge_Amount__c;
           }  */
        
          }
          paysToUpdate.add(p);
         }  // for loop end
         
         update paysToUpdate;
         
         if(!paysToInsert.isEmpty()) {
         insert paysToInsert;
         }

         // After update is performed on paysToUpdate list, update the flag on IsUpdate flag on Finance_Account_Number__r back to false
        
         List < Finance_Account__c > finAccList = new list < Finance_Account__c > ();
         finAccList = [Select Id, IsUpdated__c from Finance_Account__c where id IN: finAccIdSet];
        
         if (finAccList.size() > 0) {
          for (integer i = 0; i < finAccList.size(); i++) {
           finAccList[i].IsUpdated__c = false;
          }
          update finAccList;
         }//try block End
             
    } Catch ( Exception e ) {
           /*******************************************************************************************************
                 EXCEPTION HANDLING  - ANY EXCEPTION WILL BE LOGGED IN ERROR LOG OBJECT    
            *******************************************************************************************************/
              List<Id> finAccs = new List<Id>(finAccIdSet);
             
             // UTILITY CLASS TO CREATE ERROR LOG OBJECT RECORD
             UtilityClass.logError('INT 6B', e.getmessage(), String.join(finAccs, ',') ,  String.join(paysToUpdate, ',')  );
       
       }
}

global void finish(Database.BatchableContext BC) {

 try {
      
      //Changes added to the defect 114064 by Jayashree    
      //Database.executeBatch(new batchPaymentUpdateFlag());
         
          // Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
          // Query the AsyncApexJob object to retrieve the current job's information.       
          AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id = : BC.getJobId()];
          //Send an email to the Apex job's submitter notifying of job completion.       
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
          String emailLabel = Label.Batch_Notification_Emails;
        
          String[] toAddresses = new String[] {
           a.CreatedBy.Email
          };
          // Comma seperated values in Label Batch_Notification_Emails
          // Add each value to the toAddresses 
          for (String s: emailLabel.split(',')) {
           toAddresses.add(s);
          }
        
          // setToAddresses sends email to the email addresses in toAddresses 
          mail.setToAddresses(toAddresses);
          mail.setSubject('ChargentOrders__ChargentOrder__c Updated ' + a.Status);
          mail.setPlainTextBody('The Batch Apex job processed ' + a.TotalJobItems + ' batches with ' + a.NumberOfErrors + ' failures.');
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
           mail
          });
         } catch (System.Exception ex) {
                 //Changes added to the defect 114064 by Jayashree
                // UTILITY CLASS TO CREATE ERROR LOG OBJECT RECORD 
             UtilityClass.logError('INT 6B FINISH Method', ex.getmessage(), NULL ,  NULL  );
       
         }
    }

    /*******************************************************************************************************
    * @description :  CREATE RECURRING PAYMENT
    * @param : RESPONSE BODY PARAMS CHARGENT ORDER OBJECT   
    * @return : VOID
    * @example 
    * @Update history : 25th May 2016 - Defect 114149 by Omkar - Removed the line ie.. ( cinsertNew.ChargentOrders__Bank_Name__c = p.Payment_Source_Nickname__r.Bank_Name__c; )

    *******************************************************************************************************/
  //Changes added to the defect 114041 by Jayashree 
    Private Void createRP(ChargentOrders__ChargentOrder__c p ){
      
      try { 
                    Date NWD;
                    ChargentOrders__ChargentOrder__c cinsertNew = new ChargentOrders__ChargentOrder__c();
                    cinsertNew.Payment_Source_Nickname__c = p.Payment_Source_Nickname__c;
                    cinsertNew.ChargentOrders__Charge_Amount__c = p.ChargentOrders__Charge_Amount__c;
                    cinsertNew.ChargentOrders__Charge_Date__c = p.ChargentOrders__Charge_Date__c;                   
                    cinsertNew.ChargentOrders__Manual_Charge__c = true;
                    cinsertNew.ChargentOrders__Payment_Method__c = 'check';
                    cinsertNew.ChargentOrders__Payment_Status__c = 'Recurring';
                    cinsertNew.Payment_Display_Status__c = 'Pending';                   
                    cinsertNew.ChargentOrders__Payment_Frequency__c ='Monthly';
                    
                    Honda_Finance__c hondaCT = Honda_Finance__c.getOrgDefaults();
                    Integer days = Integer.valueOf(hondaCT.No_of_Days__c) ;
                    
                    if(p.Finance_Account_Number__r.Payment_Due_Date__c != null) {
                        Date newStartDate = p.Finance_Account_Number__r.Payment_Due_Date__c - days;
                        cinsertNew.ChargentOrders__Payment_Start_Date__c = newStartDate;
                        
                        //  Fix for QC 114449
                        // Set the next withdrawal date based on new easy pay start date
                        cinsertNew.Next_Withdrawal_Date__c = NWDManager.calculateNWD(p, newStartDate, false);
                    }
                    
                    cinsertNew.ChargentOrders__Payment_Stop__c = 'Date';
                    cinsertNew.ChargentOrders__Payment_End_Date__c = p.Finance_Account_Number__r.Final_Due_Date__c;
                    cinsertNew.Payment_Type__c = 'R';
                    cinsertNew.Payment_Channel__c = 'R';
                    cinsertNew.ChargentOrders__Tokenization__c = p.Payment_Source_Nickname__r.ChargentOrders_Tokenization__c;
                    cinsertNew.Finance_Account_Number__c = p.Finance_Account_Number__r.Id;
                    cinsertNew.recordtypeid = p.recordtype.id;
                    //Changes added to the defect 114165 by Jayashree
                    cinsertNew.Duplicate_Key_Tracker__c =  p.Finance_Account_Number__r.Finance_Account_Number__c + 'Recurring_Payment' + 'ACTIVE';
                    //End of defect 114165 
                 paysToInsert.add(cinsertNew);   
     } catch (exception e) {
         String Stacktrace  = e.getStackTraceString();
         String ErrorDetails = 'Message => ' + e.getMessage() + '\n';
                        ErrorDetails += 'Cause => ' + e.getCause() + '\n'; 
                        ErrorDetails += 'Linenumber => ' + e.getLineNumber()+ '\n';
                        ErrorDetails += 'User => ' +Userinfo.getUserName() + '\n' ;
         UtilityClass.logError(Stacktrace, ErrorDetails, p.Id,  p.Finance_Account_Number__r.Id );
     }
     
   } 
   
   //End of defect 114041
}