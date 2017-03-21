@isTest(SeeAllData = true)
public class SmartSheetUpdateSchedular_Test{
    static testmethod void Method1(){
        Test.StartTest();
            SmartSheetUpdateSchedular  c;
            c = new SmartSheetUpdateSchedular ();
            String sch = '0 0 * * * ?';
            System.schedule('SmartSheetUpdate1', sch, c);    
            //SmartSheetView  sobj = new SmartSheetView();
            //SmartSheetView.SSDatas();
        Test.StopTest();
        
    }
}