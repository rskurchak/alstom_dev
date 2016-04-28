/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *  ~ Author          : Ali BEN AISSA ~ ali.ben.aissa@cgi.com 
 *  ~ Date Created    : 22/07/2015
 */
@isTest
private class AP71Opportunity_TEST {

    static testMethod void ap71opportunityTest() {
      
      // create account
     Account acc = UtilityTestMethod.getAccount();
       insert acc;
      
      // create Opportunity
     Opportunity opp = UtilityTestMethod.getOpportunity();
       opp.AccountId = acc.Id;
       opp.CloseDate = date.today();
       opp.Amount =50000;
      
      test.startTest();
      // test before Insert
      insert opp;
      
      opp.Amount = 100599453;
      // test before update
      update opp;
      
      test.stopTest();
    }
}