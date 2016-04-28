/*
  VFC75_PortalComponentMyContacts_TEST
  Class Test Controller for VFC75_PortalComponentMyContacts
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
   ~ Date Created    : 17/06/2014 
*/
@isTest
private class VFC75_PortalComponentMyContacts_TEST {
    public static testMethod void testVFC75() {
        System.debug('## >>>>> testing class VFC75_PortalComponentMyContacts START <<<<<');
        Account account = UtilityTestMethod.getAccount();
        insert account;
    	Contact c = new Contact(Salutation='Mr', FirstName='Test', LastName='Contact Test Bulk', AccountId=account.Id);
    	insert c;
    	
     	Profile p = [SELECT Id FROM Profile WHERE Name='AT - Customer User']; 
      	User CommunityUser = new User(Alias = 'newUser', Email='vfc75@transport.alstom.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='vfc75@transport.alstom.com', ContactId= c.Id);
      	insert CommunityUser;
        List<User>  AlstomUserList = UtilityTestMethod.getUsersToInsert(4); 
        insert AlstomUserList;
		
		System.runAs(CommunityUser) {
			List<AlstomContact__c> alstomsalescontactlist = UtilityTestMethod.getAlstomContacts(AlstomUserList, 4, false, c.Id);
			insert alstomsalescontactlist;
			List<AlstomContact__c> alstomtechnicalcontactlist = UtilityTestMethod.getAlstomContacts(AlstomUserList, 4, true, c.Id);
			insert alstomtechnicalcontactlist;
        	Test.startTest();
	    	VFC75_PortalComponentMyContacts VFC75 = new VFC75_PortalComponentMyContacts();
	    	List<AlstomContact__c> alstomsalescontactlisttest = VFC75.getAlstomSalesContacts();
	    	List<AlstomContact__c> alstomtechnicalcontactlisttest = VFC75.getAlstomTechnicalContacts();
        	Test.stopTest();
		}
        System.debug('## >>>>> testing class VFC75_PortalComponentMyContacts END <<<<<');
    }
}