global class CWCAccountSharingRecalc implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;//Database.getQueryLocator([ SELECT Id, CaseAccountParent__c, AccountId FROM AccountShare ]); 
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        //SharingService service = new SharingService( new CaseMapper() );
        //service.share(scope);
    }
    
    global void finish(Database.BatchableContext BC) {
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(CustomMetadataServices.getNotificationRecipients( CustomMetadataServices.GENERAL_EMAIL_NOTIFICATION ).split(','));
        mail.setSubject('Apex Sharing Recalculation Completed.');
        mail.setPlainTextBody('The Apex sharing recalculation finished processing');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}