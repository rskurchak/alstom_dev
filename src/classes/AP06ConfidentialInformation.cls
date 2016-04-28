/*
    AP06ConfidentialInformation apex class
   ~ Author          : Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 
    ~ Date Created    : 24/07/2012 
    ~ Description     : Apex Class 
                        - automatically add the owner of the parent object (Account, Contact, Opportunity, Competitor, Tender) 
                        in the sharing table for the Confidential Information
*/

public class AP06ConfidentialInformation 
{
    // automatically add the owner of the parent object (Account, Contact, Opportunityn, Competitor, Tender)
    // in the sharing table for the Confidential Information
    
    /* called by ConfidentialInformation__c After Insert */
    public static void createParentSharing(List<ConfidentialInformation__c> cInformations)
    {
        System.debug('## >>> Starting AP06ConfidentialInformation.createParentSharing <<<');
        
        List<ConfidentialInformation__Share> confInfoSharing = new List<ConfidentialInformation__Share>();
        
        for(ConfidentialInformation__c confInfo : cInformations)
            confInfoSharing.add(new ConfidentialInformation__Share(AccessLevel='Edit', ParentId=confInfo.Id, RowCause=Schema.ConfidentialInformation__Share.rowCause.ParentObjectOwner__c, UserOrGroupId=confInfo.TECH_ParentOwnerId__c));
        
        if(confInfoSharing.size() > 0)
            insert confInfoSharing;
        
        System.debug('## >>> End AP06ConfidentialInformation.createParentSharing<<<');          
    }
    
    // update the Sharing for the ConfidentialInformation when the owner of the parent Object changes
    /* called by Account, Opp ... After Update */
    public static void updateParentSharing(Set<Id> sObjectIds)
    {
        System.debug('## >>> Starting AP06ConfidentialInformation.createParentSharing <<<');
        System.debug('sObjectIds >>>>> '+sObjectIds);
        Map<Id, ConfidentialInformation__c> confInfos = new Map<Id, ConfidentialInformation__c>(); 
        for(ConfidentialInformation__c confInfo : [SELECT Id, TECH_ParentOwnerId__c FROM ConfidentialInformation__c WHERE Account__c IN :sObjectIds OR Contact__c IN :sObjectIds OR Opportunity__c IN :sObjectIds OR Competitor__c IN :sObjectIds])
            confInfos.put(confInfo.Id, confInfo);
        
        List<ConfidentialInformation__Share> shares2Delete = new List<ConfidentialInformation__Share>();
        for(ConfidentialInformation__Share confInfoShare2Delete : [SELECT Id FROM ConfidentialInformation__Share WHERE RowCause= :Schema.ConfidentialInformation__Share.rowCause.ParentObjectOwner__c AND ParentId IN :confInfos.keySet()])
            shares2Delete.add(confInfoShare2Delete);
        
        if(shares2Delete.size() > 0)
            delete shares2Delete;
            
        createParentSharing(confInfos.values());
        
        System.debug('## >>> End AP06ConfidentialInformation.createParentSharing<<<');
    }
}