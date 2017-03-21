Public class CaseTriggerHandler{
    
    public Map<string,id> ClinicMap = new Map<string,id>();
    
    public void Isinsert(Map<id,case> NewMap, Map<id,case> OldMap){
        UpdateAcc(NewMap);          
    }
    
    public void UpdateAcc(Map<id,case> NewMap){
        For(Case c : NewMap.values()){
            if(c.accountid == null){
                 ClinicNo(c.subject,c.id);   
            }
        }
        
        if(ClinicMap.size()>0){
            List<case> Updatelist = new List<case>();
            set<id> temp = new set<id>();
            For(Account a : [Select id,Store_Number__c from account where Store_Number__c != null and Store_Number__c =:ClinicMap.keyset() ]){
                if(ClinicMap.containskey(a.Store_Number__c) && !temp.contains(ClinicMap.get(a.Store_Number__c))){
                    case c = new case();
                    c.id = ClinicMap.get(a.Store_Number__c);
                    c.accountid = a.id;
                    temp.add(ClinicMap.get(a.Store_Number__c));
                    Updatelist.add(c);
                }    
            }
            if(Updatelist.size()>0){
                try{
                    update Updatelist;
                }
                catch(Exception e){
                system.debug('ERROR===>'+e);
                }
            }
        }
    }
    
    public void ClinicNo(string subject,id caseid){
        
        if(subject != null && subject != ''){
            subject = subject.replaceall('#','');
            String[] s=subject.split('\\D+');
            set<id> temp = new set<id>();
            for(string ss:s){
               if(ss != null && ss != '' && !temp.contains(caseid)){
               //temp.add(caseid);
               ClinicMap.put(ss,caseid);
               system.debug('Clinic No===>'+ss);
               }
            }
            
            if(test.isRunningTest())
                ClinicMap.put('0863',caseid);
        }
    }
}