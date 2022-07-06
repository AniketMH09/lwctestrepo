/* Apex Class Name       :    AHFC_GlobalConstants
    * Description        :    A Utility class that stores the hardcoded literals as final 
                              static variables which are used across the application
    * Modification Log   :
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    * Kanagaraj            		May 25 2021             	Created
*********************************************************************************/

public with sharing class AHFC_GlobalConstans {
  public static final String SEMICOLON = ';';
  public static final String COLON = ':';
  public static final String BLANK = '';
  public static final String SPACE = ' ';
  public static final String EMPTY = '';
  public static final String SINGLE_LINE_DELIM = '\n';
  public static final String INTEGRATIONLOG_SOBJECTAPI = 'AHFC_Integration_Logs__c';
  public static final String INTEGRATIONLOG_EXCEPTIONRT = 'Apex_Exception';
  public static final String INTEGRATIONLOG_REQUESTRT = 'Integration_Request';
  public static final String INTEGRATIONLOG_RESPONSERT = 'Integration_Response';
  public static final String ACTIVESTATUS = 'Active';
  public static final String DELETED_STATUS = 'Deleted';
  public static final String SUCCESS = 'Success';
  public static final String ALREADY_REGISTERED = 'Already Registered';
  public static final String EXCEPTIONMSG = 'Exception has occurred';
  public static final String CUSTOMER_PROFILE = 'Customer';
  public static final String AGENT_PROFILE = 'Agent';
  public static final String GET_METHOD = 'GET';
  public static final String POST_METHOD = 'POST';
  public static final String PUT_METHOD = 'PUT';  
  public static final String DELETE_METHOD = 'DELETE';  
  public static final String REQUEST = 'REQUEST';
  public static final String RESPONSE = 'RESPONSE';
  public static final String DEFAULTTIMEOUT = '12000';
  public static final String RECURRING = 'Recurring';
  public static final String OTP_PRINCIPAL = 'OTP Principal';
  public static final String OTP_STANDARD = 'OTP Standard';
  public static final String PENDING = 'Pending';
  public static final String PROCESSING = 'Processing';
  public static final String POSTED = 'Posted';
  public static final String RESEARCHING = 'Researching';
  public static final String CLEARED_TO_GL = 'Cleared to GL';
  public static final String DUE_DATE_CHANGE = 'Due Date Change';
  public static final String DISASTER_RELIEF = 'Disaster Relief';
  public static final String PAYMENT_DEFERRAL = 'Payment Deferral';
  public static final String WEB = 'Web';
  public static final String AGENT = 'Agent';
  public static final String IVR = 'IVR';
  public static final String PAYOFF = 'Payoff';
  public static final String EASYPAY = 'EASYPAY';
  public static final String CANCELLED = 'Cancelled';
  public static final String R = 'R';
  public static final String SERVICE_ACCOUNT = 'Service Account';
  public static final String ACCOUNT = 'Account';
  public static final String PERSON_ACCOUNT = 'Person Account';
  public static final String PAYMENT = 'Payment';
  public static final String NAMED_CRED = 'callout:';
  public static final String PAYMENT_STATUS = 'Payment Status';
  public static final String PAYMENT_TYPE = 'Payment Type';
  public static final String Stopped = 'Stopped';
  public static final String Suspended = 'Suspended';
  public static final String FAILED = 'FAILED';
  public static final Date TODAY = Date.today();  
  public static final string HFS = 'HFS';
  public static final string AFS = 'AFS';
  public static final string DUEDATECHANGE = 'DUEDATECHANGE';//Added By JK
  public static final string LOGCASENOTES = 'LOGCASENOTES';//Added By JK
  public static final string AHFC_AGENT = 'AHFC Agent';  // Added by Prabu
  public static final string ONETIME = 'ONETIME';//Added by Shanthi
  public static final string SYSTEM_ADMINISTRATOR = 'System Administrator';
  public static final String SAC_WEB_ENABLED = 'Web Enabled';//Added by Shanthi
  public static final String DATE_TIME_FORMAT  ='MM/dd/yyyy HH:mm:ss';//Added by Shanthi
  public static final String DATE_TIME_GMTFORMAT = 'yyyy-MM-dd HH:mm:ss.sss';
    
  public static final String PUTUPDATEADDRESS = 'PUTUPDATEADDRESS';//Added by Shanthi
  public static final String DELETEREMOVEBILLTOADDRESS = 'DELETEREMOVEBILLTOADDRESS';//Added by Shanthi
  public static final String GETDEMOGRAPHICS = 'GETDEMOGRAPHICS';//Added by Shanthi
  public static final String PUTDEMOGRAPHICS = 'PUTDEMOGRAPHICS';//Added by Shanthi
  public static final String GETPAYOFFINFO = 'GETPAYOFFINFO';//Added by Shanthi
  public static final String PUTPROMISEMADE = 'PUTPROMISEMADE';//Added by Shanthi
  public static final String GETTRANSACTIONHISTORY = 'GETTRANSACTIONHISTORY';//Added by Shanthi
  public static final String UPDATEADDRESS  ='UPDATEADDRESS';//Added by Shanthi
  
  //Written By Supriya | 27 Jan'2021
  //Added section for Integration Http Header parameters
  public static final String HTTP_HEADER_MSGID = 'hondaHeaderType.messageId';
  public static final String HTTP_HEADER_COLTIME = 'collectedTimeStamp';
  public static final String HTTP_HEADER_LOOKUPID = 'lookupID';
  public static final String WEB_ENABLED = 'Web Enabled';
  public Static Final String ACCOUNT_NOT_FOUND_GUEST = 'Account Not Found';
    
  //Written by Aditya Krishna | 3rd Feb 2021
  //Added for Finance Account Status Errors
  public Static Final String REVERSED = 'Reversed';
  public Static Final String CHARGED_OFF = 'Charged off';
  public Static Final String REPOSSESSED = 'Repossessed';
  public Static Final String EARLY_TERM = 'Early Term';
  public Static Final String FULL_TERM = 'Full Term';
  public Static Final String PAID_OFF = 'Paid off';
  public Static Final String OVERTERM = 'Overterm';
  public Static Final String CLOSED = 'Closed';
  public Static Final String NOT_AVAILABLE = 'Not Available';

  public Static Final String REVERSED_ERROR = 'There was an issue registering the account, please call customer service at 1-800-XXX-XXX.';
  public Static Final String CLOSED_ERROR = 'The account you are attempting to access is closed, are you sure you want to proceed?';
  public Static Final String ALREADY_REGISTERED_ACC ='This account is already registered, please try logging in.';
  public Static Final String NO_MATCH_CRITERIA = 'The information entered does not match an account, please try again.';
  public Static Final String ACCOUNT_NOT_FOUND = 'Account Not Found.';
  public Static Final String ACCOUNT_NOT_DELETED  ='Bank Account has already been deleted.';//Added by Shanthi
    
  //AHFC_AddressIntegrationUtil Added by Shanthi
 public Static Final String ADDRESS_INT_CLSNAME  = 'AHFC_AddressIntegrationUtil'; 
  public Static Final String ADDRESS_INT_MTHDNAME = 'makeRemoveBillToAddrCallout'; 
  public Static Final String ADDRESS_INT_WEBSERVICENAME = 'Remove Bill To Address'; 
  public Static Final String ADDRESS_INT_UPDATE_WEBSERVICENAME  = 'Update Address';
  public Static Final String ADDRESS_INT_UPDATE_MTDNAME = 'makeUpdateAddressCallout'; 
  
  public Static Final String HDR_MSGID  = 'hondaHeaderType.messageId';
  public Static Final String COLLECTED_TIMESTAMP  = 'collectedTimeStamp';  
  public Static Final String LOOKUP_ID  = 'lookupID'; 
  public Static Final String INTUTIL_RECID =  'Record Id';
  public Static Final String INTUTIL_OBJNAME = 'UI-real-time';
    
  //Payment Integration util Added by Shanthi
  public Static Final String PAYMENT_INT_CLSNAME = 'AHFC_PaymentIntegrationUtil';
  public Static Final String PAYMENT_INT_MTHDNAME = 'makeCallout';
    
   //AHFC_PayOffInfoIntegrationUtil Added by Shanthi
  public Static Final String PAYOFF_INT_CLSNAME = 'AHFC_PayOffInfoIntegrationUtil';
  public Static Final String PAYOFF_INT_MTHDNAME = 'makePayOffCallout'; 
  public Static Final String PAYOFF_INT_WEBSERVICENAME = 'Get PayOff Info'; 
  
  //AHFC_PromiseMadeIntegrationUtil Added by Shanthi
  public Static Final String PROMISE_INT_CLSNAME = 'AHFC_PromiseMadeIntegrationUtil';
  public Static Final String PROMISE_INT_MTDNAME = 'makeCallout';
  public Static Final String PROMISE_INT_WEBSERVICENAME = 'Promise Made';
  
  //AHFC_CaseNotesIntegrationUtil Added by Shanthi
  public Static Final String CASE_INT_CLSNAME = 'AHFC_PromiseMadeIntegrationUtil';
  public Static Final String CASE_INT_MTDNAME = 'makeCallout';
  public Static Final String CASE_INT_DEFERRAL = 'deferral';
  public Static Final String UTF  ='UTF-8';
    
    //AHFC_TransactionIntegrationUtil Added by Shanthi
  public Static Final String TRANSACTION_INT_CLSNAME = 'AHFC_TransactionIntegrationUtil';
  public Static Final String TRANSACTION_INT_MTDNAME = 'makeTransactionhistoryCallout';
  public Static Final String TRANSACTION_INT_WEBSERVICENAME = 'Get Transaction History';
    
    //AHFC_DemographicsIntegrationUtil Added by Shanthi
  public Static Final String DEMOGRAPHIC_INT_CLSNAME  = 'AHFC_DemographicsIntegrationUtil'; 
  public Static Final String DEMOGRAPHIC_INT_MTHDNAME = 'makeGetDemographicsCallout'; 
  public Static Final String DEMOGRAPHIC_INT_WEBSERVICENAME = 'Get Demographics'; 
  public Static Final String DEMOGRAPHIC_INT_UPDATE_WEBSERVICENAME  = 'Update Other Demographics';
  public Static Final String DEMOGRAPHIC_INT_UPDATE_MTDNAME = 'handleUpdateOtherDemographics';
  
    //AHFC_MarketingTileController Added by Prabu Mohanasundaram  
  public static final String Auto = 'Auto';  
  public static final String HFSP = 'HFSP'; 
  public static final String Marine = 'Marine'; 
  public static final String Powersports = 'Powersports'; 
  public static final String PowerEquipment = 'Power Equipment'; 
  public static final String AcctTypeLease = 'Lease'; 
  public static final String AcctTypeRetail = 'Retail'; 
  public static final String AcctTypeBalloon = 'Balloon'; 
  public static final String AcctTypeClosed = 'A'; 
  public static final String AcctType500 = 'N'; 
  public static final String AcctTypeHappyPath = 'y'; 
  public static final String EnrollEDillevery = 'eDelivery'; 
  public static final String Paper = 'Paper';
    
  public static final Boolean sixOTP = false;
  public static final Boolean sixOTPAndOneEZP = false; 
  public static final String paymentStatusPending = 'Pending';
  public static final String paymentStatusProcessing = 'Processing';
  public static final String stdOneTimePay = 'Standard One-Time Payment';
  public static final String principalOneTimePay = 'Principal One-Time Payment';
  public static final String reccuringPay = 'Recurring Payment';
    
}