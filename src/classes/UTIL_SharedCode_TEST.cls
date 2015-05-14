@isTest
private class UTIL_SharedCode_TEST {
	// this is kind of a silly test, but it is mildy useful and makes sure that I didn't go crazy.
	// ...plus...coverage.
	@isTest static void test_pledge_RT() {
		Id pledgeRt = UTIL_SharedCode.PledgeRecordTypeId();
		String name = [Select Name From RecordType Where Id =: pledgeRt].Name;
		System.assertEquals('Pledge',name);
	}
	
	@isTest static void test_payment_RT() {
		Id pay = UTIL_SharedCode.PledgePaymentRecordTypeId();
		String name = [Select Name From RecordType Where Id =: pay].Name;
		System.assertEquals('PledgePayment',name);
	}

	@isTest static void test_new_payment() {
		Account acc = new Account(Name='Test');
		insert acc;
		Contact con = new Contact(AccountId= acc.id, Lastname='Blah');
		insert con;
		Opportunity pledge = new Opportunity(RecordTypeId=UTIL_SharedCode.PledgeRecordTypeId(),
											Name='The Test Pledge',StageName='Pledged',
											CloseDate=Date.today(),Amount=500,
											PatronDonate__Fund__c='Annual Fund',
											PatronDonate__FiscalYearApplied__c = '2014',
											PatronDonate__DonationSource__c = 'Mail',
											Type = 'General',
											PatronDonate__Donor__c = con.Id,
											PatronDonate__Anonymous__c=false,
											AccountId = acc.Id);
		insert pledge;

		Opportunity oppty = UTIL_SharedCode.newPaymentFromPledge(pledge);
		System.assertEquals(pledge.CloseDate,oppty.CloseDate);
		System.assertEquals(pledge.AccountId,oppty.AccountId);

		List<String> fieldNames = new List<String>();
		for (FieldSetMember fsm: SobjectType.Opportunity.FieldSets.Pledge_Payment_FS.getFields()) {
			fieldNames.add(fsm.getFieldPath());
		}

		if ((new Set<String>(fieldNames)).contains('PatronDonate__Fund__c')) {
			System.assertEquals(pledge.PatronDonate__Fund__c,oppty.PatronDonate__Fund__c);
		}
	}
	
}