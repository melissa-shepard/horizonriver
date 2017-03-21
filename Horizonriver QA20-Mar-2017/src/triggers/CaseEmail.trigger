trigger CaseEmail on EmailMessage (after insert, after update) {
   CaseEmail handler=new CaseEmail();
   if(Trigger.isAfter && Trigger.isinsert){
       handler.OnAfterInsert(Trigger.NewMap);
   }
}