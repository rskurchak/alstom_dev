trigger CaseTrigger on Case (after insert, after update) {
	if(PAD.canTrigger('BW01')){
		SharingService service = new SharingService( new CaseMapper() );

		service.share( service.filter( Trigger.new, Trigger.oldMap ) );
	}
}