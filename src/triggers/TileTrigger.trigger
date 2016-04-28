trigger TileTrigger on Tile__c (before insert, before update, after insert) {
	if(PAD.canTrigger('BW01')){
		TileService service = new TileService();

		if(Trigger.isBefore){
			if(Trigger.isInsert || Trigger.isUpdate){
				if(!TileService.isReasigned){
					service.reassignOrders(Trigger.new);
				}
			}

			if( Trigger.isInsert ){
				service.setTranslatablePickListValues( Trigger.new );
			}
		}

		if( Trigger.isAfter ){
			if( Trigger.isInsert ){
				//service.updateTileNamesWithAppropriateLang( Trigger.newMap.keySet() );
			}
		}
	}
}