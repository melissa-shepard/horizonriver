trigger QuoteLineItemTrigger on QuoteLineItem (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
 QuoteLineItemTriggerHandler Cobj = new QuoteLineItemTriggerHandler();
        
    if(Trigger.Isinsert && Trigger.Isbefore){
        Cobj.Isinsert(Trigger.new);  
    }
}