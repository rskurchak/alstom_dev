/*
 * This class contains unit tests for validating the behavior of AP67User Apex classes and triggers.
 */

@isTest(SeeAllData=true)
private class AP67User_TEST 
{
    static testMethod void testAP67User() 
    {
    	System.debug('## >>>>> testing class AP67User START <<<<<');
        
        // data testing
        System.debug('## create the necessary data for the test method');
        
		System.debug('## retrieve user');
		List<User> users = UtilityTestMethod.getUsersToInsert(2);
		users.get(0).EmployeeNumber='000000001'; 
		users.get(1).EmployeeNumber='000000009';
		insert users;
		
		System.debug('## create Alstom Employees');
		List<AlstomEmployee__c> alstomEmployees = UtilityTestMethod.getAlstomEmployees(2);
		alstomEmployees.get(0).EmployeeNumber__c = '000000001';
		alstomEmployees.get(0).EmployeeNumber__c = '000000009';
		insert alstomEmployees;
		
		Test.startTest();
			//insert users;
			System.runAs(UtilityTestMethod.getAccManagerUsers(10).get(5))
			{
				users.get(0).isActive = false;
				update users.get(0);
				users.get(0).isActive = true;
				update users.get(0);
			}
		Test.stopTest();
		
		System.debug('## >>>>> testing class AP67User END <<<<<');
    }
}