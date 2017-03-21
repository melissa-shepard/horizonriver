trigger SubCaseTrigger on Sub_Case__c  (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	SubCaseTriggerHandler Cobj = new SubCaseTriggerHandler();
        
    if(Trigger.Isupdate && Trigger.Isafter){
        Cobj.Isupdate(Trigger.newmap,Trigger.oldmap);  
    }
}