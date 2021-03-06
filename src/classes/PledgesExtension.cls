public with sharing class PledgesExtension {

    private final Opportunity opp;

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public PledgesExtension(ApexPages.StandardController stdController) {
        List<String> fields = new List<String>();
        for(FieldSetMember fsm:SobjectType.Opportunity.FieldSets.Pledge_Payment_FS.getFields()) {
            fields.add(fsm.getFieldPath());
        }
        fields.add('Account.Name');
        stdController.addFields(fields); //also probablu should be a FS
        this.opp = (Opportunity)stdController.getRecord();
    }

    public PageReference NewPledgePayment() {
        Opportunity newPayment;
        try {
            newPayment = UTIL_SharedCode.newPaymentFromPledge(this.opp);
            insert newPayment;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Payment Creation Failed'));
            newPayment = this.opp;
        }
        

        PageReference opptyPage = new ApexPages.StandardController(newPayment).view();
        return opptyPage;
    }

}