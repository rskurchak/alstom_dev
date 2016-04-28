/*
    AP68AlstomEmployee 
    ~ Author            : ymerleremond@deloitte.fr
    ~ Date              : 10/03/2015
    ~ Description       : if the Alstom Employee Number is updated and the Alstom Employee is related to a user : 
                            - update the User Employee Number
*/


public class AP68AlstomEmployee
{
    
    // Update fiew fields for User linked to the Persons list
    public static void updateOrInsertUserFields(List<AlstomEmployee__c> AlstomEmployees, boolean isInsert)
    { 
        List<User> usersToUpdate = new List<User>();
        Set<Id> usersIdToDeactive = new Set<Id>();
        List<User> usersToInsert = new List<User>();
        List<AlstomEmployee__c> alstomEmployeesToUpdate = new List<AlstomEmployee__c>();
        List<UserLogin> userLoginsToUpdate = new List<UserLogin>();
        Set<Id> salesforceUserIds = new Set<Id>();


        for(AlstomEmployee__c anAlstomEmployee : AlstomEmployees)
        {
            salesforceUserIds.add(anAlstomEmployee.SalesforceUser__c);
        }

        Map<Id,UserLogin> userLoginsByUserId = new Map<Id,UserLogin>();

        List<UserLogin> userLoginList = [SELECT Id, IsFrozen, IsPasswordLocked, UserId FROM UserLogin WHERE  UserId IN: salesforceUserIds];

        for(UserLogin anUserLogin : userLoginList)
        {
            userLoginsByUserId.put(anUserLogin.UserId, anUserLogin);
        }

        // Retrieve the Person ID of the FunctionalManager and DirectManager
        Set<Id> managers = new Set<Id>();
        for(AlstomEmployee__c alstomEmployee : AlstomEmployees) {
            if (alstomEmployee.DirectManager__c != null) {
                managers.add(alstomEmployee.DirectManager__c);
            }
        }
        Id chatterFreeProfileId = [SELECT Id FROM Profile WHERE  Name = 'AT - Chatter Free' LIMIT 1].Id;
        // Retrieve the corresponding Salesforce User of the Managers 
        Map<Id,Id> alstomEmployee2User = new Map<Id,Id>();
        for (AlstomEmployee__c alstomEmployee : [SELECT Id, SalesforceUser__c FROM AlstomEmployee__c WHERE Id IN :managers]) 
        {
            if (alstomEmployee.SalesforceUser__c != null)
            {
                alstomEmployee2User.put(alstomEmployee.Id, alstomEmployee.SalesforceUser__c);
            }
        }
        
        for(alstomEmployee__c ae:AlstomEmployees)
        {
            system.debug('updating alstom employee: ' +  ae.Id + ' IsInsert: ' + isInsert);
            UserLogin ul;
            User u;
            if (isInsert) {
                u = new User();
                u.ProfileId = chatterFreeProfileId;
                u.alias = ae.Email__c.SubString(0,ae.Email__c.indexOf('@'));
                u.username = u.alias + UserInfo.getUserName().substring(UserInfo.getUserName().indexOf('@'), UserInfo.getUserName().length());
                u.LanguageLocaleKey = 'en_US';
                u.emailencodingkey = 'UTF-8';
                u.LanguageLocaleKey = 'en_US';
                u.TimeZoneSidKey = 'Europe/Paris';
                u.LocaleSidKey = 'fr_FR_EURO';
                if (u.alias.length() > 8) {
                    u.alias = u.alias.substring(0, 8);
                }
                u.EmployeeStatus__c = true;
                system.debug('in IsInsert: ' + u.username);
                //ul = new UserLogin(Id=ae.SalesforceUser__c);
            }
            else 
            {
                u = new User(Id=ae.SalesforceUser__c);
                //[SELECT Id, IsActive, ProfileId FROM User where Id = :ae.SalesforceUser__c LIMIT 1];
                //u = [SELECT Id, IsActive, ProfileId FROM User where Id = :ae.SalesforceUser__c LIMIT 1];
                //ul = [SELECT Id, IsFrozen, IsPasswordLocked, UserId FROM UserLogin WHERE  UserId =: ae.SalesforceUser__c LIMIT 1];
                ul = userLoginsByUserId.get(ae.SalesforceUser__c);
                if(ae.Status__c != null) 
                {
                    if(ae.Status__c == 'Active')
                    {
                        /*
                        if (ul.IsFrozen == true) {
                            ul.IsFrozen = false;
                            userLoginsToUpdate.add(ul);
                        }
                        */
                        u.EmployeeStatus__c = true;
                    }
                    else
                    { 
                        if (ul.IsFrozen == false) {
                            ul.IsFrozen = true;
                            userLoginsToUpdate.add(ul);
                        }
                        u.EmployeeStatus__c = false;
                        system.debug('Freeze done check for deactivation ProfileId : ' + ae.SalesforceUser__r.ProfileId + ' chatterFreeProfileId : ' + chatterFreeProfileId +  ' IsActive : ' + ae.SalesforceUser__r.IsActive);
                         //if user profile is Chatter free and Alstom Employee status = Inactive' then user is deactivate
                        if(ae.SalesforceUser__r != null)
                        {
                            if( ae.SalesforceUser__r.ProfileId == chatterFreeProfileId  && ae.SalesforceUser__r.IsActive == true)
                            {
                                system.debug('## Add to Deactivation list : ' +ae.SalesforceUser__c);
                                usersIdToDeactive.add(ae.SalesforceUser__c);
                            }
                        }
                    }
                }
            }

            if(ae.FirstName__c != null)
            {
                if(ae.FirstName__c.length()>40)
                {
                    u.FirstName =ae.FirstName__c.SubString(0,40);
                }
                else
                {
                    u.FirstName =ae.FirstName__c;
                }
            }
            if(ae.LastName__c != null)
            {
                if(ae.LastName__c.length()>80)
                {
                    u.LastName =ae.LastName__c.SubString(0,80);
                }
                else
                {
                    u.LastName =ae.LastName__c;
                }
            }
            if(ae.Company__c != null)
            {
                if(ae.Company__c.length()>80)
                {
                    u.CompanyName =ae.Company__c.SubString(0,80);
                }
                else
                {
                    u.CompanyName =ae.Company__c;
                }
            }
            if(ae.JobTitle__c != null)
            {
                if(ae.JobTitle__c.length()>80)
                {
                    u.Title =ae.JobTitle__c.SubString(0,80);
                }
                else
                {
                    u.Title =ae.JobTitle__c;
                }
            }
            system.debug('updating telephone: ' + ae.MobilePhone__c + '-' + u.MobilePhone + '-' + ae.WorkPhone__c + '-' + u.Phone);
            if(ae.MobilePhone__c!= null)
            {
                if(ae.MobilePhone__c.length()>40)
                {
                    u.MobilePhone =ae.MobilePhone__c.SubString(0,40);
                }
                else
                {
                    u.MobilePhone =ae.MobilePhone__c;
                }
            }
            if(ae.WorkPhone__c!= null)
            {
                u.Phone = ae.WorkPhone__c;
            }
            if(ae.StreetAddress__c!= null)
            {
                u.Street = ae.StreetAddress__c;
            }
            if(ae.Sector__c != null)
            {
                if(ae.Sector__c .length()>80)
                {
                    u.Division =ae.Sector__c.SubString(0,80);
                }
                else
                {
                    u.Division =ae.Sector__c ;
                }
            }
            if(ae.City__c != null)
            {
                if(ae.City__c.length()>40)
                {
                    u.City =ae.City__c.SubString(0,40);
                }
                else
                {
                    u.City =ae.City__c;
                }
            }
            if(ae.ZipPostalCode__c != null)
            {
                if(ae.ZipPostalCode__c.length()>20)
                {
                    u.PostalCode =ae.ZipPostalCode__c.SubString(0,20);
                }
                else
                {
                    u.PostalCode =ae.ZipPostalCode__c;
                }
            }
            if(ae.CountryName__c != null)
            {
                if(ae.CountryName__c.length()>80)
                {
                    u.Country =ae.CountryName__c.SubString(0,80);
                }
                else
                {
                    u.Country =ae.CountryName__c;
                }
            }
            if(ae.TerangaUnit__c != null)
            {
                u.TerangaUnit__c = ae.TerangaUnit__c;
            }
            
            //Update of managers
            if(ae.DirectManager__c != null)
            {
                if (alstomEmployee2User.containsKey(ae.DirectManager__c)) 
                {
                    u.ManagerId = alstomEmployee2User.get(ae.DirectManager__c);
                }
                //else    
                //{
                 //   u.ManagerId = null;
                //}
            }
            if(ae.Email__c != null)
            {
                u.Email = ae.Email__c;
            }
            if(ae.EmployeeNumber__c != null)
            {
                u.EmployeeNumber = ae.EmployeeNumber__c;
            }
            if (isInsert) {
                system.debug('Inserting in the user list: ' + u.username);
                usersToInsert.add(u);
            } else {
               
                usersToUpdate.add(u);
            }
        }
       
        if(usersToInsert.size()>0 || usersToUpdate.size()>0)
        {
            Database.SaveResult[] srList;
            if (isInsert) {
               system.debug('insering users');
               srList = Database.insert(usersToInsert, false);
            } else {
                srList = Database.update(usersToUpdate, false);
                if(userLoginsToUpdate.size()>0) {
                    srList = Database.update(userLoginsToUpdate, false);
                }
                if(usersIdToDeactive.size()>0)
                {
                    system.debug('usersIdToDeactive: ' +  usersIdToDeactive.size());
                   
                    deactiveUser(usersIdToDeactive);
                }
            }
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) 
            {
                if (!sr.isSuccess()) {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) 
                    {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('User fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
    }


    @future
    public static void deactiveUser(Set<Id> UserToDeactiveIds)
    {
        System.debug('## >>> Starting AP68AlstomsEmployee.deactiveUser for ' + UserToDeactiveIds.size() + ' users<<<');
        
        List<User> UserToDeactive = new List<User>();
        List<EntitySubscription> autoFollowSubscription2Insert = new List<EntitySubscription>(); 
        Map<Id,User> usersById = new Map<Id,User>([SELECT Id,Username FROM User WHERE Id in :UserToDeactiveIds]);
        
        for(Id userId :UserToDeactiveIds)
        {
            User u =usersById.get(userId);
            //User u = [SELECT Id,Username FROM User WHERE Id = :userId LIMIT 1];
            u.IsActive=false;
           //User u = new User(Id=userId,IsActive=false);
            System.debug('## >>> Debug Username : ' + u.Username);
           if(u.Username.toUpperCase().indexOf('DEACTIVATED') == -1) 
           {

                String sDayString = string.valueof(system.today().day());
                if(sDayString.length()<2)
                {
                    sDayString = '0' + sDayString;
                }

                
                System.debug('## >>> Debug sDayString : ' + sDayString);

                String sMonthstring = string.valueof(system.today().month());
                if(sMonthstring.length()<2)
                {
                    sMonthstring = '0' + sMonthstring;
                }

                
                System.debug('## >>> Debug sMonthtstring : ' + sMonthstring);

                String sYearstring = string.valueof(system.today().year());
               
                System.debug('## >>> Debug sYearstring : ' + sYearstring);

                u.Username =  u.Username + 'deactivated_' + sYearstring + sMonthstring + sDayString;

            System.debug('## >>> Debug new username : ' +  u.Username );

           }
           UserToDeactive.add(u);
        }
            
        Database.SaveResult[] srList;
        srList = Database.update(UserToDeactive, false);

        System.debug('## >>> End AP68AlstomsEmployee.deactiveUser<<');
    }
    
}