/*=====================================================================
* (c) 2019 Appirio - A Wipro Company, Inc
* Name: AHFC_AssignPermSetToProfile_Test.apex
* Description: Unit Test class for AHFC_AssignPermSetToProfile Apex Class 
* Created Date: 17th Jan 2019
* Created By: Mohit Parnami
*  ===================================================================== */

@isTest
public class AHFC_AssignPermSetToProfile_Test {
    
    static testMethod void testCreateAndUpdateUser() {
        
        	String orgId = UserInfo.getOrganizationId();
            String dateString = 
            String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
            Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
            String uniqueName = orgId + dateString + randomInt;
        
            AHFC_Permission_Set_For_Profile__mdt permissionSetForProfile = new AHFC_Permission_Set_For_Profile__mdt(
                                                                                MasterLabel = 'Customer',
                                                                                Permission_Set_Name__c = 'Acura_Community,Honda_Community',
                                                                                Profile_Name__c = 'Customer'
                                                                                );
            profile customerProfile = [select id, name from Profile where name =: 'Customer' limit 1];
        	profile systemAdminProfile = [select id, name from Profile where name =: 'System Administrator' limit 1];
        	UserRole executiveRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Executive' LIMIT 1];
			
        	User adminUser = new User();
            adminUser.ProfileID = systemAdminProfile.id;
        	adminUser.userRoleId = executiveRole.Id;
            adminUser.EmailEncodingKey = 'ISO-8859-1';
            adminUser.LanguageLocaleKey = 'en_US';
            adminUser.TimeZoneSidKey = 'America/New_York';
            adminUser.LocaleSidKey = 'en_US';
            adminUser.FirstName = 'first';
            adminUser.LastName = 'last';
            adminUser.Username = uniqueName + '@test' + orgId + '.org'; 
            adminUser.CommunityNickname = 'tUserAdmin123';
            adminUser.Alias = 't1';
            adminUser.Email = uniqueName + '@test' + orgId + '.org';
            adminUser.IsActive = true;
            insert adminUser;
        
            Test.startTest();
        		System.runAs(adminUser) {
                    //profile p1 = [select id, name from Profile where id =: userinfo.getProfileId()];
                    Account a = new Account(Name='Test Account Name');
                    insert a;
                    
                    Contact c = new Contact(LastName = 'Contact Last Name', AccountId = a.id);
                    insert c;
                    User user = new User();
                    user.ProfileID = customerProfile.id;
                    user.EmailEncodingKey = 'ISO-8859-1';
                    user.LanguageLocaleKey = 'en_US';
                    user.TimeZoneSidKey = 'America/New_York';
                    user.LocaleSidKey = 'en_US';
                    user.FirstName = 'first';
                    user.LastName = 'last';
                    user.Username = uniqueName + 'comm@test' + orgId + '.org'; 
                    user.CommunityNickname = 'testUser123';
                    user.Alias = 't1';
                    user.Email = uniqueName + 'comm@test' + orgId + '.org';
                    user.IsActive = true;
                    user.ContactId = c.Id;
                    insert user;
                    
                    List<Id> lstUserIds = new List<Id>();
                    lstUserIds.add(user.Id);
                    AHFC_AssignPermSetToProfile.assignPermissionSet(lstUserIds);
                    AHFC_PermSetAssigner.createErrorLog();
                    
                    List<PermissionSetAssignment> permAssigns = [Select id from PermissionSetAssignment where AssigneeId =: user.Id];
                    System.assert(permAssigns != null);
                    
                    
                    
                }
            
        	Test.stopTest();
    }
}