global class SuspenseAutoAssign implements Database.batchable<sObject>,Database.Stateful, Database.allowscallouts{

   global String query;
   //global Map<string, String> newEmailMap = new Map<String, String>();
  public Integer intCount=0;

   global Database.Querylocator start (Database.BatchableContext SC)
   {   
       	Date yesterday = system.today().adddays(-1); 
       	query = 'SELECT id,TranDesc__c,Error_Description__c,Origin_Code__c FROM Suspense__c where  CreatedDate = TODAY order by Origin_Code__c ';
       	return Database.getQueryLocator(query);
   }     

    global void execute(Database.BatchableContext SC,List<Suspense__c> RC) {
        
       
        //if (strId !='')
        //SuspenseCallOut.makeHttpCallforSuspenseBatch( strId );
    }
    
     global void finish(Database.BatchableContext SC) 
   {
        try
        {
          
        }
        catch(System.Exception ex)
        {
   System.Debug(' *** Exception  ==> ' + ex.getMessage() ); 
        }   
   } 
}