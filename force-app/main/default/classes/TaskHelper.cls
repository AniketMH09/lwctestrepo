public class TaskHelper {

    // Class is designed to supress the recursive behaviour while multiple triggers are executed by a single update.

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


   // Class is designed to supress the recursive behaviour while multiple triggers are executed by a single update for PreferencesUpdateNotification Trigger
   
    private static boolean triggerExecutedSMS= false;
    
    public static boolean istriggerExecutedSMS() {
        return triggerExecutedSMS;
    }
    
    public static void setTriggerAsExecutedSMS() {
        triggerExecutedSMS = true;
    }
    
    public static void setTriggerAsNotExecutedSMS() {
        triggerExecutedSMS = false;
    }
}