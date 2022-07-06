/**************************************************************************
Author      :  Sajila Kadayaprath
Description :  Test class for Pendingpaymentextn
*****************************************************************************/

@isTest
public class Pendingpaymentextn_Test{
    private static TestMethod void testPendingPayExtension(){
    
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='4125';
        finacc2.Past_Amount_Due__c=22000.54;
        finacc2.Honda_Brand__c ='HFS';
        insert finacc2;
        
        System.debug(finacc2.Past_Amount_Due__c);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;
            
        insert cbg; 
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c=finacc2.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        //RecordType rt = [select Id from RecordType where Name ='Recurring Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        ch.Payment_Display_Status__c='Processing';
        ch.ChargentOrders__Payment_Start_Date__c=System.Today()+2;
        ch.ChargentOrders__Payment_Status__c='Recurring';
        //ch.ChargentOrders__Payment_Frequency__c='Once';
        insert ch;
        
        Honda_Finance__c h=new Honda_Finance__c();
        h.CutOff_Time__c=System.Today();
        insert h;
        
        System.debug(finacc2.Id);
        System.debug(finacc2.Past_Amount_Due__c);
        Test.startTest();
        PageReference pageRef = Page.Pendingpayment;
        Test.setCurrentPage(pageRef);
    
        ApexPages.StandardController sc = new ApexPages.standardController(finacc2);
        ApexPages.CurrentPage().getparameters().put('finnumber', finacc2.Finance_Account_Number__c);
        ApexPages.CurrentPage().getparameters().put('isReadOnly','true');
        ApexPages.CurrentPage().getparameters().put('cancelpayId',ch.Id);
        ApexPages.currentPage().getHeaders().put('User-Agent','Nothing');
        
        Pendingpaymentextn ppe=new Pendingpaymentextn(sc);
        ppe.showPopup();
        ppe.OnLoad();
        ppe.init();
        ppe.hidePopup();
        Boolean b=ppe.getchrRec();
        ppe.checkDevice();
        Pagereference cancel=ppe.CancelPayment();
        
        Boolean b1=ppe.pastDueStatus;
        pagereference p=ppe.redirectToHFS();
        ApexPages.currentPage().getHeaders().put('User-Agent','Android');
        ppe.checkDevice();
        ApexPages.currentPage().getHeaders().put('User-Agent','BlackBerry');
        ppe.checkDevice();
         ApexPages.currentPage().getHeaders().put('User-Agent','IEMobile');
        ppe.checkDevice();
         ApexPages.currentPage().getHeaders().put('User-Agent','iPad');
        ppe.checkDevice();
         ApexPages.currentPage().getHeaders().put('User-Agent','iPhone');
        ppe.checkDevice();
         ApexPages.currentPage().getHeaders().put('User-Agent','iPod');
        ppe.checkDevice();
        ppe.doNothingMethod();
        Test.stopTest();
    }
        private static TestMethod void testPendingPayExtension1(){
    
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='4128';
        finacc2.Past_Amount_Due__c=22000.54;
        finacc2.Honda_Brand__c ='AFS';
        finacc2.Payment_Due_Date__c=System.Today()+4;
        insert finacc2;
        
        System.debug(finacc2.Past_Amount_Due__c);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;
            
        insert cbg; 
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c=finacc2.Id;
        ch.Payment_Type__c = 'O';
        ch.ChargentOrders__Charge_Amount__c=5000;
        //RecordType rt = [select Id from RecordType where Name ='Recurring Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
        ch.Payment_Display_Status__c='Pending';
        ch.ChargentOrders__Payment_Start_Date__c=System.Today()+2;
        ch.ChargentOrders__Payment_Status__c='Recurring';
        //ch.ChargentOrders__Payment_Frequency__c='Once';
        insert ch;
        
        Honda_Finance__c h=new Honda_Finance__c();
        h.CutOff_Time__c=System.Today();
        insert h;
        
        System.debug(finacc2.Id);
        System.debug(finacc2.Past_Amount_Due__c);
        Test.startTest();
        PageReference pageRef = Page.Pendingpayment;
        Test.setCurrentPage(pageRef);
    
        ApexPages.StandardController sc = new ApexPages.standardController(finacc2);
        ApexPages.CurrentPage().getparameters().put('finnumber', finacc2.Finance_Account_Number__c);
        ApexPages.CurrentPage().getparameters().put('isReadOnly','true');
        ApexPages.CurrentPage().getparameters().put('cancelpayId',ch.Id);
        ApexPages.currentPage().getHeaders().put('User-Agent','Nothing');
        
        Pendingpaymentextn ppe=new Pendingpaymentextn(sc);

        Test.stopTest();
    }
    
    private static TestMethod void negativetestPendingPayExtension(){
    
        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c='4125';
        finacc2.Past_Amount_Due__c=-22000.54;
        finacc2.Honda_Brand__c ='AFS';
        insert finacc2;
        
        System.debug(finacc2.Past_Amount_Due__c);
        
        ChargentBase__Gateway__c cbg = new ChargentBase__Gateway__c();
            cbg.name = 'Cybersource';
            cbg.ChargentBase__Active__c = true;
            
        insert cbg; 
        
        ChargentOrders__ChargentOrder__c ch=new ChargentOrders__ChargentOrder__c ();
        ch.Finance_Account_Number__c=finacc2.Id;
        ch.Payment_Type__c = 'R';
        ch.ChargentOrders__Charge_Amount__c=5000;
        //RecordType rt = [select Id from RecordType where Name ='Recurring Payment' and sObjectType = 'ChargentOrders__ChargentOrder__c']; 
        ch.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        ch.Payment_Display_Status__c='Pending';
        ch.ChargentOrders__Payment_Start_Date__c=System.Today()+2;
        ch.ChargentOrders__Payment_Status__c='Recurring2';
        //ch.ChargentOrders__Payment_Frequency__c='Once';
        insert ch;
        
        Honda_Finance__c h=new Honda_Finance__c();
        h.CutOff_Time__c=System.Today() + 10;
        insert h;
        
        System.debug(finacc2.Id);
        System.debug(finacc2.Past_Amount_Due__c);
        Test.startTest();
        PageReference pageRef = Page.Pendingpayment;
        Test.setCurrentPage(pageRef);
    
        ApexPages.StandardController sc = new ApexPages.standardController(finacc2);
        ApexPages.CurrentPage().getparameters().put('finnumber', finacc2.Finance_Account_Number__c);
        ApexPages.CurrentPage().getparameters().put('isReadOnly','false');
        ApexPages.CurrentPage().getparameters().put('cancelpayId',ch.Id);
        ApexPages.currentPage().getHeaders().put('User-Agent','Nothing');
        
        Pendingpaymentextn ppe=new Pendingpaymentextn(sc);
        ppe.showPopup();
        ppe.OnLoad();
        ppe.init();
        ppe.hidePopup();
        Boolean b=ppe.getchrRec();
        ppe.checkDevice();
        Pagereference cancel=ppe.CancelPayment();
        
        Boolean b1=ppe.pastDueStatus;
        pagereference p=ppe.redirectToHFS();
        ApexPages.currentPage().getHeaders().put('User-Agent','Android');
        ppe.checkDevice();
        ApexPages.currentPage().getHeaders().put('User-Agent','BlackBerry');
        ppe.checkDevice();
         ApexPages.currentPage().getHeaders().put('User-Agent','IEMobile');
        ppe.checkDevice();
         ApexPages.currentPage().getHeaders().put('User-Agent','iPad');
        ppe.checkDevice();
         ApexPages.currentPage().getHeaders().put('User-Agent','iPhone');
        ppe.checkDevice();
         ApexPages.currentPage().getHeaders().put('User-Agent','iPod');
        ppe.checkDevice();
        ppe.doNothingMethod();
        Test.stopTest();
    }
    
}