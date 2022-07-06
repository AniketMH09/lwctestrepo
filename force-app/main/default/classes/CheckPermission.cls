public class CheckPermission {
@auraenabled
    public static Boolean isContributor(){
        return FeatureManagement.checkPermission('Article_Contributor');
    }
}