/*
 AP22PeriodicReport APEX Class
    ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
    ~ Date Created    : 21/03/2013
    ~ Description     : Apex Class 
                        - Add a Chatter Feed on the Parent Opportunity          
*/
public with sharing class AP22PeriodicReport 
{
    public static void addOpportunityInsertChatterFeed(list<PeriodicReport__c> listePeriodicReports)
    {
        List<FeedItem> feedItemsToInsert = new List<FeedItem>();
        
        for (PeriodicReport__c pr : listePeriodicReports)
        {   
            FeedItem oppFeedItem = new FeedItem();
            oppFeedItem.ParentId = pr.Opportunity__c;
            oppFeedItem.Type = 'LinkPost';
            oppFeedItem.LinkUrl = '/'+pr.Id;
            oppFeedItem.Title = pr.Name;
            oppFeedItem.Body = System.Label.LBL0018;
            feedItemsToInsert.add(oppFeedItem);
        }
        
        insert feedItemsToInsert;
    }
    
    public static void addOpportunityUpdateChatterFeed(list<PeriodicReport__c> listePeriodicReports)
    {
        List<FeedItem> feedItemsToInsert = new List<FeedItem>();
        
        for (PeriodicReport__c pr : listePeriodicReports)
        {   
            FeedItem oppFeedItem = new FeedItem();
            oppFeedItem.ParentId = pr.Opportunity__c;
            oppFeedItem.Type = 'LinkPost';
            oppFeedItem.LinkUrl = '/'+pr.Id;
            oppFeedItem.Title = pr.Name;
            oppFeedItem.Body = System.Label.LBL0019;
            feedItemsToInsert.add(oppFeedItem);
        }
        
        insert feedItemsToInsert;
    }
}