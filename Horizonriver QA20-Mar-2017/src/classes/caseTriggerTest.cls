@isTest
public class caseTriggerTest {
    static testMethod void closeTaskTest(){
        Case newCase = new Case();
        newCase.Status='Closed';
        newCase.Origin='Email';
       
        insert newCase;
       
    }
}