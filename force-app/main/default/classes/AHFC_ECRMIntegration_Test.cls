/* Apex Class Name   :	AHFC_ECRMIntegration_Test
* Description        :  Test Class for AHFC_ECRMIntegration
* Created By         :	Kanagaraj
* Created on         :  03-June-2021
*********************************************************************************/

@isTest
public class AHFC_ECRMIntegration_Test {
    
    @isTest
    static void testAddressvalidation(){
    string address1 = '2080 Cabot Blvd W';
    string address2 = 'Langhorne';
    string city = 'CA';
    string state = 'PA';
    string zip = '90503';
    AHFC_ECRMintegration ecrmvalidation = new AHFC_ECRMintegration();
    AHFC_ECRMIntegrationHandler ecrmhandler = new AHFC_ECRMIntegrationHandler();
    AHFC_ECRMIntegrationHandler.ValidatedAddressWrapper validaddwrapper = new AHFC_ECRMIntegrationHandler.ValidatedAddressWrapper();
	 Test.setMock(HttpCalloutMock.class, new AHFC_ECRMIntegrationHandlerCalloutMock());
      validaddwrapper = AHFC_ECRMintegration.getValidatedAddress(address1,address2,city,state,zip);
     System.assertEquals(validaddwrapper.state, 'CA','State');
    }
}