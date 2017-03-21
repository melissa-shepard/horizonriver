Public class TaskTriggerHandler{
    
    Public Static boolean flg = true;
    
    public void Isupdate(Map<id,Task> NewMap, Map<id,Task> OldMap){
        if(Test.isrunningtest() || flg){
        CreateTask(NewMap,OldMap);   
        UpdateImp(NewMap);    
        }     
    }
    
    //update Implementation
    public void UpdateImp(Map<id,Task> NewMap){
        List<id> cid = new List<id>();
        For(Task c : NewMap.values()){
            cid.add(c.whatid);
        }
        
        Map<id,id> impmap = new Map<id,id>();
        For(Implementation__c i : [Select id,Case__c from Implementation__c where Case__c =: cid]){
            impmap.put(i.Case__c,i.id);
        }
        
        if(impmap.size()>0){
            List<Implementation__c> implst = new List<Implementation__c>();
            Set<id> temp = new Set<id>();
            Implementation__c i = new Implementation__c(); 
            For(Task c : NewMap.values()){
                
                   
                    if(c.HRT_Stage__c == '1 - Telecom Team'){
                        i.Carrier__c = c.HRT_Carrier__c;
                        i.Circuit_10__c = c.HRT_Circuit_10__c;
                        i.Circuit_Speed__c = c.HRT_Circuit_Speed__c;
                        i.Circuit_Type__c = c.HRT_Circuit_Type__c;
                        i.Install_Date__c = c.HRT_Install_Date__c;
                        i.Modem_Validation_Date__c = c.HRT_Modem_Validation_Date__c;
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
                    if(impmap.containskey(c.whatid) && !(temp.contains(c.whatid))){
                        i.id = impmap.get(c.whatid);
                        temp.add(c.whatid);
                        
                    }
            }
            implst.add(i);
            
            if(implst.size()>0)
                update implst;
        }
  }
    
    //Task: Case Management - Task Creation
    public void CreateTask(Map<id,Task> NewMap, Map<id,Task> OldMap){
        flg = false;
        List<Task> TkCreate = new List<Task>();
        List<Case> CaseUpdate= new List<Case>();
        For(Task c : NewMap.values()){
            if( (c.Status == 'Completed' && c.Status != OldMap.get(c.id).Status   && string.valueof(c.whatid).startsWith('500') )){
                Task t = new Task();
                Case s = new Case();
                t.Status = 'New';
                t.Priority = 'Medium';
                if(c.HRT_Stage__c == '1 - Telecom Team'){
                t.Subject = 'Order Submit to Warehouse';
                t.HRT_Stage__c = '2 - Staging Team';
                t.Recordtypeid = TaskRecortypeID__c.getinstance('Staging Team').Record_Type_ID__c;
                s.HRT_Case_Stage__c = '2 - Staging Team';
                }
                if(c.HRT_Stage__c == '2 - Staging Team'){
                t.Subject = 'CS Tech Integration Submission - Get SR';
                t.HRT_Stage__c = '3 - Field Team';
                t.Recordtypeid = TaskRecortypeID__c.getinstance('CS Tech Integration Sub').Record_Type_ID__c;
                s.HRT_Case_Stage__c = '3 - Field Team';
                }
                if(c.HRT_Stage__c == '3 - Field Team'){
                t.Subject = 'CS Tech';
                t.HRT_Stage__c = '4 - Implementation Team I';
                t.Recordtypeid = TaskRecortypeID__c.getinstance('CS Tech').Record_Type_ID__c;
                s.HRT_Case_Stage__c = '4 - Implementation Team I';
                }
                if(c.HRT_Stage__c == '4 - Implementation Team I'){
                t.Subject = 'Review Survey Results';
                t.HRT_Stage__c = '5 - Implementation Team II';
                t.Recordtypeid = TaskRecortypeID__c.getinstance('Review Survey Results').Record_Type_ID__c;
                s.HRT_Case_Stage__c = '5 - Implementation Team II';
                }
                if(c.HRT_Stage__c == '5 - Implementation Team II'){
                s.Reason = 'All Task Completed';
                s.Status = 'Closed';
                }
                t.whatid = c.whatid;//caseid
                s.id = c.whatid;
                t.ownerid = '00541000001R7bT';
                t.Account__c = c.Account__c;
                TkCreate.add(t);
                CaseUpdate.add(s);
            }
        }
        
        if(TkCreate.size()>0)
            insert TkCreate;
        if(CaseUpdate.size()>0)
            update CaseUpdate;    
    
        
    }
}