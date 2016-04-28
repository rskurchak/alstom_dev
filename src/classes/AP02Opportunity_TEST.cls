/**
 * This class contains unit tests for validating the behavior of AP02Opportunity Apex classes
 * and triggers.
 *   ~ Author          : Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 
     ~ Date Created    : 06/07/2012
 */
@isTest
private class AP02Opportunity_TEST 
{
    static testMethod void testAP02() 
    {
        System.debug('## >>>>> testing class AP02Opportunity START <<<<<');
        
        // data testing
        System.debug('## Create Account ..');
        Account account = UtilityTestMethod.getAccounts(1).get(0);
        insert account;
		
		Account account2 = UtilityTestMethod.getAccounts(1).get(0);
        insert account2;
        
        System.debug('## Create Opportunity and set account id..');
        Opportunity opp = UtilityTestMethod.getOpportunities(1).get(0);
        opp.AccountId = account.Id;
        
        Test.startTest();
        insert opp;
        opp.AccountId = account2.Id;
        update opp;
        Test.stopTest();
        
        System.debug('## >>>>> testing class AP02Opportunity END <<<<<'); 
    }
}