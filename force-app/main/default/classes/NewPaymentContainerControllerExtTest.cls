/* Apex Class Name   :    NewPaymentContainerControllerExtTest
 * Description        :    Unit Test class for NewPaymentContainerControllerExt
 * Modification Log   :
 * ---------------------------------------------------------------------------
 * Developer                             Date                   Description
 * ---------------------------------------------------------------------------
 * Supriya Chakraborty               04th Aug 2021             Created
 * Prabu Mohanasundaram              19th Nov 2021             Modified
 *********************************************************************************/

@isTest
public class NewPaymentContainerControllerExtTest {

    @isTest public static void paymentContainerTest() {
        list < Payment_Source__c > payment = new list < Payment_Source__c > ();
        list < ChargentOrders__ChargentOrder__c > chOrder = new list < ChargentOrders__ChargentOrder__c > ();
        Finance_Account__c finAcc = new Finance_Account__c();
        String contactId;
        RecordType recType = [Select ID, name, DeveloperName from RecordType where DeveloperName = 'One_Time_Payment'];
        finAcc.Name = 'FinanceAccTest';
        finAcc.Contact__c = contactId;
        finAcc.AHFC_Garaging_Zip__c = '12345';
        finAcc.Vehicle_Identification_Number__c = '12345678912345678';
        finAcc.AHFC_Last_4_SSN__c = '1234';
        finAcc.Finance_Account_Number__c = '123456789';
        Payment_Source__c pysrc = new Payment_Source__c();
        pysrc.Bank_Name__c = 'BankOfAmericaTest';
        pysrc.Payment_Source_Nickname__c = 'Test';
        pysrc.Last_4__c = 'Test';
        pysrc.Preferred_Payment_Source__c = true;
        pysrc.Status__c = 'Active';
        Test.startTest();
        insert finAcc;
        pysrc.Finance_Account_Number__c = finAcc.Id;
        //  insert pysrc;
        system.debug('pysrctest==' + pysrc);
        payment.add(pysrc);
        insert payment;
        ChargentOrders__ChargentOrder__c charge = new ChargentOrders__ChargentOrder__c();
        charge.RecordTypeId = recType.Id;
        charge.Finance_Account_Number__c = finAcc.Id;
        charge.ChargentOrders__Charge_Amount__c = 10;
        charge.Payment_Channel__c = 'W';
        charge.Payment_Source_Nickname__c = pysrc.id;
        charge.Last_Payment_Display_Status__c = ' Test';
        charge.Payment_Type__c = 'R';
        charge.ChargentOrders__Payment_Start_Date__c = System.today();
        charge.Payment_Display_Status__c = 'Pending';
        chOrder.add(charge);
        insert chOrder;
        Test.stopTest();
        PageReference pageRef = Page.NewPaymentContainer; // Add your VF page Name here
        pageRef.getParameters().put('id', finAcc.Id);
        Test.setCurrentPage(pageRef);
        Apexpages.standardSetController sc = new Apexpages.standardSetController(payment);
        NewPaymentContainerControllerExt newcom = new NewPaymentContainerControllerExt(sc);
        newcom.doProcessing();
    }

    /**
     * @description: Added the code for cover the Prinicipal Ontime Payment
     * @author Prabu Mohanasundaram | Nov 19 2021
     **/

    @isTest public static void paymentRecTypePrincipalOneTime() {
        list < Payment_Source__c > payment = new list < Payment_Source__c > ();
        list < ChargentOrders__ChargentOrder__c > chOrder = new list < ChargentOrders__ChargentOrder__c > ();
        Finance_Account__c finAcc = new Finance_Account__c();
        String contactId;
        RecordType recType = [Select ID, name, DeveloperName from RecordType where DeveloperName = 'Principal_One_Time_Payment'];
        finAcc.Name = 'HondaMarine';
        finAcc.Contact__c = contactId;
        finAcc.AHFC_Garaging_Zip__c = '12345';
        finAcc.Vehicle_Identification_Number__c = '12345678912345678';
        finAcc.AHFC_Last_4_SSN__c = '1234';
        finAcc.Finance_Account_Number__c = '123456789';
        Payment_Source__c pysrc = new Payment_Source__c();
        pysrc.Bank_Name__c = 'BankOfAmerica';
        pysrc.Payment_Source_Nickname__c = 'HondaSports';
        pysrc.Last_4__c = 'Test';
        pysrc.Preferred_Payment_Source__c = true;
        pysrc.Status__c = 'Active';
        Test.startTest();
        insert finAcc;
        pysrc.Finance_Account_Number__c = finAcc.Id;
        //  insert pysrc;
        system.debug('pysrctest==' + pysrc);
        payment.add(pysrc);
        insert payment;
        ChargentOrders__ChargentOrder__c charge = new ChargentOrders__ChargentOrder__c();
        charge.RecordTypeId = recType.Id;
        charge.Finance_Account_Number__c = finAcc.Id;
        charge.ChargentOrders__Charge_Amount__c = 10;
        charge.Payment_Channel__c = 'W';
        charge.Payment_Source_Nickname__c = pysrc.id;
        charge.Last_Payment_Display_Status__c = ' Test';
        charge.Payment_Type__c = 'R';
        charge.ChargentOrders__Payment_Start_Date__c = System.today();
        charge.Payment_Display_Status__c = 'Pending';
        chOrder.add(charge);
        insert chOrder;
        Test.stopTest();
        // system.assertEquals(recType.DeveloperName, 'Principal_One_Time_Payment', 'RecordType Should be Principal OneTime Payment');
        PageReference pageRef = Page.NewPaymentContainer; // Add your VF page Name here
        pageRef.getParameters().put('id', finAcc.Id);
        Test.setCurrentPage(pageRef);
        Apexpages.standardSetController sc = new Apexpages.standardSetController(payment);
        NewPaymentContainerControllerExt newcom = new NewPaymentContainerControllerExt(sc);
        System.assertEquals(newcom.errorMessage, null, 'Method executed Successfully');
        newcom.doProcessing();
    }

    /**
     * @description: Added the code for cover the Payoff Payment
     * @author Prabu Mohanasundaram | Nov 19 2021
     **/
    @isTest
    public static void paymentPayoffPayment() {
        list < Payment_Source__c > payment = new list < Payment_Source__c > ();
        list < ChargentOrders__ChargentOrder__c > chOrder = new list < ChargentOrders__ChargentOrder__c > ();
        Finance_Account__c finAcc = new Finance_Account__c();
        String contactId;
        RecordType recType = [Select ID, name, DeveloperName from RecordType where DeveloperName = 'Payoff_Payment'];
        finAcc.Name = 'HondaMarine';
        finAcc.Contact__c = contactId;
        finAcc.AHFC_Garaging_Zip__c = '12345';
        finAcc.Vehicle_Identification_Number__c = '12345678912345678';
        finAcc.AHFC_Last_4_SSN__c = '1234';
        finAcc.Finance_Account_Number__c = '123456789';
        Payment_Source__c pysrc = new Payment_Source__c();
        pysrc.Bank_Name__c = 'BankOfAmerica';
        pysrc.Payment_Source_Nickname__c = 'Test';
        pysrc.Last_4__c = 'Test';
        pysrc.Preferred_Payment_Source__c = true;
        pysrc.Status__c = 'Active';
        Test.startTest();
        insert finAcc;
        pysrc.Finance_Account_Number__c = finAcc.Id;
        payment.add(pysrc);
        insert payment;
        ChargentOrders__ChargentOrder__c charge = new ChargentOrders__ChargentOrder__c();
        charge.RecordTypeId = recType.Id;
        charge.Finance_Account_Number__c = finAcc.Id;
        charge.ChargentOrders__Charge_Amount__c = 10;
        charge.Payment_Channel__c = 'W';
        charge.Payment_Source_Nickname__c = pysrc.id;
        charge.Last_Payment_Display_Status__c = ' Test';
        charge.Payment_Type__c = 'R';
        charge.ChargentOrders__Payment_Start_Date__c = System.today();
        charge.Payment_Display_Status__c = 'Pending';
        chOrder.add(charge);
        insert chOrder;
        Test.stopTest();
        system.assertEquals(recType.DeveloperName, 'Payoff_Payment', 'RecordType Should be Payoff Payment');
        PageReference pageRef = Page.NewPaymentContainer; // Add your VF page Name here
        pageRef.getParameters().put('id', finAcc.Id);
        Test.setCurrentPage(pageRef);
        Apexpages.standardSetController sc = new Apexpages.standardSetController(payment);
        NewPaymentContainerControllerExt newcom = new NewPaymentContainerControllerExt(sc);
        System.assertEquals(newcom.errorMessage, null, 'Method executed Successfully');
        newcom.doProcessing();
    }
    /**
     * @description: Added the code for cover the Recurring Payment
     * @author Prabu Mohanasundaram | Nov 19 2021
     **/
    @isTest public static void paymentRecurring() {
        list < Payment_Source__c > payment = new list < Payment_Source__c > ();
        list < ChargentOrders__ChargentOrder__c > chOrder = new list < ChargentOrders__ChargentOrder__c > ();
        Finance_Account__c finAcc = new Finance_Account__c();
        String contactId;
        RecordType recType = [Select ID, name, DeveloperName from RecordType where DeveloperName = 'Recurring_Payment'];
        finAcc.Name = 'HondaMarine';
        finAcc.Contact__c = contactId;
        finAcc.AHFC_Garaging_Zip__c = '12345';
        finAcc.Vehicle_Identification_Number__c = '12345678912345678';
        finAcc.AHFC_Last_4_SSN__c = '1234';
        finAcc.Finance_Account_Number__c = '123456789';
        Payment_Source__c pysrc = new Payment_Source__c();
        pysrc.Bank_Name__c = 'BankOfAmerica';
        pysrc.Payment_Source_Nickname__c = 'Test';
        pysrc.Last_4__c = 'Test';
        pysrc.Preferred_Payment_Source__c = true;
        pysrc.Status__c = 'Active';
        Test.startTest();
        insert finAcc;
        pysrc.Finance_Account_Number__c = finAcc.Id;
        payment.add(pysrc);
        insert payment;
        ChargentOrders__ChargentOrder__c charge = new ChargentOrders__ChargentOrder__c();
        charge.RecordTypeId = recType.Id;
        charge.Finance_Account_Number__c = finAcc.Id;
        charge.ChargentOrders__Charge_Amount__c = 10;
        charge.Payment_Channel__c = 'W';
        charge.Payment_Source_Nickname__c = pysrc.id;
        charge.Last_Payment_Display_Status__c = ' Test';
        charge.Payment_Type__c = 'R';
        charge.ChargentOrders__Payment_Start_Date__c = System.today();
        charge.Payment_Display_Status__c = 'Pending';
        charge.ChargentOrders__Payment_Status__c = 'Recurring';
        charge.ChargentOrders__Payment_Frequency__c = 'Monthly';
        chOrder.add(charge);
        insert chOrder;
        Test.stopTest();
        PageReference pageRef = Page.NewPaymentContainer; // Add your VF page Name here
        pageRef.getParameters().put('id', finAcc.Id);
        Test.setCurrentPage(pageRef);
        Apexpages.standardSetController sc = new Apexpages.standardSetController(payment);
        NewPaymentContainerControllerExt newcom = new NewPaymentContainerControllerExt(sc);
        System.assertEquals(newcom.errorMessage, null, 'Method executed Successfully');
        newcom.doProcessing();
    }
}