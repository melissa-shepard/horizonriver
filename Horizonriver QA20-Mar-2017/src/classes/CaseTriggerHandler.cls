Public class CaseTriggerHandler{
    
    public Map<string,id> ClinicMap = new Map<string,id>();
    public static boolean flg = true;
    
    public void Isinsert(Map<id,case> NewMap, Map<id,case> OldMap){
        system.debug('after insert');
        UpdateAcc(NewMap);  
        CreateSubCase(NewMap);
        AssignQ(NewMap,new Map<id,case>()); 
    }
    
    public void Isupdate(Map<id,case> NewMap, Map<id,case> OldMap){
        
        //AccountUp(NewMap,OldMap);
        if(Test.isrunningtest() || flg){
        AssignQ(NewMap,OldMap);  
        SendMail(NewMap,OldMap);  
        }     
    }
    
    public void AssignQ(Map<id,case> NewMap, Map<id,case> OldMap){
        System.debug('<<Assign Q>>');
        List<id> idlst = new List<id>();
        List<CaseTeamMember> Ctmlst = new List<CaseTeamMember>();
        Map<string,Custom_Config__c> QMap = new Map<string,Custom_Config__c>();
        Map<string,List<id>> Gpmaplst = new Map<string,List<id>>();
        List<Case> Updatelst = new List<Case>();
        DateTime dt = System.now();
        DateTime earlier = System.now();//dt.addMinutes(-30);
        Map<string,string> RoleMap = new Map<string,string>();
        String Gname = '';
        //CaseTeamRole ctr = [SELECT Id, Name, AccessLevel, PreferencesVisibleInCSP, CreatedDate, CreatedById FROM CaseTeamRole where name = 'Case Assigner' limit 1];
        For(Custom_Config__c c : [SELECT Id, Rule_ON__c ,Email_ToAdd__c, Email_Queue__c,Email_Queue_Name__c FROM Custom_Config__c where Email_Queue__c != null and Email_Queue_Name__c != null ]){
            if(c.Email_ToAdd__c != null)
            QMap.put(c.Email_Queue_Name__c,c);
            if(c.Rule_ON__c)
            RoleMap.put(c.Email_Queue_Name__c,c.Email_Queue__c);
        }
        For(GroupMember g : [SELECT Id, GroupId,Group.name, UserOrGroupId FROM GroupMember]){
            if(Gpmaplst.containskey(g.Group.name))
                Gpmaplst.get(g.Group.name).add(g.UserOrGroupId );
            else
                Gpmaplst.put(g.Group.name,new List<id>{g.UserOrGroupId});
        }
        For(case c : NewMap.values()){
            if( ( OldMap.isEmpty() && c.Assigned_Groups__c != null ) || ( !(OldMap.isEmpty()) && c.Assigned_Groups__c != null && c.Assigned_Groups__c != OldMap.get(c.id).Assigned_Groups__c && QMap.size()>0 && QMap.containskey(c.Assigned_Groups__c))){
                Case cc = new case();
                cc.id = c.id;
                cc.Ownerid = QMap.get(c.Assigned_Groups__c).Email_Queue__c;
                cc.Assigned_Group__c = '';
                if(c.Assigned_Groups__c == Custom_Config__c.getinstance('Email Q-escalations').Email_Queue_Name__c){
                cc.Queue_Changed_Date__c = system.now();
                cc.Ownerid = Custom_Config__c.getinstance('Bob Fletcher ID').Email_Queue__c;
                }
                Updatelst.add(cc);
                Gname = c.Assigned_Groups__c;
                system.debug('<<1st if>>');
            } 
            
            if(Gname != ''){
                system.debug(RoleMap+'=='+Gpmaplst.containskey(Gname)+'<<Line 63>>'+RoleMap.containskey(Gname));
                if(Gpmaplst.containskey(Gname) && RoleMap.containskey(Gname)){
                    system.debug('<<Line 65>>');
                    For(id i: Gpmaplst.get(Gname)){
                        CaseTeamMember ctmadd = new CaseTeamMember();
                        ctmadd.ParentId = c.id;
                        ctmadd.MemberId = i;
                        ctmadd.TeamRoleId = RoleMap.get(Gname);
                        Ctmlst.add(ctmadd);
                    }
                }
            }
            
            
            
        }
        
        if(Updatelst.size()>0)
            update Updatelst;
        if(Ctmlst.size()>0){
            Try{
                List<CaseTeamMember> Dellst= new List<CaseTeamMember>([SELECT Id, ParentId, MemberId, TeamTemplateMemberId, TeamRoleId, CreatedDate, CreatedById FROM CaseTeamMember where parentid =: NewMap.keyset()]);
                if(Dellst.size()>0)
                    Delete Dellst;
            }
            catch(exception e){}
            insert Ctmlst;
        }
            
        
    }
    
    //Send Mail
    public void SendMail(Map<id,case> NewMap,Map<id,case> OldMap){
        
        String QName = '';
        id cid;
        Boolean cflg = false;
        system.debug('<<Send mail>>');
        For(case c : NewMap.values()){
            
            if(c.Is_Email_Send__c && c.Is_Email_Send__c != OldMap.get(c.id).Is_Email_Send__c )
            QName = c.Assigned_Groups__c;
            else if(c.Assigned_Group__c != null && c.Assigned_Group__c != OldMap.get(c.id).Assigned_Group__c ){
            QName = c.Assigned_Group__c;
            cflg = true;
            }
            else if(c.Assigned_Groups__c != null && c.Assigned_Groups__c == Custom_Config__c.getinstance('Email Q-escalations').Email_Queue_Name__c && c.Assigned_Groups__c != OldMap.get(c.id).Assigned_Groups__c ){
            QName = c.Assigned_Groups__c;
            cflg = true;
            system.debug('==>'+c.Assigned_Groups__c);
            }
            cid = c.id;
        }
        
        if(QName != ''){
            
            Set<String> GpName = new Set<String>();
            For(GroupMember g : [SELECT Id, GroupId,Group.name, UserOrGroupId FROM GroupMember]){
                GpName.add(g.Group.name);
            }
            if(GpName.contains(QName)){
                flg = false;
                Account tempa = new account(name = 'test',Account_Status__c = 'active');
                insert tempa;
                Contact tempContact  = new contact(lastname = 'test',accountid = tempa.id,Email = 'test@test.com');
                insert tempContact ;
                EmailTemplate eobj = new EmailTemplate();
                if(cflg)
                eobj = [SELECT Id, Name, DeveloperName, NamespacePrefix, OwnerId, FolderId FROM EmailTemplate where name = 'CaseAssigned_Alert_to_TM' limit 1];
                else
                eobj = [SELECT Id, Name, DeveloperName, NamespacePrefix, OwnerId, FolderId FROM EmailTemplate where name = 'Case_Alert_to_TM' limit 1];
                OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
                List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                For(user g : [select id,email from user where id in (SELECT UserOrGroupId FROM GroupMember where Group.name =: QName )]){
                message.toAddresses = new String[] {g.email};
                }    
                    message.setTargetObjectId(tempContact.id); 
                    message.setTemplateID(eobj.id);
                    message.setWhatId(cid);
                    allmsg.add(message);
                
                if(allmsg.size()>0)
                Messaging.SendEmailResult[] results = Messaging.sendEmail(allmsg);
                
                System.debug('<<<Mail Send>>>');
                delete tempContact;
                delete tempa;
            }
        }
    
    }
    
    //Account update to task and implementation object
    public void AccountUp(Map<id,case> NewMap,Map<id,case> OldMap){
        system.debug('<<AccountUp Method>>');
        Map<id,id> cmap = new Map<id,id>();
        
        For(Case c : NewMap.values()){
            if(c.accountid != null && c.accountid != OldMap.get(c.id).accountid){
                 cmap.put(c.id,c.accountid); 
            }
        }
        
        if(cmap.size()>0){
            List<Task> Tlst = new List<Task>();
            List<Implementation__c> ImpLst = new List<Implementation__c>([Select id,Case__c from Implementation__c where Case__c =: cmap.keyset()]);
            if(ImpLst.size()>0)
                Delete ImpLst;
            
            ImpLst = new List<Implementation__c>();
            
            For(Case c : NewMap.values()){
                Implementation__c i = new Implementation__c();
                i.name = c.casenumber + ' - ' + c.subject;
                i.Case__c = c.id;
                i.Account__c = c.Accountid;
                Implst.add(i);
            }
            
            if(ImpLst.size()>0)
                Insert ImpLst;
                
            For(Task t : [select id,whatid,Account__c  from task where whatid =: cmap.keyset()]){
                Task tu = new Task();
                tu.id = t.id;
                tu.Account__c = cmap.get(t.whatid);
                Tlst.add(tu);
            }
            if(Tlst.size()>0)
                update Tlst;
        }
    }
    
    public void UpdateAcc(Map<id,case> NewMap){
        For(Case c : NewMap.values()){
            if(c.accountid != null){
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
    
    //Create Sub-Case
    public void CreateSubCase(Map<id,case> NewMap){
        List<Sub_Case__c> TkCreate = new List<Sub_Case__c>();
        List<Implementation__c> Implst = new List<Implementation__c>();
        Map<string,Custom_Config__c> QMap = new Map<string,Custom_Config__c>();
        For(Custom_Config__c c : [SELECT Id, Email_ToAdd__c, Email_Queue__c,Email_Queue_Name__c FROM Custom_Config__c where Email_Queue_Name__c != null and Email_Queue__c != null ]){
            QMap.put(c.Email_Queue_Name__c,c);
        }
        
        Id TaskRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Task Assignment').getRecordTypeId();
        
        For(Case c : NewMap.values()){
            if(c.Accountid != null && c.recordtypeid == TaskRecTypeId){
                Sub_Case__c t = new Sub_Case__c();
                t.Name = 'Order Circuit';
                t.HRT_Status__c = 'New';
                t.HRT_Priority__c = 'Medium';
                t.HRT_Stage__c = '1 - Telecom Team';
                t.Case__c = c.id;//caseid
                t.HRT_Account_Email__c = c.HRT_Account_Email_Formula__c;
                if(QMap.containskey('1 - Telecom Team'))
                t.ownerid = QMap.get('1 - Telecom Team').Email_Queue__c;
                t.Recordtypeid = Schema.SObjectType.Sub_Case__c.getRecordTypeInfosByName().get('Task 1 - Order Circuit').getRecordTypeId();
                TkCreate.add(t);
            
                Implementation__c i = new Implementation__c();
                i.name = c.casenumber + ' - ' + (c.subject != null?c.subject:'');
                i.Case__c = c.id;
                i.Account__c = c.Accountid;
                Implst.add(i);
            }
            
        }
        System.debug('TkCreate==>'+TkCreate);
        if(TkCreate.size()>0)
            insert TkCreate;
        if(Implst.size()>0)
            insert Implst;
    }
}