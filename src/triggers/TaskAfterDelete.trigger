trigger TaskAfterDelete on Task (after delete) {
	
    System.debug('## >>> Task after Delete <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP67Tasks
        - 
    **************************************************************************************************************/
    if(PAD.canTrigger('AP67')) {
    	List<Task> ap67ActionPlans = new List<Task>();
		for(Task task : Trigger.old) {
			if (task.Type == 'Find Plan') {
				ap67ActionPlans.add(task);
			}
    	}
		if(ap67ActionPlans.size() > 0) {
    		AP67Tasks.checkFindPlanHasActionPlans(ap67ActionPlans);
		}
    }//bypass
    
    System.debug('## >>> Task after Delete : END <<<');
}