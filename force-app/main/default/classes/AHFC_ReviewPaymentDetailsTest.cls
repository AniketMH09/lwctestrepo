/*@Apex Class   	 :   AHFC_ReviewPaymentDetailsTest
* @description       :   Test class for AHFC_ReviewPaymentDetails
* @created By        :   Aswin Jose
* @created on        :   30/6/2021
* @modified on		 :	
* @modified By		 :	Aswin Jose
* @modification Log	 :	
*********************************************************************************/
@isTest
public class AHFC_ReviewPaymentDetailsTest {
    
    public static testMethod void testData1(){
        Test.startTest();
        
        Finance_Account__c finAccount = new Finance_Account__c();
        finAccount.Finance_Account_Number__c='1000001';
        finAccount.Honda_Brand__c='AFS';
        finAccount.AHFC_Last_4_SSN__c    ='1234';  
        finAccount.AHFC_Garaging_Zip__c   = '12345';
        finAccount.Vehicle_Identification_Number__c = '12345678901234567';
        finAccount.Final_Due_Date__c = System.today().AddDays(100);
        insert finAccount;
        System.assertEquals(finAccount.Finance_Account_Number__c, '1000001', 'Finance account created successfully');
        
        Payment_Source__c paymentSource = new Payment_Source__c();
        paymentSource.ChargentOrders_Tokenization__c = '123123123123123';
        insert paymentSource;
        System.assertEquals(paymentSource.ChargentOrders_Tokenization__c, '123123123123123', 'Payment source created successfully');
        
        Communication_Preferences__c commprefObj = new Communication_Preferences__c();
        commprefObj.Email_Address__c = 'rossi@honda.com.invalid';
        commprefObj.Text_Number__c = '9495600700';
        commprefObj.Payment_Confirmations_via_Email__c = true;
        commprefObj.Payment_Confirmations_via_Text__c = true;
        commprefObj.Paperless_Statements_Letters__c = true;
        commprefObj.Finance_Account_Number__c = finAccount.Id;
        insert commprefObj;
        System.assertEquals(commprefObj.Email_Address__c, 'rossi@honda.com.invalid', 'Communication preference created successfully');
        
        Communication_Preferences__c commPref = AHFC_ReviewPaymentDetails.commPrefDetail(finAccount.Id);
       
        Communication_Preferences__c commPrefForOtp = AHFC_ReviewPaymentDetails.commPrefDetailForOTP(finAccount.Id);
      
        System.assertEquals(commPref.Id, commprefObj.id, 'Success');
        System.assertEquals(commPrefForOtp.Id, commprefObj.id, 'Success');
        
        Communication_Preferences__c commprefObjEasyPay = new Communication_Preferences__c();
        commprefObjEasyPay.Email_Address__c = 'tony@honda.com.invalid';
        commprefObjEasyPay.Text_Number__c = '9495600799';
        commprefObjEasyPay.EasyPay_Communications_via_Email__c = true;
        commprefObjEasyPay.EasyPay_Communications_via_Text__c = true;
        commprefObjEasyPay.Paperless_Statements_Letters__c = true;
        commprefObjEasyPay.Finance_Account_Number__c = finAccount.Id;
        insert commprefObjEasyPay;
        
         Communication_Preferences__c commPrefForEasyPay = AHFC_ReviewPaymentDetails.commPrefDetailForEasyPay(finAccount.Id);
        System.assertEquals(commPrefForEasyPay.Id, commprefObjEasyPay.id, 'Success');
        
        List<ChargentOrders__ChargentOrder__c> payList = AHFC_ReviewPaymentDetails.insertPayments(finAccount.Id, paymentSource.Id, 5000.50,System.today(),23);
        
        List<ChargentOrders__ChargentOrder__c> lstSuccessPayments = [SELECT id, Confirmation_Number__c,Payment_Type__c, ChargentOrders__Payment_Start_Date__c, 
                              Payment_Source_Nickname__r.Name,PaymentAuthorizedOn__c FROM ChargentOrders__ChargentOrder__c 
                                                                     WHERE Finance_Account_Number__c =: finAccount.Id];
        if(payList.size()>0 && lstSuccessPayments.size()>0){
            System.assertEquals(payList[0].Confirmation_Number__c, lstSuccessPayments[0].Confirmation_Number__c, 'New payment inserted successfully');
        }  
        else{
            system.assert(lstSuccessPayments.size() == 0, 'New Payment insert failed');
        }
        
        
        Test.stopTest();
    }
    
    public static testMethod void testData2(){
        Test.startTest();
        
        Id recTypeId = Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        
        Finance_Account__c finAccount = new Finance_Account__c();
        finAccount.Finance_Account_Number__c='1000001';
        finAccount.Honda_Brand__c='AFS';
        finAccount.AHFC_Last_4_SSN__c    ='1234';  
        finAccount.AHFC_Garaging_Zip__c   = '12345';
        finAccount.Vehicle_Identification_Number__c = '12345678901234567';
        finAccount.Final_Due_Date__c = System.today().AddDays(100);
        insert finAccount;
        
        Payment_Source__c paymentSource = new Payment_Source__c();
        paymentSource.ChargentOrders_Tokenization__c = '123123123123123';
        insert paymentSource;
        
        ChargentOrders__ChargentOrder__c objPayment = new ChargentOrders__ChargentOrder__c();
        
        objPayment.Finance_Account_Number__c	 				= finAccount.Id;
        objPayment.Payment_Source_Nickname__c 					= paymentSource.Id;
        objPayment.ChargentOrders__Payment_Start_Date__c 		= system.today();
        objPayment.ChargentOrders__Payment_End_Date__c 			= System.today().AddDays(1000);
        objPayment.Next_Withdrawal_Date__c 						= system.today();
        objPayment.ChargentOrders__Charge_Amount__c 			= 500;
        objPayment.Payment_Type__c  							= 'R';  
        objPayment.recordtypeid 								= recTypeId;
        objPayment.ChargentOrders__Manual_Charge__c 			= true;
        objPayment.ChargentOrders__Payment_Method__c 			= 'check'; 
        objPayment.ChargentOrders__Payment_Status__c 			= 'Recurring';
        objPayment.Payment_Display_Status__c 					= 'Pending';
        objPayment.ChargentOrders__Payment_Stop__c 				= 'Date';
        objPayment.ChargentOrders__Payment_Frequency__c 		= 'Monthly';
        objPayment.Payment_Channel__c 							= 'R';
        objPayment.ChargentOrders__Tokenization__c 				= '234324324234';
        objPayment.Duplicate_Key_Tracker__c 					=  finAccount.Finance_Account_Number__c + 'Recurring_Payment' + 'ACTIVE';
        
        insert objPayment;  
        System.assertEquals(objPayment.ChargentOrders__Tokenization__c, '234324324234', 'Payment has been created successfully');
        
        List<ChargentOrders__ChargentOrder__c> updateList = AHFC_ReviewPaymentDetails.updatePaymentAfterCancelEasyPay(objPayment.Id);
        System.assertEquals(updateList.size(), 1, 'Success');
        System.assertEquals(updateList[0].Payment_Display_Status__c, 'Cancelled', 'Payment has been cancelled');
        
        
        Test.stopTest();
    }
    
    //For US:3692 Added by Aswin Jose
    public static testMethod void testData3(){
        test.startTest();
        
        Id recTypeIdStdOTP = Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Standard One-Time Payment').getRecordTypeId();
        Id recTypeIdPrincipalOTP = Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Principal One-Time Payment').getRecordTypeId();
        Id recTypeIdEZP = Schema.SObjectType.ChargentOrders__ChargentOrder__c.getRecordTypeInfosByName().get('Recurring Payment').getRecordTypeId();
        
        Finance_Account__c finAccount = new Finance_Account__c();
        finAccount.Finance_Account_Number__c='1000001';
        finAccount.Honda_Brand__c='AFS';
        finAccount.AHFC_Last_4_SSN__c    ='1234';  
        finAccount.AHFC_Garaging_Zip__c   = '12345';
        finAccount.Vehicle_Identification_Number__c = '12345678901234567';
        finAccount.Final_Due_Date__c = System.today().AddDays(100);
        insert finAccount;
        
        List<ChargentOrders__ChargentOrder__c> paymentList = new List<ChargentOrders__ChargentOrder__c>();
        ChargentOrders__ChargentOrder__c objPayment1 = new ChargentOrders__ChargentOrder__c();
        objPayment1.Finance_Account_Number__c = finAccount.id;
        objPayment1.ChargentOrders__Charge_Amount__c = 50;
        objPayment1.RecordTypeId = recTypeIdStdOTP;
        objPayment1.Payment_Display_Status__c = 'Pending';
        
        ChargentOrders__ChargentOrder__c objPayment2 = new ChargentOrders__ChargentOrder__c();
        objPayment2.Finance_Account_Number__c = finAccount.id;
        objPayment2.ChargentOrders__Charge_Amount__c = 100;
        objPayment2.RecordTypeId = recTypeIdStdOTP;
        objPayment2.Payment_Display_Status__c = 'Pending';
        
        ChargentOrders__ChargentOrder__c objPayment3 = new ChargentOrders__ChargentOrder__c();
        objPayment3.Finance_Account_Number__c = finAccount.id;
        objPayment3.ChargentOrders__Charge_Amount__c = 200;
        objPayment3.RecordTypeId = recTypeIdStdOTP;
        objPayment3.Payment_Display_Status__c = 'Pending';
        
        ChargentOrders__ChargentOrder__c objPayment4 = new ChargentOrders__ChargentOrder__c();
        objPayment4.Finance_Account_Number__c = finAccount.id;
        objPayment4.ChargentOrders__Charge_Amount__c = 300;
        objPayment4.RecordTypeId = recTypeIdStdOTP;
        objPayment4.Payment_Display_Status__c = 'Pending';
        
        ChargentOrders__ChargentOrder__c objPayment5 = new ChargentOrders__ChargentOrder__c();
        objPayment5.Finance_Account_Number__c = finAccount.id;
        objPayment5.ChargentOrders__Charge_Amount__c = 400;
        objPayment5.RecordTypeId = recTypeIdStdOTP;
        objPayment5.Payment_Display_Status__c = 'Pending';
        
        ChargentOrders__ChargentOrder__c objPayment6 = new ChargentOrders__ChargentOrder__c();
        objPayment6.Finance_Account_Number__c = finAccount.id;
        objPayment6.ChargentOrders__Charge_Amount__c = 500;
        objPayment6.RecordTypeId = recTypeIdStdOTP;
        objPayment6.Payment_Display_Status__c = 'Processing';
        
        paymentList.add(objPayment1);
        paymentList.add(objPayment2);
        paymentList.add(objPayment3);
        paymentList.add(objPayment4);
        paymentList.add(objPayment5);
        paymentList.add(objPayment6);
        insert paymentList;
        
        System.assertEquals(paymentList.size(), 6, 'Six Payment Records added');
        
        AHFC_ReviewPaymentDetails.PaymentWrapper paywrap =AHFC_ReviewPaymentDetails.getNumberOfPaymentsAlreadyCreated(finAccount.Id);
        System.assertEquals(paywrap.sixOtpError, true, 'there are six OTP, so sixOtpError flag will be true');
        
        test.stopTest();
    }
}