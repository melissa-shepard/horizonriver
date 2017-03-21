trigger CaseTriggers on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    CaseTriggerHandler Cobj = new CaseTriggerHandler();
        
    if(Trigger.Isinsert && Trigger.Isafter){
        Cobj.Isinsert(Trigger.newmap,Trigger.oldmap);       
    }     
}