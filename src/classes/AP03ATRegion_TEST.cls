/**
 * This class contains unit tests for validating the behavior of AP03ATRegion Apex class
 * and triggers (was initially in AP03ATRegion, moved on 21/08/2014 to a standalone test class component)
 *   ~ Author          : Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 
     ~ Date Created    : 24/07/2012
 */
@isTest
private class AP03ATRegion_TEST 
{
    private static final String  USER_PROFILE_NAME = 'AT - Customer Community +';
    private static final String  USER_NAME_PREFIX  = '@transport.alstom.com';

    static testMethod void testAP03()
    {
        System.debug('## >>>>> testing class AP03ATRegion START <<<<<');
         
        System.debug('## Create entries for the custom settings CountryATRegion__c  ..');
        insert new CountryATRegion__c(Name='1', Country__c='France', ATRegion__c='Europe', ATCluster__c='France');
        insert new CountryATRegion__c(Name='2', Country__c='Morocco', ATRegion__c='Africa', ATCluster__c='Maghreb');
        insert new CountryATRegion__c(Name='3', Country__c='Mexico', ATRegion__c='America',ATCluster__c='Central America');
        
        Test.startTest();
          
        System.debug('## Create Account ..');
        Account acc = UtilityTestMethod.getAccount();
        acc.Country__c = 'France';
        insert acc;
        acc = [SELECT ATCluster__c, ATRegion__c FROM Account where Id= :acc.Id];
        System.AssertEquals('Europe',acc.ATRegion__c);
        System.AssertEquals('France',acc.ATCluster__c);

        Contact contact = TestUtils.createContacts(new List<Account>{acc}, true)[0];

        Id userProfileId = [SELECT Id
                            FROM Profile
                            WHERE Name =: USER_PROFILE_NAME LIMIT 1][0].Id;

        TestUtils.createUsers(new List<Contact>{contact}, userProfileId, USER_NAME_PREFIX, true);

        acc.Country__c = 'Mexico';
        update acc; 
        acc = [SELECT ATCluster__c, ATRegion__c FROM Account where Id= :acc.Id];
        System.AssertEquals('America',acc.ATRegion__c);
        System.AssertEquals('Central America',acc.ATCluster__c);
            
        System.debug('## Create Opportunity ..');
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AccountId = acc.Id;
        opp.Country__c = 'France';
        insert opp;
        opp = [SELECT ATCluster__c, ATRegion__c FROM Opportunity where Id= :opp.Id];
        System.AssertEquals('Europe',opp.ATRegion__c);
        System.AssertEquals('France',opp.ATCluster__c);
        
        opp.Country__c = 'Mexico';
        update opp; 
        opp = [SELECT ATCluster__c, ATRegion__c FROM Opportunity where Id= :opp.Id];
        System.AssertEquals('America',opp.ATRegion__c);
        System.AssertEquals('Central America',opp.ATCluster__c);
        
        System.debug('## Create Competitor ..');
        Competitor__c competitor = UtilityTestMethod.getCompetitors(1).get(0);
        competitor.Country__c = 'France';
        insert competitor;
        competitor = [SELECT ATCluster__c, ATRegion__c FROM Competitor__c where Id= :competitor.Id];
        System.AssertEquals('Europe',competitor.ATRegion__c);
        System.AssertEquals('France',competitor.ATCluster__c);
        
        competitor.Country__c = 'Mexico';
        update competitor;
        competitor = [SELECT ATCluster__c, ATRegion__c FROM Competitor__c where Id= :competitor.Id];
        System.AssertEquals('America',competitor.ATRegion__c);
        System.AssertEquals('Central America',competitor.ATCluster__c);
        
        System.debug('## Create Project ..');
        Project__c project = new Project__c(Account__c = acc.Id);
        project.Country__c = 'France';
        insert project;
        project = [SELECT ATCluster__c, ATRegion__c FROM Project__c where Id= :project.Id];
        System.AssertEquals('Europe',project.ATRegion__c);
        System.AssertEquals('France',project.ATCluster__c);
        
        project.Country__c = 'Mexico';
        update project; 
        project = [SELECT ATCluster__c, ATRegion__c FROM Project__c where Id= :project.Id];
        System.AssertEquals('America',project.ATRegion__c);
        System.AssertEquals('Central America',project.ATCluster__c);
        
        System.debug('## Create Lead ..');
        Lead lead = new Lead(LastName='Daffy', Company='Acme');
        lead.Country__c = 'France';
        insert lead;
        lead = [SELECT ATCluster__c, ATRegion__c FROM Lead where Id= :lead.Id];
        System.AssertEquals('Europe',lead.ATRegion__c);
        System.AssertEquals('France',lead.ATCluster__c);
        
        lead.Country__c = 'Mexico';
        update lead; 
        lead = [SELECT ATCluster__c, ATRegion__c FROM Lead where Id= :lead.Id];
        System.AssertEquals('America',lead.ATRegion__c);
        System.AssertEquals('Central America',lead.ATCluster__c);
        
        System.debug('## Create Installed Base Infra ..');
        InstalledBaseInfra__c infra = new InstalledBaseInfra__c(Account__c=acc.Id);
        infra.Country__c = 'France';
        insert infra;
        infra = [SELECT ATCluster__c, ATRegion__c FROM InstalledBaseInfra__c where Id= :infra.Id];
        System.AssertEquals('Europe',infra.ATRegion__c);
        System.AssertEquals('France',infra.ATCluster__c);
        
        infra.Country__c = 'Mexico';
        update infra; 
        infra = [SELECT ATCluster__c, ATRegion__c FROM InstalledBaseInfra__c where Id= :infra.Id];
        System.AssertEquals('America',infra.ATRegion__c);
        System.AssertEquals('Central America',infra.ATCluster__c);
        
        System.debug('## Create Installed Base RS ..');
        InstalledBaseRS__c ibrs = new InstalledBaseRS__c(Account__c=acc.Id);
        ibrs.Country__c = 'France';
        insert ibrs;
        ibrs = [SELECT ATCluster__c, ATRegion__c FROM InstalledBaseRS__c where Id= :ibrs.Id];
        System.AssertEquals('Europe',ibrs.ATRegion__c);
        System.AssertEquals('France',ibrs.ATCluster__c);
        
        ibrs.Country__c = 'Mexico';
        update ibrs; 
        ibrs = [SELECT ATCluster__c, ATRegion__c FROM InstalledBaseRS__c where Id= :ibrs.Id];
        System.AssertEquals('America',ibrs.ATRegion__c);
        System.AssertEquals('Central America',ibrs.ATCluster__c);
        
        Test.stopTest();
        System.debug('## >>>>> testing class AP03ATRegion STOP<<<<<');
      }
}