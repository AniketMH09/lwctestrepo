trigger ErrorLogEmailNotification on ErrorLog__c (After insert) {
    ErrorLogEmailNotificationctrl.Emailnotification(trigger.new);
}