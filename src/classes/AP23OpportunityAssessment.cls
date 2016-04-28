/*
 AP23OpportunityAssessment APEX Class
    ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
    ~ Date Created    : 21/03/2013
    ~ Description     : Apex Class 
                        - Add a Chatter Feed on the Parent Opportunity          
*/
public with sharing class AP23OpportunityAssessment 
{
    public static void addOpportunityInsertChatterFeed(list<OpportunityAssessment__c> listeOpportunityAssessments)
    {
        List<FeedItem> feedItemsToInsert = new List<FeedItem>();
        
        for (OpportunityAssessment__c oa : listeOpportunityAssessments)
        {   
            FeedItem oppFeedItem = new FeedItem();
            oppFeedItem.ParentId = oa.Opportunity__c;
            oppFeedItem.Type = 'LinkPost';
            oppFeedItem.LinkUrl = '/'+oa.Id;
            oppFeedItem.Title = 'FP_'+oa.Formula_BOID__c+'_'+oa.AssessmentVersion__c;
            oppFeedItem.Body = System.Label.LBL0020;
            feedItemsToInsert.add(oppFeedItem);
        }
        
        insert feedItemsToInsert;
    }
    
    public static void addOpportunityUpdateChatterFeed(list<OpportunityAssessment__c> listeOpportunityAssessments)
    {
        List<FeedItem> feedItemsToInsert = new List<FeedItem>();
        
        for (OpportunityAssessment__c oa : listeOpportunityAssessments)
        {   
            FeedItem oppFeedItem = new FeedItem();
            oppFeedItem.ParentId = oa.Opportunity__c;
            oppFeedItem.Type = 'LinkPost';
            oppFeedItem.LinkUrl = '/'+oa.Id;
            oppFeedItem.Title = 'Find Plan';
            oppFeedItem.Body = System.Label.LBL0021;
            feedItemsToInsert.add(oppFeedItem);
        }
        
        insert feedItemsToInsert;
    }
}