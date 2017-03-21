trigger SureTaxBilling on AcctSeed__Billing__c (after insert,before insert) {
        
    if(trigger.isAfter && trigger.isInsert){
        //SureTaxWarning.calculateTax(trigger.new[0].id);
    }
}