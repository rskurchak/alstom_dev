/*
 AP12Competitor apex class
    ~ Author          : Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 
    ~ Date Created    : 1/08/2012 
    ~ Description     : Apex Class 
    					- prevent changing the value of Is AGlobal Competitor field to false (unchecked) 
    					if the Competitor is referenced as a Parent
*/
public class AP12Competitor 
{
	// prevent changing the value of Is AGlobal Competitor field to false (unchecked) if the Competitor is referenced as a Parent 
	// context : Competitor Before Update
	public static void isParent(Map<Id, Competitor__c> competitors)
	{
		System.debug('## >>> Starting AP12Competitor.isParent <<<');
		
		for(Competitor__c comp : [SELECT Id, (SELECT Id FROM Competitors__r LIMIT 1) FROM Competitor__c WHERE Id IN :competitors.keySet()])
			if(comp.Competitors__r != null && comp.Competitors__r.size() == 1)
				competitors.get(comp.Id).addError(System.Label.LBL0033);
		
		System.debug('## >>> AP12Competitor.isParent END <<<');
	}
}