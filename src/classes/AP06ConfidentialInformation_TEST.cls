/**
 * This class contains unit tests for validating the behavior of AP06ConfidentialInformation Apex classes
 * and triggers.
 *   ~ Author          : Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 
     ~ Date Created    : 24/07/2012
 */
@isTest
private class AP06ConfidentialInformation_TEST 
{
    static testMethod void testAP01() 
    {
        System.debug('## >>>>> testing class AP06ConfidentialInformation START <<<<<');
        
        List<User> users = UtilityTestMethod.getActiveUsersFromProfile(2,'AT - Sales');
        List<User> usersadmin = UtilityTestMethod.getUsersAdmin(1);
        insert usersadmin.get(0);
        
        // data testing
        System.debug('## Create Account ..');
        Account account = UtilityTestMethod.getAccounts(1).get(0);
        account.OwnerId = users.get(0).Id;
        insert account;
        
        System.debug('## Create Contact ..');
        Contact contact = UtilityTestMethod.getContacts(1).get(0);
        contact.AccountId = account.Id;
        insert contact;        

        System.debug('## Create Competitor ..');
        Competitor__c competitor = UtilityTestMethod.getCompetitors(1).get(0);
        insert competitor;        

        System.debug('## Create Opportunity ..');
        Opportunity opportunity = UtilityTestMethod.getOpportunityWithBOID();
        insert opportunity;        
        
        System.debug('## Create ConfidentialInformation ..');
        
        System.debug('## START testing ConfidentialInformationAfterInsert');
        ConfidentialInformation__c confInfo = UtilityTestMethod.getConfidentialInformations(1).get(0);
        confInfo.Account__c = account.Id;
        
        Test.startTest();
        // TESTING Triggers 
        insert confInfo;
        System.debug('## END testing ConfidentialInformationAfterInsert');
        
        System.debug('## START testing AccountAfterUpdate');
        account.OwnerId = users.get(1).Id;
        update account;
        System.debug('## END testing AccountAfterUpdate');
        
        System.debug('## START testing ContactAfterUpdate');
        contact.OwnerId = users.get(1).Id;
        update contact;
        System.debug('## END testing ContactAfterUpdate');

        System.debug('## START testing CompetitorAfterUpdate');
        competitor.OwnerId = users.get(1).Id;
        update competitor;
        System.debug('## END testing CompetitorAfterUpdate');

        System.debug('## START testing OpportunityAfterUpdate');
        opportunity.OwnerId = users.get(1).Id;
        update opportunity;
        System.debug('## END testing OpportunityAfterUpdate');
        
        Test.stopTest();
        
        System.debug('## >>>>> testing class AP06ConfidentialInformation END <<<<<'); 
    }
}