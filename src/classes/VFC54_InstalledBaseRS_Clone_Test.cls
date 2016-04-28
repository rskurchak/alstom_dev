/*
  Class Test Controller for VFC54_InstalledBaseRS_Clone
    ~ Author          : Jawad GHOULAM ~ jawad.ghoulam@cgi.com 
    ~ Date Created    : 05/11/2013
*/
@isTest
private class VFC54_InstalledBaseRS_Clone_Test {
    private static final String  USER_PROFILE_NAME = 'AT - Customer Community +';
    private static final String  USER_NAME_PREFIX  = '@transport.alstom.com';


    static testMethod void VFC54_InstalledBaseRS_Clone_Test() {
      
      // Create a Account
      Account account = UtilityTestMethod.getAccount();
      insert account;
      
      Contact contact = TestUtils.createContacts(new List<Account>{account}, true)[0];

      Id userProfileId = [SELECT Id
                          FROM Profile
                          WHERE Name =: USER_PROFILE_NAME LIMIT 1][0].Id;

      TestUtils.createUsers(new List<Contact>{contact}, userProfileId, USER_NAME_PREFIX, true);

      // Create a Installed Base RS
      InstalledBaseRS__c installedBaseRS = UtilityTestMethod.getInstalledBaseRS();
      installedBaseRS.Account__c = account.Id;
      insert installedBaseRS;
      
      // Create a Subsystem Rolling Stock
      SubsystemRS__c subsystemRS = UtilityTestMethod.getSubsystemRS();
      subsystemRS.InstalledBaseRS__c = installedBaseRS.Id;
      insert subsystemRS;

    /* TEST START */
      Test.startTest();
      PageReference vfp54 = Page.VFP54_InstalledBaseRS_Clone; 
      Test.setCurrentPage(vfp54);
      VFC54_InstalledBaseRS_Clone vfc54 = new VFC54_InstalledBaseRS_Clone(new ApexPages.StandardController(installedBaseRS));
      vfc54.childObjName = 'SubsystemRS__c';
      vfc54.doClone();
      vfc54.CancelClone();
      Test.stopTest();
    }
}