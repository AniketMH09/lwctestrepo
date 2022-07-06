/* Apex Class Name       :    AHFC_RemoveAndUpdateAddressHandler
    * Description        :    This Class is used to Remove BillTo and Update Address
    * Modification Log   :
    * ---------------------------------------------------------------------------
    * Developer                          Date                   Description
    * ---------------------------------------------------------------------------
    * Prabu Mohanasundaram               15 JUNE 2021               Created
    * Prabu Mohanasundaram			     11 NOV  2021				Modified the handleRemoveBillToAddress
    															    method for getting the response of StatusCode
*********************************************************************************/
public with sharing class AHFC_RemoveAndUpdateAddressHandler {
    
    public static Map<String,AHFC_Integration_Setting__mdt> mapIntSettings = AHFC_IntegrationLogUtil.getAllIntegrationSettings();
    public static final String PUTADDRESSKEY = AHFC_GlobalConstans.PUTUPDATEADDRESS;
    public static final String REMOVEBILLTOADDRKEY = AHFC_GlobalConstans.DELETEREMOVEBILLTOADDRESS;
    
    /*
     * @author Prabu JUN 25 2021
     * Description : This method is used to handle update address 
     * @return List reference : Returns Boolean
     * @param : takes Json string as parameter
    */
    @AuraEnabled
    public static AHFC_AddressIntegrationUtil.responseAddressWrapper handleUpdateAddress(String strJSON){
        
        UpdateAddressWrapper objUpdAddrWrapper = (UpdateAddressWrapper )JSON.deserialize(strJSON, UpdateAddressWrapper.class);
        string zipformating = objUpdAddrWrapper.zipCode;
        objUpdAddrWrapper.zipCode = zipformating.replace('-',''); // Added by Kanagaraj for US_10480 & US_10481
        AHFC_AddressIntegrationUtil objIntHandler = new AHFC_AddressIntegrationUtil();
        AHFC_AddressIntegrationUtil.responseAddressWrapper objResponseAddress;
        if(objUpdAddrWrapper!=null && mapIntSettings!=null && !mapIntSettings.isEmpty()
            && mapIntSettings.containsKey(PUTADDRESSKEY)){
                objResponseAddress = objIntHandler.makeUpdateAddressCallout(JSON.serialize(objUpdAddrWrapper), mapIntSettings.get(PUTADDRESSKEY));
        }
        return objResponseAddress;
    }

    /*
     * @author Prabu JUN 25 2021
     * Description : This method is used to handle remove bill to address
     * @return List reference : Returns void
     * @param : takes string Id as Params
    */
    @AuraEnabled
    public static AHFC_AddressIntegrationUtil.removeBillToResponseWrapper handleRemoveBillToAddress(String strLookUpID){
        AHFC_AddressIntegrationUtil.removeBillToResponseWrapper objBilltoResponse;
        AHFC_AddressIntegrationUtil objIntHandler = new AHFC_AddressIntegrationUtil();
        if(String.isNotBlank(strLookUpID) && mapIntSettings!=null && !mapIntSettings.isEmpty()
            && mapIntSettings.containsKey(REMOVEBILLTOADDRKEY)){
               objBilltoResponse = objIntHandler.makeRemoveBillToAddrCallout(strLookUpID, mapIntSettings.get(REMOVEBILLTOADDRKEY));
                system.debug('billResponse-->'+objBilltoResponse);
        }
        return objBilltoResponse;
    }
   
    /*
     * @author Prabu JUN 25 2021
     * Description : This wrapper class used for storing response value
    */
    public class UpdateAddressWrapper{
        public String lookupID =AHFC_GlobalConstans.EMPTY;
        public String addressLine1=AHFC_GlobalConstans.EMPTY;
        public String addressLine2=AHFC_GlobalConstans.EMPTY;
        public String city=AHFC_GlobalConstans.EMPTY;
        public String state=AHFC_GlobalConstans.EMPTY;
        public String zipCode=AHFC_GlobalConstans.EMPTY;
        public String addressType=AHFC_GlobalConstans.EMPTY;
        public String county=AHFC_GlobalConstans.EMPTY;
        public Boolean isScrubbedAccepted=false;
    }
     
}