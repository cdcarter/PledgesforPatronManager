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

	@isTest static void test_set_record_type() {
		Opportunity pledge = new Opportunity(RecordTypeId=UTIL_SharedCode.PledgeRecordTypeId(),
											Name='The Test Pledge',StageName='Pledged',
											CloseDate=Date.today(),Amount=500);
		insert pledge;

		UTIL_SharedCode.SetRecordTypeRequest req = new UTIL_SharedCode.SetRecordTypeRequest();
		req.oppty = pledge.Id;
		req.recordTypeName = 'MajorGift';
		UTIL_SharedCode.SetOpportunityRecordType(new List<UTIL_SharedCode.SetRecordTypeRequest>{req});
		pledge = [Select Id, RecordTypeId FROM Opportunity WHERE Id =: pledge.id];
		Id rtid = [Select Id From RecordType Where DeveloperName = 'MajorGift'].Id;
		System.assertEquals(rtid,pledge.RecordTypeId);

	}
	
	@isTest static void bulk_test_set_record_type()  {
		List<Opportunity> opptys = new List<Opportunity>();
		Id pledgeRT = UTIL_SharedCode.PledgeRecordTypeId();
		for(integer i = 0;i<2000;i++) {
			Opportunity pledge = new Opportunity(RecordTypeId = pledgeRT,
											Name='The Test Pledge' + i,StageName='Pledged',
											CloseDate=Date.today(),Amount=500);
			opptys.add(pledge);
		}
		insert opptys;
		List<UTIL_SharedCode.SetRecordTypeRequest> requests = new List<UTIL_SharedCode.SetRecordTypeRequest>();
		for(Opportunity opp: opptys) {
			UTIL_SharedCode.SetRecordTypeRequest req = new UTIL_SharedCode.SetRecordTypeRequest();
			req.oppty = opp.Id;
			req.recordTypeName = 'MajorGift';
			requests.add(req);
		}
		UTIL_SharedCode.SetOpportunityRecordType(requests);
		Opportunity pledge = [Select Id, RecordTypeId FROM Opportunity WHERE Id =: opptys[200].id];
		Id rtid = [Select Id From RecordType Where DeveloperName = 'MajorGift'].Id;
		System.assertEquals(rtid,pledge.RecordTypeId);
	}
}