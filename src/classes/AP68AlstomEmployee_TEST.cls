/*
 * This class contains unit tests for validating the behavior of AP59Person Apex classes and triggers.
 */

@isTest(SeeAllData=true)
private class AP68AlstomEmployee_TEST 
{
    static testMethod void testAP68User() 
    {
    	System.debug('## >>>>> testing class AP68AlstomEmployee START <<<<<');
        
        // data testing
        System.debug('## create the necessary data for the test method');
        
		System.debug('## retrieve user');
		List<User> users = UtilityTestMethod.getUsers(1);
		
		System.debug('## create person');
		AlstomEmployee__c alstomEmployee = UtilityTestMethod.getAlstomEmployees(1).get(0);
		alstomEmployee.EmployeeNumber__c = '999999999';
		alstomEmployee.SalesforceUser__c = users.get(0).Id; 
		alstomEmployee.FirstName__c = 'first';
		alstomEmployee.LastName__c = 'last';
		alstomEmployee.City__c = 'paris';
		alstomEmployee.Status__c = 'Active';
		alstomEmployee.Company__c = 'Company Test';
		alstomEmployee.JobTitle__c = 'JobTitle Test';
		alstomEmployee.MobilePhone__c = '0606060606';
		alstomEmployee.WorkPhone__c = '0303030303';
		alstomEmployee.StreetAddress__c = '1 AVENUE TEST';
		alstomEmployee.Sector__c = 'Sector Test';
		alstomEmployee.ZipPostalCode__c = '75001';
		alstomEmployee.CountryName__c = 'France';
		alstomEmployee.Email__c = 'Test@test.com';
		insert alstomEmployee; 

		User idm = [SELECT Id FROM user WHERE Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
		
		Test.startTest(); 
			System.runAs(idm) {
				alstomEmployee.FirstName__c = 'first1';
				alstomEmployee.LastName__c = 'last1';
				alstomEmployee.City__c = 'Lyon';
				alstomEmployee.Company__c = 'Company Test1';
				alstomEmployee.JobTitle__c = 'JobTitle Test1';
				alstomEmployee.MobilePhone__c = '0606060607';
				alstomEmployee.WorkPhone__c = '0303030304';
				alstomEmployee.StreetAddress__c = '1 AVENUE TEST1';
				alstomEmployee.Sector__c = 'Sector Test1';
				alstomEmployee.ZipPostalCode__c = '75002';
				alstomEmployee.CountryName__c = 'United Kingdom';
				alstomEmployee.EmployeeNumber__c = '100737374';
				alstomEmployee.Email__c = 'Test2@test.com';
				update alstomEmployee;
				alstomEmployee.FirstName__c = 'first1 first1 first1 first1 first1 first1first1first1first1first1';
				alstomEmployee.LastName__c = 'last1last1last1last1last1last1last1last1last1last1last1last1last1';
				alstomEmployee.City__c = 'LyonLyonLyonLyonLyonLyonLyonLyonLyonLyonLyonLyonLyonLyonLyonLyonLyonLyon';
				alstomEmployee.Company__c = 'Company Test1Company Test1Company Test1Company Test1Company Test1Company Test1';
				alstomEmployee.JobTitle__c = 'JobTitle Test1JobTitle Test1JobTitle Test1JobTitle Test1JobTitle Test1JobTitle Test1';
				alstomEmployee.MobilePhone__c = '0606060607';
				alstomEmployee.WorkPhone__c = '0303030304';
				alstomEmployee.StreetAddress__c = '1 AVENUE TEST11 AVENUE TEST11 AVENUE TEST11 AVENUE TEST11 AVENUE TEST11 AVENUE TEST1';
				alstomEmployee.Sector__c = 'Sector Test1Sector Test1Sector Test1Sector Test1Sector Test1Sector Test1Sector Test1';
				alstomEmployee.ZipPostalCode__c = '75002';
				alstomEmployee.CountryName__c = 'United Kingdom';
				alstomEmployee.EmployeeNumber__c = '100737374';
				alstomEmployee.Email__c = 'Test2@test.com';
				update alstomEmployee;
			}
		Test.stopTest();
		
		System.debug('## >>>>> testing class AP68AlstomEmployee END <<<<<');
    }
}