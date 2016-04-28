/*
 AP11Account apex class
    ~ Author          : Mohamed EL MOUSSAOUI ~ mohamed.el-moussaoui@axoa.fr 
    ~ Date Created    : 1/08/2012 
    ~ Description     : Apex Class 
    					- sync ParentId field with TECH_GlobalAccount to maintain the custom lookup relation
    					- prevent changing the value of IsAGlobal Account field to false (unchecked) if the Account is referenced as a Parent
*/
public class AP11Account 
{
	// sync ParentId field with TECH_GlobalAccount to maintain the custom lookup relation  
	// context : Account Before Update/ Before Insert
	public static void syncParentField(List<Account> accounts)
	{
		System.debug('## >>> Starting AP11Account.syncParentField <<<');
		
		for(Account acc : accounts)
			acc.TECH_GlobalAccount__c = acc.ParentId;
		
		System.debug('## >>> AP11Account.syncParentField END <<<');
	}
	
	// prevent changing the value of IsAGlobal Account field to false (unchecked) if the Account is referenced as a Parent 
	// context : Account Before Update
	public static void isParent(Map<Id, Account> accounts)
	{
		System.debug('## >>> Starting AP11Account.isParent <<<');
		
		for(Account acc : [SELECT Id, (SELECT Id FROM GlobalAccounts__r LIMIT 1) FROM Account WHERE Id IN :accounts.keySet()])
			if(acc.GlobalAccounts__r != null && acc.GlobalAccounts__r.size() == 1)
				accounts.get(acc.Id).addError(System.Label.LBL0032);
		
		System.debug('## >>> AP11Account.isParent END <<<');
	}
}