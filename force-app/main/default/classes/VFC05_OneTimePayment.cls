/** @Author Hemamalini 
    @name VFC05_OneTimePayment
    @CreateDate 7_Oct_2015 
    @Description This class is used to create the Standard One-Time Payment and Principal One-Time Payment details 
    on Chargent Order. 
    @Version 1.0 **/


public with sharing class VFC05_OneTimePayment{
            public ChargentOrders__ChargentOrder__c c; 
            public boolean val1{get;set;}
            public boolean val2{get;set;}
            public ChargentOrders__ChargentOrder__c cOrderRecord;
            public String chargentID;
            public integer flag;
            public String hostValue;
            public final ChargentOrders__ChargentOrder__c acct;
            Map<String,RecordType>  orderRTMap ;  

    public VFC05_OneTimePayment(ApexPages.StandardController controller){           
            val1=false;           
            val2=true;
            this.acct = (ChargentOrders__ChargentOrder__c)controller.getRecord();
            orderRTMap = RecordTypeUtility.getOrderRecordTypes();
            this.c = (ChargentOrders__ChargentOrder__c)controller.getRecord();
            ChargentId = ApexPages.CurrentPage().getParameters().get('id');
            system.debug('Inside Constructor'+ChargentId);
            }           
   public pageReference EditFunction(){  
            String hostValue=ApexPages.currentPage().getHeaders().get('Host');
            cOrderRecord = [select id,recordtype.developername,Payment_Display_Status__c,ChargentOrders__Payment_Status__c from ChargentOrders__ChargentOrder__c where Id=:acct.id];
            if(cOrderRecord.Payment_Display_Status__c == 'Posted' || cOrderRecord.Payment_Display_Status__c == 'Processing' || cOrderRecord.Payment_Display_Status__c=='Cancelled'){
            flag=1;
            }
            if(flag==1){
            val1=false;
            }else{
            //PageReference newPage = new pagereference('https://cs17.salesforce.com/'+acct.Id+'/e?retURL=%2F'+acct.Id);
            val1=true;                      
            }
            return null;
          }
    public pageReference PageRedirect(){
           String hostValue=ApexPages.currentPage().getHeaders().get('Host');
           PageReference newPage = new pagereference(System.Label.System_CL0001+hostValue+System.Label.System_CL0002+acct.Id+System.Label.System_CL0003+acct.Id);
           newPage.setRedirect(true);
           return newpage;
        }
    public pageReference DeleteFuntion() {  
           cOrderRecord = [select id,Payment_Display_Status__c,ChargentOrders__Payment_Status__c from ChargentOrders__ChargentOrder__c where Id=:acct.id];
           ChargentOrders__ChargentOrder__c c = new ChargentOrders__ChargentOrder__c();
           c.ChargentOrders__Payment_Status__c = 'Complete';
           c.Payment_Display_Status__c = 'Cancelled';
           c.id = cOrderRecord.id;
           update c;            
           val2=false;           
           return null;
        }
  }