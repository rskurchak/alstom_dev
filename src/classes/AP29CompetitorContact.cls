/*
 AP29CompetitorContact 
    ~ Author            : jawad.ghoulam@cgi.com
    ~ Modification Date : 21/08/2013
    ~ Description       : Check if there are loops in the relationships = a contact cannot be parent of its own parent.
        This function is native on the standard Contact object and the Reports To field, but needs to be implemented 
        here since we're dealing with a custom object.
*/
public class AP29CompetitorContact {

    public static void CompetitorContactCheckLoop(List<CompetitorsContact__c> currentComCon) {
        boolean isLoop = false;
        
        // Create a list - each entry represents a 'generation' of parents in the parent/child hierarchy 
        // (parent, grandparent, great-grandparent, etc.)
        List<CompetitorsContact__c> listComCon = new List<CompetitorsContact__c>();
        
        // Create a list of parent ids - used for single query to receive parent generation CompetitorsContact__c.
        List<ID> listParentIDs = createListOfParentIDsFromComConList(currentComCon);

        while (listParentIDs.size() > 0)
        {
            // Use a single database query to get the parent CompetitorsContact__c records, put results in a sub list 'listParentResults', and add the sub list to the list 'listComCon'.
            List<CompetitorsContact__c> listParentResults = new List<CompetitorsContact__c>([SELECT ReportsTo__c FROM CompetitorsContact__c WHERE Id IN :listParentIDs]);
            listComCon.addAll(listParentResults);
    
            // Create a list of Parent ids using the results from the previous query.
            listParentIDs = createListOfParentIDsFromComConList(listParentResults);
        }

        // Now iterate the trigger.new list and perform parent look-ups via the list of generational CompetitorsContact__c.
        for (CompetitorsContact__c comConUltimateParent : currentComCon)
        {
            ID idParent = comConUltimateParent.Id;
        
            // Iterate the list until you find a null parent id.
            for (Integer j=0; (idParent != null && j<listComCon.size()-1); j++)
            {
                // Check if the current Competitor contact exist in the list of generational CompetitorsContact__c
                if(idParent == listComCon.get(j).ReportsTo__c){
                    isLoop = true;
                }
            }
            // is it true there's a closed loop. Display an error
            if (isLoop == true){
               comConUltimateParent.ReportsTo__c.addError(System.label.LBL0060);
            }   
        }
    }
    
    /**
    * Create list of parent ids
    * @return listParentIDs
    */
    public static List<ID> createListOfParentIDsFromComConList(List<CompetitorsContact__c> lstComCon)
    {
        List<ID> listParentIDs = new List<ID>();
    
        // Iterate list competitor contact to create list of parent ids.
        for (CompetitorsContact__c acct : lstComCon)
        {
            listParentIDs.add(acct.ReportsTo__c);
        }
        return listParentIDs;
    }  
}