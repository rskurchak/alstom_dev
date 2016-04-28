/*
 AP03ATRegion apex class
   ~ Author          : Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 
    ~ Date Created    : 19/11/2012 
    ~ Description     : Apex Class 
                        - update the ATRegion field every time the Country Field get changed for Account, Competitor, Opportunity, Project (Insert new / Update)                        
*/
public class AP03ATRegion 
{
    // update the ATRegion field every time the Country Field get changed for Account, Competitor, Opportunity, Project
    // context :- Opportunity before insert & before Update
    //          - Account before insert & before Update
    //          - Competitor before insert & before Update
    //          - Project before insert & before Update
    //          - Lead before insert & before Update
    //          - Installed Base RS before insert & before Update
    //          - Installed Base Infra before insert & before Update
    public static void updateSObjectATRegion(List<Sobject> sObjects)
    {
        Map<String, String> regionCountry = new Map<String, String>();
        Map<String, String> clusterCountry = new Map<String, String>();
        for(CountryATRegion__c cs : CountryATRegion__c.getAll().values())
        {
            regionCountry.put(cs.Country__c, cs.ATRegion__c);
            clusterCountry.put(cs.Country__c, cs.ATCluster__c);
        }
        
        for(Sobject obj : sObjects)
        {
            if (obj.get('Country__c') != null)
            {
                obj.put('ATRegion__c', regionCountry.get(String.valueOf(obj.get('Country__c'))));
                obj.put('ATCluster__c', clusterCountry.get(String.valueOf(obj.get('Country__c')))); 
            }
        }       
    }
}