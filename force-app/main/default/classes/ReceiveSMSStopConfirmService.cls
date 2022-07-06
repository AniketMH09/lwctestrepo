/*
Author     : Jayashree
Modifiedby : Paramasivan
Description: The purpose of this class is to create the user and setting the needed parameters for AFS/HFS to SF SSO.


Hi Michael
Summarizing our discussion –

1.	Develop a REST based endpoint service to update few parameters in the Communication Preference object
2.	The REST service should receive a Text Number as the request
3.	The endpoint service must look up a Communication Preference record by the request Text Number (Field Name in the object - Text_Number__c)
4.	Once found, update the following fields on the Communication Preference object –
a.	EasyPay Communications via Text

b.	Payment Confirmations via Text

c.	Payment Profile Updates via Text

d.	Payment Reminders via Text
5.	If update successful, send a status code ‘111’ and status message ‘SUCCESS’
6.	If failure, send a status code ‘121’ and status message ‘FAILURE’
7.	Following is the class that we have built for another REST service requirement that you can refer – ProvisionCustomerUserController.cls
8.	Name this service class as “ReceiveSMSStopConfirmService”

** Modification on 02/04/2018: DSX Changes : Communication preference should disable Account Service Updates via text option.


*/
@RestResource(urlMapping = '/ReceiveSMSStopConfirmService/*')
global with sharing class ReceiveSMSStopConfirmService {

	public Static Boolean successFlag;

	/*
   This class is for making the request structure
      */
	global class RequestWrapper {
		public string phoneNumber;
	}

	/*
   This class is for making the response structure
   */
	global class ResponseWrapper {
		public String statusCode;
		public String statusMessage;
	}

	@HttpPost
	global static ResponseWrapper Customerlogic(RequestWrapper Body) {
		ResponseWrapper respWrapper = new ResponseWrapper();
		successFlag = false;

		Task task;
        String phoneNumber = '';
        System.debug('ReceiveSMSStopConfirmService - Body.phoneNumber - ' + Body.phoneNumber);
        
        // Exact Target will send the phoneNumber as 10 digit only. Need to format to phoneType before searching
        if(Body.phoneNumber.isNumeric() && Body.phoneNumber.length() == 10)
			{
				phoneNumber = Body.phoneNumber;
			}
			else if(Body.phoneNumber.isNumeric() && Body.phoneNumber.length() == 11 && Body.phoneNumber.left(1) == '1')
			{
				phoneNumber = Body.phoneNumber.substring(1, Body.phoneNumber.length());
			}
			else
			{
				respWrapper.statusCode = '121';
				respWrapper.statusMessage = 'FAILURE';
			}
        
		//get related com pref
		list < Communication_Preferences__c > comPref = [SELECT Id
		FROM Communication_Preferences__c
		WHERE Text_Number__c = : phoneNumber LIMIT 80];

		//if no com pref found
		if (ComPref.isEmpty()) {
			respWrapper.statusCode = '121';
			respWrapper.statusMessage = 'FAILURE';
		}

		//if any com pref are found
		if (!ComPref.isEmpty()) {
				List<Task> taskList=new List<Task>(); ////As part of DSX Changes creating List of task for each communication preference record 
			For(Communication_Preferences__c c: ComPref) {
				c.EasyPay_Communications_via_Text__c = false;
				c.Payment_Confirmations_via_Text__c = false;
				c.Payment_Profile_Updates_via_Text__c = false;
				c.Payment_Reminders_via_Text__c = false;
                //DSX Changes Starts on 02/04/2018
                c.Account_Status_Updates_via_Text__c=false;
				//DSX Changes Ends on 02/04/2018
				task = new Task();
				task.WhatId = c.Id;
				task.Subject = 'SMS: STOP Confirmation';
				task.ActivityDate = Date.today();
				task.Description = 'STOP Confirmation has been sent';
				task.Priority = 'Normal';
				task.Status = 'completed';
                //As part of DSX Changes creating List of task for each communication preference record 
                taskList.add(task);
			}

			update comPref;

			// Adding a task record to display in the Notification History

			//insert task;  Commented as part of DSX Changes
			insert taskList;

			respWrapper.statusCode = '111';
			respWrapper.statusMessage = 'SUCCESS';
		}


		return respWrapper;
	}


}