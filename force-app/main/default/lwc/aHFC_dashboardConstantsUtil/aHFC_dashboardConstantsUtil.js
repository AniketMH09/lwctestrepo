/* Component Name        :    aHFC_dashboardConstantsUtil
    * Description        :    Util class for all Dashboard compoonents
    * Modification Log   :  
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    
    * Shristi                      30/07/2021              Modified for US 8745
*/

import AHFC_DashboardStatement_Link_Download_Acrobat_Reader from "@salesforce/label/c.AHFC_DashboardStatement_Link_Download_Acrobat_Reader";

import AHFC_MyDashboard from "@salesforce/label/c.My_Dashboard";
import AHFC_MakeAPayment from "@salesforce/label/c.Make_A_Payment";
import AHFC_EnrollInEasyPay from "@salesforce/label/c.Enroll_In_EasyPay";
import AHFC_FinanceAccountDetails from "@salesforce/label/c.Finance_Account_Details";
import AHFC_MyPaymentSources from "@salesforce/label/c.My_Payment_Sources";
import AHFC_CommunicationPreferences from "@salesforce/label/c.Communication_Preferences";
import AHFC_Statements from "@salesforce/label/c.Statements";
import AHFC_Correspondence from "@salesforce/label/c.Correspondence";

import AHFC_OffersHondaURL from "@salesforce/label/c.Offers_Honda_URL";
import AHFC_OffersAcuraURL from "@salesforce/label/c.Offers_Acura_URL";
import AHFC_OffersPowersportsURL from "@salesforce/label/c.Offers_Powersports_URL";
import AHFC_OffersPowerEquipmentURL from "@salesforce/label/c.Offers_Power_Equipment_URL";
import AHFC_OffersMarineURL from "@salesforce/label/c.Offers_Marine_URL";

import AHFC_CalculatorHondaNewVehiclesURL from "@salesforce/label/c.Calculator_Honda_New_Vehicles_URL";
import AHFC_CalculatorHondaCertifiedPreOwnedURL from "@salesforce/label/c.Calculator_Honda_Certified_Pre_Owned_URL";
import AHFC_CalculatorPowersportsURL from "@salesforce/label/c.Calculator_Powersports_URL";
import AHFC_CalculatorAcuraURL from "@salesforce/label/c.Calculator_Acura_URL";
import AHFC_CalculatorMarineURL from "@salesforce/label/c.Calculator_Marine_URL";
import AccoutTypeRetail from '@salesforce/label/c.dashboard_account_type';

import AHFC_LocateADealerHondaURL from "@salesforce/label/c.Locate_A_Dealer_Honda_URL";
import AHFC_LocateADealerAcuraURL from "@salesforce/label/c.Locate_A_Dealer_Acura_URL";
import AHFC_LocateADealerPowersportsURL from "@salesforce/label/c.Locate_A_Dealer_Powersports_URL";
import AHFC_LocateADealerMarineURL from "@salesforce/label/c.Locate_A_Dealer_Marine_URL";
import AHFC_LocateADealerPowerEquipmentURL from "@salesforce/label/c.Locate_A_Dealer_Power_Equipment_URL";

import AHFC_ProductSupportHondaURL from "@salesforce/label/c.Product_Support_Honda_URL";
import AHFC_ProductSupportAcuraURL from "@salesforce/label/c.Product_Support_Acura_URL";
import AHFC_ProductSupportPowersportsURL from "@salesforce/label/c.Product_Support_Powersports_URL";
import AHFC_ProductSupportMarineURL from "@salesforce/label/c.Product_Support_Marine_URL";
import AHFC_ProductSupportPowerRequirementURL from "@salesforce/label/c.Product_Support_Power_Requirement_URL";

import AHFC_MyAccount from "@salesforce/label/c.MyAccount";
import AHFC_FinanceTools from "@salesforce/label/c.FINANCETOOLS";
import AHFC_ApplyforPreApproval from "@salesforce/label/c.ApplyforPreApproval";
import AHFC_LeaseVsFinance from "@salesforce/label/c.LeaseVsFinance";
import AHFC_HondaLoyaltyBenefits from "@salesforce/label/c.HondaLoyaltyBenefits";
import AHFC_AcuraLoyaltyAdvantage from "@salesforce/label/c.AcuraLoyaltyAdvantage";
import AHFC_EndofTerm from "@salesforce/label/c.EndofTerm";
import AHFC_ProtectionofProducts from "@salesforce/label/c.ProtectionofProducts";
import AHFC_SUPPORT from "@salesforce/label/c.SUPPORT";
import AHFC_HelpCenter from "@salesforce/label/c.HelpCenter";
import AHFC_ContactUs from "@salesforce/label/c.ContactUs";
import AHFC_PaymentOptions from "@salesforce/label/c.PaymentOptions";
import AHFC_PrintableForms from "@salesforce/label/c.PrintableForms";
import AHFC_OWNERS from "@salesforce/label/c.OWNERS";
import LargeLabel from "@salesforce/label/c.Large";
import MediumLabel from "@salesforce/label/c.Medium";
import AHFC_Cookie_Policy from "@salesforce/label/c.Cookie_Policy_URL";

import AHFC_InvesterRelationsUrl from "@salesforce/label/c.Investor_Relations_URL";
import AHFC_CareersUrl from "@salesforce/label/c.Careers_URL";

import AHFC_FaqHelpPayments from "@salesforce/label/c.Faq_Help_Payments";
import AHFC_FaqHelpAccountManagement from "@salesforce/label/c.Faq_Help_Account_Management";
import AHFC_FaqhelpEndOFTerm from "@salesforce/label/c.Faq_help_End_OF_Term";
import AHFC_FaqHelpViewAllFaq from "@salesforce/label/c.Faq_Help_View_All_Faq";



import AHFC_HondaCarLogoUrl from "@salesforce/label/c.Honda_Car_Logo_URL";
import AHFC_HondaAcuraLogoUrl from "@salesforce/label/c.Honda_Acura_Logo_URL";
import AHFC_HondaBikeLogoUrl from "@salesforce/label/c.Honda_Bike_Logo_URL";
import AHFC_HondaPowerEquipmentLogoUrl from "@salesforce/label/c.Honda_PowerEquipment_Logo_URL";
import AHFC_HondaMarineLogoUrl from "@salesforce/label/c.Honda_Marine_Logo_URL";
import AHFC_HondaJetLogoUrl from "@salesforce/label/c.Honda_Jet_URL";

import AHFC_OFFER from "@salesforce/label/c.Footer_Offers";
import AHFC_Honda from "@salesforce/label/c.Footer_Honda";
import AHFC_Acura from "@salesforce/label/c.Footer_Acura";
import AHFC_PowerSports from "@salesforce/label/c.Footer_Powersports";
import AHFC_PowerEquipment from "@salesforce/label/c.Footer_Power_Equipment";
import AHFC_Marine from "@salesforce/label/c.Footer_Marine";
import AHFC_Calculator from "@salesforce/label/c.Footer_Calculators";
import AHFC_HondaNewVehickes from "@salesforce/label/c.Footer_Honda_New_Vehicles";
import AHFC_HondaCertifiedOwner from "@salesforce/label/c.Footer_Honda_Certified_Pre_Owned";
import AHFC_Locatedealer from "@salesforce/label/c.Footer_Locate_a_Dealer";
import AHFC_ProductSupport from "@salesforce/label/c.Footer_Product_Support";
import AHFC_HondaFamilyOfBrands from "@salesforce/label/c.Footer_THE_HONDA_FAMILY_OF_BRANDS";
import AHFC_Aboutus from "@salesforce/label/c.Footer_About_Us";
import AHFC_TermsAndConditions from "@salesforce/label/c.Footer_Terms_Conditions";
import AHFC_Privacypolicy from "@salesforce/label/c.Footer_Privacy_Policy";
import AHFC_InvestorRelations from "@salesforce/label/c.Footer_Investor_Relations";
import AHFC_Careers from "@salesforce/label/c.Footer_Careers";
import AHFC_PersonalInfo from "@salesforce/label/c.Footer_Do_Not_Sell_My_Personal_Information";
import AHFC_Cookietext from "@salesforce/label/c.Footer_Cookie_text";
import AHFC_CookiePolicy from "@salesforce/label/c.Footer_cookie_policy";
import AHFC_Corporation from "@salesforce/label/c.Footer_Corporation";
import AHFC_FooterLogIn from "@salesforce/label/c.Footer_Log_In";
import AHFC_EditNickname from "@salesforce/label/c.EditModel_Edit_Nickname";
import AHFC_NickName from "@salesforce/label/c.EditModel_Nickname";
import AHFC_EditSave from "@salesforce/label/c.EditModel_Save";
import AHFC_Editcancel from "@salesforce/label/c.EditModel_Cancel";
import AHFC_CurrentBillDetails from "@salesforce/label/c.CurrentBill_VIEW_DETAILS";
import AHFC_CurrentBillHelp from "@salesforce/label/c.CurrentBill_Need_Help";
import AHFC_CurrentBillDueAmount from "@salesforce/label/c.CurrentBill_Amount_Due_Details";



import AHFC_DashboardStatement_Link_View_All_Statement from "@salesforce/label/c.AHFC_DashboardStatement_Link_View_All_Statement";
import AHFC_DashboardStatement_Link_Go_Paperless from "@salesforce/label/c.AHFC_DashboardStatement_Link_Go_Paperless";
import AHFC_DashboardStatement_Placeholder_Select_Month from "@salesforce/label/c.AHFC_DashboardStatement_Placeholder_Select_Month";
import AHFC_DashboardPaymentActivity_Label_Nexy_Payment from "@salesforce/label/c.AHFC_DashboardPaymentActivity_Label_Nexy_Payment";
import AHFC_DashboardPaymentActivity_Label_Last_Payment from "@salesforce/label/c.AHFC_DashboardPaymentActivity_Label_Last_Payment";
import AHFC_DashboardPaymentActivity_Link_View_Activity from "@salesforce/label/c.AHFC_DashboardPaymentActivity_Link_View_Activity";
import AHFC_DashboardPaymentProgress_Label_Maturity_Date from "@salesforce/label/c.AHFC_DashboardPaymentProgress_Label_Maturity_Date";
import AHFC_DashboardPaymentProgress_Label_Term from "@salesforce/label/c.AHFC_DashboardPaymentProgress_Label_Term";
import AHFC_DashboardPaymentProgress_Label_Term_Months from "@salesforce/label/c.AHFC_DashboardPaymentProgress_Label_Term_Months";
import AHFC_DashboardPaymentProgress_Link_Payoff_Calender from "@salesforce/label/c.AHFC_DashboardPaymentProgress_Link_Payoff_Calender";
import AHFC_DashboardPaymentProgress_Link_Contract_Details from "@salesforce/label/c.AHFC_DashboardPaymentProgress_Link_Contract_Details";
import AHFC_Community_Named_Payoff_Calendar from "@salesforce/label/c.AHFC_Community_Named_Payoff_Calendar";
import AHFC_Community_Named_Contracts from "@salesforce/label/c.AHFC_Community_Named_Contracts";
import AHFC_Dashboard_Link_Account_Details from "@salesforce/label/c.AHFC_Dashboard_Link_Account_Details";
import AHFC_Dashboard_Link_Add_Product from "@salesforce/label/c.AHFC_Dashboard_Link_Add_Product";
import AHFC_Dashboard_Label_Vin from "@salesforce/label/c.AHFC_Dashboard_Label_Vin";
import AHFC_Dashboard_Label_Account_No from "@salesforce/label/c.AHFC_Dashboard_Label_Account_No";
import AHFC_Dashboard_Label_Account_Type from "@salesforce/label/c.AHFC_Dashboard_Label_Account_Type";
import AHFC_Dashboard_Label_Current_Bill_Title from "@salesforce/label/c.AHFC_Dashboard_Label_Current_Bill_Title";
import AHFC_Dashboard_Label_Payment_Progress_Title from "@salesforce/label/c.AHFC_Dashboard_Label_Payment_Progress_Title";
import AHFC_Dashboard_Label_Payment_Activity_Title from "@salesforce/label/c.AHFC_Dashboard_Label_Payment_Activity_Title";
import AHFC_Dashboard_Label_Statements_Title from "@salesforce/label/c.AHFC_Dashboard_Label_Statements_Title";
import AHFC_Dashboard_Label_Messages_Title from "@salesforce/label/c.AHFC_Dashboard_Label_Messages_Title";
import AHFC_DashboardFaq_Label_Heading from "@salesforce/label/c.AHFC_DashboardFaq_Label_Heading";
import AHFC_Dashboard_Label_More_Info from "@salesforce/label/c.AHFC_Dashboard_Label_More_Info";
import AHFC_Dashboard_Label_Less_Info from "@salesforce/label/c.AHFC_Dashboard_Label_Less_Info";
import AHFC_DashboardCurrentBill_Label_Easypay_Enrolled from "@salesforce/label/c.AHFC_DashboardCurrentBill_Label_Easypay_Enrolled";
import AHFC_DashboardCurrentBill_Label_Total_Amount_Due from "@salesforce/label/c.AHFC_DashboardCurrentBill_Label_Total_Amount_Due";
import AHFC_DashboardCurrentBill_Label_Due_Date from "@salesforce/label/c.AHFC_DashboardCurrentBill_Label_Due_Date";
import AHFC_DashboardCurrentBill_Label_Due_Date_Day from "@salesforce/label/c.AHFC_DashboardCurrentBill_Label_Due_Date_Day";
import AHFC_DashboardCurrentBill_Label_Due_Date_Days from "@salesforce/label/c.AHFC_DashboardCurrentBill_Label_Due_Date_Days";
import AHFC_DashboardCurrentBill_Label_Due_Date_Remaining from "@salesforce/label/c.AHFC_DashboardCurrentBill_Label_Due_Date_Remaining";
import AHFC_DashboardCurrentBill_Label_Due_Date_Includes from "@salesforce/label/c.AHFC_DashboardCurrentBill_Label_Due_Date_Includes";
import AHFC_DashboardCurrentBill_Label_Due_Date_Past_Due from "@salesforce/label/c.AHFC_DashboardCurrentBill_Label_Due_Date_Past_Due";
import AHFC_DashboardCurrentBill_Button_Make_OTP from "@salesforce/label/c.AHFC_DashboardCurrentBill_Button_Make_OTP";
import AHFC_DashboardCurrentBill_Button_Manage_Easypay from "@salesforce/label/c.AHFC_DashboardCurrentBill_Button_Manage_Easypay";
import AHFC_DashboardCurrentBill_Button_Make_Payment from "@salesforce/label/c.AHFC_DashboardCurrentBill_Button_Make_Payment";
import AHFC_DashboardCurrentBill_Button_Enroll_Easypay from "@salesforce/label/c.AHFC_DashboardCurrentBill_Button_Enroll_Easypay";
import AHFC_DashboardCurrentBill_Link_Other_Payment_Options from "@salesforce/label/c.AHFC_DashboardCurrentBill_Link_Other_Payment_Options";
import AHFC_DashboardMadePayment_Label_Past_Due from "@salesforce/label/c.AHFC_DashboardMadePayment_Label_Past_Due";
import AHFC_DashboardMadePayment_Link_Already_Done from "@salesforce/label/c.AHFC_DashboardMadePayment_Link_Already_Done";
import AHFC_DashboardBlank_Label_Set_Up_Header from "@salesforce/label/c.AHFC_DashboardBlank_Label_Set_Up_Header";
import AHFC_DashboardBlank_Label_Set_Up_Sub_Header from "@salesforce/label/c.AHFC_DashboardBlank_Label_Set_Up_Sub_Header";
import AHFC_DashboardBlank_Label_Button_Add_Finance from "@salesforce/label/c.AHFC_DashboardBlank_Label_Button_Add_Finance";
import AHFC_Community_Named_Finance_Account_Profile from "@salesforce/label/c.AHFC_Community_Named_Finance_Account_Profile";
import AHFC_Community_Named_Add_Finance_Account from "@salesforce/label/c.AHFC_Community_Named_Add_Finance_Account";
import AHFC_Community_Named_Made_Payment from "@salesforce/label/c.AHFC_Community_Named_Made_Payment";
import AHFC_SupportRequestTile_Text from "@salesforce/label/c.AHFC_SupportRequestTile_Text";
import AHFC_CorrespondenceTile_Text from "@salesforce/label/c.AHFC_CorrespondenceTile_Text";
import AHFC_SupportRequestTile_Button from "@salesforce/label/c.AHFC_SupportRequestTile_Button";
import AHFC_CorrespondenceTile_btn from "@salesforce/label/c.AHFC_CorrespondenceTile_btn";
import AHFC_No_Scheduled_Payments from "@salesforce/label/c.AHFC_No_Scheduled_Payments";
import AHFC_No_payments_made_yet from "@salesforce/label/c.AHFC_No_payments_made_yet";
import AHFC_Dashboard_PaymentsActivityBtn from "@salesforce/label/c.AHFC_Dashboard_PaymentsActivityBtn";
import AHFC_Dashboard_PaymentsActivity_Status_Pending from "@salesforce/label/c.AHFC_Dashboard_PaymentsActivity_Status_Pending";
import AHFC_Dashboard_PaymentsActivity_type from "@salesforce/label/c.AHFC_Dashboard_PaymentsActivity_type";
import AHFC_Dashboard_SupportRequest_TileLabel from "@salesforce/label/c.AHFC_Dashboard_SupportRequest_TileLabel";
import AHFC_Dashboard_Correspondence_TileLabel from "@salesforce/label/c.AHFC_Dashboard_Correspondence_TileLabel";
import AHFC_Dashboard_Marketing_TileLabel from "@salesforce/label/c.AHFC_Dashboard_Marketing_TileLabel";

//labels for transactions page
import AHFC_TransactionHistory_Title from "@salesforce/label/c.AHFC_TransactionHistory_Title";
import AHFC_FROM from "@salesforce/label/c.AHFC_FROM";
import AHFC_TO from "@salesforce/label/c.AHFC_TO";
import AHFC_GO from "@salesforce/label/c.AHFC_GO";
import AHFC_TransactionHistory_Label_Filter_Sort from "@salesforce/label/c.AHFC_TransactionHistory_Label_Filter_Sort";
import AHFC_TransactionHistory_ExportList from "@salesforce/label/c.AHFC_TransactionHistory_ExportList";
import AHFC_Date from "@salesforce/label/c.AHFC_Date";
import AHFC_TransactionHistory_Label_Total from "@salesforce/label/c.AHFC_TransactionHistory_Label_Total";
import AHFC_TransactionHistory_Label_Description from "@salesforce/label/c.AHFC_TransactionHistory_Label_Description";
import AHFC_TransactionHistory_Label_Actions from "@salesforce/label/c.AHFC_TransactionHistory_Label_Actions";
import AHFC_TransactionHistory_Label_Details from "@salesforce/label/c.AHFC_TransactionHistory_Label_Details";
import AHFC_TransactionHistory_Label_View_Details from "@salesforce/label/c.AHFC_TransactionHistory_Label_View_Details";
import AHFC_TransactionHistory_Label_PastStatements from "@salesforce/label/c.AHFC_TransactionHistory_Label_PastStatements";
import AHFC_TransactionHistory_Label_ViewStatements from "@salesforce/label/c.AHFC_TransactionHistory_Label_ViewStatements";
import AHFC_TransactionHistory_Label_Return_To_Dashboard from "@salesforce/label/c.AHFC_TransactionHistory_Label_Return_To_Dashboard";
import AHFC_TransactionHistory_Label_Sort_By from "@salesforce/label/c.AHFC_TransactionHistory_Label_Sort_By";
import AHFC_CancelPayment_Label_Cancel from "@salesforce/label/c.AHFC_CancelPayment_Label_Cancel";
import AHFC_TransactionHistory_Label_Sort_Date_Ascending from "@salesforce/label/c.AHFC_TransactionHistory_Label_Sort_Date_Ascending";
import AHFC_TransactionHistory_Label_Sort_Date_Descending from "@salesforce/label/c.AHFC_TransactionHistory_Label_Sort_Date_Descending";
import AHFC_TransactionHistory_Label_Sort_Total_Ascending from "@salesforce/label/c.AHFC_TransactionHistory_Label_Sort_Total_Ascending";
import AHFC_TransactionHistory_Label_Sort_Total_Descending from "@salesforce/label/c.AHFC_TransactionHistory_Label_Sort_Total_Descending";
import AHFC_TransactionHistory_Label_Tranasactionlabel from "@salesforce/label/c.AHFC_TransactionHistory_Label_Tranasactionlabel";
//Start :Added for US 8745
import AHFC_OWNERS_Honda from "@salesforce/label/c.OWNERS_Honda";
import AHFC_OWNERS_Acura from "@salesforce/label/c.OWNERS_Acura";
import AHFC_OWNERS_HondaUrl from "@salesforce/label/c.OWNERS_HondaUrl";
import AHFC_OWNERS_AcuraUrl from "@salesforce/label/c.OWNERS_AcuraUrl";
//End :Added for US 8745
import AHFC_CUSTOMER from "@salesforce/label/c.AHFC_CUSTOMER";
import aHFC_errorFooter_Label_aboutUs from "@salesforce/label/c.aHFC_errorFooter_Label_aboutUs";
import aHFC_errorFooter_Label_acuraLoyaltyAdvantage from "@salesforce/label/c.aHFC_errorFooter_Label_acuraLoyaltyAdvantage";
import aHFC_errorFooter_Label_communicationPreferences from "@salesforce/label/c.aHFC_errorFooter_Label_communicationPreferences";
import aHFC_errorFooter_Label_correspondence from "@salesforce/label/c.aHFC_errorFooter_Label_correspondence";
import aHFC_errorFooter_Label_creditpreapproval from "@salesforce/label/c.aHFC_errorFooter_Label_creditpreapproval";
import aHFC_errorFooter_Label_dashboard from "@salesforce/label/c.aHFC_errorFooter_Label_dashboard";
import aHFC_errorFooter_Label_endofTerm from "@salesforce/label/c.aHFC_errorFooter_Label_endofTerm";
import aHFC_errorFooter_Label_financeAccountDetails from "@salesforce/label/c.aHFC_errorFooter_Label_financeAccountDetails";
import aHFC_errorFooter_Label_hondaLoyaltyBenefits from "@salesforce/label/c.aHFC_errorFooter_Label_hondaLoyaltyBenefits";
import aHFC_errorFooter_Label_leaseVsFinance from "@salesforce/label/c.aHFC_errorFooter_Label_leaseVsFinance";
import aHFC_errorFooter_Label_myPaymentSources from "@salesforce/label/c.aHFC_errorFooter_Label_myPaymentSources";
import aHFC_errorFooter_Label_paymentOptions from "@salesforce/label/c.aHFC_errorFooter_Label_paymentOptions";
import aHFC_errorFooter_Label_printableForms from "@salesforce/label/c.aHFC_errorFooter_Label_printableForms";
import aHFC_errorFooter_Label_protectionofProducts from "@salesforce/label/c.aHFC_errorFooter_Label_protectionofProducts";
import aHFC_errorFooter_Label_statements from "@salesforce/label/c.aHFC_errorFooter_Label_statements";
import aHFC_errorFooter_Label_termsAndConditions from "@salesforce/label/c.aHFC_errorFooter_Label_termsAndConditions";
//End :Added for US 5149

export const labels = {
    TransactionHistory_Title: AHFC_TransactionHistory_Title,
    FROM: AHFC_FROM,
    TO: AHFC_TO,
    GO: AHFC_GO,
    Filter: AHFC_TransactionHistory_Label_Filter_Sort,
    ExportList: AHFC_TransactionHistory_ExportList,
    DATE: AHFC_Date,
    Total: AHFC_TransactionHistory_Label_Total,
    Description: AHFC_TransactionHistory_Label_Description,
    Actions: AHFC_TransactionHistory_Label_Actions,
    Details: AHFC_TransactionHistory_Label_Details,
    ViewDetails: AHFC_TransactionHistory_Label_View_Details,
    PastStatements: AHFC_TransactionHistory_Label_PastStatements,
    ViewStatements: AHFC_TransactionHistory_Label_ViewStatements,
    Returntodashboard: AHFC_TransactionHistory_Label_Return_To_Dashboard,
    SORTBY: AHFC_TransactionHistory_Label_Sort_By,
    CancelLabel: AHFC_CancelPayment_Label_Cancel,
    AccoutTypeRetaillabel:AccoutTypeRetail,

    MyDashboardLabel: AHFC_MyDashboard,
    MakeAPaymentLabel: AHFC_MakeAPayment,
    EnrollInEasyPayLabel: AHFC_EnrollInEasyPay,
    FinanceAccountDetailsLabel: AHFC_FinanceAccountDetails,
    MyPaymentSourcesLabel: AHFC_MyPaymentSources,
    CommunicationPreferencesLabel: AHFC_CommunicationPreferences,
    StatementsLabel: AHFC_Statements,
    CorrespondenceLabel: AHFC_Correspondence,

    OffersHondaURLLabel: AHFC_OffersHondaURL,
    OffersAcuraURLLabel: AHFC_OffersAcuraURL,
    OffersPowersportsURLLabel: AHFC_OffersPowersportsURL,
    OffersPowerEquipmentURLLabel: AHFC_OffersPowerEquipmentURL,
    OffersMarineURLLabel: AHFC_OffersMarineURL,

    CalculatorHondaNewVehiclesURLLabel: AHFC_CalculatorHondaNewVehiclesURL,
    CalculatorHondaCertifiedPreOwnedURLLabel: AHFC_CalculatorHondaCertifiedPreOwnedURL,
    CalculatorPowersportsURLLabel: AHFC_CalculatorPowersportsURL,
    CalculatorAcuraURLLabel: AHFC_CalculatorAcuraURL,
    CalculatorMarineURLLabel: AHFC_CalculatorMarineURL,

    LocateADealerHondaURLLabel: AHFC_LocateADealerHondaURL,
    LocateADealerAcuraURLLabel: AHFC_LocateADealerAcuraURL,
    LocateADealerPowersportsURLLabel: AHFC_LocateADealerPowersportsURL,
    LocateADealerMarineURLLabel: AHFC_LocateADealerMarineURL,
    LocateADealerPowerEquipmentURLLabel: AHFC_LocateADealerPowerEquipmentURL,

    ProductSupportHondaURLLabel: AHFC_ProductSupportHondaURL,
    ProductSupportAcuraURLLabel: AHFC_ProductSupportAcuraURL,
    ProductSupportPowersportsURLLabel: AHFC_ProductSupportPowersportsURL,
    ProductSupportMarineURLLabel: AHFC_ProductSupportMarineURL,
    ProductSupportPowerRequirementURLLabel: AHFC_ProductSupportPowerRequirementURL,


    MyAccountLabel: AHFC_MyAccount,
    FinanceToolsLabel: AHFC_FinanceTools,
    ApplyforPreApprovalLabel: AHFC_ApplyforPreApproval,
    LeaseVsFinanceLabel: AHFC_LeaseVsFinance,
    HondaLoyaltyBenefitsLabel: AHFC_HondaLoyaltyBenefits,
    AcuraLoyaltyAdvantageLabel: AHFC_AcuraLoyaltyAdvantage,
    EndofTermLabel: AHFC_EndofTerm,
    ProtectionofProductsLabel: AHFC_ProtectionofProducts,
    SUPPORTLabel: AHFC_SUPPORT,
    HelpCenterLabel: AHFC_HelpCenter,
    ContactUsLabel: AHFC_ContactUs,
    PaymentOptionsLabel: AHFC_PaymentOptions,
    PrintableFormsLabel: AHFC_PrintableForms,
    OWNERSLabel: AHFC_OWNERS,
    LargeLabel: LargeLabel,
    MediumLabel: MediumLabel,
    CookieLabel: AHFC_Cookie_Policy,
    OWNERSHondaLabel: AHFC_OWNERS_Honda, // Added for US 8745
    OWNERSAcuraLabel: AHFC_OWNERS_Acura, // Added for US 8745
    OWNERSHondaLabelUrl: AHFC_OWNERS_HondaUrl, // Added for US 8745
    OWNERSAcuraLabelUrl: AHFC_OWNERS_AcuraUrl, // Added for US 8745

    HondaCarLogoUrl: AHFC_HondaCarLogoUrl,
    HondaAcuraLogoUrl: AHFC_HondaAcuraLogoUrl,
    HondaBikeLogoUrl: AHFC_HondaBikeLogoUrl,
    HondaPowerEquipmentLogoUrl: AHFC_HondaPowerEquipmentLogoUrl,
    HondaMarineLogoUrl: AHFC_HondaMarineLogoUrl,
    HondaJetLogoUrl: AHFC_HondaJetLogoUrl,
    InvestorRelationsURL: AHFC_InvesterRelationsUrl,
    CareersUrl: AHFC_CareersUrl,

    FaqHelpPayments: AHFC_FaqHelpPayments,
    FaqHelpAccountManagement: AHFC_FaqHelpAccountManagement,
    FaqhelpEndOFTerm: AHFC_FaqhelpEndOFTerm,
    FaqHelpViewAllFaq: AHFC_FaqHelpViewAllFaq,


    OFFER: AHFC_OFFER,
    Honda: AHFC_Honda,
    Acura: AHFC_Acura,
    PowerSports: AHFC_PowerSports,
    PowerEquipment: AHFC_PowerEquipment,
    Marine: AHFC_Marine,
    Calculator: AHFC_Calculator,
    AHFC_HondaNewVehickes: AHFC_HondaNewVehickes,
    HondaCertifiedOwner: AHFC_HondaCertifiedOwner,
    Locatedealer: AHFC_Locatedealer,
    ProductSupport: AHFC_ProductSupport,
    HondaFamilyOfBrands: AHFC_HondaFamilyOfBrands,

    Aboutus: AHFC_Aboutus,
    TermsAndConditions: AHFC_TermsAndConditions,
    Privacypolicy: AHFC_Privacypolicy,
    InvestorRelations: AHFC_InvestorRelations,
    Careers: AHFC_Careers,
    PersonalInfo: AHFC_PersonalInfo,
    Cookietext: AHFC_Cookietext,
    CookiePolicy: AHFC_CookiePolicy,
    Corporation: AHFC_Corporation,
    FooterLogIn: AHFC_FooterLogIn,
    EditNickname: AHFC_EditNickname,
    NickName: AHFC_NickName,
    EditSave: AHFC_EditSave,
    Editcancel: AHFC_Editcancel,
    CurrentBillDetails: AHFC_CurrentBillDetails,
    CurrentBillHelp: AHFC_CurrentBillHelp,
    CurrentBillDueAmount: AHFC_CurrentBillDueAmount,

    //added for US 4159
    errorFooterUrl: AHFC_CUSTOMER,
    errorFooter_aboutUs: aHFC_errorFooter_Label_aboutUs,
    errorFooter_acuraLoyaltyAdvantage: aHFC_errorFooter_Label_acuraLoyaltyAdvantage,
    errorFooter_communicationPreferences: aHFC_errorFooter_Label_communicationPreferences,
    errorFooter_correspondence: aHFC_errorFooter_Label_correspondence,
    errorFooter_creditpreapproval: aHFC_errorFooter_Label_creditpreapproval,
    errorFooter_dashboard: aHFC_errorFooter_Label_dashboard,
    errorFooter_endofTerm: aHFC_errorFooter_Label_endofTerm,
    errorFooter_financeAccountDetails: aHFC_errorFooter_Label_financeAccountDetails,
    errorFooter_hondaLoyaltyBenefits: aHFC_errorFooter_Label_hondaLoyaltyBenefits,
    errorFooter_leaseVsFinance: aHFC_errorFooter_Label_leaseVsFinance,
    errorFooter_myPaymentSources: aHFC_errorFooter_Label_myPaymentSources,
    errorFooter_paymentOptions: aHFC_errorFooter_Label_paymentOptions,
    errorFooter_printableForms: aHFC_errorFooter_Label_printableForms,
    errorFooter_protectionofProducts: aHFC_errorFooter_Label_protectionofProducts,
    errorFooter_statements: aHFC_errorFooter_Label_statements,
    errorFooter_termsAndConditions: aHFC_errorFooter_Label_termsAndConditions,

    DashboardSupportRequestText: AHFC_SupportRequestTile_Text,
    DashboardSupportRequestBtnLabel: AHFC_SupportRequestTile_Button,
    DashboardCorrespondenceText: AHFC_CorrespondenceTile_Text,
    DashboardCorrespondenceBtnLabel: AHFC_CorrespondenceTile_btn,
    StatementDownloadAcrobat: AHFC_DashboardStatement_Link_Download_Acrobat_Reader,
    StatementViewAllStatement: AHFC_DashboardStatement_Link_View_All_Statement,
    StatementGoPaperless: AHFC_DashboardStatement_Link_Go_Paperless,
    StatementSelectMonth: AHFC_DashboardStatement_Placeholder_Select_Month,
    PaymentActivityNextPayment: AHFC_DashboardPaymentActivity_Label_Nexy_Payment,
    PaymentActivityLastPayment: AHFC_DashboardPaymentActivity_Label_Last_Payment,
    PaymentActivityViewActivity: AHFC_DashboardPaymentActivity_Link_View_Activity,
    PaymentProgressMaturityDate: AHFC_DashboardPaymentProgress_Label_Maturity_Date,
    PaymentProgressTerm: AHFC_DashboardPaymentProgress_Label_Term,
    PaymentProgressTermMonths: AHFC_DashboardPaymentProgress_Label_Term_Months,
    PaymentProgressPayoffCalender: AHFC_DashboardPaymentProgress_Link_Payoff_Calender,
    PaymentProgressContractDetails: AHFC_DashboardPaymentProgress_Link_Contract_Details,
    contracts: AHFC_Community_Named_Contracts,
    PayOffCalendar: AHFC_Community_Named_Payoff_Calendar,
    DashboardAccountDetails: AHFC_Dashboard_Link_Account_Details,
    DashboardAddProduct: AHFC_Dashboard_Link_Add_Product,
    DashboardVin: AHFC_Dashboard_Label_Vin,
    DashboardAccountNo: AHFC_Dashboard_Label_Account_No,
    DashboardAccountType: AHFC_Dashboard_Label_Account_Type,
    DashboardCurrentBill: AHFC_Dashboard_Label_Current_Bill_Title,
    DashboardPaymentProgress: AHFC_Dashboard_Label_Payment_Progress_Title,
    DashboardPaymentActivity: AHFC_Dashboard_Label_Payment_Activity_Title,
    DashboardStatements: AHFC_Dashboard_Label_Statements_Title,
    DashboardMessages: AHFC_Dashboard_Label_Messages_Title,
    DashboardFaq: AHFC_DashboardFaq_Label_Heading,
    DashboardMoreInfo: AHFC_Dashboard_Label_More_Info,
    DashboardLessInfo: AHFC_Dashboard_Label_Less_Info,
    CurrentBillEasypayEnrolled: AHFC_DashboardCurrentBill_Label_Easypay_Enrolled,
    CurrentBillTotalAmountDue: AHFC_DashboardCurrentBill_Label_Total_Amount_Due,
    CurrentBillDueDate: AHFC_DashboardCurrentBill_Label_Due_Date,
    CurrentBillDay: AHFC_DashboardCurrentBill_Label_Due_Date_Day,
    CurrentBillDays: AHFC_DashboardCurrentBill_Label_Due_Date_Days,
    CurrentBillRemaining: AHFC_DashboardCurrentBill_Label_Due_Date_Remaining,
    CurrentBillIncludes: AHFC_DashboardCurrentBill_Label_Due_Date_Includes,
    CurrentBillPastDue: AHFC_DashboardCurrentBill_Label_Due_Date_Past_Due,
    CurrentBillMakeOtp: AHFC_DashboardCurrentBill_Button_Make_OTP,
    CurrentBillManageEasypay: AHFC_DashboardCurrentBill_Button_Manage_Easypay,
    CurrentBillMakePayment: AHFC_DashboardCurrentBill_Button_Make_Payment,
    CurrentBillEnrollEasypay: AHFC_DashboardCurrentBill_Button_Enroll_Easypay,
    CurrentBillOtherPayment: AHFC_DashboardCurrentBill_Link_Other_Payment_Options,
    MadePaymentPastDue: AHFC_DashboardMadePayment_Label_Past_Due,
    MadePaymentAlreadyDone: AHFC_DashboardMadePayment_Link_Already_Done,
    BlankDashboardHeader: AHFC_DashboardBlank_Label_Set_Up_Header,
    BlankDashboardSubHeader: AHFC_DashboardBlank_Label_Set_Up_Sub_Header,
    BlankDashboardAddFinance: AHFC_DashboardBlank_Label_Button_Add_Finance,
    AddFinanaceAccount: AHFC_Community_Named_Add_Finance_Account,
    FinanceAccountProfile: AHFC_Community_Named_Finance_Account_Profile,
    MadePaymentPage: AHFC_Community_Named_Made_Payment,
    AHFC_No_payments_made_yet: AHFC_No_payments_made_yet,
    AHFC_No_Scheduled_Payments: AHFC_No_Scheduled_Payments,
    AHFC_Dashboard_PaymentsActivityBtn: AHFC_Dashboard_PaymentsActivityBtn,
    AHFC_Dashboard_PaymentsActivity_Status_Pending: AHFC_Dashboard_PaymentsActivity_Status_Pending,
    AHFC_Dashboard_PaymentsActivity_type: AHFC_Dashboard_PaymentsActivity_type,
    DashboardSupportRequest: AHFC_Dashboard_SupportRequest_TileLabel,
    DashboardCorrespondence: AHFC_Dashboard_Correspondence_TileLabel,
    DashboardMarketing: AHFC_Dashboard_Marketing_TileLabel,
    DateAscending: AHFC_TransactionHistory_Label_Sort_Date_Ascending,
    DateDescending: AHFC_TransactionHistory_Label_Sort_Date_Descending,
    TotalAscending: AHFC_TransactionHistory_Label_Sort_Total_Ascending,
    TotalDescending: AHFC_TransactionHistory_Label_Sort_Total_Descending,
    Tranasactionlabel: AHFC_TransactionHistory_Label_Tranasactionlabel,
    OBJECT: "object"

};