public class Batcherror{
     
        public Batcherror(String errorMessage, String className, String AffectedId,String requestBody,String responseBody) {
            this.className = className;
            this.errorMessage = errorMessage;
            this.AffectedId = AffectedId;
            this.requestBody = requestBody;
            this.responseBody = responseBody;
            lstBatchError.add(this);
            system.debug(lstBatchError) ;
        }
        public Batcherror(){
            
        }
	 public String className;
     public String errorMessage;
     public String AffectedId;
     public String requestBody;
     public String responseBody;
     public static list<Batcherror> lstBatchError = new list<Batcherror>();
     public static void publishBatcherrors(){
         
         for (Batcherror btcherr :Batcherror.lstBatchError){
             
             UtilitiyMethods.createErrorlogevt(btcherr.errorMessage, btcherr.className, btcherr.AffectedId,btcherr.requestBody, btcherr.responseBody);
             
         }
        
    } 
    
    
	}