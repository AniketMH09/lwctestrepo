/*=====================================================================
* (c) 2018 Appirio - A Wipro Company, Inc
* Name: AHFC_Lease_Terms_Conditions_Controller.apex
* Description: Apex controller class for AHFC_Lease_Terms_Conditions apex page
* Created Date: 27th Feb 2019
* Created By: Naveen Pilla
*  ===================================================================== */
public class AHFC_Lease_Terms_Conditions_Controller {
    
    public string communityName {get; set;}
    //method name:- getCommunityName
    //purpose:- method to get Community Name and check in page to show header logo and footer text mesaage on it.
    public pageReference getCommunityName(){
        communityName = System.currentPageReference().getParameters().get('communityName');
        system.debug('communityName >>>>>>>> '+communityName);
        if(String.isBlank(communityName)){
            ErrorLog__c errorLog = new ErrorLog__c();
            errorLog.ClassName__c = Label.AHFC_Lease_Terms_Conditions_Controller;
            errorLog.ExceptionMsg__c = Label.AHFC_Lease_Terms_Conditions_Controller_Community ;
            insert errorLog;
        }
        
        return null;          
    }

}