/*
    SchedulerTenderSharing
    ~ Author          : Fabien Taillon ~ fabien.taillon@cgi.com 
    ~ Date Created    : 23/10/2013
    ~ Description     : Scheduler for BatchTenderSharing Apex Batch
*/
global class SchedulerTenderSharing implements Schedulable
{
    global void execute(SchedulableContext sc) 
    {
        BatchTenderSharing bts = new BatchTenderSharing();
        bts.query = 'Select Id, Opportunity__c from Tender__c where Opportunity__c != null';
        ID batchprocessid = Database.executeBatch(bts);
    }
}