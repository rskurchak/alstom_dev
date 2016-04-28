trigger UserAfterUpdate on User (after update) {
	
    System.debug('## >>> User after Update <<< run by ' + UserInfo.getName());
    
    /**********************************************************************************************************************
        AP67User :  update the SalesforceUser__c value for the corresponding Alstom Employee record having the same Employee Number 
                    with the created user OR create a new Alstom Employee linked to the new user if no Alstom Employee was found
    ***********************************************************************************************************************/
    if(PAD.canTrigger('AP67'))
    {
        Set<Id> ap67UserIds = new Set<Id>();
        for(User user : Trigger.new) {
                if(user.EmployeeNumber != trigger.oldMap.get(user.id).EmployeeNumber)
                {
                    ap67UserIds.add(user.Id);
                }
                
        }
        if(ap67UserIds.size() > 0)
            AP67User.linkUserToAlstomEmployee(ap67UserIds);
    }//bypass

    /********************************************************************
	   AP69User - Synchronize Customer Portal User info to Contact
    ********************************************************************/
    if (PAD.canTrigger('AP69')) {
    	List<User> customerPortalUsers = new List<User>();
		for (User user: Trigger.new) {
			if ((user.ContactId != null)  // community user
				&& (user.Title != Trigger.oldMap.get(user.Id).Title  // customer key info changed
					|| user.FirstName != Trigger.oldMap.get(user.Id).FirstName
					|| user.LastName != Trigger.oldMap.get(user.Id).LastName
					|| user.Email != Trigger.oldMap.get(user.Id).Email
					|| user.Phone != Trigger.oldMap.get(user.Id).Phone
					|| user.MobilePhone != Trigger.oldMap.get(user.Id).MobilePhone)
			) {
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
    if ( PAD.canTrigger('BW01') ) {
        List<User> customerPortalUsers = new List<User>();
        for (User user: Trigger.new) {
            if (user.ContactId != null && user.ProfileId != Trigger.oldMap.get(user.Id).ProfileId ) { // community user with changed Profile
                customerPortalUsers.add(user);
            }
        }
        if ( !customerPortalUsers.isEmpty() ) {
            TileService service = new TileService();
            
            service.assignPermissionSets( customerPortalUsers );
        }
    } //bypass

	System.debug('## >>>  User after Update : END <<<');
	
}