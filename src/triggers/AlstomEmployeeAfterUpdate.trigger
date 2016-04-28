trigger AlstomEmployeeAfterUpdate on AlstomEmployee__c (after update) {
    System.Debug('## >>> AlstomEmployee__c after update <<< run by ' + UserInfo.getName());
    /****************************************************************************************
        AP68AlstomEmployee : if the Alstom Employee Number is updated and the Alstom Employee is related to a user : 
                     - update the User Employee Number
                     - CR Notify Champion
    *****************************************************************************************/
    if(PAD.canTrigger('AP68'))
    {
        Map<Id, String> ap68UserIdEmployeeNumMap = new Map<Id, String>();
 		Set<Id> alstomEmployeeIdsActiveInAlstomChange = new Set<Id>();
         
        List<String> SyncFieldsWithUser = new List<String>{
    											 'SalesforceUser__c'
        										,'Status__c'
        										,'FirstName__c'
        										,'LastName__c'
        										,'Company__c'
        										,'JobTitle__c'
        										,'MobilePhone__c'
        										,'WorkPhone__c'
        										,'StreetAddress__c'
        										,'Sector__c'
        										,'City__c'
        										,'ZipPostalCode__c'
        										,'CountryName__c'
        										,'TerangaUnit__c'
        										,'DirectManager__c'
        										,'FunctionalManager__c'
        										,'EmployeeNumber__c'
        										,'Email__c'
        										,'SiteName__c'
        										,'Business__c'
        										,'SubBusiness__c'
        										,'JobFunction__c'
        										};
        
        // List of Persons where the associated user must be updated (ActiveInAlstom field)
        List<AlstomEmployee__c> alstomEmployeesFieldsToUpdateWithUser = new List<AlstomEmployee__c>();
        
        //Set Id Alstom Employee to update
        Set<Id> alstomEmployeeIds = new Set<Id>();

        for(AlstomEmployee__c alstomEmployee : Trigger.new) {
        	//If Alstom Employee is associated and if Alstom Employee fiels has changed => update the user associated
        	system.debug('checking for fields changed');
        	if(alstomEmployee.SalesforceUser__c != null)
        	{
        		for(String f : SyncFieldsWithUser)
        		{
		        	system.debug('field to see if changed: ' + f + ' old value: ' + Trigger.oldMap.get(alstomEmployee.Id).get(f) +  ' new value: ' + alstomEmployee.get(f));
                    if(alstomEmployee.get(f) !=  Trigger.oldMap.get(alstomEmployee.Id).get(f))
        			{
        				//If a field (concerned by the synchronisation) has changed => update the associated user
			        	
                        system.debug('##debug field changed: ' + alstomEmployee.get(f));
                        system.debug('##debug field changed Current User Id: ' + UserInfo.getUserId());
                        if(f!='SalesforceUser__c' || UserInfo.getProfileId() != Label.LBL0328)
                        {
                            system.debug('##debug add alstomEmployee.Id : ' + alstomEmployee.Id);
                            alstomEmployeeIds.add(alstomEmployee.Id);   
                        }           
                  	}
        		}
        	}
        }

        
        
        alstomEmployeesFieldsToUpdateWithUser = [SELECT Id, Name, Business__c, SalesforceUser__r.ProfileId, SalesforceUser__r.IsActive, City__c, Company__c, CountryCode__c, CountryName__c, DirectManager__c, Email__c, EmployeeNumber__c, FirstName__c,    FullName__c, JobFunction__c,    JobTitle__c, LastName__c, MobilePhone__c, SalesforceUser__c, Sector__c, SiteName__c, Status__c, StreetAddress__c, SubBusiness__c, TerangaUnit__c, WorkPhone__c, ZipPostalCode__c FROM AlstomEmployee__c where Id in :alstomEmployeeIds ];           

        // If Status change in Alstom Employee we also have to change it to User 
        if(alstomEmployeesFieldsToUpdateWithUser.size()>0)
        {
	    	system.debug('calling user update');
            AP68AlstomEmployee.updateOrInsertUserFields(alstomEmployeesFieldsToUpdateWithUser, false); 
        }
    }//bypass
    

    System.Debug('## >>> AlstomEmployee__c after update : END <<<');

}