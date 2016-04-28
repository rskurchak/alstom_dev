/*
//this class is for test needs only
*/
public class MockMapper extends Mapper implements MapperInterface {
    public Map<String, Map<String, String>> getFieldOptions( ){
        return new Map<String, Map<String, String>>{ 'ParentId' => new Map<String, String>{'AccessLevel' => 'Edit', 'RowCause' => 'Manual'} };
    }

    public List<SObject> getSObjectsFromShare( List<Share> records ){
        List<SObject> resulsToReturn = new List<SObject>();

        Id ugId = [SELECT Id, RelatedId
                     FROM Group
                     WHERE RelatedId IN : [Select Id, PortalAccountId From UserRole Where PortalAccountId = : null] LIMIT 1][0].Id;

        for( Share share : records ){
            resulsToReturn.add( new AccountShare( UserOrGroupId = share.getUserId(),
                                                  AccountId = share.getRecordId(),
                                                  AccountAccessLevel = share.getAccessLevel(),
                                                  Id = share.getShareId() ) );
        }
        return resulsToReturn;
    }

    protected override String getSharesQuery(List<Id> idsForQuery) {
        String whereString =  ' Where AccountId IN ' + BluewolfDevUtils.flattenListForQuery( idsForQuery, true );
        return whereString;
    }
    
    protected override Share wrapShare(SObject sharObj) {
        return new Share( (Id)(sharObj.get('AccountId')), 
                          (Id)(sharObj.get('UserOrGroupId')), 
                          (String)(sharObj.get('RowCause')), 
                          (String)(sharObj.get('AccountAccessLevel')), 
                          (Id)(sharObj.get('Id')) );
    }

    protected override String getSobjectAPIName() {
        return 'AccountShare';
    }
}