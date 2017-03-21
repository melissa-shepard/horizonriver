Public class SubCaseTriggerHandler{
    
    Public Static boolean flg = true;
    
    public void Isupdate(Map<id,Sub_Case__c> NewMap, Map<id,Sub_Case__c> OldMap){
        if(Test.isrunningtest()|| flg){
        UpdateImp(NewMap);
        CreateTask(NewMap,OldMap);   
        }     
    }
    
    //update Implementation
    public void UpdateImp(Map<id,Sub_Case__c> NewMap){
        List<id> cid = new List<id>();
        For(Sub_Case__c c : NewMap.values()){
            cid.add(c.Case__c);
        }
        
        Map<id,id> impmap = new Map<id,id>();
        For(Implementation__c i : [Select id,Case__c from Implementation__c where Case__c =: cid]){
            impmap.put(i.Case__c,i.id);
        }
        
        if(impmap.size()>0){
            List<Implementation__c> implst = new List<Implementation__c>();
            Set<id> temp = new Set<id>();
            Implementation__c i = new Implementation__c(); 
            For(Sub_Case__c c : NewMap.values()){
                
                   
                    if(c.HRT_Stage__c == '1 - Telecom Team'){
                        i.Carrier__c = c.HRT_Carrier__c;
                        i.Circuit_10__c = c.HRT_Circuit_10__c;
                        i.Circuit_Speed__c = c.HRT_Circuit_Speed__c;
                        i.Circuit_Type__c = c.HRT_Circuit_Type__c;
                        i.Install_Date__c = c.HRT_Install_Date__c;
                        i.Modem_Validation_Date__c = c.HRT_Modem_Validation_Date__c;
                        i.Support_Pin__c = c.HRT_Support_Pin__c;
                    }
                    if(c.HRT_Stage__c == '2 - Staging Team'){
                        i.CP_MAC__c = c.HRT_HW_MAC__c;
                        i.HW_Name__c = c.HRT_HW_Name__c;
                        i.HW_Serial__c = c.HRT_HW_Serial__c;
                        i.CP_IMEI__c = c.HRT_CP_IMEI__c;
                        i.HW_MAC__c = c.HRT_CP_MAC__c;
                        i.VZ_CARD__c = c.HRT_VZ_CARD__c;
                    }
                    if(c.HRT_Stage__c == '3 - Field Team'){
                        i.P4_Install_Date__c = c.HRT_P4_Install_Date__c;
                    }
                    if(c.HRT_Stage__c == '4 - Implementation Team I'){
                        i.Cutover_Date__c = c.HRT_Cutover_Date__c;
                        i.Site_Survey__c = c.HRT_Site_Survey__c;
                    }
                    if(c.HRT_Stage__c == '5 - Implementation Team II'){
                        i.Cutover_Process_Completion_Date__c = c.HRT_Cutover_process_completion_date__c;
                    }
                    if(impmap.containskey(c.Case__c) && !(temp.contains(c.Case__c))){
                        i.id = impmap.get(c.Case__c);
                        temp.add(c.Case__c);
                        
                    }
            }
            implst.add(i);
            
            if(implst.size()>0)
                update implst;
        }
  }
    
    //Task: Case Management - Task Creation
    public void CreateTask(Map<id,Sub_Case__c> NewMap, Map<id,Sub_Case__c> OldMap){
        flg = false;
        List<Sub_Case__c> TkCreate = new List<Sub_Case__c>();
        List<Case> CaseUpdate= new List<Case>();
        List<Case> CaseUpdate2= new List<Case>();
        Map<string,Custom_Config__c> QMap = new Map<string,Custom_Config__c>();
        For(Custom_Config__c c : [SELECT Id, Email_ToAdd__c, Email_Queue__c,Email_Queue_Name__c FROM Custom_Config__c where Email_Queue_Name__c != null and Email_Queue__c != null ]){
            QMap.put(c.Email_Queue_Name__c,c);
        }
        
        For(Sub_Case__c c : NewMap.values()){
            
            
            if(c.HRT_Stage__c == '1 - Telecom Team' && c.HRT_Status__c != 'New' && c.HRT_Status__c!= OldMap.get(c.id).HRT_Status__c){
            Case s = new Case();
            s.id = c.Case__c;
            s.status = 'InProgress';
            CaseUpdate2.add(s);
            }
            
        
            if(c.HRT_Status__c== 'Completed' && c.HRT_Status__c!= OldMap.get(c.id).HRT_Status__c){
                system.debug('==>'+c.name);
                Sub_Case__c t = new Sub_Case__c();
                Case s = new Case();
                t.HRT_Status__c = 'New';
                t.HRT_Priority__c = 'Medium';
                if(c.HRT_Stage__c == '1 - Telecom Team'){
                    t.Name = 'Order Submit to Warehouse';
                    t.HRT_Stage__c = '2 - Staging Team';
                    t.Recordtypeid = Schema.SObjectType.Sub_Case__c.getRecordTypeInfosByName().get('Task 2 - Staging Team').getRecordTypeId();
                    s.HRT_Case_Stage__c = '2 - Staging Team';
                    if(QMap.containskey('2 - Staging Team'))
                    t.ownerid = QMap.get('2 - Staging Team').Email_Queue__c;
                    t.HRT_Account_Email__c = c.HRT_Account_Email__c;
                }
                if(c.HRT_Stage__c == '2 - Staging Team'){
                    t.Name = 'CS Tech Integration Submission - Get SR';
                    t.HRT_Stage__c = '3 - Field Team';
                    t.Recordtypeid = Schema.SObjectType.Sub_Case__c.getRecordTypeInfosByName().get('Task 3 - CS Tech Integration Sub').getRecordTypeId();
                    s.HRT_Case_Stage__c = '3 - Field Team';
                    if(QMap.containskey('3 - Field Team'))
                    t.ownerid = QMap.get('3 - Field Team').Email_Queue__c;
                    t.HRT_Account_Email__c = c.HRT_Account_Email__c;
                }
                if(c.HRT_Stage__c == '3 - Field Team'){
                    t.Name = 'CS Tech';
                    t.HRT_Stage__c = '4 - Implementation Team I';
                    t.Recordtypeid = Schema.SObjectType.Sub_Case__c.getRecordTypeInfosByName().get('Task 4 - CS Tech').getRecordTypeId();
                    s.HRT_Case_Stage__c = '4 - Implementation Team I';
                    if(QMap.containskey('4 - Implementation Team I'))
                    t.ownerid = QMap.get('4 - Implementation Team I').Email_Queue__c;
                    t.HRT_Account_Email__c = c.HRT_Account_Email__c;
                }
                if(c.HRT_Stage__c == '4 - Implementation Team I'){
                    t.name = 'Review Survey Results';
                    t.HRT_Stage__c = '5 - Implementation Team II';
                    t.Recordtypeid = Schema.SObjectType.Sub_Case__c.getRecordTypeInfosByName().get('Task 5 - Review Survey Results').getRecordTypeId();
                    s.HRT_Case_Stage__c = '5 - Implementation Team II';
                    if(QMap.containskey('5 - Implementation Team II'))
                    t.ownerid = QMap.get('5 - Implementation Team II').Email_Queue__c;
                    t.HRT_Account_Email__c = c.HRT_Account_Email__c;
                }
                if(c.HRT_Stage__c == '5 - Implementation Team II'){
                    s.Reason = 'All Task Completed';
                    s.Status = 'Closed';
                }
                t.Case__c = c.Case__c ;//caseid
                s.id = c.Case__c;
                if(!(c.HRT_Stage__c == '5 - Implementation Team II'))
                TkCreate.add(t);
                CaseUpdate.add(s);
            }
        }
        
        if(TkCreate.size()>0)
            insert TkCreate;
        if(CaseUpdate.size()>0)
            update CaseUpdate;  
        if(CaseUpdate2.size()>0)
            update CaseUpdate2;  
    
        
    }
}