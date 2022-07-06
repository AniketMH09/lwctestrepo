public virtual class BaseTriggerHandler {

  // static map of handlername, times run() was invoked
  private static Map <String, TriggerState> triggerStateMap;
  private static Set<String> bypassedHandlers;
    
  // static boolean to stop the trigger update (recursive)
  public static boolean isAlreadyExecuted = false;
  
  // the current context of the trigger, overridable in tests
  @TestVisible
  private TriggerContext context;

  // the current context of the trigger, overridable in tests
  @TestVisible
  private Boolean isTriggerExecuting;
    
  // is Trigger initiated by User or System activity
  public static Boolean isUserSession;
  
  
  
  

  // static initialization
  static {
    triggerStateMap = new Map <String, TriggerState> ();
    bypassedHandlers = new Set<String>();
      isUserSession = false;
  }
  
  // constructor
  public BaseTriggerHandler() {
      setUserContext();
      this.setTriggerContext();
  }

  /***************************************
   * public instance methods
   ***************************************/

  // main method that will be called during execution
  public void run() {

    if(!validateRun()) return;
    
    System.debug('Context - ' + this.context + ' isUserSession - ' + isUserSession);
    
    // dispatch to the correct handler method
    if(this.context == TriggerContext.BEFORE_INSERT && this.canExecuteTrigger()) {
        this.beforeInsert();
        this.setTriggerState();
    } else if(this.context == TriggerContext.AFTER_INSERT && this.canExecuteTrigger()) {
        this.afterInsert();
        this.setTriggerState();
    }else if(this.context == TriggerContext.BEFORE_UPDATE && this.canExecuteTrigger() && !isAlreadyExecuted) {
        this.beforeUpdate();
        this.setTriggerState();
    }  else if(this.context == TriggerContext.AFTER_UPDATE && this.canExecuteTrigger() && !isAlreadyExecuted) {
        this.afterUpdate();
        this.setTriggerState();
    } 

  }



  /***************************************
   * public static methods
   ***************************************/

  public static void bypass(String handlerName) {
    BaseTriggerHandler.bypassedHandlers.add(handlerName);
  }

  public static void clearBypass(String handlerName) {
    BaseTriggerHandler.bypassedHandlers.remove(handlerName);
  }

  public static Boolean isBypassed(String handlerName) {
    return BaseTriggerHandler.bypassedHandlers.contains(handlerName);
  }

  public static void clearAllBypasses() {
    BaseTriggerHandler.bypassedHandlers.clear();
  }

  /***************************************
   * private instancemethods
   ***************************************/

  @TestVisible
  private void setTriggerContext() {
    this.setTriggerContext(null, false);
  }

  @TestVisible
  private void setTriggerContext(String ctx, Boolean testMode) {
    if(!Trigger.isExecuting && !testMode) {
      this.isTriggerExecuting = false;
      return;
    } else {
      this.isTriggerExecuting = true;
    }
    
    if((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) ||
        (ctx != null && ctx == 'before insert')) {
      this.context = TriggerContext.BEFORE_INSERT;
    } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||
        (ctx != null && ctx == 'before update')){
      this.context = TriggerContext.BEFORE_UPDATE;
    } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) ||
        (ctx != null && ctx == 'before delete')) {
      this.context = TriggerContext.BEFORE_DELETE;
    } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||
        (ctx != null && ctx == 'after insert')) {
      this.context = TriggerContext.AFTER_INSERT;
    } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) ||
        (ctx != null && ctx == 'after update')) {
      this.context = TriggerContext.AFTER_UPDATE;
    } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) ||
        (ctx != null && ctx == 'after delete')) {
      this.context = TriggerContext.AFTER_DELETE;
    } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) ||
        (ctx != null && ctx == 'after undelete')) {
      this.context = TriggerContext.AFTER_UNDELETE;
    }
  }

 
  // make sure this trigger should continue to run
  @TestVisible
  private Boolean validateRun() {
    if(!this.isTriggerExecuting || this.context == null) {
      throw new BaseTriggerHandlerException('Trigger handler called outside of Trigger execution');
    }
    if(BaseTriggerHandler.bypassedHandlers.contains(getHandlerName())) {
      return false;
    }
    return true;
  }
    
  // set the isUserSession to true if the User Context is not part of the bypassed profiles - Informatica, System Admins
    @TestVisible
	private static void setUserContext() {
        String profilesString = label.IntegrationBypassProfileId;
        Set<string> profileList = new Set<string>(profilesString.trim().split(','));
        if(!profileList.contains(UserInfo.getProfileId())) {
            isUserSession = true;
        }
        else
        {
            isUserSession = false;
        }
    }

  @TestVisible
  private String getHandlerName() {
    return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
  }
  
    
    private void setTriggerState() {
        String handlerName = getHandlerName();
        if (!BaseTriggerHandler.triggerStateMap.containsKey(handlerName)) {
            System.debug('setTriggerState - first time');
            TriggerState tstate = new TriggerState();
            if(Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) {
                System.debug('setTriggerState - isBeforeInsertFinished');
                tstate.isBeforeInsertFinished = true; }
            else if(Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) {
                System.debug('setTriggerState - isAfterInsertFinished');
                tstate.isAfterInsertFinished = true; }
            else if(Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) {
                System.debug('setTriggerState - isBeforeUpdateFinished');
                tstate.isBeforeUpdateFinished = true; }
            else if(Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) {
                System.debug('setTriggerState - isAfterUpdateFinished');
                tstate.isAfterUpdateFinished = true; }
            BaseTriggerHandler.triggerStateMap.put(handlerName, tstate);
        }
        else
        {
            TriggerState tstate = BaseTriggerHandler.triggerStateMap.get(handlerName);
            
            if(Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) {
                System.debug('setTriggerState - isBeforeInsertFinished');
                tstate.isBeforeInsertFinished = true; }
            else if(Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) {
                System.debug('setTriggerState - isAfterInsertFinished');
                tstate.isAfterInsertFinished = true; }
            else if(Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) {
                System.debug('setTriggerState - isBeforeUpdateFinished');
                tstate.isBeforeUpdateFinished = true; }
            else if(Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) {
                System.debug('setTriggerState - isAfterUpdateFinished');
                tstate.isAfterUpdateFinished = true; }
            
            BaseTriggerHandler.triggerStateMap.put(handlerName, tstate);
         }
     }
    
    private Boolean canExecuteTrigger () {
        String handlerName = getHandlerName();
        if (!BaseTriggerHandler.triggerStateMap.containsKey(handlerName)) {
            System.debug('canExecuteTrigger - no handlerName');
            return true;
        }
        else
        {
            TriggerState tstate = BaseTriggerHandler.triggerStateMap.get(handlerName);
            System.debug('canExecuteTrigger - ' + handlerName + ' isBeforeInsertFinished - ' + tstate.isBeforeInsertFinished + ' isAfterInsertFinished - ' + tstate.isAfterInsertFinished + ' isBeforeUpdateFinished - ' + tstate.isBeforeUpdateFinished + ' isAfterUpdateFinished - ' + tstate.isAfterUpdateFinished);
            
            if(Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert && !tstate.isBeforeInsertFinished) {
                return true; }
            else if(Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert && !tstate.isAfterInsertFinished) {
                return true; }
            else if(Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate && !tstate.isBeforeUpdateFinished) {
                return true; }
            else if(Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate && !tstate.isAfterUpdateFinished) {
                return true; }
            else
                return false;
         }
     }

  /***************************************
   * context methods
   ***************************************/

  // context-specific methods for override
  @TestVisible
  protected virtual void beforeInsert(){}
  @TestVisible
  protected virtual void beforeUpdate(){}
  @TestVisible
  protected virtual void beforeDelete(){}
  @TestVisible
  protected virtual void afterInsert(){}
  @TestVisible
  protected virtual void afterUpdate(){}
  @TestVisible
  protected virtual void afterDelete(){}
  @TestVisible
  protected virtual void afterUndelete(){}

  /***************************************
   * inner classes
   ***************************************/

  // inner class for managing the loop count per handler
  
    private class TriggerState {
        
        // isBeforeInsertFinished is set to TRUE after executing beforeInsert() method
        private Boolean isBeforeInsertFinished {get; set;}
    
        // isAfterInsertFinished is set to TRUE after executing afterInsert() method
        private Boolean isAfterInsertFinished {get; set;}
  
        // isBeforeUpdateFinished is set to TRUE after executing beforeUpdate() method
        private Boolean isBeforeUpdateFinished {get; set;}
  
        // isAfterUpdateFinished is set to TRUE after executing afterUpdate() method
        private Boolean isAfterUpdateFinished {get; set;}
        
        public TriggerState() {
            this.isBeforeInsertFinished = false;
            this.isAfterInsertFinished = false;
            this.isBeforeUpdateFinished = false;
            this.isAfterUpdateFinished = false;
        }
        
        }

  // possible trigger contexts
  @TestVisible
  private enum TriggerContext {
    BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
    AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
    AFTER_UNDELETE
  }

  // exception class
  public class BaseTriggerHandlerException extends Exception {}
}