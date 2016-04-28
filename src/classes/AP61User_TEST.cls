/*
 AP61User_TEST apex class
   ~ Author          : Yamyle Merle-Rémond ~yamyle.merle-remond@axoa.fr 
    ~ Date Created    : 15/07/2014 
    ~ Description     : Test Class for AP61User.
*/
@isTest
private class AP61User_TEST 
{
    static testMethod void TestAP61_insert() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='AT - Marketing'];  
        Test.startTest();       
        try
        {
            User testUser = new User(Alias = 'newUser', Email='ap61insert@transport.alstom.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='fr', LocaleSidKey='fr_FR_EURO', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='ap61insert@transport.alstom.com');
            insert testUser;
        }
        catch (Exception e)
        {
            System.assertEquals(true, e.getMessage().contains(System.label.LBL0246));
        }
    }
    
    static testMethod void TestAP61_update() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='AT - Marketing'];  
        Test.startTest();       
        try
        {
            User testUser = new User(Alias = 'newUser', Email='ap61update@transport.alstom.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='ap61update@transport.alstom.com');
            insert testUser;
            testUser.LanguageLocaleKey = 'fr';
            update testUser;
        }
        catch (Exception e)
        {
            System.assertEquals(true, e.getMessage().contains(System.label.LBL0246));
        }
        
        Test.StopTest();
    }
}