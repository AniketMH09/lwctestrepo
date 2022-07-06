/*=====================================================================
 * Name: AHFC_AddPaymentSourceClass_Test .apex
 * Description: Unit Test class for AHFC_AddPaymentSourceClass
 * Created Date: 13th May 2021
 * Created By: Abhijit kurapati
 * Modified by: Akash Solanki:- Corrected the reference for managePayoff method from Customer finance account record to finance account record ID.
 *Modified by : Prabu Mohanasundaram :- Added the code for cover the Payment Types
 *  ===================================================================== */

@isTest
public class AHFC_AddPaymentSourceClass_Test {

    public static testMethod void testPaymentSource() {

        Honda_Finance__c setting = new Honda_Finance__c();
        setting.Name = 'Test Setting';
        setting.CutOff_Time__c = datetime.now().addHours(1);


        List < Id > lstSACIdsToUpdate = new list < id > ();
        AHFC_Bank_Routing__c ahfcRouting = new AHFC_Bank_Routing__c();
        ahfcRouting.AHFC_Bank_Name__c = 'Test';
        ahfcRouting.AHFC_Routing_Number__c = '987654321';

        Account a1 = new Account(Name = 'Test Account Name', AccountNumber = '123456');
        
        Finance_Account__c finacc1 = new Finance_Account__c();
        finacc1.Finance_Account_Number__c = '2197cdac';
        finacc1.Honda_Brand__c = 'AFS';
        finacc1.Payoff_Amount__c = 200.00;


        Finance_Account__c finacc2 = new Finance_Account__c();
        finacc2.Finance_Account_Number__c = '2197';
        finacc2.Honda_Brand__c = 'AFS';
        finacc2.Payoff_Amount__c = 200.00;
        finacc2.Origination_Branch_Code__c = '107';
        finacc2.Account_Type__c = 'Retail';
        finacc2.AHFC_Product_Type__c = 'Powersports';

        //System.assertEquals('2197',finacc2.Finance_Account_Number__c);

        Customer_Finance_Account__c cfa = new Customer_Finance_Account__c();
        cfa.Finance_Account__c = finacc2.Id;
        cfa.Customer__c = a1.id;
        cfa.Is_Active__c = true;

        //System.assertEquals(a1.id,cfa.Customer__c);

        Payment_Source__c psor1 = new Payment_Source__c();
        psor1.Finance_Account_Number__c = finacc2.id;
        psor1.Customer__c = cfa.Customer__c;
        psor1.Payment_Source_Nickname__c = 'test';
        psor1.Status__c = 'Active';
        psor1.Last_4__c = '1234';
        psor1.Preferred_Payment_Source__c = true;
        psor1.Bank_Account_Number__c = '12344444';
        psor1.Payment_Source_Nickname__c = 'Test';


        Payment_Source__c psor2 = new Payment_Source__c();
        psor2.Customer__c = cfa.Customer__c;
        psor2.Status__c = 'Active';


        RecordType recType = [Select ID, name, DeveloperName from RecordType where name = 'Standard One-Time Payment'];
        RecordType recType2 = [Select ID, name, DeveloperName from RecordType where DeveloperName = 'Recurring_Payment'];

        Contact c1 = new Contact(LastName = 'Contact Last Name');

        Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'Customer'];

        UserRole userrole = [Select Id, DeveloperName From UserRole Limit 1];

        User adminUser = [Select Id, accountId, UserRoleId From User Where Profile.Name = 'System Administrator'
            and IsActive = true Limit 1
        ];
        adminUser.UserRoleId = userrole.Id;
        update adminUser;

        User u = new User(Alias = 'sandt', Email = 'stadarduser@testorg.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'stadarduser13@testorg.com');

        ChargentOrders__ChargentOrder__c charge = new ChargentOrders__ChargentOrder__c();
        charge.RecordTypeId = recType.Id;
        charge.Finance_Account_Number__c = finacc2.Id;
        charge.ChargentOrders__Charge_Amount__c = 10;
        charge.Payment_Channel__c = 'W';
        charge.Payment_Source_Nickname__c = psor1.Id;
        charge.Last_Payment_Display_Status__c = ' Test';
        charge.Payment_Type__c = 'R';
        charge.ChargentOrders__Payment_Start_Date__c = System.today();
        charge.Payment_Display_Status__c = 'Pending';


        List < Id > ServId = new List < Id > ();
        ServId.add(a1.Id);
        List < Id > nullIds = new List < Id > ();

        system.runAs(adminUser) {
            insert setting;
            insert ahfcRouting;
            insert a1;
            lstSACIdsToUpdate.add(a1.id);
            c1.AccountId = a1.id;
            insert finacc1;
            insert finacc2;
            insert cfa;
            insert psor1;
            insert psor2;
            insert c1;
            u.ContactId = c1.id;
            insert u;
            insert charge;
        }
        Test.startTest();
        AHFC_AddPaymentSourceClass.paymentSourceSACWrapper wrapper1 = new AHFC_AddPaymentSourceClass.paymentSourceSACWrapper();
        AHFC_AddPaymentSourceClass.paymentSourceSACWrapper wrapper2 = new AHFC_AddPaymentSourceClass.paymentSourceSACWrapper();
        wrapper1 = AHFC_AddPaymentSourceClass.paymentSourceSACWrapper.insertPaymentSource('123456', 'test', 'test', 'test', 'test', true, 'test', lstSACIdsToUpdate);
        wrapper2 = AHFC_AddPaymentSourceClass.paymentSourceSACWrapper.insertPaymentSource('123456', 'test', 'test', 'test', '', true, 'test', lstSACIdsToUpdate);
        System.assertEquals(wrapper1.insertedPaymentSource, null, 'null wrapper');
        System.assertEquals(wrapper2.insertedPaymentSource, null, 'null wrapper');
        List < Customer_Finance_Account__c > cfac = AHFC_AddPaymentSourceClass.getServiceAccCustomerRecords(a1.id);
        System.assertEquals(cfac.size(), 0, 'Size');
        AHFC_AddPaymentSourceClass.retrieveBankName('987654321');
        List < Finance_Account__c > finaccnt1 = AHFC_AddPaymentSourceClass.getServiceAccountRecords(nullIds);
        List < Finance_Account__c > finaccnt2 = AHFC_AddPaymentSourceClass.getServiceAccountRecords(ServId);

        System.assertEquals(finaccnt1, null, 'FInance Account ids');
        System.assertEquals(finaccnt2.size(), 0, 'FInance Account ids');
        AHFC_AddPaymentSourceClass.ServiceAccountWrapper serwrapper = new AHFC_AddPaymentSourceClass.ServiceAccountWrapper();
        serwrapper = AHFC_AddPaymentSourceClass.managePayOff(finacc2.id);
        boolean value = AHFC_AddPaymentSourceClass.getPaymentSourcePreferred(finacc2.id);
        System.assertEquals(serwrapper.boolOtpEligible, false, 'OTP Eligible value');
        System.assertEquals(value, true, 'Payment source refrenced or not');
        List < ChargentOrders__ChargentOrder__c > paymentList = AHFC_AddPaymentSourceClass.paymentList(finacc1.id);
        AHFC_AddPaymentSourceClass.getPaymentSources(finacc2.Id);
        AHFC_AddPaymentSourceClass.calculateNextWithdrawalDate('12', system.today());
        AHFC_AddPaymentSourceClass.calculateNextWithdrawalDate('12', system.today() + 25);
        AHFC_AddPaymentSourceClass.calculateNextWithdrawalDate('12', null);
        List < ChargentOrders__ChargentOrder__c > paymentList1 = AHFC_AddPaymentSourceClass.paymentList(finacc2.id);
        System.assertEquals(paymentList.size(), 0, 'Chargentorders size');
        System.assertEquals(paymentList1.size(), 0, 'Chargentorders size');
        system.runAs(adminUser) {
            AHFC_AddPaymentSourceClass.updatePaymentSource(psor1.id, 'test', true);
            serwrapper = AHFC_AddPaymentSourceClass.managePayOff(finacc2.id);
        }
        System.runAs(u) {
            AHFC_AddPaymentSourceClass.paymentSourceSACWrapper wrapper4 = new AHFC_AddPaymentSourceClass.paymentSourceSACWrapper();
            //AHFC_AddPaymentSourceClass.paymentSourceSACWrapper wrapper2  = new AHFC_AddPaymentSourceClass.paymentSourceSACWrapper();
            wrapper4 = AHFC_AddPaymentSourceClass.paymentSourceSACWrapper.insertPaymentSource('123456', 'test', 'test', 'test', 'test', true, 'test', lstSACIdsToUpdate);
            // serwrapper = AHFC_AddPaymentSourceClass.managePayOff(finacc2.id);
        }

        System.runAs(u) {
            AHFC_AddPaymentSourceClass.getCustomerAccountId();
        }
        System.runAs(u) {
            Finance_Account__c finacc6 = new Finance_Account__c();
            finacc6.Finance_Account_Number__c = '234567';
            finacc6.Honda_Brand__c = 'AFS';
            finacc6.Payoff_Amount__c = 200.00;
            insert finacc6;

            Customer_Finance_Account__c cfa4 = new Customer_Finance_Account__c();
            cfa4.Finance_Account__c = finacc6.Id;
            cfa4.Customer__c = a1.id;
            cfa4.Is_Active__c = true;
            insert cfa4;

            //System.assertEquals(a1.id,cfa.Customer__c);

            Communication_Preferences__c cPref = new Communication_Preferences__c();
            cPref.Finance_Account_Number__c = finacc6.Id;
            cPref.Customer__c = a1.Id;
            cPref.Payment_Confirmations_via_Email__c = true;
            cPref.Payment_Reminders_via_Text__c = true;
            cPref.Text_Number__c = '9992223334';
            insert cPref;
            Payment_Source__c psor5 = new Payment_Source__c();
            psor5.Finance_Account_Number__c = finacc6.id;
            psor5.Customer__c = cfa.Customer__c;
            psor5.Payment_Source_Nickname__c = 'test';
            psor5.Status__c = 'Active';
            psor5.Last_4__c = '1234';
            psor5.Preferred_Payment_Source__c = true;
            psor5.Bank_Account_Number__c = '12344444';
            psor5.Payment_Source_Nickname__c = 'Test';
            insert psor5;
            AHFC_AddPaymentSourceClass.ServiceAccountWrapper serwrapper1 = new AHFC_AddPaymentSourceClass.ServiceAccountWrapper();
            AHFC_AddPaymentSourceClass.getTotalScheduledAmount(finacc6.id, finacc6);
            try {
                serwrapper1 = AHFC_AddPaymentSourceClass.managePayOff(finacc6.id);
            } catch (exception e) {

            }
            boolean value1 = AHFC_AddPaymentSourceClass.getPaymentSourcePreferred(finacc6.id);
            AHFC_AddPaymentSourceClass.getPaymentSources(finacc6.Id);
            List < ChargentOrders__ChargentOrder__c > paymentList3 = AHFC_AddPaymentSourceClass.paymentList(finacc6.id);
            //  System.assertEquals(serwrapper1.boolOtpEligible,false,'OTP Eligible value');
            System.assertEquals(value, true, 'Payment source refrenced or not');
            System.assertEquals(paymentList3.size(), 0, 'Chargentorders size');
        }
        Test.stopTest();
    }
    public static testMethod void testPaymentSource2() {
        AHFC_AddPaymentSourceClass.PaymentSourceWrapper psw = new AHFC_AddPaymentSourceClass.PaymentSourceWrapper();
        psw.strID = 'test';
        psw.strLast4AccNumber = 'test';
        psw.strName = 'test';
        psw.boolIsPreferredSource = true;
        AHFC_AddPaymentSourceClass.paymentSourceSACWrapper wrappSAC = new AHFC_AddPaymentSourceClass.paymentSourceSACWrapper();
        System.assertEquals(wrappSAC.insertedPaymentSource, null, 'wrapper values');
    }
    /**
     * @description: Added the code for cover the OneTime Payment Records when the Display status is Pending
     * @author Prabu| Nov 22nd 2021
     **/
    public static testMethod void stdOneTimePendingStatus() {
        RecordType recType = [Select ID, name, DeveloperName from RecordType where name = 'Standard One-Time Payment'];
        Finance_Account__c finacc = new Finance_Account__c();
        ChargentOrders__ChargentOrder__c chargeOrder = new ChargentOrders__ChargentOrder__c();
        Payment_Source__c paymentsrc = new Payment_Source__c();
        Honda_Finance__c hondaFinacc = new Honda_Finance__c();
        finacc.Finance_Account_Number__c = '2541345623';
        finacc.Honda_Brand__c = 'AFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c = true;
        finacc.Region_Code__c = 'BKC';
        finacc.Account_Type__c = 'Balloon';
        finacc.Fl_Refinanced__c = true;
        finacc.Payment_Due_Date__c = System.Today();
        finacc.Fl_Suppress_All_Notifications__c = false;
        finacc.AHFC_Product_Nickname__c = 'Val Nick';
        finacc.Fl_DDC_Eligibility__c = true;
        finacc.FL_LE_Eligibility__c = true;
        finacc.AHFC_Total_days_past_due__c = 25;
        finacc.AHFC_Web_Payoff_Calendar__c = 'y';
        finacc.Next_Due_Date__c = System.Today() + 5;
        insert finacc;
        Id recID = finacc.Id;

        hondaFinacc.Name = 'Honda';
        hondaFinacc.CutOff_Time__c = DateTime.newInstance(2000, 10, 10, 10, 10, 10);
        insert hondaFinacc;

        paymentsrc.Payment_Source_Nickname__c = 'Honda prime';
        paymentsrc.Last_4__c = '1000';
        insert paymentsrc;
        ID paymentID = paymentsrc.Id;

        chargeOrder.Finance_Account_Number__c = recID;
        chargeOrder.RecordTypeId = recType.Id;
        chargeOrder.ChargentOrders__Charge_Amount__c = 100;
        chargeOrder.Payment_Channel__c = 'W';
        chargeOrder.Last_Extraction_Date__c = System.today();
        chargeOrder.Payment_Source_Nickname__c = paymentID;
        chargeOrder.Last_Payment_Display_Status__c = 'Priya';
        chargeOrder.Payment_Type__c = 'R';
        chargeOrder.Next_Withdrawal_Date__c = System.today().addDays(20);
        chargeOrder.ChargentOrders__Payment_Start_Date__c = System.today().addDays(-400);
        chargeOrder.Payment_Display_Status__c = 'Pending';
        chargeOrder.ChargentOrders__Payment_Status__c = 'Recurring';
        chargeOrder.ChargentOrders__Payment_Frequency__c = 'Monthly';
        chargeOrder.ChargentOrders__Payment_Start_Date__c = system.today() - 5;
        insert chargeOrder;

        Test.startTest();
        AHFC_AddPaymentSourceClass.ServiceAccountWrapper wrap = new AHFC_AddPaymentSourceClass.ServiceAccountWrapper();
        AHFC_AddPaymentSourceClass.paymentList(finacc.id);
        wrap = AHFC_AddPaymentSourceClass.managePayOff(finacc.id);
        system.debug('SAccountWrapper111' + wrap);
        System.assertEquals(wrap.enrolledInEasyPayAndSuspended, false, 'Enrolled in EasyPayandSuspended flag is false');
        Test.stopTest();
    }
    /**
     * @description: Added the code for cover the Recurring Payment Records when the Display status is Pending
     * @author Prabu| Nov 22nd 2021
     **/
    public static testMethod void recurringPaymtPendingStatus() {
        RecordType recType = [Select ID, name, DeveloperName from RecordType where DeveloperName = 'Recurring_Payment'];
        Finance_Account__c finacc = new Finance_Account__c();
        ChargentOrders__ChargentOrder__c chargeOrder = new ChargentOrders__ChargentOrder__c();
        Payment_Source__c paymentsrc = new Payment_Source__c();
        Honda_Finance__c hondaFinacc = new Honda_Finance__c();
        finacc.Finance_Account_Number__c = '2541345623';
        finacc.Honda_Brand__c = 'AFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c = true;
        finacc.Region_Code__c = 'BKC';
        finacc.Account_Type__c = 'Balloon';
        finacc.Fl_Refinanced__c = true;
        finacc.Payment_Due_Date__c = System.Today();
        finacc.Fl_Suppress_All_Notifications__c = false;
        finacc.AHFC_Product_Nickname__c = 'Val Nick';
        finacc.Fl_DDC_Eligibility__c = true;
        finacc.FL_LE_Eligibility__c = true;
        finacc.AHFC_Total_days_past_due__c = 25;
        finacc.AHFC_Web_Payoff_Calendar__c = 'y';
        finacc.Next_Due_Date__c = System.Today() + 7;
        insert finacc;
        Id recID = finacc.Id;

        hondaFinacc.Name = 'Honda';
        hondaFinacc.CutOff_Time__c = DateTime.newInstance(2000, 10, 10, 10, 10, 10);
        insert hondaFinacc;

        paymentsrc.Payment_Source_Nickname__c = 'Honda prime';
        paymentsrc.Last_4__c = '1000';
        insert paymentsrc;
        ID paymentID = paymentsrc.Id;

        chargeOrder.Finance_Account_Number__c = recID;
        chargeOrder.RecordTypeId = recType.Id;
        chargeOrder.ChargentOrders__Charge_Amount__c = 100;
        chargeOrder.Payment_Channel__c = 'W';
        chargeOrder.Last_Extraction_Date__c = System.today();
        chargeOrder.Payment_Source_Nickname__c = paymentID;
        chargeOrder.Last_Payment_Display_Status__c = 'Priya';
        chargeOrder.Payment_Type__c = 'R';
        chargeOrder.Next_Withdrawal_Date__c = System.today() - 5;
        chargeOrder.ChargentOrders__Payment_Start_Date__c = System.today().addDays(-400);
        chargeOrder.Payment_Display_Status__c = 'Pending';
        chargeOrder.ChargentOrders__Payment_Status__c = 'Recurring';
        chargeOrder.ChargentOrders__Payment_Frequency__c = 'Monthly';
        chargeOrder.ChargentOrders__Payment_Start_Date__c = system.today() - 5;
        insert chargeOrder;

        Test.startTest();
        AHFC_AddPaymentSourceClass.ServiceAccountWrapper wrap = new AHFC_AddPaymentSourceClass.ServiceAccountWrapper();
        AHFC_AddPaymentSourceClass.paymentList(finacc.id);
        wrap = AHFC_AddPaymentSourceClass.managePayOff(finacc.id);
        system.debug('SAccountWrapper222' + wrap);
        System.assertEquals(wrap.enrolledInEasyPayAndSuspended, false, 'Enrolled in EasyPayandSuspended flag is false');
        Test.stopTest();
    }
    /**
     * @description: Added the code for cover the Recurring Payment Records when the Display status is Suspended
     * @author Prabu| Nov 22nd 2021
     **/
    public static testMethod void recurringPaymtSuspendedStatus() {
        RecordType recType = [Select ID, name, DeveloperName from RecordType where DeveloperName = 'Recurring_Payment'];
        Finance_Account__c finacc = new Finance_Account__c();
        ChargentOrders__ChargentOrder__c chargeOrder = new ChargentOrders__ChargentOrder__c();
        Payment_Source__c paymentsrc = new Payment_Source__c();
        Honda_Finance__c hondaFinacc = new Honda_Finance__c();
        finacc.Finance_Account_Number__c = '2541345623';
        finacc.Honda_Brand__c = 'AFS';
        finacc.Fl_Recurring_Payment_Eligible_Agent__c = true;
        finacc.Region_Code__c = 'BKC';
        finacc.Account_Type__c = 'Balloon';
        finacc.Fl_Refinanced__c = true;
        finacc.Payment_Due_Date__c = System.Today();
        finacc.Fl_Suppress_All_Notifications__c = false;
        finacc.AHFC_Product_Nickname__c = 'Val Nick';
        finacc.Fl_DDC_Eligibility__c = true;
        finacc.FL_LE_Eligibility__c = true;
        finacc.AHFC_Total_days_past_due__c = 25;
        finacc.AHFC_Web_Payoff_Calendar__c = 'y';
        finacc.Next_Due_Date__c = System.Today() + 7;
        insert finacc;
        Id recID = finacc.Id;

        hondaFinacc.Name = 'Honda';
        hondaFinacc.CutOff_Time__c = DateTime.newInstance(2000, 10, 10, 10, 10, 10);
        insert hondaFinacc;

        paymentsrc.Payment_Source_Nickname__c = 'Honda prime';
        paymentsrc.Last_4__c = '1000';
        insert paymentsrc;
        ID paymentID = paymentsrc.Id;

        chargeOrder.Finance_Account_Number__c = recID;
        chargeOrder.RecordTypeId = recType.Id;
        chargeOrder.ChargentOrders__Charge_Amount__c = 100;
        chargeOrder.Payment_Channel__c = 'W';
        chargeOrder.Last_Extraction_Date__c = System.today();
        chargeOrder.Payment_Source_Nickname__c = paymentID;
        chargeOrder.Last_Payment_Display_Status__c = 'Priya';
        chargeOrder.Payment_Type__c = 'R';
        chargeOrder.Next_Withdrawal_Date__c = System.today() - 5;
        chargeOrder.ChargentOrders__Payment_Start_Date__c = System.today().addDays(-400);
        chargeOrder.Payment_Display_Status__c = 'Suspended';
        chargeOrder.ChargentOrders__Payment_Status__c = 'Recurring';
        chargeOrder.ChargentOrders__Payment_Frequency__c = 'Monthly';
        chargeOrder.ChargentOrders__Payment_Start_Date__c = system.today() - 5;
        insert chargeOrder;

        Test.startTest();
        AHFC_AddPaymentSourceClass.ServiceAccountWrapper wrap = new AHFC_AddPaymentSourceClass.ServiceAccountWrapper();
        AHFC_AddPaymentSourceClass.paymentList(finacc.id);
        wrap = AHFC_AddPaymentSourceClass.managePayOff(finacc.id);
        System.assertEquals(wrap.enrolledInEasyPayAndSuspended, true, 'Enrolled in EasyPayandSuspended flag is true');
        Test.stopTest();
    }
}