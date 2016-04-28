public class CaseMapper extends Mapper implements MapperInterface {

    final String OBJECT_API_NAME = 'Case';

    final String SHARE_OBJECT_API_NAME = 'CaseShare';

    final String SHARING_PARENT_FIELD = 'CaseId';

    private Map<String, Map<String, String>> fieldOption;

    public Map<String, Map<String, String>> getFieldOptions( ){
        if (fieldOption == null){
            fieldOption = SharingFieldOptionsServices.getFieldOptionsForObject( OBJECT_API_NAME );
        }
        return fieldOption;
    }

    private List<String> getCaseRowCause(){
        List<String> result = new List<String>();

        for ( Map<String, String> options : getFieldOptions().values() ){
            result.add( options.get( SharingFieldOptionsServices.RAW_CAUSE_FIELD ) );
        }

        return result;
    }

    public List<SObject> getSObjectsFromShare( List<Share> records ){
        List<SObject> resulsToReturn = new List<SObject>();
        for( Share share : records ){
            resulsToReturn.add( new CaseShare( UserOrGroupId = share.getUserId(),
                                               CaseId = share.getRecordId(),
                                               CaseAccessLevel = share.getAccessLevel(),
                                               Id = share.getShareId() ) );
        }
        return resulsToReturn;
    }

    protected override String getSharesQuery(List<Id> idsForQuery) {
        String whereString = ' Where ' + SHARING_PARENT_FIELD + ' IN ' + BluewolfDevUtils.flattenListForQuery( idsForQuery, true );
        whereString += ' AND RowCause IN ' + BluewolfDevUtils.flattenListForQuery( getCaseRowCause(), true );
        return whereString;
    }
    
    protected override Share wrapShare(SObject sharObj) {
        return new Share( (Id)(sharObj.get('CaseId')), 
                          (Id)(sharObj.get('UserOrGroupId')), 
                          (String)(sharObj.get('RowCause')), 
                          (String)(sharObj.get('CaseAccessLevel')), 
                          (Id)(sharObj.get('Id')) );
    }

    protected override String getSobjectAPIName() {
        return SHARE_OBJECT_API_NAME;
    }

}