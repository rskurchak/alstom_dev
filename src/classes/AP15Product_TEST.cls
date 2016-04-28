/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
 Test method best practices :
startTest / stopTest ; assert ; test with another profile
 Remove this box once modification done.
*********************************************************************/

/**
 * This class contains unit tests for validating the behavior of AP15Product Apex classes
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com
     ~ Date Created    : 15/02/2013
 */
@isTest
public class AP15Product_TEST 
{
    static testMethod void AP15Product_TEST() 
    {
        Opportunity opp = UtilityTestMethod.getOpportunity();
        insert opp;
        
        Product__c p = new Product__c(Opportunity__c = opp.Id, Leading__c=true, ProductLine__c='Rolling Stock & Components', Platform__c = 'Metro');
        
        
        test.startTest();
        
        insert p;
        p.Leading__c=false;
        update p;
    
        test.stopTest();
    }
}