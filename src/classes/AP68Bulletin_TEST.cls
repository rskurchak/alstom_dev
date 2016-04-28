/**
 * This class contains unit tests for validating the behavior of AP68Bulletin Apex classes
 * and triggers.
 *   ~ Author          : Tiantian HE ~ tiantian.he@cgi.com 
     ~ Date Created    : 03/03/2015
 */
 @isTest
private class AP68Bulletin_TEST {
	
	static testMethod void testResetReadCounter() {
        System.debug('## >>>>> testing class AP68Bulletin_TEST method testResetReadCounter() START <<<<<');
        Test.startTest();
        
        Account account = UtilityTestMethod.getAccount();
        insert account;
        // 3 contacts related to the account
        List<Contact> contacts = UtilityTestMethod.getContacts(3);
        for (Integer i=0; i<3; i++) {
        	contacts[i].AccountId = account.Id;
        }
        insert contacts;
        // 3 custom portal users related to the contacts. 2 first users using English. The 3rd using French.
        String profileId = [SELECT Id FROM Profile WHERE Name = 'AT - Customer User' LIMIT 1].Id;
        List<User> users = UtilityTestMethod.getUsersToInsert(3);
        for (Integer i=0; i<3; i++) {
        	users[i].ProfileId = profileId;
        	users[i].ContactId = contacts[i].Id;
        	if (i == 2) {
        		users[i].LanguageLocaleKey = 'fr';
        	}
        }
        insert users;
        // contacts should have the same Email addr as their users
        for (Contact contact: contacts) {
        	for (User user: users) {
        		if (contact.Id == user.ContactId) {
        			contact.Email = user.Email;
        		}
        	}
        }
        update contacts;
        System.debug('##### AP68Bulletin_TEST - contacts: ' + contacts);
        
        // the case of first publicatoin of bulletin
        Bulletin__c bulletin = new Bulletin__c(
        	Account__c = account.Id, 
        	Type__c = 'Bulletin', 
        	Language__c = 'English (en)', 
        	Name = 'Test Bulletin', 
        	Status__c = System.label.LBL0325 // Published
        );
        insert bulletin;
        
        // create a test Read Receipt
        ReadReceipt__c readReceipt = new ReadReceipt__c(Bulletin__c= bulletin.Id, User__c = users[0].Id, ReadDate__c = Datetime.now());
		insert readReceipt;
        List<Bulletin__c> updatedBulletins = [SELECT Id, PublicationDate__c, ReadCounter__c FROM Bulletin__c WHERE Id =: bulletin.Id LIMIT 1];
        System.assertEquals(1, updatedBulletins[0].ReadCounter__c);
        
        // update post-publication without clicking on the NotifyPublication button
        bulletin.Text__c = 'Bulletin content.';
        update bulletin;
        updatedBulletins = [SELECT Id, PublicationDate__c, ReadCounter__c FROM Bulletin__c WHERE Id =: bulletin.Id LIMIT 1];
        // assert the read counter is not reset
        System.assertEquals(1, updatedBulletins[0].ReadCounter__c);
        
        // update post-publication and click on the NotifyPublication button
        String result = AP68Bulletin.resetReadCounter(bulletin.Id);
        updatedBulletins = [SELECT Id, PublicationDate__c, ReadCounter__c FROM Bulletin__c WHERE Id =: bulletin.Id LIMIT 1];
        // assert the read counter is reset to 0
        System.assertEquals(0, updatedBulletins[0].ReadCounter__c);
        // assert email sending success
        System.debug('##### AP68Bulletin_TEST - result: ' + result);
        System.assertEquals('Success', result);
        
        Test.stopTest();
        System.debug('## >>>>> testing class AP68Bulletin_TEST method testResetReadCounter() END <<<<<');
	}

    static testMethod void testResetReadCounterWithIncorrectData() {
        Id incorrectBulletinId = Id.valueOf(Bulletin__c.sObjectType.getDescribe().getKeyPrefix() + '000000000000');

        String result;

        Test.startTest();

            try{
                result = AP68Bulletin.resetReadCounter( String.valueOf( incorrectBulletinId ) );
            } catch (Exception ex){}

        Test.stopTest();

        System.assert( result != 'Success');
    }
}