/*
 * Created By: Satheesh B.
 * Created Date: May 15, 2021
 * Description: This Apex Class exposes method(s) that can be utilized by 
 * other Apex Classes to create Persistent Logs of type Error or
 * Information as opposed to native Debug Logs. 
*/
global class ApexDebugLog{
    /*
        A Virtual Class that Defines the 
        Structure of a Log
    */
    public virtual class Log{
        public String Type;
        public String Component;
        public String Method;

        public String RecordId;
        public String Message;
        public String StackTrace;
        public String strObject;
        public String Category;
        public String userMessage;
    }
    /*
        A Class that Extends the Virtual Class - Log
        to define a log of type - Error
    */
    public class Error extends Log{
        public Error(String cls, String routine, String recId, Exception ex, String obj, string usrMsg){
            this.Type = 'Error';
            this.Component = cls;
            this.Method = routine;
            this.RecordId = recId;
            this.Message = ex.getMessage();
            this.StackTrace = ex.getStackTraceString();
            this.strObject = obj;
            this.userMessage = usrMsg;
        }
        public Error(String cls, String routine, String recId, String exMsg, String stackTrace){
            this.Type = 'Error';
            this.Component = cls;
            this.Method = routine;
            this.RecordId = recId;
            this.Message = exMsg;
            this.StackTrace = stackTrace;
        }
        public Error(String cls, String routine, String recId, Exception ex, String Category, String obj, String usrMsg){
            this.Type = 'Error';
            this.Component = cls;
            this.Method = routine;
            this.RecordId = recId;
            this.Message = ex.getMessage();
            this.StackTrace = ex.getStackTraceString();
            this.Category = Category;
            this.strObject = obj;
            this.userMessage = usrMsg;
        }
        public Error(String cls, String routine, String recId, String exMsg, String stackTrace, String Category, String usrMsg){
            this.Type = 'Error';
            this.Component = cls;
            this.Method = routine;
            this.RecordId = recId;
            this.Message = exMsg;
            this.StackTrace = stackTrace;
            this.Category = Category;
            this.userMessage = usrMsg;
        }
    }
    /*
        A Class that Extends the Virtual Class - Log
        to define a log of type - Information
    */
    public class Information extends Log{
        public Information(String cls, String routine, String recId, String msg, String respId, String obj){
            this.Type = 'Information';
            this.Component = cls;
            this.Method = routine;
            this.RecordId = recId;
            this.Message = msg;
            this.StackTrace = respId;
            this.strObject = obj;
        }
        public Information(String cls, String routine, String recId, String msg, String Category, String respId, String obj){
            this.Type = 'Information';
            this.Component = cls;
            this.Method = routine;
            this.RecordId = recId;
            this.Message = msg;
            this.StackTrace = respId;
            this.Category = Category;
            this.strObject = obj;
        }
    }
    /*
        A Public Method that can be utilized by
        other Apex Classes to create a record into
        the Apex Debug Log object stating the Error
        or Information.
    */
    public String createLog(Log logToCreate){
        try{
            /*
                Ensure that we're well within the Governor Limits.
                The creation of the Log shouldn't disturb the execution
                of that Apex Class that utilizes this method to
                create a log.
            */
            if(
                (Limits.getDMLRows() < Limits.getLimitDMLRows()) && 
                (Limits.getDMLStatements() < Limits.getLimitDMLStatements())
            )
            {
                Apex_Debug_Log__c apexDebuglog = new Apex_Debug_Log__c(
                    Type__c         = logToCreate.Type,
                    Component__c   = logToCreate.Component,
                    Method__c       = logToCreate.Method,
                    Request_Id_Data__c    = logToCreate.RecordId,
                    Message__c      = logToCreate.Message,
                    Stack_Trace__c  = logToCreate.StackTrace,
                    Object__c		= logToCreate.strObject,
                 	User_Message__c = logToCreate.userMessage
                );

                Database.insert(apexDebuglog, FALSE);
                return apexDebuglog.Id;
            }
            else{
                System.debug('The Governor Limits have already been exhausted and hence failed to create a Log!');
            }
        }
        catch(DMLException ex){
            System.debug('Something fatal has occurred and hence failed to create a Log! Error:' + ex.getMessage());
        }
        return null;
    }    
}