//(c) 2018 Appirio Inc.
//Created By  : Anirudh
//Created Date: 04-03-2019
//Class Name  : AHFC_Knowledge_Controller_Test
//Purpose     : Test Class for AHFC_Knowledge_Controller
@isTest
public class AHFC_Knowledge_Controller_Test {
        
    
    @isTest
    public static void test_ForLoggedInUser(){
        LIST<PermissionSet> ps = [SELECT Id FROM PermissionSet 
                             WHERE Name =: Label.AHFC_HondaCommunityPermset 
                                OR Name =: Label.AHFC_AcuraCommunityPermset];
        
        for(Integer i = 0 ; i< 2; i++){
            
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = userinfo.getUserId();
            psa.PermissionSetId = ps[i].Id;
            insert psa;
        }
        
        
        System.Assert(AHFC_Knowledge_Controller.checkLoginUser() != null);
        AHFC_Knowledge_Controller.currentRequestURL = Label.HONDA_DOMAIN;
        System.Assert(AHFC_Knowledge_Controller.checkLoginUser()!=null);
    }
    
    @isTest
    public static void test_ForGuestUser() {
        
        Profile p = [SELECT id FROM Profile WHERE Name = 'Acura Help Center Profile'];
        User user = new User();
        user.ProfileID = p.id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username =   'acuralogin@test.org'; 
        user.CommunityNickname = 'testUser123';
        user.Alias = 't1';
        user.Email = 'acuralogin@test.org';
        user.IsActive = true;
        
        insert user;
        
        System.runAs(user) {
            System.Assert(AHFC_Knowledge_Controller.checkLoginUser() != null);
            AHFC_Knowledge_Controller.currentRequestURL = Label.HONDA_DOMAIN;
            System.Assert(AHFC_Knowledge_Controller.checkLoginUser() != null);
        }
    }
    
    @isTest
    public static void test_ForWronDomain() {
        
        AHFC_Knowledge_Controller.currentRequestURL = 'www.google.com';
        AHFC_Knowledge_Controller.checkLoginUser();
    }
}