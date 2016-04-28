/*
 VFC74_BulletinCreateReadReceipt
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 18/04/2014 
    ~ Description     : Apex Class to show button to confirm the bulletin/alert read action.
*/
public class VFC74_BulletinCreateReadReceipt {
    Public Bulletin__c bulletin; 
    public boolean NotRead { get; set; }
    public boolean isAlert { get; set; }
    public final String BULLETINTYPE = 'Alert';

    public VFC74_BulletinCreateReadReceipt(ApexPages.StandardController controller) {
        this.bulletin = (Bulletin__c)controller.getRecord();
        isAlert = bulletin.Type__c == BULLETINTYPE;
        If ([SELECT Id FROM ReadReceipt__c where Bulletin__c =: this.bulletin.Id and User__c =: UserInfo.getUserID()].size() == 0){
        	NotRead = true;
        } else {
        	NotRead = false;
        }
    }
    
    public PageReference createReadReceipt() {
    	try {
	        if (NotRead){
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
}