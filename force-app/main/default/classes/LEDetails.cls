Public class LEDetails {
    Public String FinAcctId { get; set; }
    Public String FinAcctNbr { get; set; }
    Public String oldDueDay{ get; set; }
    Public Integer ExtLength{ get; set; }
    Public String ProcessingType { get; set; }
    Public String  ValidationRslt { get; set; }
    Public String WebSvcResult { get; set; }
    Public String ContactId { get; set; }
    Public Date newDueDate { get; set; }
    Public Date newLEDate {get;set;}
    Public Date maturityDate {get;set;}
    Public Date nextMaturityDate {get;set;}
    Public List<String> ErrorMessages { get; set; }
    Public finance_account__c fa { get; set; }
    Public LEDetails(String FinAcctId, Integer ExtLength ) {
        this.FinAcctId = FinAcctId;
        this.ExtLength = ExtLength;
        ErrorMessages = new String[1];

        
    }
}