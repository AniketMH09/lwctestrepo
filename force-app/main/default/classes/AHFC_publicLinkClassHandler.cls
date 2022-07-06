public class AHFC_publicLinkClassHandler {
    public static void createPublicLink(List<ContentVersion> lstOfContentVersions){
        ContentDistribution[] dist = new List<ContentDistribution>();
           for(ContentVersion varContentVersion : lstOfContentVersions){
            //if image uploaded then only create public link
            /*if(varContentVersion.FileType.toLowerCase()=='jpg'){
                system.debug('varContentVersion.FileExtension.toLowerCase():' + varContentVersion.FileType);                
                dist.add(getContentDistribution(varContentVersion.Id));
            }*/
               
            dist.add(getContentDistribution(varContentVersion.Id));
        }
        if(!dist.isEmpty())
        {
            insert dist;
        }
    }    
    public static ContentDistribution getContentDistribution(Id contentVersionId){
        ContentDistribution newDistribution = new ContentDistribution();
        newDistribution.ContentVersionId = contentVersionId;
        newDistribution.Name = 'External Link';
        newDistribution.PreferencesNotifyOnVisit = false;
        newDistribution.PreferencesAllowViewInBrowser = true;
        newDistribution.PreferencesAllowOriginalDownload=true;
        system.debug('createdContentDistribution created');
        return newDistribution;
    }
}