/**
 * This class contains unit tests for validating the behavior of SchedulerAccountTeamSharing & BatchAccountTeamSharing APEX Class
 * and triggers.
 *   ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
     ~ Date Created    : 12/06/2013
 */
@isTest
private class SchedulerAccountTeamSharing_TEST
{
	public static testMethod void SchedulerAccountTeamSharing_TEST() 
	{ 
		User user = UtilityTestMethod.getUsersPQM(1).get(0);
        insert user;
        
		Account acc = UtilityTestMethod.getAccount();
        insert acc;
        
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.AccountId = acc.Id;
        insert opp;
        
        Project__c proj = new Project__c(Name = 'My Project', Account__c = acc.Id, Opportunity__c = opp.Id);
        insert proj;
        
        List<AccountTeamMember> listAtm = new List<AccountTeamMember>();
        AccountTeamMember atm = new AccountTeamMember(AccountId = acc.Id, UserId = UserInfo.getUserId(), TeamMemberRole = 'Other');
		AccountTeamMember atm2 = new AccountTeamMember(AccountId = acc.Id, UserId = user.Id, TeamMemberRole = 'Other');
        listAtm.add(atm);
        listAtm.add(atm2);
        insert listAtm;
        
        Test.startTest();

        SchedulerAccountTeamSharing s = new SchedulerAccountTeamSharing();        
        String sch = '0 0 23 * * ?'; 
        system.schedule('SchedulerAccountTeamSharing_TEST', sch, s);
        
        Test.stopTest();
	}
}