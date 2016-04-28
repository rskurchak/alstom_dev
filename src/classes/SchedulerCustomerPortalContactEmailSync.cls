/*
	SchedulerCustomerPortalContactEmailSync
    ~ Author          : Tiantian HE ~ tiantian.he@cgi.com 
    ~ Date Created    : 10/03/2015
    ~ Description     : Scheduler for BatchCustomerPortalContactEmailSync Apex Batch
*/
global class SchedulerCustomerPortalContactEmailSync implements Schedulable {

	global void execute(SchedulableContext sc) {
		BatchCustomerPortalContactEmailSync bats = new BatchCustomerPortalContactEmailSync();
		bats.query = 'SELECT Id, ContactId, Email FROM User WHERE ContactId != \'\'';
        Id batchprocessid = Database.executeBatch(bats);
	}
	
}