@isTest(SeeAllData = True)
Public Class TaskTrigger_Test{

    static testmethod void TaskTriggerHandler(){
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
        update c;
                
        Task t1 = [select id,status,whatid from task where whatid =:c.id and whatid != null and status != 'Completed' limit 1];
        task t = new task();
        t.id = t1.id;
        t.status = 'Completed';
        t.HRT_Carrier__c = 'test';
        t.HRT_Circuit_10__c = 'test';
        t.HRT_Circuit_Speed__c = 'test';
        t.HRT_Circuit_Type__c = 'test';
        t.HRT_Install_Date__c = system.today();
        t.HRT_Modem_Validation_Date__c = system.today();
        t.HRT_Support_Pin__c = 'test';
        t.HRT_Stage__c = '1 - Telecom Team';
        update t;
        
        Task t2 = [select id,status,whatid,HRT_HW_Serial__c,HRT_HW_Name__c,HRT_CP_MAC__c,HRT_CP_IMEI__c,HRT_VZ_CARD__c,HRT_HW_MAC__c from task where HRT_Stage__c  = '2 - Staging Team' and whatid =:t1.whatid limit 1];
        t2.HRT_HW_Serial__c = 1; 
        t2.HRT_HW_Name__c = 'test'; 
        t2.HRT_CP_MAC__c = 'test'; 
        t2.HRT_CP_IMEI__c = 'test'; 
        t2.HRT_VZ_CARD__c =  1;
        t2.HRT_HW_MAC__c = 'test'; 
        t2.status = 'Completed';
        update t2;
        
        Task t3 = [select id,HRT_P4_Install_Date__c,status,whatid from task where HRT_Stage__c  = '3 - Field Team' and whatid =:t1.whatid limit 1];
        t3.HRT_P4_Install_Date__c = system.today();
        t3.status = 'Completed';
        update t3;
        
        Task t4 = [select id,status,whatid,HRT_Cutover_Date__c from task where HRT_Stage__c  = '4 - Implementation Team I' and whatid =:t1.whatid limit 1];
        t4.HRT_Cutover_Date__c = system.today();
        t4.status = 'Completed';
        update t4;
        
        Task t5 = [select id,HRT_Cutover_process_completion_date__c,status,whatid from task where HRT_Stage__c  = '5 - Implementation Team II' and whatid =:t1.whatid limit 1];
        t5.HRT_Cutover_process_completion_date__c = system.today();
        t5.status = 'Completed';
       // update t5;
        
        test.stoptest();
    }

}