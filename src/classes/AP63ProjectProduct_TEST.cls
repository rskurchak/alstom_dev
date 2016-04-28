/**
 * This class contains unit tests for validating the behavior of AP18Product Apex classes
 * and triggers.
 *   ~ Author          : Christophe AVERSENG
     ~ Date Created    : 05/05/2014 - copied from AP18Product_TEST
 */
@isTest
private class AP63ProjectProduct_TEST 
{
    static testMethod void AP63ProjectProduct_TEST () 
    {
        Project__c prj = UtilityTestMethod.getProject();
        insert prj;
        ProjectProduct__c p = new ProjectProduct__c(Project__c = prj.Id, Leading__c=true, ProductLine__c='Trains', Platform__c = 'Metro');
        ProjectProduct__c p2 = new ProjectProduct__c(Project__c = prj.Id, ProductLine__c='Rolling Stock & Components', 
                     Platform__c = 'Metrooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
    
    
    test.startTest();
    insert p;
    insert p2;
    test.stopTest();
    }
}