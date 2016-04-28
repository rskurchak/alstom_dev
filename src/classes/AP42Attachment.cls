public with sharing class AP42Attachment 
{
    public static void newAttachmentChatterFeed(list<Attachment> listAtt)
    {
        List<FeedItem> feedItemsToInsert = new List<FeedItem>();
        
        for (Attachment att : listAtt)
        {   
            FeedItem feedItem = new FeedItem();
            feedItem.ParentId = att.ParentId;
            feedItem.Type = 'LinkPost';
            feedItem.LinkUrl = '/'+att.Id;
            feedItem.Title = att.Name;
            feedItem.Body = System.Label.LBL0067;
            feedItemsToInsert.add(feedItem);
        }
        
        insert feedItemsToInsert;
    }
    
    public static void updatedAttachmentChatterFeed(list<Attachment> listAtt)
    {
        List<FeedItem> feedItemsToInsert = new List<FeedItem>();
        
        for (Attachment att : listAtt)
        {   
            FeedItem feedItem = new FeedItem();
            feedItem.ParentId = att.ParentId;
            feedItem.Type = 'LinkPost';
            feedItem.LinkUrl = '/'+att.Id;
            feedItem.Title = att.Name;
            feedItem.Body = System.Label.LBL0068;
            feedItemsToInsert.add(feedItem);
        }
        
        insert feedItemsToInsert;
    }
}