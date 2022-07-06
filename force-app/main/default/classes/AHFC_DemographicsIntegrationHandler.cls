/* Apex Class Name       :    AHFC_DemographicsIntegrationHandler
* Description        :    This Class is used to handle all integration updates related to Service Account Demographics
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Kanagaraj			         25 MAY 2021               Created
*********************************************************************************/

public without sharing class AHFC_DemographicsIntegrationHandler {
    public static Map<String,AHFC_Integration_Setting__mdt> mapIntSettings = AHFC_IntegrationLogUtil.getAllIntegrationSettings();
    public static final String GETDEMOGRAPHICSKEY = AHFC_GlobalConstans.GET_METHOD + AHFC_GlobalConstans.GETDEMOGRAPHICS;
    public static final String PUTDEMOGRAPHICSKEY = AHFC_GlobalConstans.PUT_METHOD + AHFC_GlobalConstans.PUTDEMOGRAPHICS;
    public AHFC_DemographicsIntegrationUtil objIntHandler = new AHFC_DemographicsIntegrationUtil();
    
    //Written By Kanagaraj | 25 MAY 2021
    /*
  * Description : This method is used to handle Get Demographics 
  * @return List reference : Returns DemographicsWrapper
  */
    public DemographicsWrapper handleGetDemographics(String strLookUpID) {
        String strDemographics=AHFC_GlobalConstans.EMPTY;
        DemographicsWrapper objDemographics;
        
        if(String.isNotBlank(strLookUpID) && mapIntSettings!=null && !mapIntSettings.isEmpty()
           && mapIntSettings.containsKey(GETDEMOGRAPHICSKEY)) {
               strDemographics = objIntHandler.makeGetDemographicsCallout(strLookUpID, mapIntSettings.get(GETDEMOGRAPHICSKEY));
               system.debug('strDemographics>>>>>'+strDemographics);
               objDemographics = (DemographicsWrapper) System.JSON.deserialize(strDemographics, DemographicsWrapper.class);
               return objDemographics;   
           }
        return null;
    }
    
    //Written By Kanagaraj | 25 MAY 2021
    /*
  * Description : This method is used to handle update other Demographics
  * @return List reference : Returns true if the update is successful else false
  */
    public AHFC_DemographicsIntegrationUtil.responseDemographyWrapper handleUpdateOtherDemographics(String strLookUpID, String strDemographicsBody){
       
        AHFC_DemographicsIntegrationUtil.responseDemographyWrapper responsewrpp = new AHFC_DemographicsIntegrationUtil.responseDemographyWrapper();
        if(String.isNotBlank(strDemographicsBody) && mapIntSettings!=null && !mapIntSettings.isEmpty()
           && mapIntSettings.containsKey(PUTDEMOGRAPHICSKEY)){
               return objIntHandler.handleUpdateOtherDemographics(strLookUpID, strDemographicsBody, mapIntSettings.get(PUTDEMOGRAPHICSKEY));
           }
        return responsewrpp;
    }
    
    public class DemographicsWrapper {
        @AuraEnabled
        public Address billToAddress;
        @AuraEnabled
        public Address garagingAddress;
        @AuraEnabled
        public OtherDemographics otherDemographics;
        @AuraEnabled
        public String statementSuppressed=AHFC_GlobalConstans.EMPTY;
    }    
    public class Address {
        @AuraEnabled
        public String addressLine1=AHFC_GlobalConstans.EMPTY;
        @AuraEnabled
        public String addressLine2=AHFC_GlobalConstans.EMPTY;
        @AuraEnabled
        public String addressType=AHFC_GlobalConstans.EMPTY;
        @AuraEnabled
        public String city=AHFC_GlobalConstans.EMPTY;
        @AuraEnabled
        public String county=AHFC_GlobalConstans.EMPTY;
        @AuraEnabled
        public String state=AHFC_GlobalConstans.EMPTY;
        @AuraEnabled
        public String zipCode=AHFC_GlobalConstans.EMPTY;
        @AuraEnabled
        public Boolean isNullBillingAddress=false;
    }
    public class OtherDemographics {
        @AuraEnabled
        public String lookupID=AHFC_GlobalConstans.EMPTY;
        @AuraEnabled
        public String cellPhone=AHFC_GlobalConstans.EMPTY;
        @AuraEnabled
        public String cellPhone2=AHFC_GlobalConstans.EMPTY;
        @AuraEnabled
        public String homePhone=AHFC_GlobalConstans.EMPTY;
        @AuraEnabled
        public String placeOfEmployment=AHFC_GlobalConstans.EMPTY;
        @AuraEnabled
        public String workPhone=AHFC_GlobalConstans.EMPTY;
    }
    
}