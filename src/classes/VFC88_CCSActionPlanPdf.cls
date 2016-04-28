public without sharing class VFC88_CCSActionPlanPdf 
{
    public CSSActionPlan__c curActionPlan {get;set;}
    public List<ProjectSurvey__c> ListSurveyActionPlan {get;set;}
    
    public List<CSSAction__c> ListSurveyAction {get;set;}
    
    public VFC88_CCSActionPlanPdf(ApexPages.StandardController stdCtrl)
    {
        curActionPlan = (CSSActionPlan__c)stdCtrl.getrecord();
        String sNamefile  = getFileName().replace(' ','') + '.pdf';
       
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=' + sNamefile  );
        ListSurveyActionPlan = new List<ProjectSurvey__c>();
        ListSurveyActionPlan = [Select Id, Name, Status__c, Survey__c, SurveyURL__c, ResponseDate__c,InterviewDate__c,SatisfactionTowardsAT__c,NetPromoterScore__c from ProjectSurvey__c where CSSActionPlan__c = :curActionPlan.Id];
        //ListSurveyAction = [Select Id, Name, AssignedTo__c,Description__c , Type__c, Priority__c, DueDate__c, Status__c, Contact__c, Comments__c, ProjectSurvey__r.Name, ProjectSurvey__r.InterviewDate__c, ProjectSurvey__r.SatisfactionTowardsAT__c from CSSAction__c where Project__c = :curActionPlan.Project__c and ProjectSurvey__c in (Select Id from ProjectSurvey__c where CSSActionPlan__c = :curActionPlan.Id)];
        ListSurveyAction = [Select Id, Name, AssignedTo__c,Description__c , Type__c, Priority__c, DueDate__c, Status__c, Contact__c, Comments__c, ProjectSurvey__r.Name, ProjectSurvey__r.InterviewDate__c, ProjectSurvey__r.SatisfactionTowardsAT__c from CSSAction__c where CSSActionPlan__c = :curActionPlan.ID];
        
            
            
                //ConnectApi.BinaryInput Conn = new ConnectApi.BinaryInput(pdf.getcontent(),'application/pdf','toto.pdf');
                //ConnectApi.FeedItemInput FeedChat = new ConnectApi.FeedItemInput();
                //FeedChat.subjectid = curActionPlan.Id;
                //ConnectApi.ChatterFeeds.postFeedElement(null,FeedChat,Conn);
                
            
    }
    
     public string getFileName()
    {
        String sNamePdf = '';
        if(curActionPlan.Name != null)
        {
            sNamePdf = sNamePdf + curActionPlan.Name;
        }
        
        if(curActionPlan.Action_Plan_Status__c != null)
        {
            if(sNamePdf != '')
            {
                sNamePdf = sNamePdf + '_';
            }
            sNamePdf = sNamePdf + curActionPlan.Action_Plan_Status__c;
        }
        
        
        Datetime dNow = date.today();
       
        if(sNamePdf != '')
        {
            sNamePdf = sNamePdf + '_';
        }
        
        sNamePdf = sNamePdf + dNow.format('yyyy-MM-dd');
        return sNamePdf;
    }

    public void postAttachmentToChatter( )
    {
        
        String PostChat = ApexPages.currentPage().getParameters().get('PostChat');
        if(PostChat == '1')
        {
            Pagereference pdf = new Pagereference('/Apex/VFP88_CCSActionPlanPdf?id=' + curActionPlan.Id);
                
            if(!Test.IsRunningTest())
            {
                FeedItem post = new FeedItem();
                post.ParentId = curActionPlan.Id;
                
                post.ContentData  = pdf.getcontent();
                
                String sNamePdf = getFileName();
                
                //system.debug('##Simon Debug ' + sNamePdf);
                post.Title = sNamePdf;
                post.ContentFileName = sNamePdf + '.pdf'; 
                post.ContentDescription = 'New pdf CCS Action plan : ' + curActionPlan.Name;
                insert post;
                
                //Attachment attach = new Attachment();
                //attach.ParentId = curActionPlan.Id;
                //attach.Name = 'toto.pdf'; 
                //attach.Body  = post.ContentData;
                
                 
                //attach.Description = 'New pdf CCS Action plan';
                //insert attach;
            }
        }
    }
}