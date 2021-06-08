@isTest
public class ApexDebugLog_Test{
    testMethod
    static void createErrorLog(){
        try{
            Integer result = 1 / 0;
        }
        catch(Exception ex){
            ApexDebugLog adLog = new ApexDebugLog();
            adLog.createLog(
                new ApexDebugLog.Error(
                    'ApexDebugLog_Test',
                    'createErrorLog',
                    NULL,
                    ex,
                    'Account'
                )
            );
            
            adLog.createLog(
                new ApexDebugLog.Error(
                    'ApexDebugLog_Test',
                    'createErrorLog',
                    NULL,
                    ex,
                    'Internal',
                    'Account'
                )
            );
            
            adLog.createLog(
                new ApexDebugLog.Error(
                    'ApexDebugLog_Test',
                    'createErrorLog',
                    'Test',
                    'TestMsg',
                    null
                )
            );
            
            adLog.createLog(
                new ApexDebugLog.Error(
                    'ApexDebugLog_Test',
                    'createErrorLog',
                    'Request JSON Captured here',
                    'Internal',
                    'Response JSON Captured Here',
                    'Account'
                )
            );

            List<Apex_Debug_Log__c> lstLogsCreated = [
                SELECT  Id, Type__c, Component__c, Method__c
                FROM    Apex_Debug_Log__c
                WHERE   Method__c = 'createErrorLog'
            ];

            System.assertEquals(4, lstLogsCreated.size());
        }
    }

    testMethod
    static void createInformationLog(){
        new ApexDebugLog().createLog(
            new ApexDebugLog.Information(
                'ApexDebugLog_Test',
                'createInformationLog',
                'Request JSON captured Here',
                'Logging Information from an Apex Class - Message',
                'Information',
                'Account'
            )
        );
        
        new ApexDebugLog().createLog(
            new ApexDebugLog.Information(
                'ApexDebugLog_Test',
                'createInformationLog',
                'Request JSON captured Here',
                'Logging Information from an Apex Class - Message',
                'Information',
                'Response JSON message captured here',
                'Account'
            )
        );

        List<Apex_Debug_Log__c> lstLogsCreated = [
            SELECT  Id, Type__c, Component__c, Method__c, Message__c
            FROM    Apex_Debug_Log__c
            WHERE   Method__c = 'createInformationLog'
        ];

        System.assertEquals(2, lstLogsCreated.size());
        System.assertEquals('Information', lstLogsCreated.get(0).Type__c);
        System.assertEquals('ApexDebugLog_Test', lstLogsCreated.get(0).Component__c);
        System.assertEquals('Logging Information from an Apex Class - Message', lstLogsCreated.get(0).Message__c);
    }
}