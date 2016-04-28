/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
 Add assert
 Remove this box once modification done.
*********************************************************************/
/**
 * This class contains unit tests for validating the behavior of AP25Project Apex classes
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
     ~ Date Created    : 25/04/2013
 */
@isTest
private class AP25Project_TEST 
{
    static testMethod void AP25Project_TEST() 
    {
        User u = UtilityTestMethod.getUsersPQM(1).get(0);
        insert u;
        
        Account acc = UtilityTestMethod.getAccount();
        insert acc;
        
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AccountId = acc.Id;
        insert opp;
        
        Project__c proj = new Project__c(Name = 'My Project', Account__c = acc.Id, Opportunity__c = opp.Id);
        
        
        Test.startTest();
        
        insert proj;
        proj.OwnerID = u.Id;
        update proj;
        delete proj;
        undelete proj;
        
        Test.stopTest();
    }
}