@istest
public class AHFC_GatherKnowledgeStatistics_Test {
    @isTest static void executeTest(){
        
        Test.StartTest();
        AHFC_GatherKnowledgeStatistics testSchedule = new AHFC_GatherKnowledgeStatistics();
        String sch = '0 0 19 * * ?'; 
        system.schedule('Test AHFC_GatherKnowledgeStatistics Check', sch, testSchedule); 
        Test.stopTest();  
        
    }  
    
}