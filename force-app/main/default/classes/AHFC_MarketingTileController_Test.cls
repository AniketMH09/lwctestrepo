/* Apex Class Name   :    AHFC_MarketingTileController_Test
* @Description        :    This is the Test Class of AHFC_MarketingTileController
* Modification Log   :
* --------------------------------------------------------------------------- 
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Saikiran Doddeni              Jun 25 2021             Created
* Narain              			Jan 11 2022             Updated

*********************************************************************************/

@isTest
public class AHFC_MarketingTileController_Test {
    @isTest
    static void AHFC_MarketingTile_Test()
    {
        Finance_Account__c finacc = new Finance_Account__c();
        Finance_Account__c finacc2 = new Finance_Account__c();
        Finance_Account__c finacc3 = new Finance_Account__c();
        Finance_Account__c finacc4 = new Finance_Account__c();
        Finance_Account__c finacc5 = new Finance_Account__c();
        Finance_Account__c finacc6 = new Finance_Account__c();
        Finance_Account__c finacc7 = new Finance_Account__c();
        Finance_Account__c finacc8 = new Finance_Account__c();
        Finance_Account__c finacc9 = new Finance_Account__c();
        Finance_Account__c finacc10 = new Finance_Account__c();
        Finance_Account__c finacc11 = new Finance_Account__c();
        Finance_Account__c finacc12 = new Finance_Account__c();
        Finance_Account__c finacc13 = new Finance_Account__c();
        Finance_Account__c finacc14 = new Finance_Account__c();
        Finance_Account__c finacc15 = new Finance_Account__c();
        
        
        finacc.Finance_Account_Number__c='2541345678';
        finacc.Honda_Brand__c='HFS';
        finacc.Account_Type__c='Balloon';
        finacc.Maturity_Date__c=System.today().addDays(400);
        finacc.AHFC_Product_Type__c = 'Auto';
        
        finacc2.Finance_Account_Number__c='2541345612';
        finacc2.Honda_Brand__c='AFS';
        finacc2.Account_Type__c='Balloon';
        finacc2.Maturity_Date__c=System.today().addDays(400);
        finacc2.AHFC_Product_Type__c = 'Auto';
        
        finacc3.Finance_Account_Number__c='2541345623';
        finacc3.Honda_Brand__c='HFSP';
        finacc3.Account_Type__c='Balloon';
        finacc3.Maturity_Date__c=System.today();
        finacc3.AHFC_Product_Type__c = 'Marine';
        
        finacc4.Finance_Account_Number__c='25413454541';
        finacc4.Honda_Brand__c='HFSP';
        finacc4.Account_Type__c='Balloon';
        finacc4.Maturity_Date__c=System.today();
        finacc4.AHFC_Product_Type__c = 'Powersports';
        
        finacc5.Finance_Account_Number__c='25413752455';
        finacc5.Honda_Brand__c='HFSP';
        finacc5.Account_Type__c='Balloon';
        finacc5.Maturity_Date__c=System.today();
        finacc5.AHFC_Product_Type__c = 'Power Equipment';
        
        finacc6.Finance_Account_Number__c='25413453465';
        finacc6.Honda_Brand__c='HFS';
        finacc6.Account_Type__c='Lease';
        finacc6.Maturity_Date__c=Date.today().addDays(-400);
        finacc6.AHFC_Product_Type__c = 'Auto';
        
        finacc7.Finance_Account_Number__c='25414565353';
        finacc7.Honda_Brand__c='AFS';
        finacc7.Account_Type__c='Lease';
        finacc7.Maturity_Date__c=system.today().addDays(-400);
        finacc7.AHFC_Product_Type__c = 'Auto';
        
        finacc8.Finance_Account_Number__c='254134545212';
        finacc8.Honda_Brand__c='';
        finacc8.Account_Type__c='';
        finacc8.Maturity_Date__c=system.today().addDays(200);
        finacc8.AHFC_Product_Type__c = '';
        
        finacc9.Finance_Account_Number__c='25414585353';
        finacc9.Honda_Brand__c='AFS';
        finacc9.Account_Type__c='Lease';
        finacc9.Maturity_Date__c=system.today().addDays(-90);
        finacc9.AHFC_Product_Type__c = 'Auto';
        
        
        finacc10.Finance_Account_Number__c='25414265353';
        finacc10.Honda_Brand__c='HFS';
        finacc10.Account_Type__c='Lease';
        finacc10.Maturity_Date__c=system.today().addDays(-25);
        finacc10.AHFC_Product_Type__c = 'Auto';
        
        
        finacc11.Finance_Account_Number__c='25414585323';
        finacc11.Honda_Brand__c='AFS';
        finacc11.Account_Type__c='Lease';
        finacc11.Maturity_Date__c=system.today().addDays(200);
        finacc11.AHFC_Product_Type__c = 'Auto';
        
        finacc12.Finance_Account_Number__c='25417265353';
        finacc12.Honda_Brand__c='HFS';
        finacc12.Account_Type__c='Lease';
        finacc12.Maturity_Date__c=system.today().addDays(200);
        finacc12.AHFC_Product_Type__c = 'Auto';
        
        finacc13.Finance_Account_Number__c='25417265351';
        finacc13.Honda_Brand__c='HFS';
        finacc13.Account_Type__c='Lease';
        finacc13.Maturity_Date__c=system.today().addDays(200);
        finacc13.AHFC_Product_Type__c = 'Other';
        
        finacc14.Finance_Account_Number__c='25417265359';
        finacc14.Honda_Brand__c='AFS';
        finacc14.Account_Type__c='Lease';
        finacc14.Maturity_Date__c=system.today().addDays(200);
        finacc14.AHFC_Product_Type__c = 'Other';
        
        finacc15.Finance_Account_Number__c='25417267359';
        finacc15.Honda_Brand__c='HFSP';
        finacc15.Account_Type__c='Lease';
        finacc15.Maturity_Date__c=system.today().addDays(200);
        finacc15.AHFC_Product_Type__c = 'Other';
        
        insert finacc;
        insert finacc2;
        insert finacc3;
        insert finacc4;
        insert finacc5;
        insert finacc6;
        insert finacc7;
        insert finacc8;
        insert finacc9;
        insert finacc10;
        insert finacc11;
        insert finacc12;
        insert finacc13;
        insert finacc14;
        insert finacc15;
        
        AHFC_MarketingTileController.MarketingWrapper Test_ex1 = new AHFC_MarketingTileController.MarketingWrapper();
        AHFC_MarketingTileController.MarketingWrapper Test_ex2 = new AHFC_MarketingTileController.MarketingWrapper();
        AHFC_MarketingTileController.MarketingWrapper Test_ex3 = new AHFC_MarketingTileController.MarketingWrapper();
        AHFC_MarketingTileController.MarketingWrapper Test_ex4 = new AHFC_MarketingTileController.MarketingWrapper();
        AHFC_MarketingTileController.MarketingWrapper Test_ex5 = new AHFC_MarketingTileController.MarketingWrapper();
        AHFC_MarketingTileController.MarketingWrapper Test_ex6 = new AHFC_MarketingTileController.MarketingWrapper();
        AHFC_MarketingTileController.MarketingWrapper Test_ex7 = new AHFC_MarketingTileController.MarketingWrapper();
        AHFC_MarketingTileController.MarketingWrapper Test_ex8 = new AHFC_MarketingTileController.MarketingWrapper();
        AHFC_MarketingTileController.MarketingWrapper Test_ex9 = new AHFC_MarketingTileController.MarketingWrapper();
        AHFC_MarketingTileController.MarketingWrapper Test_ex10 = new AHFC_MarketingTileController.MarketingWrapper();
		AHFC_MarketingTileController.MarketingWrapper Test_ex11 = new AHFC_MarketingTileController.MarketingWrapper();
		AHFC_MarketingTileController.MarketingWrapper Test_ex12 = new AHFC_MarketingTileController.MarketingWrapper();
		AHFC_MarketingTileController.MarketingWrapper Test_ex13 = new AHFC_MarketingTileController.MarketingWrapper();
		AHFC_MarketingTileController.MarketingWrapper Test_ex14 = new AHFC_MarketingTileController.MarketingWrapper();
		AHFC_MarketingTileController.MarketingWrapper Test_ex15 = new AHFC_MarketingTileController.MarketingWrapper();

        
        Test.startTest();
        Test_ex1 = AHFC_MarketingTileController.marketingFlagRetrieve(finacc.Id);
        Test_ex2 = AHFC_MarketingTileController.marketingFlagRetrieve(finacc2.Id);
        Test_ex3 = AHFC_MarketingTileController.marketingFlagRetrieve(finacc3.Id);
        Test_ex4 = AHFC_MarketingTileController.marketingFlagRetrieve(finacc4.Id);
        Test_ex5 = AHFC_MarketingTileController.marketingFlagRetrieve(finacc5.Id);
		Test_ex6 = AHFC_MarketingTileController.marketingFlagRetrieve(finacc6.Id);
        Test_ex7 = AHFC_MarketingTileController.marketingFlagRetrieve(finacc7.Id);
        Test_ex8 = AHFC_MarketingTileController.marketingFlagRetrieve(finacc8.Id);
        Test_ex9 = AHFC_MarketingTileController.marketingFlagRetrieve(finacc9.Id);
        Test_ex10 = AHFC_MarketingTileController.marketingFlagRetrieve(finacc10.Id);
        Test_ex11 = AHFC_MarketingTileController.marketingFlagRetrieve(finacc11.Id);
        Test_ex12 = AHFC_MarketingTileController.marketingFlagRetrieve(finacc12.Id);        
        Test_ex13 = AHFC_MarketingTileController.marketingFlagRetrieve(finacc13.Id);        
        Test_ex14 = AHFC_MarketingTileController.marketingFlagRetrieve(finacc14.Id);
        Test_ex15 = AHFC_MarketingTileController.marketingFlagRetrieve(finacc15.Id);
  
        Test.stopTest();
        
    }

}
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // finacc.Fl_Recurring_Payment_Eligible_Agent__c=true;
       // finacc.Region_Code__c='BKC';
        
        //finacc.Fl_Refinanced__c=true;
        //finacc.Payment_Due_Date__c=System.Today();
        //finacc.Fl_Suppress_All_Notifications__c = false;
        //finacc.AHFC_Product_Nickname__c ='test';
        //finacc.Fl_DDC_Eligibility__c=true;
        //finacc.FL_LE_Eligibility__c=true;
        //finacc.AHFC_Total_days_past_due__c=25;
       // Honda_Brand__c,Account_Type__c,AHFC_Product_Type__c,Maturity_Date__c