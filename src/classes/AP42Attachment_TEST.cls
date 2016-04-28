@isTest
private class AP42Attachment_TEST
{
    static testMethod void AP42Attachment_TEST() 
    {
        Opportunity opp = UtilityTestMethod.getOpportunity();
        opp.LeadingProductLine__c = 'Rolling Stock & Components';
        opp.Platform__c = 'Mainlines';
        //opp.BOid__c = '12345';
        insert opp;
        
        Tender__c tender = UtilityTestMethod.getTender(opp.Id);
        insert tender;
        
        Milestone__c milestone = UtilityTestMethod.getMilestone(tender.Id);
        insert milestone;
        
        Attachment att = new Attachment(ParentId = milestone.Id, Name = 'My Milestone attachment', Body = Blob.valueOf('My Attachment Body'));
        
        test.startTest();
        
        insert att;
        att.Name = 'My Milestone Attachment';
        update att;
        
        test.stopTest();
    }
}