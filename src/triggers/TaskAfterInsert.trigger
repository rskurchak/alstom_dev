trigger TaskAfterInsert on Task (after insert) {
	
    System.debug('## >>> Task after Insert <<< run by ' + UserInfo.getName());
    
    /**************************************************************************************************************
        AP67Tasks
        - 
    **************************************************************************************************************/
    if(PAD.canTrigger('AP67')) {
    	List<Task> ap67ActionPlans = new List<Task>();
		for(Task task : Trigger.new) {
			if (task.Type == 'Find Plan') {
				ap67ActionPlans.add(task);
			}
    	}
		if(ap67ActionPlans.size() > 0) {
    		AP67Tasks.checkFindPlanHasActionPlans(ap67ActionPlans);
		}
    }//bypass
    
    System.debug('## >>> Task after Insert : END <<<');
}