/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
 Test method best practices: startTest / stopTest ; assert ; test with another profile
 Remove this box once modification done.
*********************************************************************/
/**
 * This class contains unit tests for validating the behavior of AP18Product Apex classes
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com
     ~ Date Created    : 18/02/2013
 */
@isTest
private class AP18Product_TEST 
{
    static testMethod void AP18Product_TEST() 
    {
        Opportunity opp = UtilityTestMethod.getOpportunity();
        insert opp;
        Product__c p = new Product__c(Opportunity__c = opp.Id, Leading__c=true, ProductLine__c='Rolling Stock & Components', Platform__c = 'Metro', Product__c = 'ASP');
        Product__c p2 = new Product__c(Opportunity__c = opp.Id, ProductLine__c='Rolling Stock & Components', Product__c = 'ASP',
                                       Platform__c = 'Metrooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo');
        
        
        test.startTest();
        insert p;
        insert p2;
        test.stopTest();
    }
}