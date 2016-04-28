trigger TileAssignmentTrigger on TileAssignment__c (before insert, after insert, after delete) {
	
	if(PAD.canTrigger('BW01')){
		TileService service = new TileService();

		if(Trigger.isAfter){
			if(Trigger.isInsert){
				service.assign(Trigger.new);
			}			

			if(Trigger.isDelete){
				service.revoke( Trigger.old );
			}
		}
	}
}