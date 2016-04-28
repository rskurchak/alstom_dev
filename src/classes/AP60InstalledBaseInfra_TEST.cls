/**
 * This class contains unit tests for validating the behavior of AP60InstalledBaseInfra_TEST Apex classes
 * and triggers.
 *   ~ Author          : Yamyle MERLE-REMOND ~ yamyle.merle-remond@axoa.fr 
     ~ Date Created    : 27/02/2014
 */
@isTest
public with sharing class AP60InstalledBaseInfra_TEST {
    static testMethod void TestAP60InstalledBaseInfra() {
        Account account = UtilityTestMethod.getAccount();
        insert account;

        RecordType RecTypeBallastTrack = [SELECT Id, Name FROM RecordType WHERE SObjectType='InstalledBaseInfra__c' AND Name = 'Ballast track' LIMIT 1];
        RecordType RecTypeHVIntakeSubstation = [SELECT Id, Name FROM RecordType WHERE SObjectType='InstalledBaseInfra__c' AND Name = 'HV Intake Substation' LIMIT 1];
        RecordType RecTypeReturnCurrentSystem = [SELECT Id, Name FROM RecordType WHERE SObjectType='InstalledBaseInfra__c' AND Name = 'Return Current System' LIMIT 1];
       
    	List<InstalledBaseInfra__c> InstalledBaseInfraS = new List<InstalledBaseInfra__c>();
        InstalledBaseInfras.add(new InstalledBaseInfra__c(Account__c=account.Id, Name = 'Test1', RecordTypeId=RecTypeBallastTrack.Id));
        InstalledBaseInfras.add(new InstalledBaseInfra__c(Account__c=account.Id, Name = 'Test2', RecordTypeId=RecTypeHVIntakeSubstation.Id));
        InstalledBaseInfras.add(new InstalledBaseInfra__c(Account__c=account.Id, Name = 'Test3', RecordTypeId=RecTypeReturnCurrentSystem.Id));
        insert InstalledBaseInfras;
    }
}