/*	
Description: Util class for all Payment related compoonents	
*/	
import AHFC_MakeAPayment_TotalAmountDue from "@salesforce/label/c.AHFC_makeAPayment_label_totalAmtDue";	
import AHFC_makeAPayment_label_AmtDue from "@salesforce/label/c.AHFC_makeAPayment_label_AmtDue";	
import AHFC_makeAPayment_RemaningAmountDue from "@salesforce/label/c.AHFC_makeAPayment_RemaningAmountDue";	
import AHFC_MakeAPayment_DaysRemaining from "@salesforce/label/c.AHFC_makeAPayment_DaysRemaining";	
import AHFC_MakeAPayment_MakeAPayment from "@salesforce/label/c.AHFC_makeAPayment_label_MakeAPayment";	
import AHFC_MakeAPayment_ViewDetails from "@salesforce/label/c.AHFC_makeAPayment_ViewDetails";	
import AHFC_MakeAPayment_HideDetails from "@salesforce/label/c.AHFC_MakeAPayment_HideDetails";	
import AHFC_MakeAPayment_DueDate from "@salesforce/label/c.AHFC_MakeAPayment_DueDate";	
import AHFC_MakeAPayment_CurrentAmount from "@salesforce/label/c.AHFC_MakeAPayment_CurrentAmount";	
import AHFC_MakeAPayment_FeesDue from "@salesforce/label/c.AHFC_MakeAPayment_FeesDue";	
import AHFC_MakeAPayment_PastAmountDue from "@salesforce/label/c.AHFC_MakeAPayment_PastAmountDue";	
import AHFC_MakeAPayment_DueToday from "@salesforce/label/c.AHFC_MakeAPayment_DueToday";	
import AHFC_MakeAPayement_ScheduledPayments from "@salesforce/label/c.AHFC_MakeAPayement_ScheduledPayments";	
import AHFC_MakeAPayment_OneTimePaymentOn from "@salesforce/label/c.AHFC_MakeAPayment_OneTimePaymentOn";	
import AHFC_MakeAPayment_scheduledEasyPayAmtOn from "@salesforce/label/c.AHFC_MakeAPayment_scheduledEasyPayAmtOn";	
import AHFC_MakeAPayment_PaymentType from "@salesforce/label/c.AHFC_MakeAPayment_PaymentType";	
import AHFC_MakeAPayment_PaymentDetails from "@salesforce/label/c.AHFC_MakeAPayment_PaymentDetails";	
import AHFC_MakeAPayment_MonthlyPaymentAmount from "@salesforce/label/c.AHFC_MakeAPayment_MonthlyPaymentAmount";	
import AHFC_VIN_Location from "@salesforce/label/c.AHFC_VIN_Location";	
import AHFC_MakeAPayment_ScheduledOn from "@salesforce/label/c.AHFC_MakeAPayment_ScheduledOn"	
import AHFC_MakeAPayment_PayAdditionalPrincipleAmt from "@salesforce/label/c.AHFC_MakeAPayment_PayAdditionalPrincipleAmt";	
import AHFC_MakeAPayment_PrincipleBalanceAmount from "@salesforce/label/c.AHFC_MakeAPayment_PrincipleBalanceAmount";	
import AHFC_MakeAPayment_EasyPayInstruction from "@salesforce/label/c.AHFC_MakeAPayment_EasyPayInstruction";
import AHFC_MakeAPayment_EasyPayInstructionPayOff from "@salesforce/label/c.AHFC_MakeAPayment_EasyPayInstructionPayOff";	
import AHFC_MakeAPayment_AdditionalPaymentAmount from "@salesforce/label/c.AHFC_MakeAPayment_AdditionalPaymentAmount";	
import AHFC_MakeAPayment_AutomaticPaymentAmount from "@salesforce/label/c.AHFC_MakeAPayment_AutomaticPaymentAmount";	
import AHFC_MakeAPayment_MonthlyAmount from "@salesforce/label/c.AHFC_MakeAPayment_MonthlyAmount";	
import AHFC_MakeAPayment_WithdrawalPaymentOn from "@salesforce/label/c.AHFC_MakeAPayment_WithdrawalPaymentOn";	
import AHFC_MakeAPayment_NextWithdrawalDate from "@salesforce/label/c.AHFC_MakeAPayment_NextWithdrawalDate";	
import AHFC_MakeAPayment_PayoffAmount from "@salesforce/label/c.AHFC_MakeAPayment_PayoffAmount";	
import AHFC_MakeAPayment_Scheduled_On from "@salesforce/label/c.AHFC_MakeAPayment_Scheduled_On";	
import AHFC_MakeAPayment_Payment_Source from "@salesforce/label/c.AHFC_MakeAPayment_Payment_Source";	
import AHFC_MakeAPayment_Add_Payment_Source from "@salesforce/label/c.AHFC_MakeAPayment_Add_Payment_Source";	
import AHFC_MakeAPayment_Button_Review_Payment from "@salesforce/label/c.AHFC_MakeAPayment_Button_Review_Payment";	
import AHFC_MakeAPayment_Button_Cancel from "@salesforce/label/c.AHFC_MakeAPayment_Button_Cancel";	
import AHFC_MakeAPayment_Radio_OTP from "@salesforce/label/c.AHFC_MakeAPayment_Radio_OTP";	
import AHFC_MakeAPayment_Radio_EZP from "@salesforce/label/c.AHFC_MakeAPayment_Radio_EZP";	
import AHFC_MakeAPayment_Radio_PayOff from "@salesforce/label/c.AHFC_MakeAPayment_Radio_PayOff";	
import AHFC_MakeAPayment_PayoffAmountCalculation from "@salesforce/label/c.AHFC_MakeAPayment_PayoffAmountCalculation";	
import AHFC_makeAPayment_DayRemaining from "@salesforce/label/c.AHFC_makeAPayment_DayRemaining";	
import AHFC_automaticPaymentAmount_Help_Text from "@salesforce/label/c.AHFC_automaticPaymentAmount_Help_Text";	
import AHFC_withdrawalPaymentOn_Help_Text from "@salesforce/label/c.AHFC_withdrawalPaymentOn_Help_Text";
const label = {	
    TotalAmountDue : AHFC_MakeAPayment_TotalAmountDue,	
    AmountDue : AHFC_makeAPayment_label_AmtDue,	
    RemaningAmountDue : AHFC_makeAPayment_RemaningAmountDue,	
    DaysRemaning : AHFC_MakeAPayment_DaysRemaining,	
    MakeAPayment : AHFC_MakeAPayment_MakeAPayment,	
    ViewDetails : AHFC_MakeAPayment_ViewDetails,	
    HideDetails : AHFC_MakeAPayment_HideDetails,	
    DueDate: AHFC_MakeAPayment_DueDate,	
    CurrentAmount : AHFC_MakeAPayment_CurrentAmount,	
    FeesDue: AHFC_MakeAPayment_FeesDue,	
    PastAmountDue : AHFC_MakeAPayment_PastAmountDue,	
    DueToday: AHFC_MakeAPayment_DueToday,	
    ScheduledPayments: AHFC_MakeAPayement_ScheduledPayments,	
    OneTimePaymentOn: AHFC_MakeAPayment_OneTimePaymentOn,	
    ScheduledEasyPayAmtOn : AHFC_MakeAPayment_scheduledEasyPayAmtOn,	
    PaymentType : AHFC_MakeAPayment_PaymentType,	
    PaymentDetails : AHFC_MakeAPayment_PaymentDetails,	
    MonthlyPaymentAmount: AHFC_MakeAPayment_MonthlyPaymentAmount,	
    AHFC_VIN_Location : AHFC_VIN_Location,	
    ScheduledOn : AHFC_MakeAPayment_ScheduledOn,	
    PayAdditionalPrincipleAmt : AHFC_MakeAPayment_PayAdditionalPrincipleAmt,	
    PrincipleBalanceAmount : AHFC_MakeAPayment_PrincipleBalanceAmount,	
    EasyPayInstruction : AHFC_MakeAPayment_EasyPayInstruction,
    EasyPayInstruction1 : AHFC_MakeAPayment_EasyPayInstructionPayOff,	
    AdditionalPaymentAmount : AHFC_MakeAPayment_AdditionalPaymentAmount,	
    AutomaticPaymentAmountHelpText : AHFC_automaticPaymentAmount_Help_Text,	
    AutomaticPaymentAmount : AHFC_MakeAPayment_AutomaticPaymentAmount,	
    MonthlyAmount: AHFC_MakeAPayment_MonthlyAmount,	
    WithdrawalPaymentOn : AHFC_MakeAPayment_WithdrawalPaymentOn,	
    WithdrawalPaymentOnHelpText : AHFC_withdrawalPaymentOn_Help_Text,	
    NextWithdrawalDate:  AHFC_MakeAPayment_NextWithdrawalDate,	
    PayoffAmount : AHFC_MakeAPayment_PayoffAmount,	
    PayoffAmountCalculation : AHFC_MakeAPayment_PayoffAmountCalculation,	
    PaymentSource: AHFC_MakeAPayment_Payment_Source,	
    AddPaymentSource: AHFC_MakeAPayment_Add_Payment_Source,	
    ReviewPayment: AHFC_MakeAPayment_Button_Review_Payment,	
    CancelButton: AHFC_MakeAPayment_Button_Cancel,	
    RadioOTP: AHFC_MakeAPayment_Radio_OTP,	
    RadioEZP: AHFC_MakeAPayment_Radio_EZP,	
    RadioPayoff: AHFC_MakeAPayment_Radio_PayOff,	
    DayRemaining : AHFC_makeAPayment_DayRemaining,
};	
const getMakeAPaymentConstants = () =>{	
    return {	
     PAYMENT_SOURCE : 'Payment Source',	
     RECEIVE_PAYMENT_CONFIRMATION_ON: 'Receive payment confirmation on',	
     DUE_ON: 'Due on',	
     SELECTEDDATE_IS_BEYOND_DUEDATE: "Your selected date is beyond your due date. You may incur late fees.",	
    }	
}	
export { label };	
export { getMakeAPaymentConstants };