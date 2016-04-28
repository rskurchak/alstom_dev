/*
	BatchAccountTeamSharing
    ~ Author          : Tiantian HE ~ tiantian.he@cgi.com 
    ~ Date Created    : 10/03/2015
    ~ Description     : Apex Batch to synchronize Customer Portal User Email to Customer Portal Contacts.
*/
global class BatchCustomerPortalContactEmailSync implements Database.Batchable<SObject> {

	global String query;
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		System.debug('######### BatchCustomerPortalContactEmailSync - start(): query = ' + query);
		return Database.getQueryLocator(query); 
	}
	
	global void execute(Database.BatchableContext BC, List<SObject> scope) {
		// Input SObjects: Users with Id, ContactId and Email
		
		// Get Contact List with correct Emails
		List<Contact> contacts = new List<Contact>();
		for (SObject user: scope) {
			Contact contact = new Contact(Id=(Id)user.get('ContactId'), Email=(String)user.get('Email'));
			contacts.add(contact);
		}
		System.debug('######### BatchCustomerPortalContactEmailSync - execute(): contacts = ' + contacts);
		
		// Update Contacts
		update contacts;
	}
    
    global void finish(Database.BatchableContext BC) {
    	AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
		if(a.NumberOfErrors > 0)
		{
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(new String[]{System.label.LBL0058});
			mail.setReplyTo('noreply@salesforce.com');
			mail.setSenderDisplayName('Batch Processing');
			mail.setSubject('BatchCustomerPortalContactEmailSync - '+a.Status);
			mail.setPlainTextBody('Batch Process has completed. '+a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });	
		}
	}

}