/*Apex Class Name   :   AHFC_FiservIntegrationHandlerTest
* Description       :   This is a test class for AHFC_FiservIntegrationHandler
* Created By        :   Akash Solanki
* Created on        :   25/5/2021
*********************************************************************************/
@isTest
private class AHFC_FiservIntegrationHandlerTest {

    
   @isTest
    static void testDocumentSearch(){
        Test.setMock(HttpCalloutMock.class, new AHFC_FiservIntegrationHandlerCalloutMock());
        String accountId ='00000200231885';
        String docType = 'STATEMENTS';
        AHFC_FiservIntegrationHandler.documentSearch(accountId, docType);
		system.assertEquals('00000200231885',accountId,'both accounts should be same');
    }
    
   @isTest
    static void testdocumentGet(){
        Test.setMock(HttpCalloutMock.class, new AHFC_FiservIntegrationDocGetCalloutMock());
        String docId ='ehKJ69WQ6NLeaCkByT37mImYDu_Pf_ePhmHwH3yy6rNZY2Wn3Wp-iHFHIys0ik3va0sRxzz0Q98yiw8J1AnUAsG3H4BncDdKkYNvspvWq8wuhmtf3HxfF_uKQviCwJQ1vZxLlVsXIsRckgi--AmV-adP_KuQvtU48tXjjjZQ2Cw..';
        AHFC_FiservIntegrationHandler.documentGet(docId);
        system.assertEquals('ehKJ69WQ6NLeaCkByT37mImYDu_Pf_ePhmHwH3yy6rNZY2Wn3Wp-iHFHIys0ik3va0sRxzz0Q98yiw8J1AnUAsG3H4BncDdKkYNvspvWq8wuhmtf3HxfF_uKQviCwJQ1vZxLlVsXIsRckgi--AmV-adP_KuQvtU48tXjjjZQ2Cw..',docId,'both docIDs should be same');
    }
}