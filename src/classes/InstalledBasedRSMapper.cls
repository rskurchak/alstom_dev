public class InstalledBasedRSMapper extends Mapper implements MapperInterface {

	final String OBJECT_API_NAME = 'InstalledBaseRS__c';
	final String SHARE_OBJECT_API_NAME = 'InstalledBaseRS__Share';
	final String SHARING_PARENT_FIELD = 'ParentId';

	public Map<String, Map<String, String>> getFieldOptions( ){
		return SharingFieldOptionsServices.getFieldOptionsForObject( OBJECT_API_NAME );
	}

	public List<SObject> getSObjectsFromShare( List<Share> records ){
		List<SObject> resulsToReturn = new List<SObject>();
		for( Share share : records ){
			resulsToReturn.add( new InstalledBaseRS__Share( UserOrGroupId = share.getUserId(),
															ParentId = share.getRecordId(),
															AccessLevel = share.getAccessLevel(),
															RowCause = share.getRowCause(),
															Id = share.getShareId() ) );
		}
		return resulsToReturn;
	}
    
    protected override String getSharesQuery(List<Id> idsForQuery) {
        return ' Where ' + SHARING_PARENT_FIELD + ' IN ' + BluewolfDevUtils.flattenListForQuery( idsForQuery, true );
    }
    
    protected override Share wrapShare(SObject sharObj) {
        return new Share( (Id)(sharObj.get('ParentId')), 
                          (Id)(sharObj.get('UserOrGroupId')), 
                          (String)(sharObj.get('RowCause')), 
                          (String)(sharObj.get('AccessLevel')), 
                          (Id)(sharObj.get('Id')) );
    }

    protected override String getSobjectAPIName() {
        return SHARE_OBJECT_API_NAME;
    }
}