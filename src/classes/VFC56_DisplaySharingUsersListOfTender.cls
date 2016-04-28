/*********************************************************************
 SANITY CHECK Feb. 2014 - CODE MODIFICATION REQUIRED
 Modify code following instructions below.
 Remove this box once modifications done.
*********************************************************************/

/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   Error is displayed when Tender sharing includes 'All Internal user' group.
   Error should be traced in debug logs.
 Remove this box once modification done.
*********************************************************************/

/*
 VFC56_DisplaySharingUsersListOfTender apex controller
    ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
    ~ Date Created    : 14/11/2013 
    ~ Description     : Displaying the sharing table in the Tender page layout.
    ~ Feature Id      : FEAT#0489 
*/
public with sharing class VFC56_DisplaySharingUsersListOfTender {
    // Contains current Tender
    private Tender__c tender;
    // Contains Tender Id
    public String tenderId {set; get;}
    // Contains list of Tender Team
    public List<Tender__Share> tenderTeam {set; get;}
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

    public VFC56_DisplaySharingUsersListOfTender(ApexPages.StandardController controller) {
        // Getting current Tender record
        this.tender = (Tender__c)controller.getRecord();
        tenderId = this.tender.Id;
        
        // Getting needed informations for Tender Team
        tenderTeam = [Select t.UserOrGroupId, t.RowCause, t.AccessLevel From Tender__Share t where t.ParentId = :this.tender.Id];
        typeShare = new Map<Id, String>();
        roleShare = new Map<Id, String>();
        roleIdShare = new Map<Id, String>();
        isRoleShare = new Map<Id, Boolean>();
        rowCause = new Map<Id, String>();
        urlShare = new Map<Id, String>();
        userOrGroupName = new Map<Id, String>();
        
        if(tenderTeam.size() > 0) {
            for(Tender__Share ts : tenderTeam) {
                // Getting needed informations for Group
/*********************************************************************
 SANITY CHECK INSTRUCTION: 
   SOQL Queries inside "for" loop => to bulkify (2 queries/tender share
   -> will break after 49 manual sharings)
   Error if too many entries are added (Too many SOQL queries: 101).
 Remove this box once modification done.
*********************************************************************/
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
    
    public String tenderTeamURL()
     
    {
        return '/p/share/CustomObjectSharingDetail?parentId='+tenderId;
    }
}