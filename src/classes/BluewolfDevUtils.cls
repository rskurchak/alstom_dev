public class BluewolfDevUtils {
    public static String prepareQueryForObjectData( String sObjectName, String whereSection, List<Id> idsForQuery ){
        String query = 'Select ';
        query += flattenListForQuery( Schema.getGlobalDescribe().get( sObjectName ).getDescribe().fields.getMap().Values(), false );
        query += ' From ' + sObjectName + ' ';
        query += whereSection;

        return query;
    }

    //Flatten list for a dynamic query
    public static String flattenListForQuery( List<Object> setOfValues, Boolean addQuotesAndBrackets ) {
        String query = '';  
        if( setOfValues.isEmpty() ) return query;
        
        for( Object addToString : setOfValues ) {
            if( addQuotesAndBrackets ) {
                query += '\'' + String.valueOf( addToString ) + '\', '; 
            } else {
                query += String.valueOf( addToString ) + ', ';  
            }
        }
        
        if( !query.equals('') ) {
            query = query.removeEnd( ', ' );
            if( addQuotesAndBrackets ) query = '(' + query + ') ';
        }
        return query;
    }
}