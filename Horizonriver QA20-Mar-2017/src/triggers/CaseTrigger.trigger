trigger CaseTrigger on Case (after insert, after update) {
    Set<ID> caseIds = new Set<ID>();
    for(Case item : trigger.New){
        if(item.Status == 'Closed'){
            caseIds.add(item.Id);
        }
    }
    if(caseIds.size() > 0){
        Task[] lstTasks = [Select id, status from Task where WhatId IN :caseIds AND Status != 'Completed'];
        for(Task item : lstTasks){
            item.Status = 'Completed';
        }
        Update lstTasks;        
    }    
}