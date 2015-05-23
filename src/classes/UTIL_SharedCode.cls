global with sharing class UTIL_SharedCode {
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

        for (FieldSetMember fsm: SobjectType.Opportunity.FieldSets.Pledge_Payment_FS.getFields()) {
            if (pledge.get(fsm.getFieldPath()) != null) {
                opp.put(fsm.getFieldPath(), pledge.get(fsm.getFieldPath()));
            }
        }
        // and required fields.
        opp.Name = (String)pledge.account.name + ' Donation - ' + Date.today().format();
        opp.StageName = 'Posted';
        opp.PatronDonate__Check_Date__c = Date.today();
        opp.Pledge__c = pledge.Id;

        return opp;
    }

    @InvocableMethod(label='Set RecordType' description='Set an objects record type')
    global static List<Opportunity> SetOpportunityRecordType(List<SetRecordTypeRequest> reqs) {
        List<Opportunity> results = new List<Opportunity>();
        for (SetRecordTypeRequest req: reqs) {
            Id rt = [Select Id from RecordType WHERE SObjectType =: 'Opportunity'
                 AND DeveloperName =: req.recordTypeName LIMIT 1].Id;
            results.add(new Opportunity(Id=req.oppty, RecordTypeId = rt));
        }

        update results;
        return results;
    }

    global class SetRecordTypeRequest {
        @InvocableVariable(required=true)
        public String recordTypeName;

        @InvocableVariable(required=true)
        public Id oppty;
    }
}