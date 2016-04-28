trigger UserBeforeUpdate on User (before update) {
    System.debug('## >>> User before update <<< run by ' + UserInfo.getName());
    
    /********************************************************************
	   AP61User - Verify that Alstom Internal User uses always English Language.
    ********************************************************************/
    //for(User u : Trigger.new)
    //	u.addError('Error message for update User. User Language Incorrect for Alstom Internal User. ♥');
    List<User> errUsers = new List<User>();
    if(PAD.canTrigger('AP61'))
    {
    	
		for(User u : Trigger.new) {
			if(u.isActive && u.LanguageLocaleKey != Trigger.oldMap.get(u.Id).LanguageLocaleKey && u.ContactId == null && u.LanguageLocaleKey != 'en_US') {
				errUsers.add(u);
			}
		}
		if (errUsers.size() > 0) {
			AP61User.validateUserLanguage(errUsers);
		}		
    }//bypass 
    System.debug('## >>>  User before update : END <<<');
}