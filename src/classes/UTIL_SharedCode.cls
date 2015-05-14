public with sharing class UTIL_SharedCode {
    public static Id PledgePaymentRecordTypeId() {
        return [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' 
        		AND DeveloperName = 'PledgePayment' LIMIT 1].Id;
    }

    public static Id PledgeRecordTypeId() {
        return [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' 
        		AND DeveloperName = 'Pledge' LIMIT 1].Id;
    }

    public static Opportunity newPaymentFromPledge(Opportunity pledge) {
        Opportunity opp = new Opportunity(RecordTypeId=PledgePaymentRecordTypeId());
        return opp;
    }
}