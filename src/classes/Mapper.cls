public abstract class Mapper {
	protected abstract String getSharesQuery(List<Id> idsForQuery);
    
    protected abstract Share wrapShare(SObject sharObj);
    protected abstract String getSobjectAPIName();
    
    protected Set<Share> getExistingSharesByQuery( String queryShares ){
        Set<Share> allSharingsForRecords = new Set<Share>();

        for( SObject sharObj : Database.query( queryShares ) ){
            allSharingsForRecords.add(wrapShare(sharObj));
        }
        return allSharingsForRecords;
    }
    
    public Set<Share> getExistingShares( List<Id> idsForQuery){
    	String whereString = getSharesQuery( idsForQuery);
    	String queryShares = BluewolfDevUtils.prepareQueryForObjectData(getSobjectAPIName() , whereString, idsForQuery );
    	Set<Share> allSharingsForRecords = getExistingSharesByQuery( queryShares );
    	return allSharingsForRecords;
    }
}