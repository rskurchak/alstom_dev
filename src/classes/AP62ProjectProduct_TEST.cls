/**
 * This class contains unit tests for validating the behavior of AP62ProjectProduct Apex classes
 * and triggers.
 *   ~ Author          : Christophe AVERSENG
     ~ Date Created    : 05/05/2014 - copied from AP15Product_TEST
 */
@isTest
public class AP62ProjectProduct_TEST 
{
  static testMethod void AP62ProjectProduct_TEST() 
  {
    Project__c prj = UtilityTestMethod.getProject();
    insert prj;
    
    ProjectProduct__c p = new ProjectProduct__c(Project__c = prj.Id, Leading__c=true, ProductLine__c='Trains', Platform__c = 'Metro');
        
    test.startTest();
    
    insert p;
    p.Leading__c=false;
    update p;
    
    delete p;
    
    undelete p;
  
    test.stopTest();
  }
}