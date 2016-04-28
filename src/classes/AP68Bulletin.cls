/*
 AP68Bulletin APEX Class
    ~ Author          : Tiantian HE ~ tiantian.he@cgi.com 
    ~ Date Created    : 03/03/2015
    ~ Description     : Apex Class 
                        CR-0759 - Send notification Email when a bulletin/alert is published / when the buttin 'Notify the Post-Publication Update' is clicked
    ~ Triggers        : BulletinAfterInsert, BulletinAfterUpdate
    ~ Feature Id      : FEAT#0798
*/
global with sharing class AP68Bulletin {
	
	// get the new bulletin/alert publication notification Email Template
    private static EmailTemplate bulletinAlertNotifEmailTemplate = [select Id from EmailTemplate where DeveloperName = :System.label.LBL0324 LIMIT 1];
	// get the bulletin/alert post-publication update notification Email Template
    private static EmailTemplate bulletinAlertUpdateNotifEmailTemplate = [select Id from EmailTemplate where DeveloperName = :System.label.LBL0326 LIMIT 1];
	
	/**
	 * Notification Email sending method. For each Bulletin/Alert, a notification Email is sent
	 *  to all the Customer Portal Users corresponding to the Contacts of the Account of the Bulletin/Alert
	 *  and using the same language as the Bulletin/Alert.
	 *  Called by Triggers BulletinAfterInsert and BulletinAfterUpdate.
	 */

/*
	public static List<Messaging.Sendemailresult> sendBulletinPublicationEmail(List<Bulletin__c> bulletins, List<Boolean> isFirstPublication) {

		// map storing Account Id and the list of customer portal Users
		Map<Id, Set<User>> accountCustomerUsersMap = new Map<Id, Set<User>>();
		
		// AccountIds concerned by the bulletins
		Set<Id> accountIds = new Set<Id>();
		for (Bulletin__c bulletin: bulletins) {
			accountIds.add(bulletin.Account__c);
		}
		// get all the accounts of bulletins with list of contacts
		List<Account> accounts = [SELECT Id, (SELECT Id, Email FROM Account.Contacts) FROM Account WHERE Id IN :accountIds];
		Set<Id> contactIds = new Set<Id>();
		
		// get all contact Ids
		for (Account account: accounts) {
			if (account.Contacts.size() > 0) {
				for (Contact contact: account.Contacts) {
					contactIds.add(contact.Id);
				}
			}
		}
		
		// get all Customer Portal users of the contacts
		List<User> customerPortalUsers = [SELECT Id, Email, ContactId, LanguageLocaleKey FROM User WHERE IsActive = true AND ContactId IN :contactIds];
		// no Email to send if there is no customer portal user at all
		if (customerPortalUsers == null || customerPortalUsers.size() == 0) {
			return new List<Messaging.Sendemailresult>();
		}
		
		// store all the customer portal users of the Account in the map for later use
		for (Account account: accounts) {
			Set<User> customerPortalUserSet = new Set<User>();
			for (Contact contact: account.Contacts) {
				for (User user: customerPortalUsers) {
					if (user.ContactId != null && contact.Id.equals(user.ContactId)
						&& contact.Email != null) { // the contact must have an Email address
						customerPortalUserSet.add(user); // custom portal User with related Contact
						break;
					}
				}
			}
			if (customerPortalUserSet.size() > 0) {
				accountCustomerUsersMap.put(account.Id, customerPortalUserSet);
			}
		}		
		System.debug('##### AP68Bulletin sendBulletinPublicationEmail - accountCustomerUsersMap: ' + accountCustomerUsersMap);
		
		List<Messaging.Email> emailList = new List<Messaging.Email>();
		
		// prepare a email for each bulletin/alert
		for (Integer i=0; i<bulletins.size(); i++) {
			Bulletin__c bulletin = bulletins[i];
			Boolean isFirstPublished = isFirstPublication[i];
			//for (Bulletin__c bulletin: bulletins) {
			
			// get customer portal users of the Account and using the same language preference as in bulletin/alert
			List<User> bulletinCustomerPortalUsers = new List<User>();
			//List<Id> bulletinCustomerPortalContactIds = new List<Id>();
			if (accountCustomerUsersMap.get(bulletin.Account__c) != null) {
				for (User user: accountCustomerUsersMap.get(bulletin.Account__c)) {
					String userLanguageCode =  '(' + user.LanguageLocaleKey.substring(0, 2) + ')';
        			if (userLanguageCode != '(fr)') {
        				userLanguageCode =  '(en)';
        			}
					System.debug('##### AP68Bulletin sendBulletinPublicationEmail bulletin.Language__c=' + bulletin.Language__c + ', userLanguageCode=' + userLanguageCode + ', user.LanguageLocaleKey ' + user.LanguageLocaleKey);
					if (bulletin.Language__c.contains(userLanguageCode)) {
						bulletinCustomerPortalUsers.add(user);
						System.debug('##### AP68Bulletin sendBulletinPublicationEmail user ' + user + ' added for the bulletin: ' + bulletin.Name);
					}
				}
			}
			System.debug('##### AP68Bulletin sendBulletinPublicationEmail - Bulletin/Alert name: ' + bulletin.Name + ', customer portal users: ' + bulletinCustomerPortalUsers);
			
			// prepare the email per user (contact)
			for (User customerPortalUser: bulletinCustomerPortalUsers) {
				// Only SingleEmailMessage works with Custom Object as WhatId
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				if (isFirstPublished) {
					// use the new bulletin/alert notification template for first publication
					mail.setTemplateId(bulletinAlertNotifEmailTemplate.Id);
				} else {
					// use the bulletin/alert updated template for post-publication modification
					mail.setTemplateId(bulletinAlertUpdateNotifEmailTemplate.Id);
				}
				mail.setWhatId(bulletin.Id); // mail prepared for current bulletin
				mail.setTargetObjectId(customerPortalUser.ContactId); // send the mail to customer portal Contact email addr
				System.debug('##### AP68Bulletin sendBulletinPublicationEmail - Mail to User Id=' + customerPortalUser.Id + ', Target Object Id (Contact Id:):' + customerPortalUser.ContactId);
				mail.setSaveAsActivity(false);
				emailList.add(mail);
			}
		}
		
		System.debug('##### AP68Bulletin sendBulletinPublicationEmail - emailList size: ' + emailList.size());
		System.debug('##### AP68Bulletin sendBulletinPublicationEmail - emailList: ' + emailList);
		
		// stop the process if there is no Email to send
		if (emailList.size() == 0) {
			return new List<Messaging.Sendemailresult>();
		}
		
		// send the notification Emails
		List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailList, false); // send the mails by ignoring errors occurred
		Boolean allSendingFailed = true; 
		List<Messaging.SendEmailError> errors = new List<Messaging.SendEmailError>();
		for (Messaging.SendEmailResult result: results) {
			if (!result.isSuccess()) {
				errors.addAll(result.getErrors());
			}
			else {
				allSendingFailed = false;
			}
		}
		return results;
		//if (allSendingFailed) {
		//	// if all the email sending failed, throw exception
		//	// WO0000002832622: Now the emails in errors will be tracked through the bounced emails report
		//	//throw new EmailSendingException('EmailException: ' + errors);
		//	return results;
		//} 
		//else {
		//	if (Trigger.isInsert){
		//		List<Bulletin_Sent_Notification__c> bulletinSendNotificationinsert = new List<Bulletin_Sent_Notification__c>();
		//		for (Messaging.Email item : emailList){
		//			Messaging.SingleEmailMessage mail = (Messaging.SingleEmailMessage)item;
		//			bulletinSendNotificationinsert.add(new Bulletin_Sent_Notification__c(Contact__c  = mail.getTargetObjectId(),
		//																				 Bulletin__c = mail.getWhatId()));
		//		}
		//		try{
		//			insert bulletinSendNotificationinsert;
		//		} catch (DmlException ex){
		//			for ( Integer i=0; i < ex.getNumDml(); i++  ){
		//				Id bulletinId = bulletinSendNotificationinsert[ex.getDmlIndex(i)].Bulletin__c;
		//				new Map<Id, Bulletin__c>(bulletins).get(bulletinId).addError('Can not create Bulletin sent notification record: ' +  + ex.getMessage());
		//			}
		//		}
		//	}
		//	// if at least one mail is sent, no error message will be returned to user
		//	return new List<Messaging.Sendemailresult>();
		//}
	}
*/

	/**
	 * Reset Bulletin/Alert read counter to 0 (by deleting all the Read Receipts).
	 *  Called by Bulletin Detail Page Custom Button NotifyPublication.
	 */
	webservice static String resetReadCounter(String bulletinId) {
		try {
			// delete all read receipts to mark the Bulletin/Alert as unread
			List<ReadReceipt__c> readReceiptList = [SELECT Id FROM ReadReceipt__c WHERE Bulletin__c= :bulletinId];
			if (readReceiptList.size() > 0) {
				delete readReceiptList;
			}

			// update the bulltin publication date
			Bulletin__c bulletin = new Bulletin__c(Id = bulletinId, PublicationDate__c = DateTime.now());
			update bulletin;
			
			List<Bulletin__c> bList = new List<Bulletin__c>();
			bList.add( bulletin );
			BulletinServices.notiyExternalUsersAboutBulletinUpdate( bList );

			System.debug('##### AP68Bulletin resetReadReceipt SUCCESS for Bulletin Id=' + bulletinId);
			return 'Success';

//		} catch (EmailSendingException e) {
//			System.debug('##### AP68Bulletin resetReadReceipt ERROR for Bulletin Id=' + bulletinId + ', Error: ' + e.getMessage());
//			return 'An Email sending error has occurred: ' + e.getMessage();
		} catch (DmlException e) {
			System.debug('##### AP68Bulletin resetReadReceipt ERROR for Bulletin Id=' + bulletinId + ', Error: ' + e.getMessage());
			return 'An error has occurred: ' + e.getMessage();
		}
	}

//	class EmailSendingException extends Exception {}

}