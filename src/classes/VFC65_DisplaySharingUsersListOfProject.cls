/*
 VFC65_DisplaySharingUsersListOfProject apex controller
    ~ Author          : Christophe AVERSENG
    ~ Date Created    : 06/05/2014 - copied and adapted from VFC56
    ~ Description     : Displaying the sharing table in the Project page layout.
    ~ Feature Id      : FEAT#0611
*/
public with sharing class VFC65_DisplaySharingUsersListOfProject {
  // Contains current Project
    private Project__c project;
    // Contains Project Id
    public String projectId {set; get;}
  // Contains list of Project Team
    public List<Project__Share> projectTeam {set; get;}
    // Contains list of Users
    public List<User> users {set; get;}
    // Contains list of Roles
    public List<Group> roles {set; get;}
    // Contains label of Role
    public List<UserRole> labelRole {set; get;}
    // Contains type of sharing
    public Map<Id, String> typeShare {set; get;}
    // Contains reason of sharing
    public Map<Id, String> rowCause {set; get;}
    // The Map of role label and User Or Group Id
    public Map<Id, String> roleShare {set; get;}
    // The Map of role Id and User Or Group Id
    public Map<Id, String> roleIdShare {set; get;}
    // Check if sharing type equal Role or RoleAndSubordinates
    public Map<Id, Boolean> isRoleShare {set; get;}
    // Contains URL of User or Group record
    public Map<Id, String> urlShare {set; get;}
  // Contains Name of User or Group
    public Map<Id, String> userOrGroupName {set; get;}

    public VFC65_DisplaySharingUsersListOfProject(ApexPages.StandardController controller) {
      // Getting current Project record
        this.project = (Project__c)controller.getRecord();
        projectId = this.project.Id;
        
        // Getting needed informations for Project Team
        projectTeam = [Select t.UserOrGroupId, t.RowCause, t.AccessLevel From Project__Share t where t.ParentId = :this.project.Id];
        typeShare = new Map<Id, String>();
        roleShare = new Map<Id, String>();
        roleIdShare = new Map<Id, String>();
        isRoleShare = new Map<Id, Boolean>();
        rowCause = new Map<Id, String>();
        urlShare = new Map<Id, String>();
        userOrGroupName = new Map<Id, String>();
        
        if(projectTeam.size() > 0) {
            for(Project__Share ts : projectTeam) {
              // Getting needed informations for Group
              roles = [Select Type, Name, DeveloperName From Group where Id =: ts.UserOrGroupId];
              users = [Select Name From User where Id =: ts.UserOrGroupId];
              
              // If type equal Role or RoleAndSubordinates
              if(roles.size() > 0) {
                  if (roles[0].Type != 'Regular') {
                    // Getting needed informations for User Role
                  labelRole = [Select Id, Name, DeveloperName From UserRole where DeveloperName =: String.valueOf(roles[0].DeveloperName)];
                  roleShare.put(ts.UserOrGroupId,labelRole[0].Name);
                  roleIdShare.put(ts.UserOrGroupId,labelRole[0].Id);
                  isRoleShare.put(ts.UserOrGroupId,true);
                       typeShare.put(ts.UserOrGroupId, roles[0].Type);
                       userOrGroupName.put(ts.UserOrGroupId,'');
                       urlShare.put(ts.UserOrGroupId,'');
                  }
                    else {
                      typeShare.put(ts.UserOrGroupId, 'Public Group');
                  isRoleShare.put(ts.UserOrGroupId,false);
                  userOrGroupName.put(ts.UserOrGroupId,roles[0].Name);
                  urlShare.put(ts.UserOrGroupId,'/setup/own/groupdetail.jsp?id='+ts.UserOrGroupId);
                    }
              }
              
              // If type equal User
                else if(String.valueOf(ts.UserOrGroupId).substring(0, 3) == '005') {
                    typeShare.put(ts.UserOrGroupId, 'User');
                    isRoleShare.put(ts.UserOrGroupId,false);
                    roleShare.put(ts.UserOrGroupId,'');
                    roleIdShare.put(ts.UserOrGroupId,null);
                    userOrGroupName.put(ts.UserOrGroupId,users[0].Name);
                    urlShare.put(ts.UserOrGroupId,'/_ui/core/userprofile/UserProfilePage?u='+ts.UserOrGroupId+'&tab=sfdc.ProfilePlatformFeed');
                }
                
                // If type equal Group
                else {
          typeShare.put(ts.UserOrGroupId, 'Public Group');
          isRoleShare.put(ts.UserOrGroupId,false);
          roleShare.put(ts.UserOrGroupId,'');
          roleIdShare.put(ts.UserOrGroupId,null);
          userOrGroupName.put(ts.UserOrGroupId,roles[0].Name);
          urlShare.put(ts.UserOrGroupId,'/setup/own/groupdetail.jsp?id='+ts.UserOrGroupId);
                }
            }
        }
    }
    
  public String projectTeamURL()
   
  {
    return '/p/share/CustomObjectSharingDetail?parentId='+projectId;
  }
}