/*
 VFP76_PortalNewsDetail
    ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 26/06/2014 
    ~ Description     : Apex Class to show News detail to Customer Portal User.
*/
public class VFC76_PortalNewsDetail {
    Public News__c PortalNew; 
    public List<News__c> NewNotesAttachments {get;set;}
    public boolean shownotesattachments {get;set;}
    public Integer notesattachmentspagesize {get;set;}

    public VFC76_PortalNewsDetail(ApexPages.StandardController controller) {
        this.PortalNew= (News__c)controller.getRecord();
        NewNotesAttachments = [SELECT Id,Name,(SELECT Id,Title FROM Notes),(SELECT Id,Name FROM Attachments) FROM News__c WHERE id= :this.PortalNew.Id Limit 1];
        notesattachmentspagesize = 0;
        if (NewNotesAttachments[0].Notes.size() == 0 && NewNotesAttachments[0].Attachments.size() == 0){
        	shownotesattachments = false;
        } else {
        	shownotesattachments = true;
        	notesattachmentspagesize = NewNotesAttachments[0].Notes.size() + NewNotesAttachments[0].Attachments.size();
        	if (notesattachmentspagesize > 25) {
        		notesattachmentspagesize = 25;
        	}
        }
    }
    public PageReference redirectView() {
    	ID contactId = [Select contactid from User where id =:UserInfo.getUserId()].contactId;
        if(contactId ==null){
    		String url = '/' + this.PortalNew.Id + '?&nooverride=1';
    		system.debug('url: ' + url);
	        return new ApexPages.PageReference(url).SetRedirect(true);
    	} else {
          return null; 
      	}
    }
 }