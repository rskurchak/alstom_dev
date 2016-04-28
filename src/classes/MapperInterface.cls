// An interface that defines Mapper in general
public interface MapperInterface {

	Map<String, Map<String, String>> getFieldOptions();

	List<SObject> getSObjectsFromShare( List<Share> records );

	Set<Share> getExistingShares( List<Id> idsForQuery );
}