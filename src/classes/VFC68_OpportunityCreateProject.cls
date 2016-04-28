/*
 VFC68_OpportunityCreateProject apex controller
    ~ Author          : Christophe AVERSENG
    ~ Date Created    : 06/05/2014
    ~ Description     : "Create Project" or "Go to Project List" link
    ~ Feature Id      : FEAT#0612
*/
public with sharing class VFC68_OpportunityCreateProject {
    private Opportunity opportunity;
    private Boolean bHasCreateProjectPermission;
    private List<ObjectPermissions> prjPermissions;
    // Indicates the "Create Project" button can be rendered
    public Boolean IsRenderCreateButton{get;set;}
    // Indicates the "Go to Project List" URL can be rendered
    public Boolean IsRenderProjectList{get;set;}
    
    public VFC68_OpportunityCreateProject(ApexPages.StandardController controller) {
        // Getting current record of Opportunity
        this.opportunity = (Opportunity)controller.getRecord();
        IsRenderProjectList = false;
        IsRenderCreateButton = false;
        if(this.opportunity != null) {
            // Projects related to this opportunity ?
            List<Project__c> projects = new List<Project__c>();
            projects = [Select Id from Project__c where Opportunity__c =: this.opportunity.Id];
            if (projects.size() > 0)
                IsRenderProjectList = true;
            else {
                // Other conditions to render the Create Project button
                // Testing against 'Contract Signed'
                if (opportunity.StageName == System.Label.LBL0136) {
                    // Create permission on Project object?
                    // Note: if the Create permission is brought to the user by an additional Permission Set on top of Profile, the following won't work
                    prjPermissions = [SELECT PermissionsCreate FROM ObjectPermissions WHERE parentid in (SELECT id FROM PermissionSet WHERE PermissionSet.Profile.Id =: UserInfo.GetProfileId())];
                    bHasCreateProjectPermission = prjPermissions.get(0).PermissionsCreate;
                    if (bHasCreateProjectPermission == true)
                        IsRenderCreateButton = true;
                }
            }
        }
    }    
}