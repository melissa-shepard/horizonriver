trigger TaskTrigger on Task (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    TaskTriggerHandler Cobj = new TaskTriggerHandler();
        
    if(Trigger.Isupdate && Trigger.Isafter){
        //Cobj.Isupdate(Trigger.newmap,Trigger.oldmap);  
    }
      
}