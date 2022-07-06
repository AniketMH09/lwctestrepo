public class paymentEditRedirect {
    
    @TestVisible private final ChargentOrders__ChargentOrder__c c; //variable for the Contact object
    public List<ChargentOrders__ChargentOrder__c> cOrderIDRedirect{get;set;}
    public List<Finance_Account__c> finaccount{get;set;}
    public String chargentID;
    public String finID{get;set;}   
    // constructor
    public paymentEditRedirect(ApexPages.StandardController standardPageController) {
        c = (ChargentOrders__ChargentOrder__c)standardPageController.getRecord(); //initialize the standard controller
         cOrderIDRedirect = new List<ChargentOrders__ChargentOrder__c>();   
          chargentId = ApexPages.CurrentPage().getParameters().get('Id');
            finAccount = new List<Finance_Account__c>();
           finID = ApexPages.CurrentPage().getParameters().get('finnumber');
    }
    
    public PageReference redirPage()

    {

        try

        { 
            
            Id profileId = UserInfo.getprofileid();
    
            String profileName = [Select Id, Name from Profile where Id =: profileId ].Name;
           
            System.debug('Profile name:'+profileName ); 
            
            if(profileName.equalsIgnoreCase('Agent') || profileName.equalsIgnoreCase('NPC') || profileName.equalsIgnoreCase('System Administrator') || profileName.equalsIgnoreCase('iConnect Support Team') || profileName.equalsIgnoreCase('Prod Support') || profileName.equalsIgnoreCase('NBS Agent'))
            {      
                //Added for Defect Number 112886. A condition which will check the payment status is Reseaching or not.  
                ChargentOrders__ChargentOrder__c ChargeOrderInstance = new ChargentOrders__ChargentOrder__c();         
                ChargeOrderInstance = [select id,Payment_Display_Status__c,ChargentOrders__Payment_Start_Date__c,recordtype.developername from ChargentOrders__ChargentOrder__c where id =: c.id];
                
                //Date today = date.today();
                Honda_Finance__c hfc = Honda_Finance__c.getOrgDefaults();
                
                //SFDC cut-off time Defect Id:113016
                String PaymentDate;
                Date paymentDateCheck ;
                
                Date today = Date.today();
                String dateString = today.format();
                String[] todayDate = dateString.split(System.Label.System_CL0002);
                Date todayCheck = Date.newInstance(integer.valueOf(todayDate[2]),integer.valueOf(todayDate[0]),integer.valueOf(todayDate[1]));
                
                if(ChargeOrderInstance.ChargentOrders__Payment_Start_Date__c!=null)
                {
                    paymentDate =ChargeOrderInstance.ChargentOrders__Payment_Start_Date__c.format();
                }               
                else
                {
                    paymentDate=null;
                }
                
                if(paymentDate != null && paymentDate != ''){        
                String[] myDateOnly = PaymentDate.split(' ');
                String[] strDate = myDateOnly[0].split(System.Label.System_CL0002); 
                paymentDateCheck = Date.newInstance(integer.valueOf(strDate[2]),integer.valueOf(strDate[0]),integer.valueOf(strDate[1]));     
                }
                
                
                if(chargeOrderInstance.Payment_Display_Status__c != Null)
                {
                    if(ChargeOrderInstance.Payment_Display_Status__c == 'Researching')
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You may not modify this Payment since its status is Researching.')); 
                        return null;
                    }else if(ChargeOrderInstance.Payment_Display_Status__c == 'Cancelled')
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You may not modify this Payment since its status is Cancelled.')); 
                        return null;
                    }else if(ChargeOrderInstance.Payment_Display_Status__c == 'Processing')
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You may not modify this Payment since its status is Processing.')); 
                        return null;
                    }else if(ChargeOrderInstance.Payment_Display_Status__c == 'Posted')
                    { // added by kanagaraj for US_3800
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You may not modify this Payment since its status is Posted.')); 
                        return null;
                    }else if(ChargeOrderInstance.Payment_Display_Status__c == 'Cleared to GL')
                    { // added by kanagaraj for US_3800
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You may not modify this Payment since its status is Cleared to GL.')); 
                        return null;
                    }else if(ChargeOrderInstance.Payment_Display_Status__c == 'Complete')
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You are not allowed to edit this Payment Since the status is Complete.')); 
                        return null;
                    }
                    else if((ChargeOrderInstance.recordtype.developername == 'Recurring_Payment') && (ChargeOrderInstance.Payment_Display_Status__c == 'Stopped'))
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You are not allowed to edit this Payment Since the status is Stopped.')); 
                        return null;
                    }//Defect Id:113016
                    else if( ChargeOrderInstance.recordtype.developername != 'Recurring_Payment' && (paymentDateCheck < todayCheck)  && (paymentDate !=null && paymentDate != '') )
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Payments may not be edited or cancelled after the cutoff time on the payment date.')); 
                        return null;
                    } //Defect:114097 :Added payment date condition :modified by Tiru
                    else if((ChargeOrderInstance.recordtype.developername != 'Recurring_Payment') && (ChargeOrderInstance.Payment_Display_Status__c == 'Pending') && (paymentDateCheck == todayCheck) && (Datetime.now().format('HH:mm:ss a') > hfc.CutOff_Time__c.format('HH:mm:ss a')))
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Payments may not be edited or cancelled after the cutoff time on the payment date.')); 
                        return null;
                    }
                    else if((ChargeOrderInstance.recordtype.developername == 'Recurring_Payment') && ChargeOrderInstance.Payment_Display_Status__c == 'Pending')
                    {
                        return redirectToVFPage();
                    }
                }
                
                return redirectToVFPage();
    
             }else
              {
    
                    PageReference p = new PageReference(System.Label.System_CL0002 + ChargentOrders__ChargentOrder__c.SObjectType.getDescribe().getKeyPrefix() + System.Label.System_CL0004);   
                    Map<String, String> m = p.getParameters();   
                    m.putAll(ApexPages.currentPage().getParameters());                      
    
                    m.put('nooverride', '1');                       
    
                    p.setRedirect(true);
    
                    return p;
    
             }
           

        }

        catch(Exception l_objEx)

        {           

            String l_stMsg = 'Exception while redirecting to Samples & Literature VF page.';
            String l_stErrMessage = l_objEx.getTypeName()+': '+l_stMsg;
            System.debug(l_stErrMessage);
            return null;

        }
}
    
    //method invoked from the Visualforce pages action attribute
    public PageReference redirectToVFPage() {
        Pagereference p;
        ChargentOrders__ChargentOrder__c recordDetails = [SELECT recordtype.developername FROM ChargentOrders__ChargentOrder__c WHERE Id = :c.Id]; 
        if(recordDetails.recordtype.developername == 'Recurring_Payment'){
        //p = new Pagereference(System.Label.System_CL0005+c.ID);
        p = new Pagereference(System.Label.System_CL0002+c.ID);
        p.setredirect(true);
        }else if(recordDetails.recordtype.developername == 'Payoff_Payment'){
        p = new Pagereference(System.Label.System_CL0006+c.ID);
        p.setredirect(true);
        }else if(recordDetails.recordtype.developername == 'Principal_One_Time_Payment'){
        p = new Pagereference(System.Label.System_CL0007+c.ID);
        p.setredirect(true);
        }else if(recordDetails.recordtype.developername == 'One_Time_Payment'){
        p = new Pagereference(System.Label.System_CL0008+c.ID);
        p.setredirect(true);
        }
        
        return p;
    }



 public pageReference goBack(){
     
           cOrderIDRedirect = [select Id,Finance_Account_Number__c from ChargentOrders__ChargentOrder__c where id=:chargentId];  
           //finID = this.c.Finance_Account_Number__r.Finance_Account_Number__c;
           finAccount = [select id,Finance_Account_Number__c from Finance_Account__c where Finance_Account_Number__c =: finID ];
           Pagereference p = new Pagereference('/'+cOrderIDRedirect[0].Finance_Account_Number__c);    
           //Pagereference p = new Pagereference(+sUrlRewrite+'/a1Ug0000002Jfr8');     
           p.setredirect(true);    
           return p;    
             } 
             
    }