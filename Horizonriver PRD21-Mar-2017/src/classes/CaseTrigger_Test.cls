@isTest(SeeAllData = True)
Public Class CaseTrigger_Test{

    static testmethod void CaseTriggerHandler(){
        Test.starttest();
        Account a = [Select id,Store_Number__c from account limit 1];
        a.Store_Number__c = '0011';
        update a;
        case c = new case();
        c.Status = 'New';
        c.Origin = 'Email';
        c.Subject = 'Internet carrier for Clinic 0011';
        insert c;
        test.stoptest();
    }

}