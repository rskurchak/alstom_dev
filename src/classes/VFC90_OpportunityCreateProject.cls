/*
 VFC90_OpportunityCreateProject apex controller
    ~ Author          : Ali BEN AISSA
    ~ Date Created    : 10/07/2015
    ~ Description     : "Create Project in project related list opportunity"
    ~ CR Id           : CR-0802   
*/

public with sharing class VFC90_OpportunityCreateProject {
     public String oppId {get;set;}
     private List<Opportunity> opportunity;
     private Boolean bHasCreateProjectPermission;
     private List<ObjectPermissions> prjPermissions;
     public String StageName {get;set;}
     // Indicates the "Cancel" button can be rendered
     public Boolean IsCancel{get;set;}

    public VFC90_OpportunityCreateProject() {
          // current Opp Id 
         IsCancel = false;       
         oppId =ApexPages.currentPage().getParameters().get('oppId');
         List<Project__c> projects = new List<Project__c>();
         projects = [Select Id from Project__c where Opportunity__c =: oppId];
         opportunity = [Select Id, StageName from Opportunity where Id =: oppId limit 1];    
    }
    
    public PageReference checkPermission() {
        system.debug('###> Begin method VFC90_OpportunityCreateProject.checkPermission   ### '); 
        // get permission to create projects with profile for user         
         Boolean userCanCreate= Project__c.sObjectType.getDescribe().isCreateable();
         if(!opportunity.isEmpty()){
              StageName = opportunity.get(0).StageName;
             if(userCanCreate == false
                  || !StageName.equals(System.Label.LBL0136)){
                  IsCancel =true;
                  ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You do not have permission to create a new project !');
                  ApexPages.addMessage(myMsg);
             }else{
                PageReference vfp69page = new PageReference('/apex/VFP69_Project_New?id='+oppId+'&retURL='+oppId);
                vfp69page.setRedirect(true);
                return vfp69page;
             }
         }
         return null;
    }
    
    // Cancel and go back to opportunity
    public Pagereference goBack(){
        pagereference pg = new pagereference('/'+oppId);
        pg.setRedirect(true);
        return pg;
    }
}