trigger UserBeforeInsert on User (before insert) {
    System.debug('## >>> User before insert <<< run by ' + UserInfo.getName());
    
    /********************************************************************
       AP61User - Verify that Alstom Internal User uses always English Language.
    ********************************************************************/
    /* 12/06/2015 F.TAILLON : Error while creating users with Chatter External (Customer) invitations */
    /* User is created by a Salesforce Automated Process, which doesn't exists in the Database */
    /* Following query returns no row, and thus PAD Class is crashing */
    List<User> currentUser = [SELECT BypassAppexTriggers__c, UserRole.Name, Profile.Name, Profile.Id FROM User WHERE Id =:UserInfo.getUserId()];
    
    List<User> errUsers = new List<User>();
    if(currentUser.size() > 0 && PAD.canTrigger('AP61'))
    {
        for(User u : Trigger.new) {
            if(u.isActive && u.ContactId == null && u.LanguageLocaleKey != 'en_US') {
                errUsers.add(u);
            }
        }
        if (errUsers.size() > 0) {
            AP61User.validateUserLanguage(errUsers);
        }   

    }//bypass
    System.debug('## >>>  User before insert : END <<<');
}