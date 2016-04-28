global class BatchUserAlignWithAlstomemployees implements Database.Batchable<SObject>, Database.Stateful{
  global final String query;
  
  global BatchUserAlignWithAlstomemployees(string query){
    this.query=query;
  }
  global Database.QueryLocator start(Database.BatchableContext BC)
    { 
       return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext BC, List<sObject> PersonsToAlign)
    {
      List<AlstomEmployee__c> PersonsToAlignUpdate = new List<AlstomEmployee__c>(); 
      for(sObject pers :PersonsToAlign)
       {
         AlstomEmployee__c NewPers = (AlstomEmployee__c)pers;
         
         PersonsToAlignUpdate.add(NewPers);
        }
        
        if(PersonsToAlignUpdate.size() > 0)
        {
      AP68AlstomEmployee.updateOrInsertUserFields(PersonsToAlignUpdate, False);
        }
    }
    global void finish(Database.BatchableContext BC)
    {
      
    }
}