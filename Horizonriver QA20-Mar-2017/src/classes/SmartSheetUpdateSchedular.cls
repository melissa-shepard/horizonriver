public with sharing class SmartSheetUpdateSchedular implements Schedulable
{
    public void execute(SchedulableContext ctx) {
        SmartSheetView.SSDatas();  
    }
}