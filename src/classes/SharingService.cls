public class SharingService {
    MapperInterface activeMapper;
    Map<String, Map<String, String>> fieldOptions;
    Map<Id, Map<String,Id>> recordIdToAccountLookupToAccountId;

    public SharingService( MapperInterface mapper ){
        this.activeMapper = mapper;
        fieldOptions = activeMapper.getFieldOptions();
    }
    
    private Boolean isChanged(SObject obj, SObject oldObj, Set<String> fields) {
        if (oldObj == null) {
            return true;
        }
        
        for( String fieldName : fields ) {
            if (obj.get( fieldName ) != oldObj.get(fieldName)) {
                return true;
            }
        }
        
        return false;
    }

    public List<SObject> filter( List<SObject> newList, Map<Id, SObject> oldMap ){
        List<SObject> filteredRecords = new List<SObject>();
        oldMap = (oldMap == null ? new Map<Id, SObject>() : oldMap);

        //fieldOptions = activeMapper.getFieldOptions();
        Set<String> fields = fieldOptions.keySet();
        for( SObject sObj : newList ){
            if (isChanged(sObj, oldMap.get(sObj.Id), fields)) {
                filteredRecords.add( sObj );
            }            
        }
        return filteredRecords;
    }

    public void share( List<SObject> incomingRecords ){
        if( incomingRecords.isEmpty() ) return;

        Set<Share> sharesToProcess = getShares( incomingRecords, fieldOptions );

        processShares( sharesToProcess );
    }

    public Set<Share> getShares( List<SObject> incommingRecords, Map<String, Map<String, String>> fieldOptions ){
        Set<Id> accountIds = new Set<Id>();

        // Prepare maps to make references between different objects
        recordIdToAccountLookupToAccountId = getAccountsGropedByLookupNameAndRecords( incommingRecords, accountIds, fieldOptions );

        // Get all existing sharings for given records
        Set<Share> allSharingsForRecords = activeMapper.getExistingShares( new List<Id>(recordIdToAccountLookupToAccountId.keySet()) );

        // Prepearing Set of Share records that should be created
        allSharingsForRecords.addAll( getSharesToCreate( incommingRecords, getAccountIdToGroupIdMap( accountIds ) ) );

        return allSharingsForRecords;
    }

    public void shareBulletin( Id bulletinId ){
        if( bulletinId == null ) return;

        Set<Share> sharesToProcess = getSharesForBulletin( bulletinId );

        processShares( sharesToProcess );
    }

    public Set<Id> getAccountsForBulletinToSendNotification( String bulletinId ){
        Set<Id> accountsToReturn = ((BulletinMapper)activeMapper).getAllAccounts();

        for( Bulletin_Sent_Notification__c bsn : [ Select Id, Account__c From Bulletin_Sent_Notification__c Where Account__c IN : accountsToReturn And Bulletin__c = : bulletinId ] ){
            accountsToReturn.remove( bsn.Account__c );
        }

        return accountsToReturn;
    }

    public Set<Share> getSharesForBulletin( Id bulletinId ){
        BulletinMapper bm = (BulletinMapper)activeMapper;

        Map<String, Set<Id>> userOrGroupIdsMap = bm.getUserOrGroupIdsMap( bulletinId );

        //Set<Id> accountIds = bm.getParentAccountIdsForUsers( userOrGroupIdsMap.get( bm.USER_ID_KEY ) );
        Set<Id> accountIds = bm.getParentAccountIdsForGroups( userOrGroupIdsMap.get( bm.GROUP_ID_KEY ) );

        // Prepearing Set of Share records that should be created
        return bm.getSharesToCreate( bulletinId, getAccountIdToGroupIdMap( accountIds ) );
    }

    private Set<Share> getSharesToCreate( List<SObject> incommingRecords, Map<Id, Id> accountIdToGroupId ){
        Set<Share> allSharingsForRecords = new Set<Share>();

        for( SObject record : incommingRecords ){
            for( String fieldName : recordIdToAccountLookupToAccountId.get( record.Id ).keySet() ){
                Id userGroupId = accountIdToGroupId.get( (Id)(record.get( fieldName ) ) );
                if( userGroupId != null ) {
                    allSharingsForRecords.add( new Share( record.Id, 
                                                          userGroupId, 
                                                          fieldOptions.get( fieldName ).get( SharingFieldOptionsServices.RAW_CAUSE_FIELD ),
                                                          fieldOptions.get( fieldName ).get( SharingFieldOptionsServices.ACCESS_LEVEL_FIELD ),
                                                          null ) );   
                }
            }
        }

        return allSharingsForRecords;
    }

    // Prepare maps to make references between different objects
    private Map<Id, Map<String,Id>> getAccountsGropedByLookupNameAndRecords( List<SObject> incommingRecords, Set<Id> accountIds, Map<String, Map<String, String>> fieldOptions ){
        Map<Id, Map<String,Id>> recordIdToAccountLookupToAccountId = new Map<Id, Map<String,Id>>();

        for( SObject record : incommingRecords ){
            recordIdToAccountLookupToAccountId.put( record.Id, new Map<String,Id>() );
            for( String fieldName : fieldOptions.keySet() ){
                Id appropriateAccountId = (Id)(record.get( fieldName ));
                if( appropriateAccountId != null ){
                    recordIdToAccountLookupToAccountId.get( record.Id ).put( fieldName, appropriateAccountId );
                    accountIds.add( appropriateAccountId );
                }
            }
        }
        return recordIdToAccountLookupToAccountId;
    }

    public Map<Id, Id> getAccountIdToGroupIdMap( Set<Id> accountIds ){
        Map<Id, Id> accountIdToGroupId = new Map<Id, Id>();

        // Grouping of all users by accounts
        Map<Id, Id> accountIdToUserRoleId = new Map<Id, Id>();
        for( UserRole ur : [ Select Id, PortalAccountId From UserRole Where PortalType = 'CustomerPortal' AND PortalAccountId IN :accountIds ] ){
            accountIdToUserRoleId.put( ur.PortalAccountId, ur.Id );
        }

        Map<Id, Id> userRoleIdToGroupId = new Map<Id, Id>();
        for( Group gr : [ Select Id, RelatedId From Group Where RelatedId IN :accountIdToUserRoleId.values() ] ){
            userRoleIdToGroupId.put( gr.RelatedId, gr.Id );
        }

        for( Id accId : accountIdToUserRoleId.keySet() ){
            accountIdToGroupId.put( accId, userRoleIdToGroupId.get( accountIdToUserRoleId.get( accId ) ) );
        }

        return accountIdToGroupId;
    }

    private void processShares( Set<Share> sharesToProcess ){
        List<Share> sharesToInsert = new List<Share>();
        List<Share> sharesToDelete = new List<Share>();

        for( Share share : sharesToProcess ){
            if( share.isCreated() ){
                sharesToDelete.add( share );
            } else {
                sharesToInsert.add( share );
            }
        }

        doDML( sharesToDelete, true );
        doDML( sharesToInsert, false );
    }

    private void doDML( List<Share> shares, Boolean isDelete ){
        List<SObject> operationalRecords;
        if( !shares.isEmpty() ){
            try{
                operationalRecords = activeMapper.getSObjectsFromShare( shares );
                if( isDelete ){
                    delete operationalRecords;
                } else {
                    insert operationalRecords;
                }
            } catch( DMLException dmlEx ){
                for ( Integer i=0; i < dmlEx.getNumDml(); i++ ){
                        Share shareItem = shares[ dmlEx.getDmlIndex( i ) ];
                        Trigger.newMap.get( shareItem.getRecordId() ).addError( dmlEx.getMessage() );
                }
                return;
            }
        }
    }

}