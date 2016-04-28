global class SchedulerUserAlignWithAlstomemployees implements Schedulable 
{
  global void execute(SchedulableContext sc) { 
    /**********************************
      UserAlignWithAlstomemployees
    ***********************************/
    System.Debug('## >>> Starting Scheduler batchUserAlignWithAlstomemployees <<<');          
  
    String query = 'SELECT id, EmployeeNumber__c, Status__c, SalesforceUser__c,Email__c  ,FirstName__c ,LastName__c,Company__c,CountryName__c,DirectManager__c,FunctionalManager__c,JobTitle__c,WorkPhone__c,MobilePhone__c,StreetAddress__c,Sector__c,TerangaUnit__c,City__c,ZipPostalCode__c from AlstomEmployee__c WHERE TECH_ManagerWrongSet__c= true'; 
    
    
    BatchUserAlignWithAlstomemployees batchUserAlignWithAlstomemployees = new BatchUserAlignWithAlstomemployees(query);
    ID BatchUserAlignWithPersonId = Database.executeBatch(batchUserAlignWithAlstomemployees);    
    System.Debug('## AsyncApexJob Id (batchUserAlignWithAlstomemployees) : ' + BatchUserAlignWithPersonId);
    
    System.Debug('## >>> End Scheduling batchUserAlignWithAlstomemployees <<<');
  }
}