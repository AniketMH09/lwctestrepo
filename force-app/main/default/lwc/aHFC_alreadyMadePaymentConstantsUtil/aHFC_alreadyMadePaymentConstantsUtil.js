/*
    Labels for alreadyMadePayment component.
*/

import AHFC_MadePayment_Label_MadePayment_Heading from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_Heading";
import AHFC_MadePayment_Label_MadePayment_SubHeading from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_SubHeading";
import AHFC_MadePayment_Label_MadePayment_PaymentMode from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_PaymentMode";
import AHFC_MadePayment_Label_MadePayment_TrackingNumber from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_TrackingNumber";
import AHFC_MadePayment_Label_MadePayment_PaymentDate from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_PaymentDate";
import AHFC_MadePayment_Label_MadePayment_SelectAmount from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_SelectAmount";
import AHFC_MadePayment_Label_MadePayment_RadioTotalAmount from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_RadioTotalAmount";
import AHFC_MadePayment_Label_MadePayment_RadioPastDue from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_RadioPastDue";
import AHFC_MadePayment_Label_MadePayment_RadioOther from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_RadioOther";
import AHFC_MadePayment_Label_MadePayment_AmountPaid from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_AmountPaid";
import AHFC_MadePayment_Label_MadePayment_ButtonSubmit from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_ButtonSubmit";
import AHFC_MadePayment_Label_MadePayment_ButtonCancel from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_ButtonCancel";
import AHFC_MadePayment_Label_MadePayment_ThankYou from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_ThankYou";
import AHFC_MadePayment_Label_MadePayment_SubmittedInfo from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_SubmittedInfo";
import AHFC_MadePayment_Label_MadePayment_PaymentModeLabel from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_PaymentModeLabel";
import AHFC_MadePayment_Label_MadePayment_PaymentDateLabel from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_PaymentDateLabel";
import AHFC_MadePayment_Label_MadePayment_ButtonDashboard from "@salesforce/label/c.AHFC_MadePayment_Label_MadePayment_ButtonDashboard";
import AHFC_MadePayment_Label_PastDueDays from "@salesforce/label/c.AHFC_MadePayment_Label_PastDueDays";
import AHFC_Community_Named_Dashboard from "@salesforce/label/c.AHFC_Community_Named_Dashboard";
import AHFC_Mode_Of_Payment from "@salesforce/label/c.AHFC_Mode_Of_Payment";
import AHFC_Mode_Of_Payment_Value from "@salesforce/label/c.AHFC_Mode_Of_Payment_Value";
import AHFC_comma_Seperate from "@salesforce/label/c.AHFC_comma_Seperate";
import AHFC_dollar from "@salesforce/label/c.AHFC_dollar";
import AHFC_Customer_Service_Phone_Number from "@salesforce/label/c.AHFC_MadePayment_Label_Customer_Service_Number";
import AHFC_Already_Made_Payment_Error_Msg from "@salesforce/label/c.Already_Made_Payment_Error_Msg";


const getLabels = () => {
    return {
        madePaymentHeading: AHFC_MadePayment_Label_MadePayment_Heading,
        madePaymentSubHeading: AHFC_MadePayment_Label_MadePayment_SubHeading,
        madePaymentInputPaymentMode: AHFC_MadePayment_Label_MadePayment_PaymentMode,
        madePaymentInputTrackingNumber: AHFC_MadePayment_Label_MadePayment_TrackingNumber,
        madePaymentInputPaymentDate: AHFC_MadePayment_Label_MadePayment_PaymentDate,
        madePaymentSelectAmount: AHFC_MadePayment_Label_MadePayment_SelectAmount,
        madePaymentRadioTotalAmount: AHFC_MadePayment_Label_MadePayment_RadioTotalAmount,
        madePaymentPastDue: AHFC_MadePayment_Label_MadePayment_RadioPastDue,
        madePaymentRadioOther: AHFC_MadePayment_Label_MadePayment_RadioOther,
        madePaymentAmountPaid: AHFC_MadePayment_Label_MadePayment_AmountPaid,
        madePaymentButtonSumbit: AHFC_MadePayment_Label_MadePayment_ButtonSubmit,
        madePaymentButtonCancel: AHFC_MadePayment_Label_MadePayment_ButtonCancel,
        madePaymentThankYou: AHFC_MadePayment_Label_MadePayment_ThankYou,
        madePaymentSubmittedInfo: AHFC_MadePayment_Label_MadePayment_SubmittedInfo,
        madePaymentLabelPaymentMode: AHFC_MadePayment_Label_MadePayment_PaymentModeLabel,
        madePaymentLabelPaymentDate: AHFC_MadePayment_Label_MadePayment_PaymentDateLabel,
        madePaymentButtonDashboard: AHFC_MadePayment_Label_MadePayment_ButtonDashboard,
        madePaymentPastDueDays: AHFC_MadePayment_Label_PastDueDays,
        communityNamedDashboard: AHFC_Community_Named_Dashboard,
        madePaymentModeOfPayments: AHFC_Mode_Of_Payment,
        madePaymentModeOfPaymentValues: AHFC_Mode_Of_Payment_Value,
        commaSaparate: AHFC_comma_Seperate,
        dollar: AHFC_dollar,
        Customer_Service_Phone_Number: AHFC_Customer_Service_Phone_Number,
        AHFC_Already_Made_Payment_Error_Msg:AHFC_Already_Made_Payment_Error_Msg
    }
}

export { getLabels };