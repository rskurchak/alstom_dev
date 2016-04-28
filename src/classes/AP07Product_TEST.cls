/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
 Test method best practices: startTest / stopTest ; assert ; test with another profile"
 Remove this box once modification done.
*********************************************************************/

/**
 * This class contains unit tests for validating the behavior of AP07Product Apex classes
 * and triggers.
 * Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr
 */
@isTest
private class AP07Product_TEST 
{
    static testMethod void testAP07() 
    {
        System.debug('## >>>>> testing class AP07Product START <<<<<');
        
        // data testing
        System.debug('## Create accounts..');
        List<Account> accounts = UtilityTestMethod.getAccounts(1);
        insert accounts;
        
        System.debug('## Create opportunity.. ');
        Opportunity opp = UtilityTestMethod.getOpportunities(1).get(0);
        opp.AccountId = accounts.get(0).Id;
        opp.LeadingProductLine__c = 'TEST PL';
        opp.Platform__c = 'TEST Platform';
        insert opp;
        
        System.debug('## Create Products.. ');
        List<Product__c> prds = UtilityTestMethod.getProducts(2);
        prds.get(0).Opportunity__c = opp.Id;
        prds.get(0).Leading__c = true;
        prds.get(1).Opportunity__c = opp.Id;
        prds.get(1).Leading__c = true;
        
        Test.startTest();
        //test triggers : insert
        insert prds;
        
        prds.get(1).ProductLine__c = 'New Platform';
        prds.get(1).Leading__c = true;
        //test triggers : update
        update prds.get(1);
        Test.stopTest();
        
        System.debug('## >>>>> testing class AP07Product END <<<<<');
    }
}