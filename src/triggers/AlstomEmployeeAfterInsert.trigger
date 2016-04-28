trigger AlstomEmployeeAfterInsert on AlstomEmployee__c (after insert) {
     System.Debug('## >>> AlstomEmployee__c after insert <<< run by ' + UserInfo.getName());
      /****************************************************************************************
       
    *****************************************************************************************/
 	//get all Zlstom Employee id to link
 	Set<Id> alstomEmployeeIds = new Set<Id>();
 	//Used if contact active != person active field => email 
 	Set<Id> alstomEmployeeIdsActiveInAlstomChange = new Set<Id>();
 	
 	if(PAD.canTrigger('AP67'))
    {
    	for(AlstomEmployee__c alstomEmployee : Trigger.new) 
    	{
    		if (alstomEmployee.Status__c == 'Active') {	
    			alstomEmployeeIds.add(alstomEmployee.Id);
    		}
    	}
    	// Try to link all new person to a user
        if(alstomEmployeeIds.size()>0)
        {
            AP67User.linkAlstomEmployeeToUser(alstomEmployeeIds);
        }
           // AP67User.linkAlstomEmployeeToUser(Trigger.new);
        
    }
}