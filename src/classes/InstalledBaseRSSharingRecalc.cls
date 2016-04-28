global class InstalledBaseRSSharingRecalc implements Database.Batchable<sObject> {
    
    static String emailAddress = 'vladyslav.petrovych@bluewolfgroup.com';

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator([ SELECT Id, AccountParent__c, Account__c, OperatorName__c, OperatorParentId__c,
                                                 FleetMaintainer__c, FleetMaintainerParent__c
                                          FROM InstalledBaseRS__c ]); 

    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        SharingService service = new SharingService( new InstalledBasedRSMapper() );
        service.share(scope);
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