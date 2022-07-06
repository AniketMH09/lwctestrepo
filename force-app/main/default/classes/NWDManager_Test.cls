/*
    File Name       :   NWDManager_Test
    Author          :   iConnect DEV Team
    Datetime        :   12th NOV 2017
    Description     :   Test class for NWDManager
    */

@isTest
private class NWDManager_Test{
    
    static Honda_Finance__c hondaCT;
    static Finance_Account__c finacc;
    static ChargentOrders__ChargentOrder__c easypay;
    
    /*@testsetup static void setupNWDData() {
        hondaCT = new Honda_Finance__c();
        hondaCT.No_of_Days__c = 21;
        hondaCT.CutOff_Time__c = DateTime.parse('1/18/2018 02:00 PM');
        insert hondaCT;
        
        finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Honda_Brand__c='AFS';
        finacc.IsUpdated__c=true;
        finacc.FI_Stop_Reinstate_Recurring_Payment__c='R';
        finacc.Fl_Cancel_One_Time_Payments__c = false;
        finacc.FA_Next_Withdrawal_Date__c = Date.newInstance(2018, 11, 15);
        insert finacc;
        
        easypay = new ChargentOrders__ChargentOrder__c ();
        easypay.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        easypay.ChargentOrders__Charge_Amount__c=500;
        easypay.Payment_Type__c = 'R';
        easypay.Payment_Display_Status__c='Pending';
        easypay.ChargentOrders__Payment_Status__c='Recurring';
        easypay.ChargentOrders__Payment_Frequency__c='Monthly';
        easypay.ChargentOrders__Payment_Stop__c = 'Date';
        easypay.ChargentOrders__Payment_Start_Date__c= Date.newInstance(2018, 2, 15);
        easypay.ChargentOrders__Payment_End_Date__c= Date.newInstance(3018, 2, 15);
        easypay.ChargentOrders__Charge_Date__c = '15';
        easypay.Next_Withdrawal_Date__c = Date.newInstance(2018, 11, Integer.valueOf(easypay.ChargentOrders__Charge_Date__c));
        easypay.Finance_Account_Number__c = finacc.Id;
        insert easypay;
    }*/
    
    /* **********************Testing Deferrals********************************************** */
        static TestMethod void setupDeferral(){
        hondaCT = new Honda_Finance__c();
        hondaCT.No_of_Days__c = 21;
        hondaCT.CutOff_Time__c = DateTime.parse('1/18/2016 02:00 PM');
        insert hondaCT;
        
        finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Honda_Brand__c='AFS';
        finacc.IsUpdated__c=true;
        finacc.FI_Stop_Reinstate_Recurring_Payment__c='R';
        finacc.Fl_Cancel_One_Time_Payments__c = false;
        
        
        easypay = new ChargentOrders__ChargentOrder__c ();
        easypay.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        easypay.ChargentOrders__Charge_Amount__c=500;
        easypay.Payment_Type__c = 'R';
        easypay.Payment_Display_Status__c='Pending';
        easypay.ChargentOrders__Payment_Status__c='Recurring';
        easypay.ChargentOrders__Payment_Frequency__c='Monthly';
        easypay.ChargentOrders__Payment_Stop__c = 'Date';
        easypay.ChargentOrders__Payment_End_Date__c= Date.newInstance(3030, 12, 31);
    }
    
    //Deferral with charge date after payment start date - NWD in same month as start date
    static TestMethod void testDeferral1(){
        String debugTag = 'defer 1 - ';
        Date calcNWD;
        Date currentNWD = Date.newInstance(3028, 03, 15);
        Date expectedNWD = Date.newInstance(3028, 04, 15);
        Date dueDate = Date.newInstance(3028, 04, 29);
        String chargeDate = '15';
        setupDeferral();
        
        finacc = finacc;
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        finacc.Fl_Defer_Recurring_Payment_Today__c = true;
        insert finacc;
       
        easypay = easypay;
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        
        calcNWD = NWDManager.calculateNWD(easypay, easypay.ChargentOrders__Payment_Start_Date__c, false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'calcNWD ' + calcNWD);
      //  System.assertEquals(expectedNWD, calcNWD);
    }
    
    //Deferral with charge date before payment start date - NWD in month following start date
    static TestMethod void testDeferral2(){
        String debugTag = 'defer 2 - ';
        Date calcNWD;
        Date currentNWD = Date.newInstance(2016, 11, 6);
        Date expectedNWD = Date.newInstance(2017, 1, 6);
        Date dueDate = Date.newInstance(2016, 12, 29);
        String chargeDate = '6';
        setupDeferral();
        
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        finacc.Fl_Defer_Recurring_Payment_Today__c = true;
        insert finacc;
        
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        calcNWD = NWDManager.calculateNWD(easypay, easypay.ChargentOrders__Payment_Start_Date__c, false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'start date ' + (dueDate - Integer.valueof(hondaCT.No_of_Days__c)));
        System.debug(debugTag+'calcNWD ' + calcNWD);
        //System.assertEquals(expectedNWD, calcNWD);
    }
    
    //Deferral with charge date of 31st getting set in a month with 30 days
    static TestMethod void testDeferral3(){
        String debugTag = 'defer 3 - ';
        Date calcNWD;
        String chargeDate = '31';
        Date currentNWD = Date.newInstance(3028, 11, 30);
        Date dueDate = Date.newInstance(3028, 5, 3);
        Date expectedNWD = Date.newInstance(3028, 4, 30);
        
        
        setupDeferral();
        
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        finacc.Fl_Defer_Recurring_Payment_Today__c = true;
        insert finacc;
        
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        calcNWD = NWDManager.calculateNWD(easypay, easypay.ChargentOrders__Payment_Start_Date__c, false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'start date ' + (dueDate - Integer.valueof(hondaCT.No_of_Days__c)));
        System.debug(debugTag+'calcNWD ' + calcNWD);
        //System.assertEquals(expectedNWD, calcNWD);
    }
    
    //Deferral with charge date of 31st getting set in February of a non-leap year
    static TestMethod void testDeferral4(){
        String debugTag = 'defer 4 - ';
        Date calcNWD;
        String chargeDate = '31';
        Date currentNWD = Date.newInstance(3028, 11, 30);
        Date dueDate = Date.newInstance(3029,3, 3);
        Date expectedNWD = Date.newInstance(3029, 2, 28);
        
        
        setupDeferral();
        
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        finacc.Fl_Defer_Recurring_Payment_Today__c = true;
        insert finacc;
        
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        calcNWD = NWDManager.calculateNWD(easypay, easypay.ChargentOrders__Payment_Start_Date__c, false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'start date ' + (dueDate - Integer.valueof(hondaCT.No_of_Days__c)));
        System.debug(debugTag+'calcNWD ' + calcNWD);
        //System.assertEquals(expectedNWD, calcNWD);
    }
    
    //Deferral with charge date of 31st getting set in Februrary in a leap year
    static TestMethod void testDeferral5(){
        String debugTag = 'defer 5 - ';
        Date calcNWD;
        String chargeDate = '31';
        Date currentNWD = Date.newInstance(3028, 11, 30);
        Date dueDate = Date.newInstance(2020,3, 3);
        Date expectedNWD = Date.newInstance(2020, 2, 29);
        
        
        setupDeferral();
        
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        finacc.Fl_Defer_Recurring_Payment_Today__c = true;
        insert finacc;
        
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        calcNWD = NWDManager.calculateNWD(easypay, easypay.ChargentOrders__Payment_Start_Date__c, false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'start date ' + (dueDate - Integer.valueof(hondaCT.No_of_Days__c)));
        System.debug(debugTag+'calcNWD ' + calcNWD);
     //   System.assertEquals(expectedNWD, calcNWD);
    }
    
    //Deferral with charge date of 29th getting set in Februrary of a non-leap year
    static TestMethod void testDeferral6(){
        String debugTag = 'defer 6 - ';
        Date calcNWD;
        String chargeDate = '29';
        Date currentNWD = Date.newInstance(2016, 11, 29);
        Date dueDate = Date.newInstance(2017,3, 3);
        Date expectedNWD = Date.newInstance(2017, 3, 29);
        
        
        setupDeferral();
        
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        finacc.Fl_Defer_Recurring_Payment_Today__c = true;
        insert finacc;
        
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        calcNWD = NWDManager.calculateNWD(easypay, easypay.ChargentOrders__Payment_Start_Date__c, false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'start date ' + (dueDate - Integer.valueof(hondaCT.No_of_Days__c)));
        System.debug(debugTag+'calcNWD ' + calcNWD);
       // System.assertEquals(expectedNWD, calcNWD);
    }
    
    //Deferral with charge date of 30 getting set to the 30th of the month
    static TestMethod void testDeferral7(){
        String debugTag = 'defer 7 - ';
        Date calcNWD;
        String chargeDate = '30';
        Date currentNWD = Date.newInstance(3028, 11, 30);
        Date dueDate = Date.newInstance(3028,1, 21);
        Date expectedNWD = Date.newInstance(3028, 1, 30);
        
        
        setupDeferral();
        
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        finacc.Fl_Defer_Recurring_Payment_Today__c = true;
        insert finacc;
        
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        calcNWD = NWDManager.calculateNWD(easypay, easypay.ChargentOrders__Payment_Start_Date__c, false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'start date ' + (dueDate - Integer.valueof(hondaCT.No_of_Days__c)));
        System.debug(debugTag+'calcNWD ' + calcNWD);
        //System.assertEquals(expectedNWD, calcNWD);
    }
    
    //Deferral with charge date of 31 getting set to the 31st of the month
    static TestMethod void testDeferral8(){
        String debugTag = 'defer 8 - ';
        Date calcNWD;
        String chargeDate = '31';
        Date currentNWD = Date.newInstance(2016, 12, 31);
        Date dueDate = Date.newInstance(2017, 3, 21);
        Date expectedNWD = Date.newInstance(2017, 3, 31);
        
        
        setupDeferral();
        
        hondaCT.CutOff_Time__c = DateTime.parse('1/18/2016 02:00 AM');
        update hondaCT;
        
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        finacc.Fl_Defer_Recurring_Payment_Today__c = true;
        insert finacc;
        
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        calcNWD = NWDManager.calculateNWD(easypay, easypay.ChargentOrders__Payment_Start_Date__c, false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'start date ' + (dueDate - Integer.valueof(hondaCT.No_of_Days__c)));
        System.debug(debugTag+'calcNWD ' + calcNWD);
        //System.assertEquals(expectedNWD, calcNWD);
    }
    
    //Deferral with charge date of 30 having payment start date after 30th, getting pushed into a month with less than 30 days
    static TestMethod void testDeferral9(){
        String debugTag = 'defer 9 - ';
        Date calcNWD;
        String chargeDate = '30';
        Date currentNWD = Date.newInstance(3028, 12, 30);
        Date dueDate = Date.newInstance(3029,2, 21);
        Date expectedNWD = Date.newInstance(3029, 2, 28);
        
        
        setupDeferral();
        
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        finacc.Fl_Defer_Recurring_Payment_Today__c = true;
        insert finacc;
        
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        calcNWD = NWDManager.calculateNWD(easypay, easypay.ChargentOrders__Payment_Start_Date__c, false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'start date ' + (dueDate - Integer.valueof(hondaCT.No_of_Days__c)));
        System.debug(debugTag+'calcNWD ' + calcNWD);
        //System.assertEquals(expectedNWD, calcNWD);
    }
    
    
    /* **********************************************Testing Deferrals********************************************** */
    
    
    /* **********************************************Testing Reinstatements********************************************** */
    
   
    static TestMethod void setupReinstatement(){
        hondaCT = new Honda_Finance__c();
        hondaCT.No_of_Days__c = 21;
        hondaCT.CutOff_Time__c = DateTime.parse('1/18/2016 2:00 PM');
        insert hondaCT;
        
        finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Honda_Brand__c='AFS';
        finacc.IsUpdated__c=true;
        finacc.FI_Stop_Reinstate_Recurring_Payment__c='R';
        finacc.Fl_Cancel_One_Time_Payments__c = false;
        
        
        easypay = new ChargentOrders__ChargentOrder__c ();
        easypay.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        easypay.ChargentOrders__Charge_Amount__c=500;
        easypay.Payment_Type__c = 'R';
        easypay.Payment_Display_Status__c='Stopped';
        easypay.ChargentOrders__Payment_Status__c='Recurring';
        easypay.ChargentOrders__Payment_Frequency__c='Monthly';
        easypay.ChargentOrders__Payment_Stop__c = 'Date';
        easypay.ChargentOrders__Payment_End_Date__c= Date.newInstance(3030, 12, 31);
    }
    
    //Reinstate with charge date in the future, will set NWD in the next month
    static TestMethod void testResinstate1(){
        String debugTag = 'rein 1 - ';
        Date calcNWD;
        Date currentNWD = Date.newInstance(3028, 10, 20);
        Date expectedNWD = Date.newInstance(3028, 11, 20);
        Date dueDate = Date.newInstance(3028, 7, 25);
        String chargeDate = '20';
        setupReinstatement();
        
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        insert finacc;
        
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        calcNWD = NWDManager.calculateNWD(easypay, currentNWD + 1, false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'calcNWD ' + calcNWD);
        //System.assertEquals(expectedNWD, calcNWD);
    }
    
    //Reinstate with charge date of 31 with the next month only having 30 days
    static TestMethod void testResinstate2(){
        String debugTag = 'rein 2 - ';
        Date calcNWD;
        String chargeDate = '31';
        Date currentNWD = Date.newInstance(2016, 10, 31);
        Date expectedNWD = Date.newInstance(2016, 12, 31);
        Date dueDate = Date.newInstance(2016, 7, 25);
        
        setupReinstatement();
        
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        insert finacc;
        
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        calcNWD = NWDManager.calculateNWD(easypay, currentNWD+1, false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'calcNWD ' + calcNWD);
        //System.assertEquals(expectedNWD, calcNWD);
    }
    
    //Reinstate with charge date in the past, NWD will jump an extra month
    static TestMethod void testResinstate3(){
        String debugTag = 'rein 3 - ';
        Date calcNWD;
        String chargeDate = '2';
        Date currentNWD = Date.newInstance(3028, 10, 4);
        Date expectedNWD = Date.newInstance(3028, 11, 2);
        Date dueDate = Date.newInstance(3028, 7, 25);
        
        setupReinstatement();
        
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        insert finacc;
        
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        calcNWD = NWDManager.calculateNWD(easypay, currentNWD, false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'calcNWD ' + calcNWD);
        //System.assertEquals(expectedNWD, calcNWD);
    }
    
    //Reinstate with charge date of today after cutoff
    static TestMethod void testResinstate4(){
        String debugTag = 'rein 4 - ';
        Date calcNWD;    
        String chargeDate = String.valueof(date.today().day());
        Date currentNWD = Date.today().addmonths(-1);
        Date expectedNWD = Date.today().addmonths(1);
        Date dueDate = Date.newInstance(3028, 7, 25);
        
        setupReinstatement();
        
        //Datetime dt = System.today();
        //String dt1 = '1/18/3028' + String.valueof(dt.time());
        hondaCT.CutOff_Time__c = Datetime.newInstance(3028, 1, 18, Datetime.now().time().hour() - 1, 0, 0);
        update hondaCT;
        
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        insert finacc;
        
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        calcNWD = NWDManager.calculateNWD(easypay, Date.today(), false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'calcNWD ' + calcNWD);
       // System.assertEquals(expectedNWD, calcNWD);
    } 
    
    //Reinstate with charge date of today before cutoff
    static TestMethod void testResinstate5(){ 
        String debugTag = 'rein 5 - ';
        Date calcNWD;
        String chargeDate = String.valueof(date.today().day());
        Date currentNWD = Date.today().addmonths(-1);
        Date expectedNWD = Date.today();
        Date dueDate = Date.newInstance(3028, 7, 25);
        
        setupReinstatement();
        
        
        hondaCT.CutOff_Time__c = Datetime.newInstance(3028, 1, 18, Datetime.now().time().hour() + 1, 0, 0);
        update hondaCT;
        
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        insert finacc;
        
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        calcNWD = NWDManager.calculateNWD(easypay, Date.today(), false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'calcNWD ' + calcNWD);
       // System.assertEquals(expectedNWD, calcNWD);
    } 
    
    //Using a reinstatement to test that the NWD is not being set to a date after a date-based payment has completed
    static TestMethod void testResinstate6(){ 
        String debugTag = 'rein 6 - ';
        Date calcNWD;
        String chargeDate = String.valueof(date.today().day());
        Date currentNWD = Date.today().addmonths(-1);
        Date expectedNWD = currentNWD;
        Date dueDate = Date.newInstance(3028, 7, 25);
        
        setupReinstatement();
        hondaCT.CutOff_Time__c = Datetime.newInstance(3028, 1, 18, Datetime.now().time().hour() + 1, 0, 0);
        update hondaCT;
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        insert finacc;
        
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        easypay.ChargentOrders__Payment_End_Date__c = Date.today().addmonths(-1);
        easypay.ChargentOrders__Payment_Stop__c = 'Date';
        insert easypay;
        
        calcNWD = NWDManager.calculateNWD(easypay, Date.today(), false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'calcNWD ' + calcNWD);
       // System.assertEquals(expectedNWD, calcNWD);
    } 

    //Using a reinstatement to test that the NWD is not being set to a date after a count-based payment has completed
    static TestMethod void testResinstate7(){ 
        String debugTag = 'rein 7 - ';
        Date calcNWD;
        String chargeDate = String.valueof(date.today().day());
        Date currentNWD = Date.today().addmonths(-1);
        Date expectedNWD = currentNWD;
        Date dueDate = Date.newInstance(3028, 7, 25);
        
        setupReinstatement();
        hondaCT.CutOff_Time__c = Datetime.newInstance(3028, 1, 18, Datetime.now().time().hour() + 1, 0, 0);
        update hondaCT;
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        insert finacc;
        
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        easypay.ChargentOrders__Payment_Stop__c = 'Count';
        easypay.Extracted_Payment_Count__c = 5;
        easypay.ChargentOrders__Payment_Count__c = 5;    
        insert easypay;
        
        calcNWD = NWDManager.calculateNWD(easypay, Date.today(), false);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'calcNWD ' + calcNWD);
       // System.assertEquals(expectedNWD, calcNWD);
    } 
    /* **********************************************Testing Reinstatements********************************************** */
    
    /* **********************************************Testing Skip First Month********************************************** */
 static TestMethod void setupSkip(){
        hondaCT = new Honda_Finance__c();
        hondaCT.No_of_Days__c = 21;
        hondaCT.CutOff_Time__c = DateTime.parse('1/18/2016 02:00 PM');
        insert hondaCT;
        
        finacc = new Finance_Account__c();
        finacc.Finance_Account_Number__c='1111';
        finacc.Honda_Brand__c='AFS';
        finacc.IsUpdated__c=true;
        finacc.FI_Stop_Reinstate_Recurring_Payment__c='R';
        finacc.Fl_Cancel_One_Time_Payments__c = false;
        
        
        easypay = new ChargentOrders__ChargentOrder__c ();
        easypay.RecordTypeId=Schema.SobjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        easypay.ChargentOrders__Charge_Amount__c=500;
        easypay.Payment_Type__c = 'R';
        easypay.Payment_Display_Status__c='Pending';
        easypay.ChargentOrders__Payment_Status__c='Recurring';
        easypay.ChargentOrders__Payment_Frequency__c='Monthly';
        easypay.ChargentOrders__Payment_Stop__c = 'Date';
        easypay.ChargentOrders__Payment_End_Date__c= Date.newInstance(2020, 12, 31);
        easypay.Skip_First__c = true;
     
    }
    
    //Skip first month so December is skipped and ensure the new NWD is set to January of the next year
    static TestMethod void testSkip1(){
        String debugTag = 'skip 1 - ';
        Date calcNWD;
        Date currentNWD = Date.newInstance(2016, 12, 15);
        Date expectedNWD = Date.newInstance(2017, 2, 15);
        Date dueDate = Date.newInstance(2016, 7, 25);
        String chargeDate = '15';
        setupSkip();
        
        finacc = finacc;
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        finacc.Fl_Defer_Recurring_Payment_Today__c = true;
        insert finacc;
       
        easypay = easypay;
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        
        calcNWD = NWDManager.calculateNWD(easypay, currentNWD+1, true);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'calcNWD ' + calcNWD);
        //System.assertEquals(expectedNWD, calcNWD);
    }
    
    //Testing skipping the first month, with the next month having less days than the charge date
    static TestMethod void testSkip2(){
        String debugTag = 'skip 2 - ';
        Date calcNWD;
        Date currentNWD = Date.newInstance(2017, 1, 31);
        Date expectedNWD = Date.newInstance(2017, 3, 31);
        Date dueDate = Date.newInstance(2017, 1, 28);
        String chargeDate = '31';
        setupSkip();
        
        finacc = finacc;
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        finacc.Fl_Defer_Recurring_Payment_Today__c = true;
        insert finacc;
       
        easypay = easypay;
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= dueDate - Integer.valueof(hondaCT.No_of_Days__c);
        insert easypay;
        
        
        calcNWD = NWDManager.calculateNWD(easypay,easypay.ChargentOrders__Payment_Start_Date__c , true);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'dueDate ' + dueDate);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'calcNWD ' + calcNWD);
        //System.assertEquals(expectedNWD, calcNWD);
    }
    
    //Deferral with charge date after payment start date - NWD in same month as start date
    static TestMethod void testAdvanceNWDToNxtYr(){
        String debugTag = 'Advance NWD Scenario - ';
        Date currentNWD = Date.newInstance(2016, 12, 1);
        Date expectedNWD = Date.newInstance(2017, 1, 1);
        Date dueDate = Date.newInstance(2016, 12, 10);
        String chargeDate = '1';
        setupDeferral();
        
        finacc = finacc;
        finacc.FA_Next_Withdrawal_Date__c = currentNWD;
        finacc.Payment_Due_Date__c = dueDate;
        finacc.Fl_Defer_Recurring_Payment_Today__c = false;
        insert finacc;
       
        easypay = easypay;
        easypay.ChargentOrders__Charge_Date__c = chargeDate;
        easypay.Next_Withdrawal_Date__c = currentNWD;
        easypay.Finance_Account_Number__c = finacc.Id;
        easypay.ChargentOrders__Payment_Start_Date__c= Date.newInstance(2016, 10, 10);
        insert easypay;
        
        ManagePaymentService.processingDate = currentNWD;
        ManagePaymentService.updateNextWithdrawalDate(easypay);
        System.debug(debugTag+'chargeDate ' + chargeDate);
        System.debug(debugTag+'Todays Date ' + currentNWD);
        System.debug(debugTag+'currentNWD ' + currentNWD);
        System.debug(debugTag+'expectedNWD ' + expectedNWD);
        System.debug(debugTag+'calcNWD ' + easypay.Next_Withdrawal_Date__c);
        System.assertEquals(expectedNWD, easypay.Next_Withdrawal_Date__c);
    }
}