/*
    AP67User 
    ~ Author            : ymerleremond@deloitte.fr
    ~ Date              : 10/03/2014
    ~ Description       : - update the SalesforceUser__c value for the corresponding Alstom Employee record having the same Employee Number 
                            with the created user and assign all actions assigned to this Alstom Employee by updating the OwnerId with the  
                            user id OR create a new Alstom Employee linked to the new user if no Alstom Employee was found.
*/
public class AP67User 
{ 
    //we used @future because off the use of mix DML (setup and non setup DML)
    
    /* This method is called by User After Insert trigger */
    // update the SalesforceUser__c value for the corresponding Person record having the same Employee Number 
    // with the created user and assign all actions assigned to this Person by updating the OwnerId with the  
    // user id OR create a new Person linked to the new user if no Person was found
    public static boolean linkUserToAlstomEmployeeFutureCall=false;
    public static boolean linkAlstomEmployeeToUserFutureCall=false;
     
    
    public static void linkUserToAlstomEmployee(Set<Id> usersIds)
    {
        linkUserToAlstomEmployeeFutureCall = true;
        System.Debug('## >>> Starting AP67User.linkUserToAlstomEmployee with '+usersIds.size()+' usersIds <<<');
        Map<String, User> usersEmployeeNumber = new Map<String, User>(); //<EmployeeNumber, User>  
        Set<Id> UserToDeactiveIds = new Set<Id>();
        boolean bNoAction = false;
        for(User user : [SELECT Id, EmployeeNumber, Email, LastName, FirstName FROM User Where Id IN :usersIds])//get the Users related to the Trigger
        { 
            usersEmployeeNumber.put(user.EmployeeNumber, user);
        }
        //List<AlstomEmployee__c> alstomEmployees2Update = new List<AlstomEmployee__c>();
        Map<Id, AlstomEmployee__c> MapAlstomEmployees2Update = new Map<Id, AlstomEmployee__c>();
        Set<Id> alstomEmployeeIds = new Set<Id>();

        //if a Alstom Employee already exist with the same EmployeeNumber as the user ==> link the Alstom Employee with user
        System.Debug('## >>> Debug Search ae same employee number');
        //and Update user field with Alstom Employee linked (AlstomEmployeeAfterUpdate)
        for(AlstomEmployee__c alstomEmployee : [SELECT Id, EmployeeNumber__c, SalesforceUser__c,SalesforceUser__r.Profile.Name,Status__c,FirstName__c,LastName__c,Company__c,JobTitle__c,MobilePhone__c,WorkPhone__c,StreetAddress__c,Sector__c,City__c,ZipPostalCode__c,CountryName__c,TerangaUnit__c,DirectManager__c,FunctionalManager__c,Email__c,JobFunction__c FROM AlstomEmployee__c WHERE EmployeeNumber__c IN :usersEmployeeNumber.keySet()])
        {
            bNoAction = false;

            System.Debug('## >>> Debug Find ae same employee number : ' + alstomEmployee.Id);
            //if old user linked profile = chatter => auto deactive
            System.Debug('## >>> Debug Find ae, check SalesforceUser__c old link : ' + alstomEmployee.SalesforceUser__c);
            
            if(alstomEmployee.SalesforceUser__c != null)
            {
                //if alstom employee already linked to the good user => no action
                if(alstomEmployee.SalesforceUser__c == usersEmployeeNumber.get(alstomEmployee.EmployeeNumber__c).Id)
                {
                    bNoAction = true;
                }
                
                if(bNoAction == false)
                {
                    // deactivation of old user linked before creation of the new link
                    System.Debug('## >>> Debug Find ae, checkSalesforceUser__r.Profile.Name old link : ' + alstomEmployee.SalesforceUser__r.Profile.Name);
                    if(alstomEmployee.SalesforceUser__r.Profile.Name == 'AT - Chatter Free')
                    {
                        System.Debug('## >>> Debug Find ae, deactive user : ' + alstomEmployee.SalesforceUser__c);
                        UserToDeactiveIds.add(alstomEmployee.SalesforceUser__c);
                    }
                }
            }
            
            if(bNoAction==false)
            {
                alstomEmployee.SalesforceUser__c = usersEmployeeNumber.get(alstomEmployee.EmployeeNumber__c).Id;
                //alstomEmployees2Update.add(alstomEmployee);
                MapAlstomEmployees2Update.put(alstomEmployee.Id, alstomEmployee);
            }

            usersEmployeeNumber.remove(alstomEmployee.EmployeeNumber__c);
            alstomEmployeeIds.add(alstomEmployee.Id);
            
        }
        
        //Get all Alstom Employees already linked with this users to unlink (old link)
        for(AlstomEmployee__c alstomEmployee : [SELECT Id, EmployeeNumber__c, SalesforceUser__c ,Status__c,FirstName__c,LastName__c,Company__c,JobTitle__c,MobilePhone__c,WorkPhone__c,StreetAddress__c,Sector__c,City__c,ZipPostalCode__c,CountryName__c,TerangaUnit__c,DirectManager__c,FunctionalManager__c,Email__c,JobFunction__c FROM AlstomEmployee__c WHERE Id NOT IN :alstomEmployeeIds AND SalesforceUser__c IN :usersIds])
        {
            alstomEmployee.SalesforceUser__c = null;

            //alstomEmployees2Update.add(alstomEmployee);
            MapAlstomEmployees2Update.put(alstomEmployee.Id, alstomEmployee);
        }
        
        //if(alstomEmployees2Update.size() > 0)
        if(MapAlstomEmployees2Update.size() > 0)
        {
            //update alstomEmployees2Update;
            update MapAlstomEmployees2Update.values();
        }
        if(UserToDeactiveIds.size()>0)
        {
            AP68AlstomEmployee.deactiveUser(UserToDeactiveIds);
        }

        System.Debug('## >>> END AP67User.linkUserToAlstomEmployee <<<');
    }
    
    

    
    public static void linkAlstomEmployeeToUser(Set<Id> AlstomEmployeesIds)
    {
        linkAlstomEmployeeToUserFutureCall = true;
        System.Debug('## >>> Starting AP67User.linkAlstomEmployeeToUser <<<');
        Set<Id> alstomEmployeeUpdateIds = new Set<Id>();
        Set<Id> usersIds = new Set<Id>();
        Map<String, AlstomEmployee__c> MapEmployeeNumbers = new Map<String, AlstomEmployee__c>();
        Map<String, AlstomEmployee__c> MapEmails = new Map<String, AlstomEmployee__c>();
        Map<String, AlstomEmployee__c> MapEmailsDuplicate = new Map<String, AlstomEmployee__c>();
        Map<String, AlstomEmployee__c> MapUsernames = new Map<String, AlstomEmployee__c>();
        //List<AlstomEmployee__c> alstomEmployees2Update = new List<AlstomEmployee__c>();
        Map<Id, AlstomEmployee__c> MapAlstomEmployees2Update = new Map<Id, AlstomEmployee__c>();
        List<AlstomEmployee__c> alstomEmployeesUsers2Insert = new List<AlstomEmployee__c>();
        
        

        //Get Alstom Employee INFO
        system.debug('looking for : ' + AlstomEmployeesIds);
        for(AlstomEmployee__c ae : [SELECT Id, EmployeeNumber__c, SalesforceUser__c,Status__c,FirstName__c,LastName__c,Company__c,JobTitle__c,MobilePhone__c,WorkPhone__c,StreetAddress__c,Sector__c,City__c,ZipPostalCode__c,CountryName__c,TerangaUnit__c,DirectManager__c,FunctionalManager__c,Email__c,JobFunction__c FROM AlstomEmployee__c Where Id IN :AlstomEmployeesIds])//get the Alstom Employeed related to the Trigger 
        {
            system.debug('in the cycle : ' + ae.EmployeeNumber__c + ' ' + ae.Email__c);
            MapEmployeeNumbers.put(ae.EmployeeNumber__c, ae);
            MapEmails.put(ae.Email__c, ae);
            MapUsernames.put(ae.Email__c.SubString(0,ae.Email__c.indexOf('@')) + UserInfo.getUserName().substring(UserInfo.getUserName().indexOf('@'), UserInfo.getUserName().length()), ae);
            system.debug('ae to process: ' + ae.EmployeeNumber__c + ' ' + ae.Email__c);
        }


        //We remove all Email Key already associated to an Alstom Employee:
        for(AlstomEmployee__c ae : [SELECT Id, Email__c, SalesforceUser__c FROM AlstomEmployee__c Where Id NOT IN :AlstomEmployeesIds AND Email__c IN :MapEmails.KeySet() AND SalesforceUser__c != null]) 
        {
            system.debug('email duplicate in list : ' + ae.Email__c + ' ' + ae.Id);
            MapEmailsDuplicate.put(ae.Email__c, ae);
        }
        system.debug('query: ' + 'SELECT Id, EmployeeNumber, Email, Username FROM User WHERE EmployeeNumber IN ' + MapEmployeeNumbers.KeySet() + 'OR Email IN ' + MapEmails.KeySet() + ' ORDER BY LastLoginDate DESC LIMIT 1');
        

        //FIND USER BY EMPLOYEE NUMBER
        //only last loged user
        Set<String> lstEmployNumberInFor = new Set<String>();
        for(User u: [SELECT Id, EmployeeNumber, Email, Username FROM User WHERE EmployeeNumber IN :MapEmployeeNumbers.KeySet() ORDER BY LastLoginDate DESC ]){
            if(lstEmployNumberInFor.contains(u.EmployeeNumber) != true)
            {
                lstEmployNumberInFor.add(u.EmployeeNumber);
                system.debug('values for user: ' + u.EmployeeNumber + ' ' + u.Email + ' ' + u.Username); 
                if (MapEmployeeNumbers.get(u.EmployeeNumber) != null) {
                    system.debug('found ae number: ' + u.EmployeeNumber); 
                    MapEmployeeNumbers.get(u.EmployeeNumber).SalesforceUser__c = u.Id;
                    usersIds.add(u.Id); 
                    alstomEmployeeUpdateIds.add(MapEmployeeNumbers.get(u.EmployeeNumber).Id);
                    system.debug('ae to update 1: ' + MapEmployeeNumbers.get(u.EmployeeNumber).Id + ' ' + MapEmployeeNumbers.get(u.EmployeeNumber).Email__c);
                    MapAlstomEmployees2Update.put(MapEmployeeNumbers.get(u.EmployeeNumber).Id, MapEmployeeNumbers.get(u.EmployeeNumber));
                }
            }
            
        }


        //FIND USER bY EMAIL
        //only last loged user
        Set<String> lstEmailInFor = new Set<String>();
        for(User u: [SELECT Id, EmployeeNumber, Email, Username FROM User WHERE Email IN :MapEmails.KeySet() and Id NOT IN :usersIds ORDER BY LastLoginDate ]){
            if(lstEmailInFor.contains(u.Email) != true)
            {
                lstEmailInFor.add(u.Email);
                if (MapEmails.get(u.Email) != null) {
                    if (MapEmailsDuplicate.get(u.Email) == null){
                        system.debug('its not duplicate: ' + u.Email);
                        if (MapAlstomEmployees2Update.get(MapEmails.get(u.Email).Id) == null){
                            system.debug('found ae email: ' + u.Email);
                            MapEmails.get(u.Email).SalesforceUser__c = u.Id;
                            MapAlstomEmployees2Update.put(MapEmails.get(u.Email).Id, MapEmails.get(u.Email));
                            usersIds.add(u.Id);
                        } 
                    } else {
                        system.debug('email duplicate: ' + u.Email);
                        if (MapAlstomEmployees2Update.get(MapEmails.get(u.Email).Id) == null){
                            MapEmails.get(u.Email).UsernameDuplicate__c = true;
                            MapAlstomEmployees2Update.put(MapEmails.get(u.Email).Id, MapEmails.get(u.Email));
                            usersIds.add(u.Id);
                        } 
                    }
                    //usersIds.add(u.Id);
                    alstomEmployeeUpdateIds.add(MapEmails.get(u.Email).Id);
                    system.debug('ae to update 2: ' + MapEmails.get(u.Email).Id + ' ' + MapEmails.get(u.Email).Email__c);
                    }
            }
            
        }

        //Check duplicate User name
        for(User u: [SELECT Id, EmployeeNumber, Email, Username FROM User WHERE EmployeeNumber NOT IN : MapEmployeeNumbers.KeySet() AND Email NOT IN :MapEmails.KeySet() AND Username IN :MapUsernames.KeySet()]){
            if (MapUsernames.get(u.Username) != null) {
                system.debug('Username Duplicate 2: ' + u.Username);
                MapUsernames.get(u.Username).UsernameDuplicate__c = true;
                //usersIds.add(u.Id);
                alstomEmployeeUpdateIds.add(MapUsernames.get(u.Username).Id);
                system.debug('ae to update 4: ' + MapUsernames.get(u.Username).Id + ' ' + MapUsernames.get(u.Username).Email__c);
                //alstomEmployees2Update.add(MapUsernames.get(u.Username));
                

                if (MapAlstomEmployees2Update.get(MapUsernames.get(u.Username).Id) == null){
                    if(MapUsernames.get(u.Username).SalesforceUser__c != null)
                    {
                        MapAlstomEmployees2Update.put(MapUsernames.get(u.Username).Id, MapUsernames.get(u.Username));
                    }
                //  MapAlstomEmployees2Update.put(MapUsernames.get(u.Username).Id, MapUsernames.get(u.Username));
                //} else {
                //  MapAlstomEmployees2Update.get(MapUsernames.get(u.Username).Id).UsernameDuplicate__c = true;
                }
            }
        }

        //Check Insert conditions
        for(AlstomEmployee__c alstomEmployee : [SELECT Id, EmployeeNumber__c, SalesforceUser__c,Status__c,FirstName__c,LastName__c,Company__c,JobTitle__c,MobilePhone__c,WorkPhone__c,StreetAddress__c,Sector__c,City__c,ZipPostalCode__c,CountryName__c,SiteName__c,TerangaUnit__c,DirectManager__c,FunctionalManager__c,Email__c,JobFunction__c FROM AlstomEmployee__c WHERE Id IN :AlstomEmployeesIds AND SalesforceUser__c NOT IN :usersIds AND Id NOT IN :MapAlstomEmployees2Update.keySet()])
        {
            boolean bInsert = true;

            if(alstomEmployee.CountryName__c != null)
            {
                system.debug('##debug LBL0339 : ' + Label.LBL0339.toUpperCase() + ', Country Name : ' + alstomEmployee.CountryName__c.toUpperCase());
                //exeption for a country not allowed
                if(Label.LBL0339 != null)
                {
                    if(Label.LBL0339.toUpperCase().indexOf(alstomEmployee.CountryName__c.toUpperCase()) != -1)
                    {
                        bInsert = false;
                        //exeption for a site allowed
                        if(Label.LBL0340 != null)
                        {
                            if(Label.LBL0340.toUpperCase().indexOf(alstomEmployee.SiteName__c.toUpperCase()) != -1)
                            {
                                bInsert = true;
                            }
                        }
                    }
                } 
                
            }

            if(bInsert == true)
            {
                system.debug('ae to insert: ' + alstomEmployee.EmployeeNumber__c + ' ' + alstomEmployee.Email__c);
                alstomEmployeesUsers2Insert.add(alstomEmployee);
            }
        }
        //Get all person already linked with this users to unlink (old link)
        
        for(AlstomEmployee__c alstomEmployee : [SELECT Id, EmployeeNumber__c, SalesforceUser__c,Status__c,FirstName__c,LastName__c,Company__c,JobTitle__c,MobilePhone__c,WorkPhone__c,StreetAddress__c,Sector__c,City__c,ZipPostalCode__c,CountryName__c,TerangaUnit__c,DirectManager__c,FunctionalManager__c,Email__c,JobFunction__c FROM AlstomEmployee__c WHERE Id NOT IN :AlstomEmployeesIds AND SalesforceUser__c IN :usersIds])
        {
            system.debug('ae to update 5: ' + alstomEmployee.Id + ' ' + alstomEmployee.Email__c);
            alstomEmployee.SalesforceUser__c = null;
            //alstomEmployees2Update.add(alstomEmployee);
            if (MapAlstomEmployees2Update.get(alstomEmployee.Id) == null){
                MapAlstomEmployees2Update.put(alstomEmployee.Id, alstomEmployee);
            } else {
                MapAlstomEmployees2Update.get(alstomEmployee.Id).SalesforceUser__c = null;
            }
        }
         
        //UPDATE USERS
        if(MapAlstomEmployees2Update.size() > 0)
        {
            //update alstomEmployees2Update;
            update MapAlstomEmployees2Update.values();
             AP68AlstomEmployee.updateOrInsertUserFields(MapAlstomEmployees2Update.values(),false);

        }

        //INSERT USERS
        if(alstomEmployeesUsers2Insert.size()>0)
        {
            AP68AlstomEmployee.updateOrInsertUserFields(alstomEmployeesUsers2Insert, true); 
        }
        
        System.Debug('## >>> END AP67User.linkAlstomEmployeeToUser <<<');
    }
    
    
}