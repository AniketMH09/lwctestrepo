/*=====================================================================
* (c) 2018 Appirio - A Wipro Company, Inc
* Name: AHFC_Article_Pdf_Button_Controller.apex
* Description: Apex class for AHFC_Article_Pdf_Button Lightning Component
* Created Date: 11th Dec 2018
* Created By: Naveen Pilla
*  ===================================================================== */

public class AHFC_Article_Pdf_Button_Controller {

    @AuraEnabled
    public static Boolean getDownloadStatus(Id faqId){
        List<FAQ__Kav> faqList= [select id, Allow_Print_Download__c
                                 from FAQ__kav where id=:faqId];
        return faqList[0].Allow_Print_Download__c;
    }
}