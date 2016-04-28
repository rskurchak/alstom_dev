trigger UserAfterInsert on User (after insert)
{
    System.debug('## >>> User after Insert <<< run by ' + UserInfo.getName());
    
    /* 12/06/2015 F.TAILLON : Error while creating users with Chatter External (Customer) invitations */
    /* User is created by a Salesforce Automated Process, which doesn't exists in the Database */
    /* Following query returns no row, and thus PAD Class is crashing */
    List<User> currentUser = [SELECT BypassAppexTriggers__c, UserRole.Name, Profile.Name, Profile.Id FROM User WHERE Id =:UserInfo.getUserId()];
    
    /********************************************************************
       AP04User - autfollow communication User 'wallCom' after creation 
    ********************************************************************/
    if (currentUser.size() > 0 && PAD.canTrigger('AP04')) {
        Set<Id> filteredUsers = new Set<Id>();
        for (User u : Trigger.new){
            if ( u.isActive && u.ContactId == null && !u.Profile_Name__c.contains('Chatter') ){
                filteredUsers.add(u.Id);
            }
        }

        if ( !filteredUsers.isEmpty() ){
            AP04User.autoFollow(filteredUsers);
        }
    }//bypass
    
    /**********************************************************************************************************************
        AP67User :  update the SalesforceUser__c value for the corresponding Alstom Employee record having the same Employee Number 
                    with the created user OR create a new Alstom Employee linked to the new user if no Alstom Employee was found
    ***********************************************************************************************************************/
    if (currentUser.size() > 0 && PAD.canTrigger('AP67'))
    {
        Set<Id> ap67UserIds = new Set<Id>();
        Set<Id> ap67CreatedBy= new Set<Id>();
        //Map<Id,Id> userIdToProfilId = new Map<Id,Id>();
        for(User user : Trigger.new) {
            ap67CreatedBy.add(user.createdbyid);
        }

        /*for(User u :[Select Id, ProfileId From User WHERE Id in :ap67CreatedBy])
        {
            userIdToProfilId.put(u.Id,u.ProfileId);
        }*/

        for(User user : Trigger.new) {
            System.debug('Test Insert of user ' + string.valueof(user.Id));

            //if(string.valueof(userIdToProfilId.get(user.createdbyid)) != Label.LBL0328)
            //{
            System.debug('Insert of user ' + string.valueof(user.Id));
            ap67UserIds.add(user.Id);
            //}
        }

        if(ap67UserIds.size() > 0)

            AP67User.linkUserToAlstomEmployee(ap67UserIds);
    }//bypass
    
    /********************************************************************
       AP69User - Synchronize Customer Portal User info to Contact
    ********************************************************************/
    if (currentUser.size() > 0 && PAD.canTrigger('AP69')) {
        List<User> customerPortalUsers = new List<User>();
        for (User user: Trigger.new) {
            if (user.ContactId != null) { // community user
                customerPortalUsers.add(user);
            }
        }
        if (customerPortalUsers.size() > 0) {
            AP69User.syncUserInfoToContact(customerPortalUsers);
        }
    } //bypass
           

    /********************************************************************
       UserServices - Assign Permission Sets based on Account Tile Assignment
    ********************************************************************/
    if (currentUser.size() > 0 && PAD.canTrigger('BW01')) {
        List<User> customerPortalUsers = new List<User>();
        for (User user: Trigger.new) {
            if (user.ContactId != null) { // community user
                customerPortalUsers.add(user);
            }
        }
        if ( !customerPortalUsers.isEmpty() ) {
            TileService service = new TileService();
            
            service.assignPermissionSets( customerPortalUsers );
        }
    } //bypass

    System.debug('## >>>  User after Insert : END <<<');
        
}