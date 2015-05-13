public with sharing class PledgesExtension {

	private final Opportunity opp;

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public PledgesExtension(ApexPages.StandardController stdController) {
        List<String> fields = new List<String> {'Type',
                                    'PatronDonate__Fund__c',
                                    'PatronDonate__FiscalYearApplied__c',
                                    'PatronDonate__DonationSource__c',
                                    'CloseDate',
                                    'CampaignId',
                                    'Account',
                                    'PatronDonate__Donor__c',
                                    'Account.Name',
                                    'PatronDonate__Check_Date__c'};
        stdController.addFields(fields); //also probablu should be a FS
        this.opp = (Opportunity)stdController.getRecord();
    }

    public PageReference NewPledgePayment() {
        Opportunity pledge = this.opp;
        Opportunity newPayment = new Opportunity(RecordTypeId=UTIL_SharedCode.PledgePaymentRecordTypeId());
        
        // copy over relevant details -- this should probably be a fieldset
        newPayment.type = pledge.type;
        newPayment.PatronDonate__Fund__c = pledge.PatronDonate__Fund__c;
        newPayment.PatronDonate__FiscalYearApplied__c = pledge.PatronDonate__FiscalYearApplied__c;
        newPayment.PatronDonate__DonationSource__c = pledge.PatronDonate__DonationSource__c;
        newPayment.CloseDate = pledge.CloseDate;
        newPayment.CampaignId = pledge.CampaignId;
        newPayment.AccountId = pledge.AccountId;
        if (pledge.PatronDonate__Donor__c != NULL) {
            newPayment.PatronDonate__Donor__c = pledge.PatronDonate__Donor__c;
        }

        // and required fields.
        newPayment.Name = (String)pledge.account.name + ' Donation - ' + Date.today().format();
        newPayment.StageName = 'Posted';
        newPayment.PatronDonate__Check_Date__c = Date.today();
        newPayment.Pledge__c = pledge.Id;
        insert newPayment;

        PageReference opptyPage = new ApexPages.StandardController(newPayment).view();
        opptyPage.setRedirect(true);
        return opptyPage;
    }

}