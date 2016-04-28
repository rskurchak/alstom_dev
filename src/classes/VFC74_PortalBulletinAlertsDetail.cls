/*
 VFC74_PortalBulletinAlertsDetail
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 02/07/2014 
    ~ Description     : Apex Class to show bulletin/alert detail to Customer Portal User.
*/
public class VFC74_PortalBulletinAlertsDetail {
    Public Bulletin__c bulletin;
    public List<Bulletin__c> BulletinLists {get;set;} 
    public boolean NotRead { get; set; }
    public boolean shownotesattachments {get;set;}
    public Integer notesattachmentspagesize {get;set;}
    public boolean isAlert { get; set; }
    public final String BULLETINTYPE = 'Alert';

    public VFC74_PortalBulletinAlertsDetail(ApexPages.StandardController controller) {
        this.bulletin= (Bulletin__c)controller.getRecord();
        BulletinLists = [SELECT Id, Name, Type__c, Is_Obsolescence_Alert__c,
                                (SELECT Id,Title FROM Notes),
                                (SELECT Id,Name FROM Attachments),
                                (SELECT Id FROM Read_Receipts__r where User__c =: UserInfo.getUserID())
                         FROM Bulletin__c WHERE id= :this.bulletin.Id Limit 1];
        notesattachmentspagesize = 0;
        if (BulletinLists[0].Notes.size() == 0 && BulletinLists[0].Attachments.size() == 0){
        	shownotesattachments = false;
        } else {
        	shownotesattachments = true;
        	notesattachmentspagesize = BulletinLists[0].Notes.size() + BulletinLists[0].Attachments.size();
        	if (notesattachmentspagesize > 25) {
        		notesattachmentspagesize = 25;
        	}
        }
        isAlert = BulletinLists[0].Type__c == BULLETINTYPE && BulletinLists[0].Is_Obsolescence_Alert__c;

 		if (BulletinLists[0].Read_Receipts__r.size() == 0){
        	NotRead = true;
        } else {
        	NotRead = false;
        }
    }
    
    public PageReference createReadReceipt() {
    	try {
	        If (NotRead){
		        ReadReceipt__c readReceipt = new ReadReceipt__c(Bulletin__c= this.bulletin.Id, User__c = UserInfo.getUserID(), ReadDate__c = Datetime.now());
		        insert readReceipt;

                if( isAlert ){
                    PageReference receiptPage = new PageReference('/apex/VFP74_BulletinSurveyCreateReadReceipt?Id='+readReceipt.Id);
                    receiptPage.setRedirect(true);
                    return receiptPage;
                }
	        }
        } catch (Exception e){// roll everything back in case of error
            ApexPages.addMessages(e);
            return null;
        }
        return new PageReference('/apex/VFP64_PortalHome');
    }
    
     public PageReference redirectView() {
    	ID contactId = [Select contactid from User where id =:UserInfo.getUserId()].contactId;
        if(contactId ==null){
    		String url = '/' + this.bulletin.Id + '?&nooverride=1';
    		system.debug('url: ' + url);
	        return new ApexPages.PageReference(url).SetRedirect(true);
    	} else {
          return null; 
      	}
    }
    
}