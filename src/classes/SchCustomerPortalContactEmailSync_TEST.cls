/**
 * This class contains unit tests for validating the behavior of SchedulerCustomerPortalContactEmailSync & BatchCustomerPortalContactEmailSync APEX Classes
 * and triggers.
 *   ~ Author          : Tiantian HE ~ tiantian.he@cgi.com 
     ~ Date Created    : 10/03/2015
 */
@isTest
private class SchCustomerPortalContactEmailSync_TEST {
	
	public static testMethod void SchCustomerPortalContactEmailSync_TEST() {
		Test.startTest();

        SchedulerCustomerPortalContactEmailSync s = new SchedulerCustomerPortalContactEmailSync();
		// 5 minutes after the hour, every hour
		String sch = '0 10 * * * ? ';
        system.schedule('SchCustomerPortalContactEmailSync_TEST', sch, s);
        
        Test.stopTest();
	} 

}