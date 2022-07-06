Public class DDCDetails {
    Public String FinAcctId { get; set; }
    Public String FinAcctNbr { get; set; }
    Public String oldDueDay{ get; set; }
    Public Integer DueDay{ get; set; }
    Public String ProcessingType { get; set; }
    Public String  ValidationRslt { get; set; }
    Public String WebSvcResult { get; set; }
    Public String ContactId { get; set; }
    Public Date newDueDate { get; set; }
    Public List<String> ErrorMessages { get; set; }
    Public finance_account__c fa { get; set; }
    Public DDCDetails(String FinAcctId, Integer DueDay ) {
        this.FinAcctId = FinAcctId;
        this.DueDay = DueDay;
        ErrorMessages = new String[1];

        
    }
}