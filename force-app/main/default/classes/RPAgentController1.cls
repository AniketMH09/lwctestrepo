/********************** @Update History **********************
@17 April 2017- Defect RSS41359 by AMS team

/********************** @Update History **********************/

public with sharing class RPAgentController1{
 public String Helptxt{get;set;} 
 public ChargentOrders__ChargentOrder__c c{get;set;}
 public ChargentOrders__ChargentOrder__c cOrder{get;set;}
 public Boolean NextWithdrawalDate {get;set;}
 public Boolean eligibleFlagRP {get;set;}
 public Boolean displayModeRP {get;set;}
 public Boolean OTPFlag {get;set;}
 public Boolean readOnly {get;set;}
 public String bankAccntToken {get;set;}
 PageReference p;

 public String chargeDate {get;set;}
 public Date NextTransactionDate {get;set;}
 Public boolean val{get;set;}

 public ChargentOrders__ChargentOrder__c cinsertNew;

 public String finID ; 
 public String chargentID;
 public String RPID{get;set;}
 public String RecurringID {get;set;}
 public Boolean editMode {get; private set;}
 public Boolean detailMode {get;set;}
 public Boolean displayMode {get;set;}
 public DateTime today;
 Integer flag = 0;
 Public String RecordMode = NULL ;
 public List<ChargentOrders__ChargentOrder__c> cOrderIDRedirect{get;set;}

 public Finance_Account__c finAccount{get;set;}
 Map<Id,Payment_Source__c> bankAccountsMap ;
 Map<String,RecordType>  orderRTMap ; 
 Map<String,RecordType>  gatewayRTMap ;
 public Map<String,List<ChargentOrders__ChargentOrder__c>> orderMap;
 public Map<String,List<ChargentOrders__ChargentOrder__c>> orderMapRP;
 public ChargentOrders__ChargentOrder__c cOrderRecordRP{get;set;}
 public list<ChargentOrders__ChargentOrder__c > cOrderListRP{get;set;}
 public List<ChargentOrders__ChargentOrder__c> cOrders {get;set;}
 public string pageDislayEasypay;

 public List<SelectOption> BankAccs {get;set;} 
 public String SelBankAcc {get;set;} 
 Map<String,Payment_Source__c>  BankAccRecords ;
 Public String IsFromBank = ''; 
 
 //Changes added to the defect 114004 by Jayashree
 public String errorColorNRC {get;set;}
 public String errorColorCount{get;set;}
 public String paymentCount {get;set;}
 
 //End of defect 114004
 
 public Date newStartDate;
 
 public RPAgentController1(ApexPages.StandardController controller) {

  Helptxt ='Help Message!';

  editMode = true;
  eligibleFlagRP = false;
  OTPFlag = false;
  displayModeRP = false;
  readOnly = false;
  val=false;  
  
  //Changes added to the defect 114004 by Jayashree
  errorColorNRC = 'None';
  errorColorCount = 'None';
  paymentCount = '';
  //End of defect 114004
  
  cOrderIDRedirect = new List<ChargentOrders__ChargentOrder__c>();
 /*Changes propsed for Security Vulnerabilities against line 107,553 -- Gufran Date 4/20/2020*/ 
 // finID = ApexPages.CurrentPage().getParameters().get('finnumber');
 finID = ApexPages.CurrentPage().getParameters().get('finnumber').escapeHtml4();
 finID = ESAPI.encoder().SFDC_HTMLENCODE(finID);
  chargentId = ApexPages.CurrentPage().getParameters().get('Id');
  chargentId  = ESAPI.encoder().SFDC_HTMLENCODE(chargentId);
  finAccount = new Finance_Account__c();
  cOrder = new ChargentOrders__ChargentOrder__c();  
  this.c = (ChargentOrders__ChargentOrder__c)controller.getRecord();
     // Custom Label for Recurring Record Type
     c.RecordTypeId = System.label.Recurring_Record_Type;   
     // Commented by Aravind as the method is called on load method of the page   
     //    fetchdataRP();

         // ASSIGN BANK ACCOUNTS TO MAP FOR AUTO POPULATION ON CHANGE  

         BankAccs = New List<SelectOption> () ;

         if ( ApexPages.CurrentPage().getParameters().get('isfromBank') <> NULL  ) {
           isfromBank =ApexPages.CurrentPage().getParameters().get('isfromBank') ;
         }
         
         if ( ApexPages.CurrentPage().getParameters().get('finnumber') <> NULL ) {
              RecordMode = 'NEW' ;
                // LIST THE RELATED BANK ACCOUNTS IN DROP DOWN 
                BankAccRecords = New Map<String,Payment_Source__c> (PaymentsUtils.fetchBankAccs(finID)) ;
                if ( !BankAccRecords.isEmpty() ) {
    
                  for ( String a : BankAccRecords.keySet() ) {
                    SelBankAcc = a ;
                    Break;
                  }
                  BankAccs  = PaymentsUtils.fetchBankAccSelecOptions(finID,'NEW',NULL); 
                  populateRecords();
                } 
            

         } else if ( ApexPages.CurrentPage().getParameters().get('Id') <> NULL ) {
              RecordMode = 'EDIT' ;
                // LIST THE RELATED BANK ACCOUNTS IN DROP DOWN 
                
                ChargentOrders__ChargentOrder__c ChargentOrder = [SELECT Id, ChargentOrders__Charge_Amount__c, Payment_Source_Nickname__c, 
                Finance_Account_Number__r.Finance_Account_Number__c, Next_Withdrawal_Date__c, ChargentOrders__Charge_Date__c,
                ChargentOrders__Payment_Frequency__c, ChargentOrders__Payment_Count__c 
                FROM ChargentOrders__ChargentOrder__c 
                WHERE ID  = : chargentID ]; 
    
                NextTransactionDate = ChargentOrder.Next_Withdrawal_Date__c;
                this.c = (ChargentOrders__ChargentOrder__c)controller.getRecord();
                //this.c = (ChargentOrder ) ;
    
                SelBankAcc =  ChargentOrder.Payment_Source_Nickname__c ; 
                String FinNumber = ChargentOrder.Finance_Account_Number__r.Finance_Account_Number__c ;
                
                BankAccRecords = New Map<String,Payment_Source__c> (PaymentsUtils.fetchBankAccs(FinNumber)) ;
                BankAccs  = PaymentsUtils.fetchBankAccSelecOptions(FinNumber ,'EDIT',SelBankAcc); 
                populateRecords();
            
          } else {
              RecordMode = 'NULL' ;
          }
        
         
        
                
    }



          public void fetchdataRP(){

            orderRTMap = RecordTypeUtility.getOrderRecordTypes();
            gatewayRTMap = RecordTypeUtility.getgatewayRecordTypes();


            if(chargentId != null ) {
              cOrderRecordRP = [select recordtype.developername,Finance_Account_Number__r.Finance_Account_Number__c,Payment_Source_Nickname__c,ChargentOrders__Payment_Status__c from ChargentOrders__ChargentOrder__c where id = :ApexPages.CurrentPage().getParameters().get('Id') and Payment_Display_Status__c != 'Cancelled'];
              finID = cOrderRecordRP.Finance_Account_Number__r.Finance_Account_Number__c;
            }


            finAccount = [select id,Good_Through_Date__c,Region_Code__c,Finance_Account_Number__c,Due_On_Day__c,Fl_Charged_Off__c,Fl_Recurring_Payment_Eligible_Agent__c,Final_Due_Date__c,Account_Type__c,Regular_Monthly_Payment__c,Ownerid,Payoff_Amount__c,Fl_Refinanced__c,FI_Stop_Reinstate_Recurring_Payment__c,past_amount_due__c,next_due_date__c,name,Payment_Due_Date__c,Paid_to_Date__c from Finance_Account__c where Finance_Account_Number__c = :finID];
            orderMap = UtilityClass.getChargentOrders(finAccount.id);


         //Eligibility Checks    
         if(finaccount.Fl_Recurring_Payment_Eligible_Agent__c == true){
          eligibleFlagRP = true;
         
         
          // NEW BUSINESS RULE 5TH JAN FOR PAYMENT AMOUNT FIELD EDIT OR READ ONLY
          if(finaccount.Region_Code__c <> 'NRC'){
                if( finaccount.account_type__c == 'Lease'  || finaccount.Account_Type__c == 'Balloon'  ) {
                    readOnly = True;
                } 
                if(  finaccount.Account_Type__c == 'Balloon' && finAccount.Fl_Refinanced__c ) {
                    readOnly = False;
                }
          } 

          if(chargentId == null || chargentId == '')   { 

            //One time Payment Redirection 
            List<ChargentOrders__ChargentOrder__c> cOrdersOtp = new List<ChargentOrders__ChargentOrder__c>();
            if(orderRTMap.containsKey('One_Time_Payment')){
              cOrdersOtp = [select id,ChargentOrders__Charge_Amount__c 
              from ChargentOrders__ChargentOrder__c 
              where Finance_Account_Number__r.id = :finAccount.id 
              and recordtypeid = :orderRTMap.get('One_Time_Payment').Id 
              and Payment_Display_Status__c in('Pending','Processing')];    
            }
            
            System.debug(' finAccount.Past_Amount_Due__c  ==> ' + finAccount.Past_Amount_Due__c  );   
            //System.debug(' sumOfPayments  ==> ' + sumOfPayments );
            
            Decimal sumOfPayments = 0.0;

            for(ChargentOrders__ChargentOrder__c c : cOrdersOtp) {
              if(c.ChargentOrders__Charge_Amount__c != null) {
                sumOfPayments += c.ChargentOrders__Charge_Amount__c ;
              }
            }
            

            
            if(finAccount.Past_Amount_Due__c > 0 && sumOfPayments < finAccount.Past_Amount_Due__c) {
              OTPFlag = true ;
              flag = 1;
            }  

            

          // Existing RP Record 
          
          if(orderRTMap.containsKey('Recurring_Payment')){
            cOrders = [select id,ChargentOrders__Charge_Amount__c,ChargentOrders__Charge_Date__c,ChargentOrders__Next_Transaction_Date__c,Payment_Source_Nickname__r.Payment_Source_Nickname__c 
            from ChargentOrders__ChargentOrder__c 
            where Finance_Account_Number__r.id = :finAccount.id and recordtypeid =:orderRTMap.get('Recurring_Payment').Id 
            and Payment_Display_Status__c in ('Pending','Processing','Suspended')];
          }

          if(cOrders.size() > 0)
          {
            displayModeRP = true;
            flag = 1;
          }  


          // Preferred Bank Account Populate 
          cOrder = new ChargentOrders__ChargentOrder__c();
          List<Payment_Source__c> ps = new list<Payment_Source__c>();
          ps = [Select Payment_Source_Nickname__c,id,Preferred_Payment_Source__c,Last_4__c,Bank_Name__c from Payment_Source__c where Finance_Account_Number__r.id = :finAccount.id and Preferred_Payment_Source__c = true];
          if(ps.size() > 0) {
            this.c.Payment_Source_Nickname__c = ps[0].id;
            if(ps[0].Bank_Name__c != null && ps[0].Bank_Name__c != '')
            cOrder.ChargentOrders__Bank_Name__c=ps[0].Bank_Name__c;
          //system.debug(ps[0].Last_4__c);
          /* if(ps[0].Last_4__c.length() == 4)
          cOrder.Payment_Source_Nickname__r.Last_4__c = ps[0].Last_4__c;*/
        } 
        
        
        // Populate Charge Amount 
        
        if(finaccount.Regular_Monthly_Payment__c != null && finaccount.Regular_Monthly_Payment__c != 0){

          this.c.ChargentOrders__Charge_Amount__c = finaccount.Regular_Monthly_Payment__c;

        }             
        
        //New Regular Monthly Payment update
        
        if(finaccount.account_type__c == 'Lease' && finaccount.Regular_Monthly_Payment__c != 0) {
          if(orderMap.containsKey('Recurring_Payment')){
            cOrderListRP = orderMap.get('Recurring_Payment');
            cinsertNew = new ChargentOrders__ChargentOrder__c();
            cinsertNew.Monthly_Payment_Amount__c = finAccount.Regular_Monthly_Payment__c; 
            cinsertNew.id = cOrderListRP[0].id;
            update cinsertNew;
          }
        }
        
      }

    }
    else{         
      eligibleFlagRP = false;        
    }

  }
  
  Public Boolean isValidDate = True;
  
  public void checkDatevalue() {
    system.debug(' checkDatevalue() ==> ' + this.c.ChargentOrders__Charge_Date__c  + this.c);
   
   
    ChargeDate = this.c.ChargentOrders__Charge_Date__c;
   
    
   system.debug(' this.c.ChargentOrders__Charge_Date__c ==> ' + this.c.ChargentOrders__Charge_Date__c  + this.c.ChargentOrders__Charge_Amount__c  );
   
     //Start of defect 114290 by Jayashree 
    if(this.c.Skip_First__c && this.c.ChargentOrders__Charge_Date__c == NULL ) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,System.label.EasyPayChargeDateIsBlank));
        flag = 1;
    }
    
    //End of defect 114290

    // Defect: 113923 by Veera 06 APR 2016  STARTS

      else if ( this.c.ChargentOrders__Charge_Date__c <> NULL && !this.c.Skip_First__c) {
      
            NextTransactionDate = NWDManager.calculateNWD(c, Date.today(), false);
     } 
     
     //Defect: 113923 by Veera 06 APR 2016  ENDS
     
     //Start of defect 114290 by Jayashree 
     else if(this.c.Skip_First__c && this.c.ChargentOrders__Charge_Date__c != NULL ) {          
         
         NextTransactionDate = NWDManager.calculateNWD(c, Date.today(), true);
    }
    
   
    //End of defect 114290


       isValidDate = True;  

       //system.debug(this.c.ChargentOrders__Charge_Date__c);
       
       system.debug(' NextTransactionDate  ==> '+ NextTransactionDate  );

       //Date SelDate = Date.valueof(tmpDatetime);
       Date SelDate = NextTransactionDate ;
       Date DueDate = finaccount.Payment_Due_Date__c ;

       
       flag = 0;
       
       /*Adding as a part of RSS41359 fix */
       if(NextTransactionDate > finAccount.Final_Due_Date__c)
          {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Next Withdrawal Date cannot be beyond the final Payment Due Date'));
        flag = 1;
                        isValidDate = False;
          }

    if(finaccount.Region_Code__c <> 'NRC')
{
    if((finaccount.account_type__c == 'Lease') || (finaccount.account_type__c == 'Retail') || (finaccount.Account_Type__c == 'Balloon'))
    {        
            if(ChargeDate <> NULL ) 
        {                
                    
                    Integer startday=(Integer.valueof(finaccount.Due_On_Day__c))+1;
                    startday=(startday > 31? startday - 31 : startday);
                    Integer endday = (Integer.valueof(finaccount.Due_On_Day__c)) + 11;
                    endday = (endday> 31? endday- 31 : endday);
    
            if(Integer.valueof(chargeDate) >= startday && startday > EndDay)
            {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid date selected'));
                            flag = 1;
                            isValidDate = False;
                    }
                    else if (Integer.valueof(chargeDate) >= startday && Integer.valueof(chargeDate) < EndDay)
            {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid date selected'));
                            flag = 1;
                            isValidDate = False;
                    } 
                    else if (Integer.valueof(chargeDate) < EndDay && startday > EndDay)
            {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid date selected'));
                            flag = 1;
                            isValidDate = False;
                    }   


                }  
        }
} 

      
      //End of fix 114146
      
      //Jayashree Commented out Existing Business Rule for NRC for the defect 113988  
     /* else if(finaccount.Region_Code__c == 'NRC'){
        if(this.c.ChargentOrders__Charge_Date__c <> NULL ) {

          if ( integer.valueof(this.c.ChargentOrders__Charge_Date__c) != finaccount.Payment_Due_Date__c.Day() && DueDate.Daysbetween(SelDate) > 0 && DueDate.Daysbetween(SelDate) <= 7 ) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid date selected'));
            flag = 1;
            isValidDate = False;
          } 
        } 
      } */
    }     
    
    
    /* Method : On Selection of Bank Account Populate the Bank details */

    Public void populateRecords() {

     System.debug('*** populateRecords ==> ' + SelBankAcc );

     if ( SelBankAcc <> NULL ) {
       c.Payment_Source_Nickname__r            = BankAccRecords.get(SelBankAcc);
       c.ChargentOrders__Bank_Name__c          = BankAccRecords.get(SelBankAcc).Bank_Name__c ;
       c.Payment_Source_Nickname__r.Last_4__c  = BankAccRecords.get(SelBankAcc).Last_4__c ;
       bankAccntToken = BankAccRecords.get(SelBankAcc).ChargentOrders_Tokenization__c;
     }

   }

   public pageReference editRP() {
    readOnly = false;
    editMode = true;
    detailMode = false;
    return null;
  }
  
  public pageReference cancelRP(){
    String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
    String sfBaseProtocol = System.URL.getSalesforceBaseUrl().getProtocol();

    //remove namespace
    integer firstDotPos = sUrlRewrite.indexOf(System.Label.System_CL0014);
    sURlRewrite = sURlRewrite.substring(firstDotPos+1);

    //replace visual.force with salesforce
    sURlRewrite = sURlRewrite.replace(System.Label.System_CL0015, System.Label.System_CL0016);
    sUrlRewrite = sfBaseProtocol+System.Label.System_CL0017+sURlRewrite;
    //System.debug('URLrEWRITE: ' + sUrlRewrite );  
    if(chargentId == null || chargentId == '')   { 
     Pagereference p = new Pagereference(System.Label.System_CL0002+finAccount.Id);
     return p;
   }
   else{
    cOrderIDRedirect = [select Id from ChargentOrders__ChargentOrder__c where id=:chargentId];
    Pagereference p = new Pagereference(System.Label.System_CL0002+cOrderIDRedirect[0].Id);
    //Pagereference p = new Pagereference(+sUrlRewrite+'/a1Ug0000002Jfr8');
    p.setredirect(true);
    return p;
  }
  return null;
}

public void validationCheck() {
 flag = 0;
 errorColorNRC = 'None';  
 errorcolorCount = 'None'; 
    
    if ( this.c.ChargentOrders__Charge_Date__c == NULL ) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Select a Payment Start Date'));
        flag = 1;  
    }
    
   if ( SelBankAcc == Null ) {

   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You must select a Bank Account to continue.'));
   flag = 1;   

   } 
    //changed Error Message for defect # 113919 by Jayashree
   else if((( this.c.ChargentOrders__Charge_Amount__c)  == null )|| ( this.c.ChargentOrders__Charge_Amount__c <= 0)){
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'EasyPay amount cannot be equal to $0.00.'));
    flag = 1;   
  }
 
   else
      {
          /* if(this.c.ChargentOrders__Charge_Amount__c > finAccount.Regular_Monthly_Payment__c ){
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Amount cannot be greater than Regular Monthly Payment.'));  
                     flag=1;                 
                     } */

                     //if((this.c.ChargentOrders__Charge_Amount__c > finAccount.Payoff_Amount__c) && ( (finAccount.account_type__c == 'Retail') || (finAccount.account_type__c == 'Balloon' && finAccount.Fl_Refinanced__c == true) )){
                     if((this.c.ChargentOrders__Charge_Amount__c >= finAccount.Payoff_Amount__c) && ( (finAccount.account_type__c == 'Retail') || (finAccount.account_type__c == 'Balloon' && finAccount.Fl_Refinanced__c == true) )){  
          			   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Payment Amount cannot be greater than or equal to the payoff amount.'));  
                       flag = 1;
                     }

                     if((this.c.ChargentOrders__Charge_Amount__c < finAccount.Regular_Monthly_Payment__c) && ( (finAccount.account_type__c == 'Retail') || (finAccount.account_type__c == 'Balloon' && finAccount.Fl_Refinanced__c == true) ) ){
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Amount cannot be less than Regular Monthly Payment.'));  
                       flag = 1;
                     }  
                    
                    //Changes added to the defect 114004 by Jayashree

                     if( this.c.Deficiency_Account__c == true && (paymentCount == null  || !paymentCount.isNumeric())){
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'For NRC Accounts, please provide a valid Payment Count'));  
                       errorColorCount = 'Red';
                       flag = 1;
                       } 
                      
                      If(this.c.Deficiency_Account__c == true && (paymentCount != null  && paymentCount.isNumeric() && Integer.valueOf(paymentCount) == 0 )) {
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'For NRC Accounts, please provide a valid Payment Count'));  
                       errorColorCount = 'Red';
                       flag = 1;
                       } 
                      
                     
                     if( this.c.Deficiency_Account__c == false && (paymentCount.isNumeric() && Integer.valueOf(paymentCount) != 0 )){
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please check the box to confirm you are setting up EasyPay for an NRC Account'));  
                       errorColorNRC = 'Red';
                       flag = 1;
                     } 
                     
                     
                     //End of defect 114004
                   }
                 }

         public pageReference saveRP() {


           checkDatevalue();
           validationCheck();
           populateRecords();

           System.debug('isValidDate  ==>   ' + isValidDate  );

           if ( isValidDate  )  {

             if(flag != 1 ) {
             
               String BankAccRecordId = '';
               if(chargentID == null || chargentID == '')  {

                 cinsertNew = new ChargentOrders__ChargentOrder__c();
                 cinsertNew.ChargentOrders__Bank_Name__c = c.ChargentOrders__Bank_Name__c;
                 cinsertNew.Next_Withdrawal_Date__c = NextTransactionDate;
               // cinsertNew.Next_Withdrawal_Date__c =  Now.Today().format('yyyy-M', 'CDT')   ;

              
               cinsertNew.Payment_Source_Nickname__c = c.Payment_Source_Nickname__r.id;
               cinsertNew.ChargentOrders__Charge_Amount__c = this.c.ChargentOrders__Charge_Amount__c;
               cinsertNew.ChargentOrders__Charge_Date__c = this.c.ChargentOrders__Charge_Date__c;
               cinsertNew.ChargentOrders__Manual_Charge__c = true;
               cinsertNew.ChargentOrders__Payment_Method__c = 'check';
               cinsertNew.ChargentOrders__Payment_Status__c = 'Recurring';
               cinsertNew.Payment_Display_Status__c = 'Pending';
               cinsertNew.ChargentOrders__Payment_Stop__c = 'Date';
               cinsertNew.ChargentOrders__Payment_Frequency__c ='Monthly';
               //Added new line for RSS 41375 the CG AMS Leon & Rajesh
               cinsertNew.Skip_First__c = this.c.Skip_First__c;  
                  //Start of defect 114290 by Jayashree
               if ( PaymentsUtils.isBeforeCutOffTime() ) {
                       cinsertNew.ChargentOrders__Payment_Start_Date__c = system.today();
                   } else {
                       cinsertNew.ChargentOrders__Payment_Start_Date__c = system.today().AddDays(1);
                   }
               
               //End of defect 114290
               // cinsertNew.ChargentOrders__Payment_End_Date__c = finAccount.Final_Due_Date__c;
               cinsertNew.ChargentOrders__Payment_End_Date__c = finAccount.Final_Due_Date__c;

               cinsertNew.Payment_Type__c = 'R';
               cinsertNew.Payment_Channel__c = 'R';
               cinsertNew.Finance_Account_Number__c = finAccount.ID;
               cinsertNew.ChargentOrders__Tokenization__c=bankAccntToken;
               if(orderRTMap.containsKey('Recurring_Payment')){
                cinsertNew.recordtypeid = orderRTMap.get('Recurring_Payment').Id;
              }

              BankAccRecordId = c.Payment_Source_Nickname__r.Id ;
              
              if( this.c.Deficiency_Account__c ){
                cinsertNew.Deficiency_Account__c  = True ;
                cinsertNew.ChargentOrders__Payment_Stop__c = 'Count' ;
                cinsertNew.ChargentOrders__Payment_End_Date__c = NULL ;
                cinsertNew.ChargentOrders__Payment_Count__c  = Integer.valueOf(paymentCount);
               
              }
              //Changes added to the defect 114165 by Jayashree
               cinsertNew.Duplicate_Key_Tracker__c =  finID + 'Recurring_Payment' + 'ACTIVE';
              //End of defect 114165
              insert cinsertNew;

            }
            else {
            
             if( this.c.Deficiency_Account__c ){
                this.c.Deficiency_Account__c  = True ; 
                this.c.ChargentOrders__Payment_Stop__c = 'Count' ;
                this.c.ChargentOrders__Payment_End_Date__c = NULL ;
                this.c.ChargentOrders__Payment_Count__c  = Integer.valueOf(paymentCount);
             }
                
             this.c.ChargentOrders__Tokenization__c=bankAccntToken;
             this.c.Payment_Source_Nickname__c = c.Payment_Source_Nickname__r.id;
             this.c.Next_Withdrawal_Date__c = NextTransactionDate;
             BankAccRecordId = c.Payment_Source_Nickname__r.Id ;
             update c;

               //system.debug('Inside else');
             }
            

                Pagereference p = new Pagereference(System.Label.System_CL0002+finaccount.ID);
                if(IsFromBank == 'true'){
                  p = new Pagereference(System.Label.System_CL0002+BankAccRecordId);
                }
                p.setredirect(true);
                return p;

              }
              return null;
              } else {


               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid date selected'));
               return null;

             }        
           }



         }