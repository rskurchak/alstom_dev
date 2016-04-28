trigger TaskAfterUpdate on Task (after update) {
	
    System.debug('## >>> Task after Update <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP67Tasks
        - 
    **************************************************************************************************************/
    if(PAD.canTrigger('AP67')) {
    	List<Task> ap67ActionPlans = new List<Task>();
		for(Task task : Trigger.new) {
			if (task.Type == 'Find Plan') {
				// in case of Task attached to another Opportunity,
				//  the new and old Find Plans should both be updated
				if (task.WhatId != Trigger.oldMap.get(task.Id).WhatId) {
					ap67ActionPlans.add(task); // Action Plan with new Opportunity Id
					ap67ActionPlans.add(Trigger.oldMap.get(task.Id)); // Action Plan with old Opportunity Id
				}
			}
    	}
		if(ap67ActionPlans.size() > 0) {
    		AP67Tasks.checkFindPlanHasActionPlans(ap67ActionPlans);
		}
    }//bypass
    
    System.debug('## >>> Task after Update : END <<<');
}