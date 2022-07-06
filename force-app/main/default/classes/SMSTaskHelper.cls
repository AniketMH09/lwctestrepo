public class SMSTaskHelper {

    private static boolean triggerExecuted= false;
    
    public static boolean istriggerExecuted() {
        return triggerExecuted;
    }
    
    public static void setTriggerAsExecuted() {
        triggerExecuted = true;
    }
    
    public static void setTriggerAsNotExecuted() {
        triggerExecuted = false;
    }

}