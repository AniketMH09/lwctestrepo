public class AHFC_CustomSearchController {
    @AuraEnabled
    public static List<String> searchForIds(String searchText) {
       // String q = 'SELECT Id, PublishStatus FROM faq__kav';
       // List<faq__kav> articles = Database.query(q);
    List<List<SObject>> results = [FIND :searchText IN ALL FIELDS  RETURNING Account(Id), Contact(Id), Lead(Id)];
    List<String> ids = new List<String>();
    for (List<SObject> sobjs : results) {
      for (SObject sobj : sobjs) {
        ids.add(sobj.Id);
      }
    }
    return ids;
}
}