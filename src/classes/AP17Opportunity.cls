/*
 AP17Opportunity apex class
    ~ Author          : Fabien TAILLON ~ fabien.taillon@cgi.com 
    ~ Date Created    : 19/02/2013
    ~ Description     : Apex Class 
    					- check if the the Opportunity is Global if there is child Opportunities			
*/
public with sharing class AP17Opportunity 
{
	public static void checkHasChildOpportunity(list<Opportunity> oppList)
	{
		map<Id, Opportunity> oppMap = new map<Id, Opportunity>();
		for (Opportunity o : oppList)
			oppMap.put(o.Id, o);
			
		for (Opportunity opp : [Select Id, (Select Id From Opportunities__r) From Opportunity where Id IN :oppList])
			if (opp.Opportunities__r.size() > 0)
				oppMap.get(opp.Id).addError(System.label.LBL0047);
	}
}