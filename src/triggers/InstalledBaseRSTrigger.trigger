trigger InstalledBaseRSTrigger on InstalledBaseRS__c (after insert, after update) {

	if(PAD.canTrigger('BW01')){
		SharingService service = new SharingService( new InstalledBasedRSMapper() );

		service.share( service.filter( Trigger.new, Trigger.oldMap ) );
	}

}