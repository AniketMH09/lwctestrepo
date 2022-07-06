/* Apex Class Name   :    AHFC_SupportRequestController
    * Description        :    class used by aHFC_supportRequest lwc component to fetch default values required for the components
    * Modification Log   :
    * ---------------------------------------------------------------------------
    * Developer                   Date                   Description
    * ---------------------------------------------------------------------------
    * Edwin            		    AUG 17 2021             	Created
*********************************************************************************/
public without sharing class AHFC_SupportRequestController {
    
    /**
     * @author Edwin AUG 17 2021
     * @description method to fetch value from database and return as List of cases
     * @param recID: 
     * @return object reference : case
	**/
    @AuraEnabled(cacheable=true)
    public static List<Case> fetchSupportRequests(Id finAccId){
        
        List<Case> caseIds = [ SELECT Id, Status, Type FROM Case 
                                WHERE Type IN('Due Date Change','Lease Extension','Document Sharing','SCRA Request') 
                                AND Finance_Account__c = :finAccId ]; 

        List<Id> newCaseIdList = new List<Id>();        
        
        for( Case caseObj :caseIds){
            
            //Those cases having Due date Change, Lease Extension and Document Sharing records with Ready For Review status will be shown in case list
        	if(caseObj.Type =='Due Date Change' || caseObj.Type =='Lease Extension' ||(caseObj.Type =='Document Sharing' && caseObj.Status =='Ready for Review')){
            	newCaseIdList.add(caseObj.Id);
        	}   
			
        }

        //fetch records with read access for the particular user
       List<UserRecordAccess> accessRecordList = [ SELECT RecordId FROM UserRecordAccess 
                                                    WHERE UserId =:UserInfo.getUserId() AND HasReadAccess = true
                                                    AND RecordId IN :newCaseIdList ];
       
        List<Id> accessableCaseIds = new List<Id>();
        for( UserRecordAccess userRecordObj :accessRecordList){
            accessableCaseIds.add(userRecordObj.Id);
        }

        List<Case> caseList = [ SELECT id,CaseNumber,Type,Status,LastModifiedDate,CreadtedDate_DateOnly__c,
                                Finance_Account__c,Finance_Account__r.AHFC_Product_Nickname__c, Finance_Account__r.Finance_Account_Number_Without_Zeroes__c
                                FROM Case WHERE Id = :accessableCaseIds ]; 
      
        System.debug('caseList >>>>'+ caseList);
        return caseList;
    }

    /**
     * @author Edwin AUG 20 2021
     * @description method to fetch value from database and return as wrapper obj
     * @param recID:Case recId to retrive Case record
     * @return object reference : SupportRequestWrapper
	**/
    @AuraEnabled(cacheable=true)
    public static SupportRequestWrapper fetchSupportRequestDetails(ID caseId){
        String easyPayTxt ='No';
        SupportRequestWrapper supReqWrapper = new SupportRequestWrapper();
		Case caseDetails = new case();
        
        List<Case> caseDetailsList = [SELECT id,CaseNumber,Type,Status,CreatedDate,Finance_Account__c,Requested_Next_Due_Date_Day__c,
                            Maturity_Date__c,Requested_Maturity_Date_Text__c,Document_Type__c,Requested_Months__c,Finance_Account__r.Due_On_Day__c, Finance_Account__r.Finance_Account_Number__c
                            FROM case WHERE Id =:caseId AND (Type ='Due Date Change' OR Type ='Lease Extension' OR ( Type ='Document Sharing' AND Status ='Ready for Review')) ] ;
        if(caseDetailsList.isEmpty()){
            return null;
        }
        
        List<ChargentOrders__ChargentOrder__c> paymentList =[ SELECT id, RecordType.name,Payment_Display_Status__c 
                                                              FROM ChargentOrders__ChargentOrder__c 
                                                              WHERE Finance_Account_Number__c = :caseDetailsList[0].Finance_Account__c];

        for(ChargentOrders__ChargentOrder__c objPayment : paymentList){

            //cheking whether its enrolled in easypay
            if(objPayment.RecordType.name=='Recurring Payment' && (objPayment.Payment_Display_Status__c =='Pending' || objPayment.Payment_Display_Status__c == 'Suspended' || objPayment.Payment_Display_Status__c == 'Processing')){            
                easyPayTxt = 'Yes';            
        }
    }
        supReqWrapper.supportCase = caseDetailsList[0];
        supReqWrapper.easyPay = easyPayTxt;
         
        return supReqWrapper;
    }


//wrapper class
/**
* @description     SupportRequestWrapper
*/
public without sharing class SupportRequestWrapper{
    /**
* @description     easyPay
*/
    @AuraEnabled
    public String easyPay {get;set;}
    /**
* @description     supportCase
*/
    @AuraEnabled
    public Case supportCase{get;set;}    
    
    }
}