/*
 AP69User APEX Class
    ~ Author          : Tiantian HE ~ tiantian.he@cgi.com 
    ~ Date Created    : 12/03/2015
    ~ Description     : Apex Class 
                        CR-0762 - Synchronize Customer Portal User information to Contact.
    ~ Triggers        : UserAfterInsert, UserAfterUpdate
    ~ Feature Id      : FEAT#0801
*/
public with sharing class AP69User {
	public static Boolean avoidFutureMethodExecutionForTestNeeds = false;

	public static void syncUserInfoToContact(List<User> customerPortalUsers) {
		List<Contact> customerPortalContacts = new List<Contact>();
		
		for (User user: customerPortalUsers) {
			Contact contact = new Contact(Id = user.ContactId);
			
			// Title
			if (user.Title != null && user.Title != '') {
				contact.Title = user.Title;
			}
			
			// First Name
			if (user.FirstName != null && user.FirstName != '') {
				contact.FirstName = user.FirstName;
			}
			
			// Last Name
			if (user.LastName != null && user.LastName != '') {
				contact.LastName = user.LastName;
			}
			
			// Email
			if (user.Email != null && user.Email != '') {
				contact.Email = user.Email;
			}
			
			// Phone
			if (user.Phone != null && user.Phone != '') {
				contact.Phone = user.Phone;
			}
			
			// Mobile Phone
			if (user.MobilePhone != null && user.MobilePhone != '') {
				contact.MobilePhone = user.MobilePhone;
			}
            
			customerPortalContacts.add(contact);
		}


		if ( !avoidFutureMethodExecutionForTestNeeds ){
			updateContactDetails( JSON.serialize( customerPortalContacts ) );
		}
	}

	@future 
	public static void updateContactDetails( String serializedContacts ){
		List<Contact> contactsToUpdate = (List<Contact>)JSON.deserialize(serializedContacts, List<Contact>.class);
		try{
			update contactsToUpdate;
		} catch( DMLException dmlEx ){
	        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	        mail.setToAddresses( CustomMetadataServices.getNotificationRecipients( CustomMetadataServices.CONTACT_UPDATE_ERROR_NOTIFICATION ).split(',') );
	        mail.setReplyTo('noreply@salesforce.com');
	        mail.setSenderDisplayName('Contact Details update');
	        mail.setSubject('Contact Update - Error');
	        
	        String body = 'Error on processing Contact records:<br/><br/>';
			for ( Integer i=0; i < dmlEx.getNumDml(); i++ ){
				Contact c = contactsToUpdate[ dmlEx.getDmlIndex( i ) ];
	            body += '<br/>Record - Contact: '+c.Id;
	            body += '<br/>Message: ' + dmlEx.getMessage();
	        }
	        mail.setHtmlBody(body);
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });	
		}
	}

}