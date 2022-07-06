/*******************************************************************************************************
    * @author   : Accenture
    * @date     :  
    * @modified :   
    * @group    :  
    * @group-content : 
    * @description :  UTILS CLASS FOR ALL PDF SUMMARY GENERATION PAGE
    * Last updated on 27-July for Defect - 114148
********************************************************************************************************/

Public Class PDFUtils{
    
    Static Honda_Finance__c hondaCT = Honda_Finance__c.getOrgDefaults();
    Static String timeZone = hondaCT.Time_Zone__c ;  
    Static String CutOFFTime = PaymentsUtils.getCutOfftime() + ' ' + timeZone ;  
    
    
    /*******************************************************************************************************
    * @description :  CREATE SUMMARY MESSAGE    
    * @param : REQUEST PARAMS 
    * @param : 
    * @return :  STRING
    * @example 
    *  
    *******************************************************************************************************/
    Public Static String SetSummaryMessage(String PaymentType, String IsNew, String PaymentDate, Communication_Preferences__c Preference ){
        
        String SummaryMessage = NULL;
        
        if (  !Preference.Payment_Confirmations_via_Email__c && !Preference.Payment_Confirmations_via_Text__c ) {
                     
             SummaryMessage = 'Your '+ PaymentType +' payment was successfully '+IsNew+'.';  
         
         }  else if ( Preference.Payment_Confirmations_via_Email__c && !Preference.Payment_Confirmations_via_Text__c ) {
             
             SummaryMessage = 'Your '+ PaymentType +' payment was successfully '+IsNew+' and a confirmation was sent to ' + Preference.Email_Address__c+'.';  
         
         }  else if ( !Preference.Payment_Confirmations_via_Email__c && Preference.Payment_Confirmations_via_Text__c ) {
             
             SummaryMessage = 'Your '+ PaymentType +' payment was successfully '+IsNew+' and a confirmation was sent to ' + Preference.Text_Number__c+'.';  
         
         } else if ( Preference.Payment_Confirmations_via_Email__c && Preference.Payment_Confirmations_via_Text__c ) {
             
             SummaryMessage = 'Your '+ PaymentType +' payment was successfully '+IsNew+' and a confirmation was sent to ' + Preference.Email_Address__c +' and '+ Preference.Text_Number__c +'.';  
         
         }
         
         
        
        return SummaryMessage;
    }
    
    
    /*******************************************************************************************************
    * @description :  CREATE SUMMARY MESSAGE    
    * @param : REQUEST PARAMS 
    * @param : 
    * @return :  STRING
    * @example 
    *  
    *******************************************************************************************************/
    Public Static String SetEasyPaySummaryMessage(String IsNew, String PaymentDate, Communication_Preferences__c Preference ){
        
        String SummaryMessage = NULL;
        
        if (  !Preference.EasyPay_Communications_via_Email__c && !Preference.EasyPay_Communications_via_Text__c ) {
                     
             SummaryMessage = 'You have successfully '+ IsNew +' in EasyPay. Your next payment will be processed at ' + CutOFFTime +' on ' +PaymentDate+ '. You can cancel this schedule at any time.';   
         
         }  else if ( Preference.EasyPay_Communications_via_Email__c && !Preference.EasyPay_Communications_via_Text__c ) {
             
             SummaryMessage = 'You have successfully '+ IsNew +' in EasyPay and a confirmation was sent to ' + Preference.Email_Address__c+ '. Your next payment will be processed at ' + CutOFFTime +' on ' +PaymentDate+ '. You can cancel this schedule at any time.';   
         
         }  else if ( !Preference.EasyPay_Communications_via_Email__c && Preference.EasyPay_Communications_via_Text__c ) {
             
             SummaryMessage = 'You have successfully '+ IsNew +' in EasyPay and a confirmation was sent to ' + Preference.Text_Number__c+ '. Your next payment will be processed at ' + CutOFFTime +' on ' +PaymentDate+ '. You can cancel this schedule at any time.'; 
         
         } else if ( Preference.EasyPay_Communications_via_Email__c && Preference.EasyPay_Communications_via_Text__c ) {
             
             SummaryMessage = 'You have successfully '+ IsNew +' in EasyPay and a confirmation was sent to ' + Preference.Email_Address__c+ ' and ' +Preference.Text_Number__c+ '. Your next payment will be processed at ' + CutOFFTime +' on ' +PaymentDate+ '. You can cancel this schedule at any time.';   
         
         }
         
         
        
        return SummaryMessage;
    }
    
    /*******************************************************************************************************
    * @description :  FORMAT THE DATE    
    * @param : DATE  
    * @param : 
    * @return :  STRING
    * @example 
    *  
    *******************************************************************************************************/
    Public Static String FmtDate(Date InputDate){
       if ( InputDate <> NULL ) {
           String fmtPaymentDate = InputDate.month()+'/'+InputDate.day() +'/'+ InputDate.year() ;
           return fmtPaymentDate ;
       } else {
           return null;
       }
        
    }
    
    //Added for defect - 114148
    /*******************************************************************************************************
    * @description :  FORMAT THE DAY SUFFIX    
    * @param : INTEGER  
    * @param : 
    * @return :  STRING
    * @example 
    *  
    *******************************************************************************************************/
    Public static String getDayOfMonthSuffix(Integer n) {
        try{
        
            if (n == null) {
                return '';
            }
    
            else if (n >= 11 && n <= 20) {
                return 'th';
            }else{
                Integer modResult = Math.mod(n, 10);        
                if (modResult == 1) { 
                    return 'st'; 
                } else if (modResult == 2) { 
                    return 'nd'; 
                } else if (modResult == 3) { 
                    return 'rd'; 
                } else { 
                    return 'th';
                }
            }
        } Catch ( Exception e ){
            UtilityClass.logErrorResp('PDF SUMMARY REVIEW PAGE ',   'Exception Caught - Class PDFUtils.getDayOfMonthSuffix', ' input Day  ==> ' + n, Null, 'Message==>' +e.getmessage() + '\n' +'StackTrace==>' +e.getStackTraceString().left(32000)  );
            return null;
        }
    }
    
}