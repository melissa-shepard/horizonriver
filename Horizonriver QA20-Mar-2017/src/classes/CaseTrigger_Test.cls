@isTest(SeeAllData = True)
Public Class CaseTrigger_Test{

    static testmethod void CaseTriggerHandler(){
        Test.starttest();
        Account a = [Select id,Store_Number__c from account order by createddate asc limit 1];
        a.Store_Number__c = '0011';
        update a;
        case c = new case();
        c.Status = 'New';
        c.Origin = 'Email';
        c.Subject = 'Internet carrier for Clinic 0011';
        c.accountid = a.id;
        insert c;
                
        Account ac = [Select id,Store_Number__c from account order by createddate desc limit 1];
        c.Is_Email_Send__c = true;
        c.accountid = ac.id;
        c.Assigned_Groups__c = 'Escalations';
        update c;
        
        Sub_Case__c s = [select id,Case__c,HRT_Stage__c from Sub_Case__c where Case__c =: c.id limit 1];
        Sub_Case__c t = new Sub_Case__c();
        t.id = s.id;
        t.HRT_Status__c = 'Completed';
        t.HRT_Carrier__c = 'test';
        t.HRT_Circuit_10__c = 'test';
        t.HRT_Circuit_Speed__c = 'test';
        t.HRT_Circuit_Type__c = 'test';
        t.HRT_Install_Date__c = system.today();
        t.HRT_Modem_Validation_Date__c = system.today();
        t.HRT_Support_Pin__c = 'test';
        t.HRT_Stage__c = '1 - Telecom Team';
        update t;
        
        t.HRT_Stage__c = '2 - Staging Team';
        t.HRT_Status__c = 'New';
        t.HRT_Is_Task_Completed__c = false;
        t.HRT_HW_Serial__c = 1; 
        t.HRT_HW_Name__c = 'test'; 
        t.HRT_CP_MAC__c = 'test'; 
        t.HRT_CP_IMEI__c = 'test'; 
        t.HRT_VZ_CARD__c =  1;
        t.HRT_HW_MAC__c = 'test'; 
        update t;
        
        t.HRT_Status__c = 'Completed';
        update t;
        
        test.stoptest();
    }
    
    static testmethod void Test2(){
        Test.starttest();
        Account a = [Select id,Store_Number__c from account order by createddate asc limit 1];
        a.Store_Number__c = '0011';
        update a;
        case c = new case();
        c.Status = 'New';
        c.Origin = 'Email';
        c.Subject = 'Internet carrier for Clinic 0011';
        c.accountid = a.id;
        insert c;
                
        Account ac = [Select id,Store_Number__c from account order by createddate desc limit 1];
        c.Is_Email_Send__c = true;
        c.accountid = ac.id;
        c.Assigned_Groups__c = 'Escalations';
        update c;
        
        Sub_Case__c s = [select id,Case__c,HRT_Stage__c from Sub_Case__c where Case__c =: c.id limit 1];
        Sub_Case__c t = new Sub_Case__c();
        t.id = s.id;
        t.HRT_Stage__c = '3 - Field Team';
        t.HRT_Is_Task_Completed__c = false;
        t.HRT_Status__c = 'New';
        t.HRT_P4_Install_Date__c = system.today();
        t.HRT_Cutover_Date__c = system.today();
        update t;
        
        t.HRT_Status__c = 'Completed';
        update t;
        
        t.HRT_Stage__c = '4 - Implementation Team I';
        t.HRT_Is_Task_Completed__c = false;
        t.HRT_Status__c = 'New';
        update t;
        
        t.HRT_Status__c = 'Completed';
        update t;
        
        test.stoptest();
    }

}