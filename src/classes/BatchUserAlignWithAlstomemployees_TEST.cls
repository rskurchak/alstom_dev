@isTest 
global class BatchUserAlignWithAlstomemployees_TEST {
  static testMethod void testBatchUserAlignWithAlstomemployees(){  
    
    Test.startTest();
    String query = 'SELECT id,  Status__c, SalesforceUser__c,Email__c  ,FirstName__c ,LastName__c,Company__c,CountryName__c,DirectManager__c,FunctionalManager__c,JobTitle__c,WorkPhone__c,MobilePhone__c,StreetAddress__c,Sector__c,TerangaUnit__c,City__c,ZipPostalCode__c from Alstomemployee__c WHERE TECH_ManagerWrongSet__c= true'; 
    BatchUserAlignWithAlstomemployees batchUserAlignWithAlstomemployees = new BatchUserAlignWithAlstomemployees(query);
    if(UtilityTestMethod.CanRunBatch())  
    {
    ID BatchUserAlignWithAlstomemployees1 = Database.executeBatch(BatchUserAlignWithAlstomemployees);      
    }
    Test.stopTest();    
  }
}