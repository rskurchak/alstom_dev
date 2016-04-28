trigger TenderSubmissionBeforeInsert on TenderSubmission__c (before insert) 
{
    if (PAD.canTrigger('AP43'))
        AP43TenderSubmission.getAmountsInformations(trigger.new);
}