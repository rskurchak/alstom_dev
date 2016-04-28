/*
	SchedulerAccountTeamSharing
    ~ Author          : Fabien Taillon ~ fabien.taillon@cgi.com 
    ~ Date Created    : 12/06/2013
    ~ Description     : Scheduler for BatchAccountTeamSharing Apex Batch
*/
global class SchedulerAccountTeamSharing implements Schedulable
{
	global void execute(SchedulableContext sc) 
	{
		BatchAccountTeamSharing bats = new BatchAccountTeamSharing();
		bats.query = 'Select Id from Account where Id IN (Select Account__c from Project__c)';
        ID batchprocessid = Database.executeBatch(bats);
	}
}