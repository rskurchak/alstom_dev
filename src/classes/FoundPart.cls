public class FoundPart {

    public PartAndRepair__c partAndRepair { get; set;}
    public Map<String, String> typeIconLinks {
        get {
            if ( typeIconLinks == null) {
                typeIconLinks = new Map<String, String>();
            }
            return typeIconLinks;
        }
        set;
    } 
    
}