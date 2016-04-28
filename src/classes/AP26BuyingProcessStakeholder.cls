/*
 AP26BuyingProcessStakeholder Apex Class
    ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
    ~ Date Created    : 22/05/2013
    ~ Description     : Apex Class 
                        - add a Chatter Post to the related Contact Feed        
*/
public with sharing class AP26BuyingProcessStakeholder 
{
    public static void addContactChatterPost(list<BuyingProcessStakeholder__c> bpsList)
    {
        List<FeedItem> feedItemsToInsert = new List<FeedItem>();
        
        // Getting needed informations on related Contact and Opportunity
        Map<Id, BuyingProcessStakeholder__c> bpsMap = new Map<Id, BuyingProcessStakeholder__c>([Select Id, ContactName__r.Name, Opportunity__r.Name From BuyingProcessStakeholder__c where Id IN :bpsList]);
        
        for (BuyingProcessStakeholder__c bps : bpsList)
        {   
            FeedItem contactFeedItem = new FeedItem();
            contactFeedItem.ParentId = bps.ContactName__c;
            contactFeedItem.Type = 'TextPost';
            contactFeedItem.Body = bpsMap.get(bps.Id).ContactName__r.Name + ' ' + System.Label.LBL0022 + ' ' + bpsMap.get(bps.Id).Opportunity__r.Name;
            feedItemsToInsert.add(contactFeedItem);
        }

        insert feedItemsToInsert;
    }
}