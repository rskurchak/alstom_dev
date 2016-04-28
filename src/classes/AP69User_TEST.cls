/**
 * This class contains unit tests for validating the behavior of AP69User Apex classes
 * and triggers.
 *   ~ Author          : Tiantian HE ~ tiantian.he@cgi.com 
     ~ Date Created    : 12/03/2015
 */
 @isTest
private class AP69User_TEST {
	
	static testMethod void testSyncUserInfoToContactInsert() {
		//check if current user has UserRole
		if (UserInfo.getUserRoleId() == null){
			UserRole ur = [SELECT Id FROM UserRole LIMIT 1];
			System.runAs(new User(Id = UserInfo.getUserId())){
				//assign User to Role
				User u = new User(Id = UserInfo.getUserId(), UserRoleId = ur.Id);
				update u;
			}
		}

		// create the contact
		Account account = UtilityTestMethod.getAccount();
		insert account;
		Contact contact = UtilityTestMethod.getContact();
		contact.AccountId = account.Id;
		contact.Title = 'Mr.';
		contact.FirstName = 'customer';
		contact.LastName = 'portal';
		contact.Email = 'test.portal@test.portal.com';
		contact.Phone = '0505050505';
		contact.MobilePhone = '0606060606';
		insert contact;

		// create the customer portal user of the contact
		String profileId = [SELECT Id FROM Profile WHERE Name = 'AT - Customer User' LIMIT 1].Id;
		List<User> customerPortalUsers = UtilityTestMethod.getUsersToInsert(1);
		customerPortalUsers[0].ProfileId = profileId;
		customerPortalUsers[0].ContactId = contact.Id;
		customerPortalUsers[0].Title = 'Dr.';
		customerPortalUsers[0].FirstName = 'Test';
		customerPortalUsers[0].LastName = 'SMITH';
		customerPortalUsers[0].Email = 'test.smith@customer.portal.com';
		customerPortalUsers[0].Phone = '0000000000';
		customerPortalUsers[0].MobilePhone = '9999999999';

		Test.startTest();

		insert customerPortalUsers;

		Test.stopTest();

		// test the user insert synchronization
		List<Contact> updatedContacts = [SELECT Title, FirstName, LastName, Email, Phone, MobilePhone FROM Contact WHERE Id = :contact.Id LIMIT 1];
		System.assertEquals('Dr.', updatedContacts[0].Title);
		System.assertEquals('Test', updatedContacts[0].FirstName);
		System.assertEquals('SMITH', updatedContacts[0].LastName);
		System.assertEquals('test.smith@customer.portal.com', updatedContacts[0].Email);
		System.assertEquals('0000000000', updatedContacts[0].Phone);
		System.assertEquals('9999999999', updatedContacts[0].MobilePhone);
	}

	static testMethod void testSyncUserInfoToContactUpdate() {
		//check if current user has UserRole
		if (UserInfo.getUserRoleId() == null){
			UserRole ur = [SELECT Id FROM UserRole LIMIT 1];
			System.runAs(new User(Id = UserInfo.getUserId())){
				//assign User to Role
				User u = new User(Id = UserInfo.getUserId(), UserRoleId = ur.Id);
				update u;
			}
		}

		// create the contact
		Account account = UtilityTestMethod.getAccount();
		insert account;
		Contact contact = UtilityTestMethod.getContact();
		contact.AccountId = account.Id;
		contact.Title = 'Mr.';
		contact.FirstName = 'customer';
		contact.LastName = 'portal';
		contact.Email = 'test.portal@test.portal.com';
		contact.Phone = '0505050505';
		contact.MobilePhone = '0606060606';
		insert contact;

		// create the customer portal user of the contact
		String profileId = [SELECT Id FROM Profile WHERE Name = 'AT - Customer User' LIMIT 1].Id;
		List<User> customerPortalUsers = UtilityTestMethod.getUsersToInsert(1);
		customerPortalUsers[0].ProfileId = profileId;
		customerPortalUsers[0].ContactId = contact.Id;
		customerPortalUsers[0].Title = 'Dr.';
		customerPortalUsers[0].FirstName = 'Test';
		customerPortalUsers[0].LastName = 'SMITH';
		customerPortalUsers[0].Email = 'test.smith@customer.portal.com';
		customerPortalUsers[0].Phone = '0000000000';
		customerPortalUsers[0].MobilePhone = '9999999999';
		insert customerPortalUsers;

		// test the user update synchronization
		customerPortalUsers[0].FirstName = 'John';

		Test.startTest();

		System.runAs(new User(Id = UserInfo.getUserId())){
			update customerPortalUsers;
		}

		Test.stopTest();

		List<Contact> updatedContacts = [SELECT Title, FirstName, LastName, Email, Phone, MobilePhone FROM Contact WHERE Id = :contact.Id LIMIT 1];
		System.assertEquals('John', updatedContacts[0].FirstName);
		
	}

	static testMethod void testSyncUserInfoToContactWithIncorrectData(){
		Id incorrectContactId = Id.valueOf(Contact.sObjectType.getDescribe().getKeyPrefix() + '000000000000');

		User userWithIncorrectContactId = new User( Id = UserInfo.getUserId(),
													Title = 'Mr.',
													ContactId = incorrectContactId );

		Test.startTest();

			try{
				AP69User.syncUserInfoToContact( new List<User>{userWithIncorrectContactId} );
			} catch (Exception ex){}

		Test.stopTest();
	}

}