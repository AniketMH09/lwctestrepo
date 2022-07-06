/* Apex Class Name       :    AHFC_EconfigModelIntegHandlerTest
* @description        	 :    Test Class for AHFC_EconfigModelIntegHandler
* Modification Log   	 :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Akash Solanki               29th July 2021          Created For US 6697
*********************************************************************************/
@isTest
public class AHFC_EconfigModelIntegHandlerTest {
    
    static Id custUserProfileId = [SELECT Id, Name FROM Profile Where Name = 'Customer'].Id;
    /**
* @description createTestData
**/
    @testSetup
    public static void createTestData(){
        List<Account> accList = new List<Account>();
        Id idSysAdmin = [select ID, Name FROM Profile where Name = 'System Administrator']?.Id;
        Id idPortalRole = [Select Id From UserRole where Name = 'Business Processes' Limit 1]?.Id;
        
        //insert System Admin
        User sysAdminUser = AHFC_TestDataFactory.getTestUser(idPortalRole, idSysAdmin, 'John', 'Lewis', true);
        System.runAS(sysAdminUser)
        {
            
            //create Person Accounts
            for(Integer i=0; i<5; i++){
                accList.add(AHFC_TestDataFactory.createPersonAccount());
            }
            if(!accList.isEmpty()){
                insert accList;
            }
            
            Account personAcc = [Select PersonContactId From Account Where Id = :accList[0].Id];
            //create community user 1
            User testUser = AHFC_TestDataFactory.getTestUser(null, custUserProfileId, 'John', 'Customer User', false);
            testUser.ContactId = personAcc.PersonContactId;
            insert testUser;
        }
    }
    
    /**
* @description testGetEconfig
**/
    @isTest 
    public static void testGetEconfig(){
        List<User> usr = [SELECT Id, Name FROM User Where Name Like 'John Customer User' AND ProfileId =:custUserProfileId];
        String modelId = '{ "@id": "TRX300X9"},';
        modelId +=     ' {"@id": "SXS10M3PL" }';
        String actualResponse = '{"TRX300X9":"OWNERLINK/images/mc_images/at/2009/hom_TRX300X_White.jpg","SXS10M3PL":"_/media/products/family/pioneer_1000/trims/trim_main/pioneer_1000/2020/2020_pioneer_1000_olive_650x380.png"}';
        System.runAs(usr[0]){
            
            Test.startTest();
            
            Test.setMock(HttpCalloutMock.class, new AHFC_EconfigModelIntegHandlerMock());
            String strresponse = AHFC_EconfigModelIntegHandler.getEconfigResponse(modelId);
            
            AHFC_EconfigModelResponseHandler.Asset_Z assetForModel = new AHFC_EconfigModelResponseHandler.Asset_Z();	
            assetForModel.id = '1327392';
            assetForModel.path = '-/media/products/family/pioneer-1000/trims/trim-main/pioneer-1000/2020/2020-pioneer-1000-olive-650x380.png';
            assetForModel.name = '2020-Pioneer-1000-Olive-650x380';
            assetForModel.type_cd = 'MCGMHRIMG';
            
            AHFC_EconfigModelResponseHandler.Assets_Z assets = new AHFC_EconfigModelResponseHandler.Assets_Z();
            assets.asset = null;
            
            AHFC_EconfigModelResponseHandler.Asset_color_match assetcolorMatch = new AHFC_EconfigModelResponseHandler.Asset_color_match();
            assetcolorMatch.color = null;
            
            AHFC_EconfigModelResponseHandler.AssetColor assetcolor = new AHFC_EconfigModelResponseHandler.AssetColor();
            assetcolor.id = '507';
            
            AHFC_EconfigModelResponseHandler.Mot mot = new AHFC_EconfigModelResponseHandler.mot();
            mot.db_results = null;
            
            AHFC_EconfigModelResponseHandler.Db_results dbresults = new AHFC_EconfigModelResponseHandler.Db_results();
            dbresults.assets = null;
            dbresults.models = null;
            
            AHFC_EconfigModelResponseHandler.Model model = new AHFC_EconfigModelResponseHandler.Model();
            model.id = 'SXS10M3PL';
            model.model_name = 'PIONEER 1000 EPS';
            model.assets = null;
            model.colors = null;
            
            AHFC_EconfigModelResponseHandler.Colors colorsOfModel = new AHFC_EconfigModelResponseHandler.Colors();
            colorsOfModel.exteriorcolor = null;
            
            AHFC_EconfigModelResponseHandler.Exteriorcolor extColor = new AHFC_EconfigModelResponseHandler.Exteriorcolor();
            extColor.id = '507';
            
            AHFC_EconfigModelResponseHandler.Assets assetss = new AHFC_EconfigModelResponseHandler.Assets();
            assetss.asset = null;
            
           	AHFC_EconfigModelResponseHandler.Models modelss = new AHFC_EconfigModelResponseHandler.Models();
            modelss.model = null;
            
            AHFC_EconfigModelResponseHandler.Asset assett = new AHFC_EconfigModelResponseHandler.Asset();
            assett.id = '507';
            
            Test.StopTest();
        }
    }
}