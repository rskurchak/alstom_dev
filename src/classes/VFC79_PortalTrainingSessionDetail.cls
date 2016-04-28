/*
 VFC79_PortalTrainingSessionDetail
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 02/07/2014 
    ~ Description     : Apex Class to show Training Session detail to Customer Portal User.
*/
public class VFC79_PortalTrainingSessionDetail {
    Public TrainingSession__c trainingsession;
    public List<TrainingSession__c> trainingsessionList {get;set;} 
    public boolean shownotesattachments {get;set;}
    public Integer notesattachmentspagesize {get;set;}
    public String trainingsessionDescription {get;set;}

    public VFC79_PortalTrainingSessionDetail(ApexPages.StandardController controller) {
        this.trainingsession= (TrainingSession__c)controller.getRecord();
        trainingsessionList = [SELECT Id,Name, Description__c, (SELECT Id,Title FROM Notes),(SELECT Id,Name FROM Attachments) FROM TrainingSession__c WHERE id= :this.trainingsession.Id Limit 1];
        notesattachmentspagesize = 0;
        if (trainingsessionList[0].Notes.size() == 0 && trainingsessionList[0].Attachments.size() == 0){
            shownotesattachments = false;
        } else {
            shownotesattachments = true;
            notesattachmentspagesize = trainingsessionList[0].Notes.size() + trainingsessionList[0].Attachments.size();
            if (notesattachmentspagesize > 25) {
                notesattachmentspagesize = 25;
            }
        }
        trainingsessionDescription = trainingsessionList[0].Description__c;
        if (trainingsessionDescription != null) {
            trainingsessionDescription = trainingsessionDescription.replaceAll('<[^>]*>','');
        }
    }
    
     public PageReference redirectView() {
        ID contactId = [Select contactid from User where id =:UserInfo.getUserId()].contactId;
        if(contactId ==null){
            String url = '/' + this.trainingsession.Id + '?&nooverride=1';
            system.debug('url: ' + url);
            return new ApexPages.PageReference(url).SetRedirect(true);
        } else {
          return null; 
        }
    }
    
}