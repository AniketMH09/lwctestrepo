/* Apex Class Name    :    AHFC_SchedulePaymentController
* @description        :    This Class is used to  display schedule payment details
* Modificatied On     :    26/07/2021
* Modification log    :    In paymentDetails method,included 'Fl_OneTime_Payment_Eligible_Web__c' while fetching from ChargentOrders__ChargentOrder__c (US:3793)
                      :    Include cutoff time logic in paymentDetails method
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* satish                      06/07/2021             Created
* Edwin                       26/07/2021             Modified
*********************************************************************************/
public without sharing class AHFC_SchedulePaymentController {
    public static final Date datToday = System.today();
    /**
* @description     paymentList to get the payment details from chargent order object
* @param           sacRecID
* @return          List<ChargentOrders__ChargentOrder__c>
*/
    @AuraEnabled
    public static List<ChargentOrders__ChargentOrder__c> paymentList(String sacRecID){
        // Start - Record access check - Supriya Chakraborty 10-Nov-2021       
        list<Finance_Account__c> finObj = new list<Finance_Account__c>();    
        finObj = [select id,name,Finance_Account_Number__c,AHFC_Product_Nickname__c,AHFC_Web_Manage_Comm_Pref__c,AHFC_Web_Account_Locked__c  from Finance_Account__c where id=:sacRecId];
        boolean isUserAuth = UserSecurity.ValidateFinNumberInit(finObj[0].Finance_Account_Number__c);        
        if(!isUserAuth){
            throw new AuraHandledException('invalid access');            
        } 
        // End - Record access check - Supriya Chakraborty 10-Nov-2021
        
        List<ChargentOrders__ChargentOrder__c> lstPayments = [SELECT id,RecordType.name, Finance_Account_Number__c, ChargentOrders__Charge_Amount__c, Payment_Channel__c, 
                                                              Last_Payment_Display_Status__c,Payment_Type__c,ChargentOrders__Payment_Start_Date__c,Payment_Display_Status__c 
                                                              FROM ChargentOrders__ChargentOrder__c  WHERE Finance_Account_Number__c =:sacRecID and ( Payment_Display_Status__c = 'Pending' OR Payment_Display_Status__c = 'Processing' OR Payment_Display_Status__c = 'Suspended')];
        
        
        return lstPayments;
        
    }
    
    @AuraEnabled
    public static PaymentWrapper paymentDetails(String sacRecID){
        PaymentWrapper payWrapper = new PaymentWrapper();        
        // Start - Record access check - Supriya Chakraborty 11-Nov-2021       
        list<Finance_Account__c> finObj = new list<Finance_Account__c>();    
        finObj = [select id,name,Finance_Account_Number__c,AHFC_Product_Nickname__c,AHFC_Web_Manage_Comm_Pref__c,AHFC_Web_Account_Locked__c  from Finance_Account__c where id=:sacRecId];
        boolean isUserAuth = UserSecurity.ValidateFinNumberInit(finObj[0].Finance_Account_Number__c);        
        if(!isUserAuth){
            throw new AuraHandledException('invalid access');            
        } 
        // End - Record access check - Supriya Chakraborty 11-Nov-2021
        try{

        Boolean isEZPEnrolled =false;
        Boolean showEZP =false;
        Boolean openCancelEZPEligibility =false;
        Boolean isOTPWebEnabled =false;  //added by edwin US:3793

        
       /* Honda_Finance__c hfc = Honda_Finance__c.getOrgDefaults();
        string cutOffTime = hfc.CutOff_Time__c.format('h:mm a') ;
        Boolean cutOffFlag =false;
        
        
        if(System.now().time() > hfc.CutOff_Time__c.time()){
            
            cutOffFlag = true;
            
            
        }else{
            cutOffFlag = false;
            
        }   */

        //cutoff time logic starts here 
       
        Boolean cutOffFlag =isAfterCutOffTime();

        
          //cutoff time logic ends here

        List<ChargentOrders__ChargentOrder__c> lstOtpPayments = new List<ChargentOrders__ChargentOrder__c>();
        List<ChargentOrders__ChargentOrder__c> lstEasyPayPayments = new List<ChargentOrders__ChargentOrder__c>();
        List<ChargentOrders__ChargentOrder__c> lstPayments = [SELECT id,RecordType.name, Finance_Account_Number__c, ChargentOrders__Charge_Amount__c, 
                                                              Confirmation_Number__c,Payment_Channel__c, PaymentAuthorizedOn__c,Last_Extraction_Date__c,
                                                              Payment_Source_Nickname__r.Payment_Source_Nickname__c,
                                                              Payment_Source_Nickname__r.Last_4__c,Payment_Source_Nickname__c, 
                                                              Last_Payment_Display_Status__c,Payment_Type__c,Next_Withdrawal_Date__c,
                                                              ChargentOrders__Payment_Start_Date__c,Payment_Display_Status__c,
                                                              Finance_Account_Number__r.Fl_OneTime_Payment_Eligible_Web__c,
                                                              Account_Type__c,Fl_Refinanced__c,Finance_Account_Number__r.Fl_Payoff_Payment_Eligible_Web__c                          //added for US:3974
                                                              FROM ChargentOrders__ChargentOrder__c  WHERE Finance_Account_Number__c =:sacRecID and ( Payment_Display_Status__c = 'Pending' OR Payment_Display_Status__c = 'Processing' OR Payment_Display_Status__c = 'Suspended')
                                                              order by ChargentOrders__Payment_Start_Date__c ASC];
        
        
        for(ChargentOrders__ChargentOrder__c objPayment : lstPayments){
            system.debug('lstPayments'+objPayment);
            isOTPWebEnabled = objPayment.Finance_Account_Number__r.Fl_OneTime_Payment_Eligible_Web__c; //US:3793 by edwin
            if((objPayment.RecordType.name=='Standard One-Time Payment'||objPayment.RecordType.name=='Principal One-Time Payment' || objPayment.RecordType.name=='Payoff Payment') && (objPayment.Payment_Display_Status__c=='Pending'|| objPayment.Payment_Display_Status__c=='Processing')){
                lstOtpPayments.add(objPayment);
                
            }else{
                if(objPayment.RecordType.name=='Recurring Payment'){
                    if(objPayment.Payment_Display_Status__c=='Pending'/*||objPayment.Payment_Display_Status__c=='Processing'*/){
                        lstEasyPayPayments.add(objPayment);
                        isEZPEnrolled = true;
                        showEZP =true;
                        openCancelEZPEligibility =false;
                    }
                    else if(objPayment.Payment_Display_Status__c=='Suspended'){
                        lstEasyPayPayments.add(objPayment);
                        isEZPEnrolled = false;
                        showEZP =true;
                        openCancelEZPEligibility =true;
                        cutOffFlag = false;
                    }
                    else{
                        isEZPEnrolled = false;
                    }
                    
                }
                
            }
            
        }
        
        payWrapper.cutOffFlag = cutOffFlag;
        payWrapper.isEZPEnrolled = isEZPEnrolled;
        payWrapper.showEZP = showEZP;
        payWrapper.openCancelEZPEligibility = openCancelEZPEligibility;
        payWrapper.lstOtpPayments = lstOtpPayments;
        payWrapper.lstEasyPayPayments =lstEasyPayPayments;
        payWrapper.dateToday = datToday;
        payWrapper.isOTPWebEnabled = isOTPWebEnabled;
    }
    catch(Exception ex){
        system.debug('Exception happened, Exceptioon:'+ ex);
        UtilityClass.logError('AHFC_SchedulePaymentController : paymentDetails',ex.getMessage(),sacRecID,'');
    }
        return payWrapper;
    }

      /**
* Created by    :  Edwin
* Created On    :  26 July 2021
* @description  :   check whether current time greater than cutoff time
* 
* @return          cutoff time
*/
@AuraEnabled
public static boolean isAfterCutOffTime(){

        Honda_Finance__c hfc = Honda_Finance__c.getOrgDefaults();
        Datetime  CutOffTime  =  Datetime.valueof(hfc.get('CutOff_Time__c')) ;
        String tmp1 =  CutOffTime.format('HH:mm','America/Los_Angeles');
        String tmp2 =  DateTime.Now().format('HH:mm','America/Los_Angeles');            
        Time CuttOFFTime = Time.newInstance(  Integer.Valueof(tmp1.SubstringBefore(':')),  Integer.Valueof(tmp1.SubstringAfter(':')), 0 ,0 );
        Time CurrentPSTTime = Time.newInstance(  Integer.Valueof(tmp2.SubstringBefore(':')),  Integer.Valueof(tmp2.SubstringAfter(':')), 0 ,0 );
		system.debug('temp1'+tmp1);
    	system.debug('temp2'+tmp2);
	     system.debug('CuttOFFTime'+CuttOFFTime);
    	system.debug('CurrentPSTTime'+CurrentPSTTime);

        Boolean cutOffFlag =false;

        if(CurrentPSTTime > CuttOFFTime){
                cutOffFlag = true;
                system.debug(cutOffFlag);
            }else{
                cutOffFlag = false;
                
            }
    return cutOffFlag;
    
}

@AuraEnabled
    public static DateTime todayDateTime(){
        return system.now();
    }


    //wrapper class
    /**
* @description     PaymentWrapper
*/
    public without sharing class PaymentWrapper{
        
        /**
* @description     lstEasyPayPayments
*/
        @AuraEnabled
        public List<ChargentOrders__ChargentOrder__c> lstEasyPayPayments{get;set;}
        /**
* @description     lstOtpPayments
*/
        @AuraEnabled
        public List<ChargentOrders__ChargentOrder__c> lstOtpPayments{get;set;}
        /**
* @description     isEZPEnrolled
*/
        @AuraEnabled
        public Boolean isEZPEnrolled{get;set;} 
        /**
* @description     openCancelEZPEligibility
*/
        @AuraEnabled
        public Boolean openCancelEZPEligibility{get;set;} 
        /**
* @description     showEZP
*/
        @AuraEnabled
        public Boolean showEZP{get;set;} 
        /**
* @description     cutOffFlag
*/
        @AuraEnabled
        public Boolean cutOffFlag{get;set;} 
        
        /**
* @description     dateToday
*/
        @AuraEnabled
        public Date dateToday{get;set;}
        
            /**
* @description     isOTPWebEnabled
*/
@AuraEnabled
public Boolean isOTPWebEnabled{get;set;} 
        
    }
    
    
}