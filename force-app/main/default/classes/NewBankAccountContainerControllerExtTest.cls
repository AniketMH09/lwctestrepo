@isTest
public class NewBankAccountContainerControllerExtTest {  
    
    
   	static testMethod void NewBankAccountContainer_Test() {
        
        Finance_Account__c finacc =new Finance_Account__c();          
        finacc.Finance_Account_Number__c='2541345676';
        finacc.Honda_Brand__c='AFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c=true;
        finacc.Region_Code__c='BKC';
        finacc.Account_Type__c='Balloon';
        finacc.Fl_Refinanced__c=true;
        finacc.Payment_Due_Date__c=System.Today();
        finacc.Fl_Suppress_All_Notifications__c = false;
        finacc.AHFC_Product_Nickname__c ='test';
        finacc.Fl_DDC_Eligibility__c=true;
        finacc.FL_LE_Eligibility__c=true;
        finacc.AHFC_Total_days_past_due__c=25;
        finacc.AHFC_Web_Payoff_Calendar__c='y';
        insert finacc;
        String recId=finacc.Id;
        
        Payment_Source__c pasor = new Payment_Source__c();
        pasor.Finance_Account_Number__c = finacc.id;        
        pasor.Bank_Name__c='Bank of india';
        pasor.Payment_Source_Nickname__c='Test';
        pasor.Last_4__c='1234';
        pasor.Status__c='Active';           
        insert pasor;
        String pasorId=pasor.Id;
        
        Payment_Source__c pasor1 = new Payment_Source__c();
        pasor1.Status__c='Active';
        pasor1.Finance_Account_Number__c = finacc.id;
        insert pasor1;
        Payment_Source__c pasor2 = new Payment_Source__c();
        pasor2.Status__c='Active';
        pasor2.Finance_Account_Number__c = finacc.id; 
        insert pasor2;
        Payment_Source__c pasor3 = new Payment_Source__c();
        pasor3.Status__c='Active';
        pasor3.Finance_Account_Number__c = finacc.id; 
        insert pasor3;
        Payment_Source__c pasor4 = new Payment_Source__c();
        pasor4.Status__c='Active';
        pasor4.Finance_Account_Number__c = finacc.id; 
        insert pasor4;
        
        List<Finance_Account__c> finaccList= new List<Finance_Account__c>();
        finaccList.add(finacc);
        
        
        List<Payment_Source__c> paymentList= new  List<Payment_Source__c>();
        paymentList.add(pasor);
        
        paymentList.add(pasor1);
        paymentList.add(pasor2);
        paymentList.add(pasor3);
        paymentList.add(pasor4);
        
        
        Test.startTest();            
        PageReference pr= Page.NewBankAccountContainer;
        Test.setCurrentPage(pr);
        //newAcc=NewBankAccountContainerControllerExt(ApexPages.con); 
        ApexPages.StandardSetController con= new ApexPages.StandardSetController(paymentList);
        ApexPages.currentPage().getParameters().put('id',finacc.Id);
        NewBankAccountContainerControllerExt newAcc= new NewBankAccountContainerControllerExt(con);
        newAcc.RedirectToPage(recID);
        newAcc.doProcessing();
        Test.stopTest();
    
    }

}