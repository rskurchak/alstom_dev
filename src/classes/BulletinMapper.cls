public class BulletinMapper implements MapperInterface {
	final String OBJECT_API_NAME = 'Bulletin__c';
	final String SHARE_OBJECT_API_NAME = 'Bulletin__Share';

	final String BULLETIN_CAUSE_OWNER = 'Owner';
    final String SHARING_PARENT_FIELD = 'ParentId';

    public final String USER_ID_KEY = 'UserId';
    public final String GROUP_ID_KEY = 'GroupId';

    final Set<String> CASE_ROW_OWNERS = new Set<String>{ BULLETIN_CAUSE_OWNER };

    Set<Id> allAccounts = new Set<Id>();

    final Map<String, String> SHARE_FIELD_OPTIONS = new Map<String, String>{ 
    								SharingFieldOptionsServices.ACCESS_LEVEL_FIELD => SharingFieldOptionsServices.ACCESS_LEVEL_VALUE_READ,
    								SharingFieldOptionsServices.RAW_CAUSE_FIELD => SharingFieldOptionsServices.CAUSE_VALUE_GLOBAL_ACCOUNT };


    public Map<String, Map<String, String>> getFieldOptions( ){
    	return new Map<String, Map<String, String>>();
    }

    public Set<Id> getAllAccounts(){
    	return allAccounts;
    }

    public List<SObject> getSObjectsFromShare( List<Share> records ){
        List<SObject> resulsToReturn = new List<SObject>();
        for( Share share : records ){
            resulsToReturn.add( new Bulletin__Share( UserOrGroupId = share.getUserId(),
                                               		 ParentId = share.getRecordId(),
                                               		 AccessLevel = share.getAccessLevel(),
                                               		 RowCause = share.getRowCause() ) );
        }
        return resulsToReturn;
    }

    public Map<String, Set<Id>> getUserOrGroupIdsMap( Id recordId ){
    	Map<String, Set<Id>> userOrGroupIdsMap = new Map<String, Set<Id>>();

        for( Bulletin__Share bShare : [ Select Id, ParentId, UserOrGroupId From Bulletin__Share Where ParentId = :recordId ] ){
            if( bShare.UserOrGroupId.getSobjectType() == Schema.User.SObjectType ){
            	if( !userOrGroupIdsMap.containsKey( USER_ID_KEY ) ){
            		userOrGroupIdsMap.put( USER_ID_KEY, new Set<Id>() );
            	}
                userOrGroupIdsMap.get( USER_ID_KEY ).add( bShare.UserOrGroupId );
            } else if( bShare.UserOrGroupId.getSobjectType() == Schema.Group.SObjectType ){
            	if( !userOrGroupIdsMap.containsKey( GROUP_ID_KEY ) ){
            		userOrGroupIdsMap.put( GROUP_ID_KEY, new Set<Id>() );
            	}
                userOrGroupIdsMap.get( GROUP_ID_KEY ).add( bShare.UserOrGroupId );
            }
        }
        System.debug('@@@@@@@@ userOrGroupIdsMap = ' + userOrGroupIdsMap);

        return userOrGroupIdsMap;
    }

    public Set<Id> getParentAccountIdsForUsers( Set<Id> userIds ){
    	Set<Id> accountIds = new Set<Id>();
    	
    	if( !userIds.isEmpty() ){
	        for( Contact c : [ Select Id, Account.ParentId From Contact Where Id IN ( Select ContactId From User Where Id IN :userIds ) ] ){
	            if( c.Account.ParentId != null ){
	                accountIds.add( c.Account.ParentId );
	            }
	        }    		
    	}
    	allAccounts.addAll(accountIds);

        return accountIds;
    }

    public Set<Id> getParentAccountIdsForGroups( Set<Id> groupIds ){
    	Set<Id> accountIds = new Set<Id>();
    	Set<Id> parrentAccountIds = new Set<Id>();
		Set<Id> userRoleIds = new Set<Id>();

        for( Group gr : [ Select Id, RelatedId From Group Where Id IN :groupIds ] ){
            userRoleIds.add( gr.RelatedId );
        }
        for( UserRole ur : [ Select Id, PortalAccountId From UserRole Where Id IN :userRoleIds ] ){
            accountIds.add( ur.PortalAccountId );
        }
        allAccounts.addAll(accountIds);
        for( Account acc : [ Select Id, ParentId From Account Where Id IN :accountIds ] ){
        	if( acc.ParentId != null ){
        		parrentAccountIds.add( acc.ParentId );
        	}
        }
        allAccounts.addAll(parrentAccountIds);
    	return parrentAccountIds;
    }

    public Set<Share> getSharesToCreate( Id recordId, Map<Id, Id> accountIdToGroupId ){
        Set<Share> allSharingsForRecords = new Set<Share>();

        for( Id groupId : accountIdToGroupId.values() ){
            allSharingsForRecords.add( new Share( recordId, 
                                                  groupId, 
                                                  SHARE_FIELD_OPTIONS.get( SharingFieldOptionsServices.RAW_CAUSE_FIELD ),
                                                  SHARE_FIELD_OPTIONS.get( SharingFieldOptionsServices.ACCESS_LEVEL_FIELD ),
                                                  null ) );
        }
        return allSharingsForRecords;
    }

 	public Set<Share> getExistingShares( List<Id> idsForQuery ){
 		return new Set<Share>();
 	}

}