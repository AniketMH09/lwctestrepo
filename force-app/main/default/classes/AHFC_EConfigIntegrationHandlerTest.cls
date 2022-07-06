/* Apex Class Name       :    AHFC_EConfigIntegrationHandlerTest
* @description        	 :    Test Class for AHFC_EConfigIntegrationHandler
* Modification Log   	 :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Akash Solanki               7th July 2021          Created
*********************************************************************************/
@isTest
public class AHFC_EConfigIntegrationHandlerTest {
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
        String inputVin = '{"@vin_number": "1HGCV1E3XLA000482","@division_cd": "A"},';
        inputVin+='{"@vin_number": "5FPYK3F10MB000075","@division_cd": "A"}';
        System.runAs(usr[0]){
            
            Test.startTest();
            
            Test.setMock(HttpCalloutMock.class, new AHFC_EConfigIntegrationHandlerMock());
            String strresponse = AHFC_EConfigIntegrationHandler.getEconfigResponse(inputVin);
            
            AHFC_eConfigResponseHandler.Message messageWrapper = new AHFC_eConfigResponseHandler.Message();	
            messageWrapper.msg_type = 'Informational';
            messageWrapper.msg_number = '5000';
            messageWrapper.cdata_section = 'No warnings.';
            AHFC_eConfigResponseHandler.Vin vinWrapper = new AHFC_eConfigResponseHandler.Vin();
            vinWrapper.error_action='No Input';
            vinWrapper.error_code ='612';
            vinWrapper.error_reason='Error Input';
            vinWrapper.vin_number='1HGCV1E3XLA000482';
            vinWrapper.model = null;
            AHFC_eConfigResponseHandler.asset assetWrapper = new AHFC_eConfigResponseHandler.asset();
            assetWrapper.id = '1334523';
            assetWrapper.path = 'https://automobiles.honda.com/-/media/Honda-Automobiles/Vehicles/2020/Accord Sedan/AW/Carshot/carshot_AccordSedan_front_ACCORD15TSPORT_2020_PlatinumWhitePearl_CV1E3LEW_NH-883P.png';
            assetWrapper.type_cd = 'BASECAR';
            assetWrapper.view_cd = '34FRONT';
            AHFC_eConfigResponseHandler.Dependency dependencyWrapper = new AHFC_eConfigResponseHandler.Dependency();
            dependencyWrapper.filename = '.2020.Accord Sedan';
            dependencyWrapper.name = '';
            dependencyWrapper.type = 'ModelGroup';
            AHFC_eConfigResponseHandler.Model modelWrapper = new AHFC_eConfigResponseHandler.Model();
            modelWrapper.trim_name = 'Sport';
            modelWrapper.id = 'CV1E3LEW';
            modelWrapper.make = 'Honda';
            modelWrapper.model_group_name = 'Accord Sedan';
            modelWrapper.model_name = 'ACCORD 1.5T SPORT';
            modelWrapper.model_year = '2020';
            modelWrapper.trans_name = '6 Speed Manual';
            modelWrapper.division_cd = 'A';
            modelWrapper.colors = null;
            AHFC_eConfigResponseHandler.Color colorWrapper = new AHFC_eConfigResponseHandler.Color();
            colorWrapper.id = '8889';
            ColorWrapper.base_color_name = 'White';
            ColorWrapper.color_cd = 'WB';
            ColorWrapper.color_type = 'E';
            ColorWrapper.mfg_color_cd = 'NH-883P';
            ColorWrapper.name = 'Platinum White Pearl';
            ColorWrapper.assets=null;
            AHFC_eConfigResponseHandler.Cache cacheWrapper = new AHFC_eConfigResponseHandler.Cache();
            cacheWrapper.filename = 'Honda Accord Doc';
            System.assertNotEquals(strresponse, null, 'Get Econfig Failed');
            
            Test.StopTest();
        }
    }
}