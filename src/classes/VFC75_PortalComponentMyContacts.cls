/*
 VFC75_PortalComponentMyContacts
   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 17/04/2014 
    ~ Description     : Generic controller to retrieve Alstom Contacts.
*/
public class VFC75_PortalComponentMyContacts {
    private static String userId = UserInfo.getUserId();
    public User u {get;set;}
    ID contactId {get;set;}

    public VFC75_PortalComponentMyContacts() {   
        u = [Select ID, Name, LastName, FirstName, Title, SmallPhotoURL, FullPhotoURL, ContactId, CompanyName, Street, PostalCode, City, Country From User Where ID =: UserInfo.getUserID() Limit 1];
        contactId = [Select contactid from User where id =: u.Id].contactId;
    }
    public List<AlstomContact__c> getAlstomSalesContacts(){
        List<AlstomContact__c> AlstomSalesContacts= [Select Id, UserName__c, Email__c, Phone__c, Title__c, AlstomContact__r.SmallPhotoUrl from AlstomContact__c where DisplayInCustomerPortal__c = 'My Contacts' and Contact__c =: contactId order by UserName__c LIMIT 3];
        for (AlstomContact__c ac : AlstomSalesContacts) {
        	system.debug('url: '+ ac.AlstomContact__r.SmallPhotoUrl);
        }
        return AlstomSalesContacts;
    }
    
    public List<AlstomContact__c> getAlstomTechnicalContacts(){
        List<AlstomContact__c> AlstomTechnicalContacts= [Select Id, UserName__c, Email__c, Phone__c, Title__c, AlstomContact__r.SmallPhotoUrl from AlstomContact__c where DisplayInCustomerPortal__c = 'My Technical Contacts' and Contact__c =: contactId order by UserName__c LIMIT 3];
        return AlstomTechnicalContacts;
    } 
}