global class CreateNewPortalUsers implements Database.Batchable<sObject> {
	private String profileName;
	private String PROFILE_ID;
	private final String USER_NAME_PREFIX = '@transport.alstom.com';

	List<Id> contactId = new List<Id>();//new List<Id>{'0034E000006ulHv'};

	String query = 'SELECT Id, FirstName, LastName, Email, AccountId FROM Contact WHERE Id IN : contactId AND AccountId != null';

	global CreateNewPortalUsers() {
		prepareProfile( '' );
	}

	global CreateNewPortalUsers(String profileNameValue) {
		prepareProfile( profileNameValue );
	}

	global CreateNewPortalUsers(String contactIds, String profileNameValue) {
		prepareProfile( profileNameValue );
		this.contactId = new List<Id>();
		for (String stringitem : contactIds.split(',')){
			stringitem = stringitem.trim();
			if ( !String.isEmpty(stringitem) ) contactId.add(Id.valueOf(stringitem));
		}
	}

	global CreateNewPortalUsers(List<Id> contactIds, String profileNameValue) {
		prepareProfile( profileNameValue );
		this.contactId = contactIds;
	}

	private void prepareProfile(String profileNameValue){
		this.profileName = String.isEmpty(profileNameValue) ? 'AT - Customer Portal CWC User' : profileNameValue;
		this.PROFILE_ID = [SELECT Id From Profile WHERE Name = : this.profileName][0].Id;
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<Contact> contacts = (List<Contact>)scope;

		List<User> portalUsers = createPortalUsersByContacts( contacts );
		if (portalUsers.isEmpty()){
			return;
		}

		AP69User.avoidFutureMethodExecutionForTestNeeds = true;

		Database.DMLOptions dmlo = new Database.DMLOptions();
		dmlo.EmailHeader.triggerUserEmail = false;
		dmlo.EmailHeader.triggerAutoResponseEmail = false;

		Database.insert( portalUsers, dmlo );

		for (User user : portalUsers){
			System.setPassword(user.Id, 'Alstom123!');
		}
	}

	private List<User> createPortalUsersByContacts(List<Contact> contacts){
		List<User> existingUsers = [SELECT Id, ContactId FROM User WHERE ContactId IN : contacts];
		Set<Id> checkContactIds = new Set<Id>();
		for (User user : existingUsers){
			checkContactIds.add( user.ContactId );
		}

		List<User> portalUsers = new List<User>();

		for (Contact contact : contacts){
			if ( !checkContactIds.contains( contact.Id ) ) {
				portalUsers.add( createPortalUserByContact( contact ) );
			}
		}

		return portalUsers;
	}

	private User createPortalUserByContact (Contact contact){
		User user = new User();
		user.FirstName = contact.FirstName;
		user.LastName = contact.LastName;
		user.UserName = contact.LastName.replace(' ', '_') + USER_NAME_PREFIX;
		user.ProfileId = PROFILE_ID;
		user.Email = contact.Email;
		user.ContactId = contact.Id;
		user.Alias = (!String.isEmpty(contact.FirstName) ? contact.FirstName.substring(0, 1) : '') + contact.LastName.substring(0, 5);

		user.TimeZoneSidKey    = 'America/New_York';
		user.EmailEncodingKey  = 'ISO-8859-1';
		user.LocaleSidKey      = 'en_US';
		user.LanguageLocaleKey = 'en_US';

		System.Debug(LoggingLevel.ERROR, '^^^ user = ' + user);
		return user;
	}

	global void finish(Database.BatchableContext BC) {
		Set<Id> contactWithUsers = new Set<Id>();
		for (User user : [Select ContactId From User Where ContactId IN : contactId]){
			contactWithUsers.add(User.ContactId);
		}

		String mailBody = '';
		for (Id con : contactId){
			if ( !contactWithUsers.contains(con) ) {mailBody += 'Contact Id = ' + String.valueOf(con) + '\r\n';}
		}
		mailBody = String.isEmpty(mailBody) ? '' : 'For the next contacts Portal Users are not created : \r\n' + mailBody;

		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses( new List<String>{ UserInfo.getUserEmail() } );
		mail.setSubject('Creating Portal Users completed');
		mail.setPlainTextBody( mailBody );
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}

	public void sendEmailContact(String emailTemplateName){
		Id emailTemplId = [SELECT Id
						   FROM EmailTemplate
						   WHERE Name = : (String.isEmpty(emailTemplateName) ? 'AT - New portal member welcome' : emailTemplateName)][0].Id;

		Messaging.SingleEmailMessage[] mails = new List<Messaging.SingleEmailMessage>();

		for (User user : [SELECT Id
						  FROM User
						  WHERE ContactId IN : contactId] ){
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setTemplateID(emailTemplId);
			mail.setTargetObjectId( user.Id );
			mail.setSaveAsActivity(false);
			mails.add(mail);
		}

		Messaging.sendEmail( mails );
	}
}