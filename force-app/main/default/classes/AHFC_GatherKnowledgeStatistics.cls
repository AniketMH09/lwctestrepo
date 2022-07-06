global class AHFC_GatherKnowledgeStatistics implements Schedulable {
    global void execute(SchedulableContext SC){
        Flow.Interview.Gather_Article_Data theFlow = new Flow.Interview.Gather_Article_Data(new Map<String, Object>());
        theFlow.start();
    }
}