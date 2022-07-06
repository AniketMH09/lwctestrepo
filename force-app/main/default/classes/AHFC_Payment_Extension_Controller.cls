public class AHFC_Payment_Extension_Controller {
    //method name:- getNextMaturityDate
    //purpose:- method to change the date format and add requested months to current maturity date
    @AuraEnabled
    public static DateTime getNextMaturityDate(String currentMdate,Integer months){
        //add months to the current matturity date and format it
        try{
        if(currentMdate != null && currentMdate != '') {
            String[] strDate = currentMdate.split('-');
            Integer myIntYear = integer.valueOf(strDate[0]);
            Integer myIntMonth = integer.valueOf(strDate[1]);
            Integer myIntDate = integer.valueOf(strDate[2]);
            DateTime currentDate = DateTime.newInstance(myIntYear, myIntMonth, myIntDate);
            DateTime dt = currentDate.addMonths(months);
            String formattedDate = dt.format('MM/dd/YYYY');
            return dt;
            }
        // create errorlog if currentMdate is blank      
        else{
            ErrorLog__c errlog = new ErrorLog__c();
            errlog.className__c = Label.AHFC_Lease_Extension_Controller;
            errlog.ExceptionErrorMessage__c = Label.AHFC_Lease_Extension_Controller_Date;
            if(!Test.isRunningTest()) {
                 insert errlog;
            }
           // return null;
            }
            }catch(Exception e){
            ErrorLog__c errorLog = new ErrorLog__c();
                errorLog.ClassName__c = Label.AHFC_Lease_Extension_Controller;
                errorLog.ExceptionMsg__c = e.getMessage();
                if(!Test.isRunningTest()){
                    insert errorLog;
                }
            }
            return null;
    }
    @AuraEnabled
    public static DateTime getNextDueDate(String currentMdate,Integer months){
        //add months to the current matturity date and format it
        try{
        if(currentMdate != null && currentMdate != '') {
            String[] strDate = currentMdate.split('-');
            Integer myIntYear = integer.valueOf(strDate[0]);
            Integer myIntMonth = integer.valueOf(strDate[1]);
            Integer myIntDate = integer.valueOf(strDate[2]);
            DateTime currentDate = DateTime.newInstance(myIntYear, myIntMonth, myIntDate);
            DateTime dt = currentDate.addMonths(months);
            String formattedDate = dt.format('MM/dd/YYYY');
            return dt;
            }
        // create errorlog if currentMdate is blank      
        else{
            ErrorLog__c errlog = new ErrorLog__c();
            errlog.className__c = Label.AHFC_Lease_Extension_Controller;
            errlog.ExceptionErrorMessage__c = Label.AHFC_Lease_Extension_Controller_Date;
            if(!Test.isRunningTest()) {
                 insert errlog;
            }
           // return null;
            }
            }catch(Exception e){
            ErrorLog__c errorLog = new ErrorLog__c();
                errorLog.ClassName__c = Label.AHFC_Lease_Extension_Controller;
                errorLog.ExceptionMsg__c = e.getMessage();
                if(!Test.isRunningTest()){
                    insert errorLog;
                }
            }
            return null;
    }
}