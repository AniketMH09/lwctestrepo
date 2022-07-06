/* Apex Class Name   :    AHFC_DDC_LE_Flow_Controller_Test
* Description        :    This is a test class of AHFC_DDC_LE_Flow_Controller.
* Modification Log   :
* ---------------------------------------------------------------------------
* Developer                           Date                   Description 
* ---------------------------------------------------------------------------
Sagar                               3rd  Aug 2021             Created  
Prabu Mohanasundaram				22nd Nov 2021             Modified
*********************************************************************************/
/**
 * @description: This method will return the Fiance Account Number if the User is a Valid User.
 * @author Sagar| Aug 3rd 2021
 * @return Finance Account Number
 * @param
 **/
@isTest
public class AHFC_DDC_LE_Flow_Controller_Test {
    @isTest
    public static void checkValidUser() {
        profile profileRecord = [select id, name from Profile where usertype = 'CspLitePortal'
            and name =: 'Customer'
            limit 1
        ];
        User userRecord = [Select id, username from user where userroleId != null and isActive = true and Profile.name = 'System Administrator'
            limit 1
        ];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        Account accObj;
        Contact conObj;
        Contact conObj2;
        User userObj;
        system.runAs(userRecord) {
            accObj = new Account(Name = 'Test Account Name');
            insert accObj;
            conObj = new Contact(LastName = 'Contact Last Name', AccountId = accObj.id);
            insert conObj;
            conObj2 = new Contact(LastName = 'Honda', AccountId = accObj.id);
            insert conObj2;
            userObj = new User();
            userObj.ProfileID = profileRecord.id;
            userObj.EmailEncodingKey = 'ISO-8859-1';
            userObj.LanguageLocaleKey = 'en_US';
            userObj.TimeZoneSidKey = 'America/New_York';
            userObj.LocaleSidKey = 'en_US';
            userObj.FirstName = 'first';
            userObj.LastName = 'last';
            userObj.Username = uniqueName + '@test' + orgId + '.org';
            userObj.CommunityNickname = 'testUser123';
            userObj.Alias = 't1';
            userObj.Email = uniqueName + '@test' + orgId + '.org';
            userObj.IsActive = true;
            userObj.ContactId = conObj.Id;
            insert userObj;
        }

        Finance_Account__c fAccount = new Finance_Account__c(Finance_Account_Number__c = '00000422318042', Contact__c = conObj.Id);
        insert fAccount;

        Customer_Finance_Account__c cFinanceAcc = new Customer_Finance_Account__c(Finance_Account__c = fAccount.Id, Customer__c = accObj.Id);
        insert cFinanceAcc;
        System.runAs(userObj) {

            String finAccNumber = AHFC_DDC_LE_Flow_Controller.getFinanceAccountNumber(fAccount.Finance_Account_Number__c);
            System.assertEquals(fAccount.Finance_Account_Number__c, finAccNumber, 'both the finance account number should be same');
            AHFC_DDC_LE_Flow_Controller.getFinanceAccountNumber('test');
            AHFC_DDC_LE_Flow_Controller.getFinanceAccountNumber('');

        }
    }
    /**
     * @description: It will cover the when finance account contact ID is different from Logged in User contactID.
     * @author Prabu| Nov 22nd 2021
     **/

    @isTest
    public static void whenAccContactIdDiffUserContactId() {
        profile profileRecord = [select id, name from Profile where usertype = 'CspLitePortal'
            and name =: 'Customer'
            limit 1
        ];
        User userRecord = [Select id, username from user where userroleId != null and isActive = true and Profile.name = 'System Administrator'
            limit 1
        ];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        Account accObj;
        Contact conObj;
        Contact conObj2;
        User userObj;
        system.runAs(userRecord) {
            accObj = new Account(Name = 'Test Account Name');
            insert accObj;
            conObj = new Contact(LastName = 'Contact Last Name', AccountId = accObj.id);
            insert conObj;
            conObj2 = new Contact(LastName = 'Honda', AccountId = accObj.id);
            insert conObj2;
            userObj = new User();
            userObj.ProfileID = profileRecord.id;
            userObj.EmailEncodingKey = 'ISO-8859-1';
            userObj.LanguageLocaleKey = 'en_US';
            userObj.TimeZoneSidKey = 'America/New_York';
            userObj.LocaleSidKey = 'en_US';
            userObj.FirstName = 'first';
            userObj.LastName = 'last';
            userObj.Username = uniqueName + '@test' + orgId + '.org';
            userObj.CommunityNickname = 'testUser123';
            userObj.Alias = 't1';
            userObj.Email = uniqueName + '@test' + orgId + '.org';
            userObj.IsActive = true;
            userObj.ContactId = conObj.Id;
            insert userObj;
        }

        Finance_Account__c fAccount = new Finance_Account__c(Finance_Account_Number__c = '00000422318042', Contact__c = conObj2.Id);
        insert fAccount;

        Customer_Finance_Account__c cFinanceAcc = new Customer_Finance_Account__c(Finance_Account__c = fAccount.Id, Customer__c = accObj.Id);
        insert cFinanceAcc;
        System.runAs(userObj) {

            String finAccNumber = AHFC_DDC_LE_Flow_Controller.getFinanceAccountNumber(fAccount.Finance_Account_Number__c);
            System.assertEquals(fAccount.Finance_Account_Number__c, finAccNumber, 'both the finance account number should be same');


        }
    }
    /**
     * @description: It will cover when the user is Invalid , it will retrun the fNumber as a invalidUser
     * @author Sagar| Nov 22nd 2021
     **/

    @isTest
    public static void getfinaccnumber3() {
        profile profileRecord = [select id, name from Profile where usertype = 'CspLitePortal'
            and name =: 'Customer'
            limit 1
        ];
        User userRecord = [Select id, username from user where userroleId != null and isActive = true and Profile.name = 'System Administrator'
            limit 1
        ];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        Account accObj;
        Account accObj2;
        Contact conObj;
        Contact conObj2;
        User userObj;
        system.runAs(userRecord) {
            accObj = new Account(Name = 'HondaSports');
            insert accObj;
            accObj2 = new Account(Name = 'HondaMarine');
            insert accObj2;
            conObj = new Contact(LastName = 'Contact Last Name', AccountId = accObj.id);
            insert conObj;
            conObj2 = new Contact(LastName = 'Honda', AccountId = accObj2.id);
            insert conObj2;
            userObj = new User();
            userObj.ProfileID = profileRecord.id;
            userObj.EmailEncodingKey = 'ISO-8859-1';
            userObj.LanguageLocaleKey = 'en_US';
            userObj.TimeZoneSidKey = 'America/New_York';
            userObj.LocaleSidKey = 'en_US';
            userObj.FirstName = 'first';
            userObj.LastName = 'last';
            userObj.Username = uniqueName + '@test' + orgId + '.org';
            userObj.CommunityNickname = 'testUser123';
            userObj.Alias = 't1';
            userObj.Email = uniqueName + '@test' + orgId + '.org';
            userObj.IsActive = true;
            userObj.ContactId = conObj2.Id;
            insert userObj;
        }

        Finance_Account__c fAccount = new Finance_Account__c(Finance_Account_Number__c = '00000422318042', Contact__c = conObj.Id);
        insert fAccount;

        Customer_Finance_Account__c cFinanceAcc = new Customer_Finance_Account__c(Finance_Account__c = fAccount.Id, Customer__c = accObj.Id);
        insert cFinanceAcc;
        System.runAs(userObj) {

            String finAccNumber = AHFC_DDC_LE_Flow_Controller.getFinanceAccountNumber(fAccount.Finance_Account_Number__c);
            System.assertEquals(fAccount.Finance_Account_Number__c, '00000422318042', 'both the finance account number should be same');
        }
    }
}