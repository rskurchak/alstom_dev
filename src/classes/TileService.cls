public class TileService {

	static public final String TILE_PERMISSION_SET_BULLETINS = 'Bulletins';
	static public final String TILE_PERMISSION_SET_REQUESTS = 'Requests';
	static public final String CODE_INSERT = 'insert';
	static public final String CODE_DELETE = 'delete';
	static public Boolean isReasigned = false;

	public Map<Id, Set<Id>> accountToUserIds = new Map<Id, Set<Id>>();

	private Map<String, Id> getPermissionSetIdsByName( Set<String> perSetNames ){
		Map<String, Id> permionSets = new Map<String, Id>();
        for(PermissionSet ps: [SELECT Id, Label, Name FROM PermissionSet WHERE Label IN :perSetNames ]){
        	permionSets.put( ps.Label, ps.Id );
        }
        return permionSets;
	}

	private Map<String, Set<Id>> preparePermissionSetToUserListMap( List<TileAssignment__c> assigments ){
		Map<String, Set<Id>> mapPermissionSetLabelToUserId = new Map<String, Set<Id>>();		
		for(TileAssignment__c ta: assigments){
			if( ta.PermissionSet__c != null ){
				accountToUserIds.put( ta.Account__c, new Set<Id>() );
				mapPermissionSetLabelToUserId.put(ta.PermissionSet__c, new Set<Id>());
			}
		}

        //Populate map of accounts to users
        Set<Id> userIds = new Set<Id>();
		for( User u : [ SELECT Id, Name, Contact.AccountId FROM User 
        				WHERE IsActive = true AND ContactId IN ( SELECT Id FROM Contact WHERE AccountId IN :accountToUserIds.keySet() ) ] ){
			accountToUserIds.get( u.Contact.AccountId ).add( u.Id );
			userIds.add(u.Id);
		}

		//Create filter for existing records
		for(PermissionSetAssignment psa: [ SELECT Id, PermissionSetId, PermissionSet.Label, AssigneeId FROM PermissionSetAssignment
										   WHERE PermissionSet.Label IN :mapPermissionSetLabelToUserId.keySet() 
										   AND AssigneeId IN :userIds ]){
			mapPermissionSetLabelToUserId.get(psa.PermissionSet.Label).add( psa.AssigneeId );
		}

		return mapPermissionSetLabelToUserId;
	}

	private List<PermissionSetAssignment> createPermissionSetAssignment( List<TileAssignment__c> assigments, 
																		 Map<String, Set<Id>> mapPermissionSetLabelToUserId,
																		 Map<String, Id> permionSetIds ){
		List<PermissionSetAssignment> permissionSetAssignmentsToInsert = new List<PermissionSetAssignment>();

		for( TileAssignment__c ta : assigments ){
			if( ta.PermissionSet__c != null ){
				Set<Id> filterUserIds = mapPermissionSetLabelToUserId.get( ta.PermissionSet__c );

				permissionSetAssignmentsToInsert.addAll( 
					createPermSetAssignmentForAccount( permionSetIds.get( ta.PermissionSet__c ), ta.Account__c, filterUserIds ) 
				);
			}
		}
		return permissionSetAssignmentsToInsert;
	}

	private List<PermissionSetAssignment> preparePermissionSetAssignmentsToDelete( List<TileAssignment__c> assigments ){
		List<PermissionSetAssignment> psaToDelete = new List<PermissionSetAssignment>();

		Map<String, Set<Id>> mapPermissionSetLabelToAccountId = new Map<String, Set<Id>>();
		Map<Id, Set<Id>> accountIdToUserIdSet = new Map<Id, Set<Id>>();
		for( TileAssignment__c ta: assigments ){
			if( ta.PermissionSet__c != null ){
				accountIdToUserIdSet.put( ta.Account__c, new Set<Id>() );
				if( !mapPermissionSetLabelToAccountId.containsKey( ta.PermissionSet__c ) ){
					mapPermissionSetLabelToAccountId.put( ta.PermissionSet__c, new Set<Id>() );
				}
				mapPermissionSetLabelToAccountId.get( ta.PermissionSet__c).add( ta.Account__c );
			}
		}

        //Populate map of accounts to users
        Set<Id> userIds = new Set<Id>();
		for( User u : [ SELECT Id, Name, Contact.AccountId FROM User 
        				WHERE IsActive = true AND ContactId IN ( SELECT Id FROM Contact WHERE AccountId IN :accountIdToUserIdSet.keySet() ) ] ){
			accountIdToUserIdSet.get( u.Contact.AccountId ).add( u.Id );
			userIds.add(u.Id);
		}


		//Create filter for existing records
		for( PermissionSetAssignment psa: [ SELECT Id, PermissionSetId, PermissionSet.Label, AssigneeId FROM PermissionSetAssignment
								    	  	WHERE PermissionSet.Label IN :mapPermissionSetLabelToAccountId.keySet() AND 
								    	  		  AssigneeId IN :userIds ] ){
			for( Id accId : mapPermissionSetLabelToAccountId.get( psa.PermissionSet.Label ) ){
				if( accountIdToUserIdSet.get( accId ).contains( psa.AssigneeId ) ){
					psaToDelete.add( psa );
				}
			}
		}

		return psaToDelete;

	}

	private List<PermissionSetAssignment> createPermSetAssignmentForAccount( Id permissionSetId, Id accountId, Set<Id> filterUserIds ) {
		List<PermissionSetAssignment> permissionSetAssignmentsToInsert = new List<PermissionSetAssignment>();

		for( Id uId : accountToUserIds.get( accountId ) ){
			if( !filterUserIds.contains( uId ) ){
				permissionSetAssignmentsToInsert.add( new PermissionSetAssignment( PermissionSetId = permissionSetId, AssigneeId = uId ) );
				filterUserIds.add(uId);
			}
		}
		return permissionSetAssignmentsToInsert;
	}


	public void revoke( List<TileAssignment__c> assigments ){
		List<PermissionSetAssignment> permissionSetAssignmentsToRemove = preparePermissionSetAssignmentsToDelete( assigments );

		//Delete new PermissionSetAssignments records
		if(!permissionSetAssignmentsToRemove.isEmpty()){
			//Delete should be performed in @future function as PermissionSetAssignment object is setup object
			processPermissionSetAssignments( JSON.serialize( permissionSetAssignmentsToRemove ), false );
		}
	}

	public void assign( List<TileAssignment__c> assigments ){		
		// Prepare map to link Permission Sets with group of users that belongs to
		Map<String, Set<Id>> mapPermissionSetLabelToUserId = preparePermissionSetToUserListMap( assigments );
		
		//Select PermisionSet objects by names
        Map<String, Id> permionSetIds = getPermissionSetIdsByName( mapPermissionSetLabelToUserId.keySet() ); 

		//Create new assigment records
		List<PermissionSetAssignment> perSetAssignmentsToInsert = createPermissionSetAssignment( assigments, mapPermissionSetLabelToUserId, permionSetIds );
System.debug(LoggingLevel.ERROR, '@@@ perSetAssignmentsToInsert '+ perSetAssignmentsToInsert);
		//Insert new PermissionSetAssignments records
		if( !perSetAssignmentsToInsert.isEmpty() ){
			//Insert should be performed in @future function as PermissionSetAssignment object is setup object
			TileService.processPermissionSetAssignments( JSON.serialize( perSetAssignmentsToInsert ), true );
		}
	}

	@future 
	public static void processPermissionSetAssignments( String perSetAssgsString, Boolean isInsert ){
		processPermissionSetAssignment( perSetAssgsString, isInsert );
	}

	public static void processPermissionSetAssignment( String perSetAssgsString, Boolean isInsert ){
		List<PermissionSetAssignment> perSetAssgs = (List<PermissionSetAssignment>)JSON.deserialize(perSetAssgsString, List<PermissionSetAssignment>.class);

		Database.SaveResult[] saveResultList;
		Database.DeleteResult[] deleteResultList;

		if( isInsert ){
			saveResultList = Database.insert(perSetAssgs, false);
		} else {
			deleteResultList = Database.delete(perSetAssgs, false);
		}

		List<PermissionSetAssignment> perSetAssgsWithErrors = new List<PermissionSetAssignment>();
		List<String> errorList = new List<String>();
		for (Integer i = 0; i < perSetAssgs.size(); i++){
			if( isInsert ){
				if ( !saveResultList[i].isSuccess() ){
					perSetAssgsWithErrors.add( perSetAssgs[i] );
					errorList.add( saveResultList[i].getErrors()[0].getMessage() );
				}
			} else {
				if ( !deleteResultList[i].isSuccess() ){
					perSetAssgsWithErrors.add( perSetAssgs[i] );
					errorList.add( deleteResultList[i].getErrors()[0].getMessage() );
				}
			}
		}
		if ( !perSetAssgsWithErrors.isEmpty() ){
			sendEmailErrors( perSetAssgsWithErrors, errorList );
		}
	}

    public static void sendEmailErrors(List<PermissionSetAssignment> perSetAssgs, List<String> saveResultList){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses( CustomMetadataServices.getNotificationRecipients( CustomMetadataServices.PERMISSION_SET_ASSIGNMENT_EXCEPTION ).split(',') );
        mail.setReplyTo('noreply@salesforce.com');
        mail.setSenderDisplayName('PermissionSetAssignments Processing');
        mail.setSubject('PermissionSetAssignments - Error');
        
        String body = 'Error on processing PermissionSetAssignment records:<br/><br/>';
		for ( Integer i = 0; i < saveResultList.size(); i++ ){
            body += '<br/>Record - PermissionSetId: ' + perSetAssgs[i].PermissionSetId + ' AssigneeId: ' + perSetAssgs[i].AssigneeId;
            body += '<br/>Message: ' + saveResultList[i];
        }
        mail.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });		
	}

 	public static List<Tile__c> getTilesByUserId( Id userId ){
		List<Tile__c> results = new List<Tile__c>();
		Set<Id> accountIds = new Set<Id>();
		for( User u : [ Select Contact.AccountId From User Where Id = :userId ] ){
			if( u.Contact.AccountId != null ){
				accountIds.add( u.Contact.AccountId );	
			}
		}
		if( !accountIds.isEmpty() ){
			results = [ Select Id, Name, Image__c, Url__c, 	OpenInNewWindow__c, toLabel(Hidden_Tile_Name__c) From Tile__c Where Id IN ( Select Tile__c From TileAssignment__c Where Account__c IN :accountIds ) ORDER BY Order__c];
		}
		return results;
	}
	
	public static List<Tile__c> getTiles(User u){
		return [SELECT Id, Image__c, Url__c, PermissionSet__c, toLabel(Hidden_Tile_Name__c) FROM Tile__c WHERE Id IN 
			(SELECT Tile__c FROM TileAssignment__c WHERE Account__c = :u.Contact.AccountId) ORDER BY Order__c];
	}

	public void reassignOrders(List<Tile__c> tiles){
		Map<Id, Tile__c> tilesToUpsert = new Map<Id, Tile__c>();
		Integer lastOrder = 0, shift = 0;
		isReasigned = true;

		Map<Id, Tile__c> mapTilesToProcess = new Map<Id, Tile__c>();
		Map<Integer, Tile__c> mapOrderToTile = new Map<Integer, Tile__c>();
		for(Tile__c t: tiles){
			//prepare map order to input tiles
			mapOrderToTile.put(Integer.valueof(t.Order__c), t);
			//prepare map id to input tiles
			mapTilesToProcess.put(t.Id, t);
		}

		//Select All tiles and shift them right if filed order match with inserted or updated tiles
		for( Tile__c t: [SELECT Id, Name, Order__c FROM Tile__c ORDER BY Order__c ]){
			//Check if need shift tile right by one
			if( mapOrderToTile.containsKey(Integer.valueof(t.Order__c)) ){
				shift++;
				lastOrder = Integer.valueof(t.Order__c);
			}
			//change order field if tile need shift and tile isn`t in processing tiles	
			if(shift > 0 && !mapTilesToProcess.containsKey(t.Id)){
				//chech if is avaliable order
				if(t.Order__c - lastOrder > shift){
					shift = 0;
					continue;
				}
				lastOrder = Integer.valueof(t.Order__c);
				t.Order__c += shift;
				//put tile to processing list 
				tilesToUpsert.put(t.Id, t);
			}
		}

		//save changed tiles
        try{
            if( !tilesToUpsert.isEmpty() ){
                upsert tilesToUpsert.values();
            }
        } catch( DMLException dmlEx ){
            for ( Integer i=0; i < dmlEx.getNumDml(); i++ ){
                    Tile__c tileErr = tilesToUpsert.values()[ dmlEx.getDmlIndex( i ) ];
                    Trigger.new[0].addError( dmlEx.getMessage() );
            }
        }
	}

	private Map<Id, Set<Id>> groupUsersByAccount( List<User> communityUsers ){
		Map<Id, Set<Id>> accountToUserIdsMap = new Map<Id, Set<Id>>();
		for( User u : communityUsers ){
			if( u.AccountId__c != null ){
				if( !accountToUserIdsMap.containsKey( u.AccountId__c ) ){
					accountToUserIdsMap.put( u.AccountId__c, new Set<Id>() );
				}
				accountToUserIdsMap.get( u.AccountId__c ).add( u.Id );
			}
		}
		return accountToUserIdsMap;
	}

	public void assignPermissionSets( List<User> communityUsers ){
		List<PermissionSetAssignment> permissionSetAssignmentsToInsert = new List<PermissionSetAssignment>();
		Set<String> perSetNames = new Set<String>();
		Map<Id, Set<String>> accountIdToPermSetName = new Map<Id, Set<String>>();

		accountToUserIds = groupUsersByAccount( communityUsers );
		System.debug('@@@@@@@@@  accountToUserIds = '+ accountToUserIds);

		for( Account acc : [ Select Id, ( Select Id, PermissionSet__c From TileAssignments__r) From Account Where Id IN :accountToUserIds.keySet() ] ){
			accountIdToPermSetName.put( acc.Id, new Set<String>() );
			for( TileAssignment__c ta : acc.TileAssignments__r ){
				accountIdToPermSetName.get( acc.Id ).add( ta.PermissionSet__c );
				perSetNames.add( ta.PermissionSet__c );
			}
		}

		System.debug('@@@@@@@@@  accountIdToPermSetName = '+ accountIdToPermSetName);
		System.debug('@@@@@@@@@  perSetNames = '+ perSetNames);

		Map<String, Id> permionSetIds = getPermissionSetIdsByName( perSetNames );
		System.debug('@@@@@@@@@  permionSetIds = '+ permionSetIds);

		for( Id accId : accountIdToPermSetName.keySet() ){
			for( String permissionSetName : accountIdToPermSetName.get( accId ) ){
				permissionSetAssignmentsToInsert.addAll( 
					createPermSetAssignmentForAccount( permionSetIds.get( permissionSetName ), accId, new Set<Id>() ) 
				);
			}
		}
		System.debug('@@@@@@@@@  permissionSetAssignmentsToInsert = '+ permissionSetAssignmentsToInsert);
		//Insert new PermissionSetAssignments records
		if( !permissionSetAssignmentsToInsert.isEmpty() ){
			//Insert should be performed in @future function as PermissionSetAssignment object is setup object
			if ( !System.isBatch() ){
				TileService.processPermissionSetAssignments( JSON.serialize( permissionSetAssignmentsToInsert ), true );
			} else {
				TileService.processPermissionSetAssignment( JSON.serialize( permissionSetAssignmentsToInsert ), true );
			}
		}
	}

	public void setTranslatablePickListValues( List<Tile__c> newList ){
		for( Tile__c t : newList ){
			t.Hidden_Tile_Name__c = t.Name;
		}
	}

	public void updateTileNamesWithAppropriateLang( Set<Id> tileIds ){
		List<Tile__c> tList = new List<Tile__c>();
		for( Tile__c t : [Select Id, toLabel(Hidden_Tile_Name__c) From Tile__c Where Id IN :tileIds ] ){
			tList.add(new Tile__c( Id = t.Id, Name = t.Hidden_Tile_Name__c));
		}
		update tList;
	}


}