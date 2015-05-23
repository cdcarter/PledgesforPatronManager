@isTest
private class PledgeRollupTrigger_TEST {
	
	@isTest static void test_doesnt_fiddle_with_pledges() {
		Opportunity pledge = new Opportunity(RecordTypeId=UTIL_SharedCode.PledgeRecordTypeId(),
											Name='The Test Pledge',StageName='Pledged',
											CloseDate=Date.today(),Amount=500);
		insert pledge;
		pledge = [Select Id,Amount_Due__c,Number_of_payments__c FROM Opportunity
								Where Id =: pledge.Id];

		System.assertEquals(500,pledge.Amount_Due__c);
		Opportunity pledge2 = new Opportunity(RecordTypeId=UTIL_SharedCode.PledgeRecordTypeId(),
											Name='The Other Pledge',StageName='Pledged',
											CloseDate=Date.today(),Amount=600);

		insert pledge2;
		pledge = [Select Id,Amount_Due__c,Number_of_payments__c FROM Opportunity
								Where Id =: pledge.Id];
		
		System.assertEquals(500,pledge.Amount_Due__c);
	}

	@isTest static void test_basic_rollingup() {
		Opportunity pledge = new Opportunity(RecordTypeId=UTIL_SharedCode.PledgeRecordTypeId(),
											Name='The Test Pledge',StageName='Pledged',
											CloseDate=Date.today(),Amount=500);
		insert pledge;

		Opportunity payment1 = new Opportunity(RecordTypeId=UTIL_SharedCode.PledgePaymentRecordTypeId(),
												Name ='A payment',StageName='Posted',
												CloseDate=Date.today(),Amount = 20, Pledge__c = pledge.Id);
		insert payment1;

		pledge = [Select Id,Amount_Due__c,Number_of_payments__c FROM Opportunity
								Where Id =: pledge.Id];
		System.assertEquals(480,pledge.Amount_Due__c);
		System.assertEquals(1,pledge.Number_of_Payments__c);

		Opportunity payment2 = new Opportunity(RecordTypeId=UTIL_SharedCode.PledgePaymentRecordTypeId(),
												Name ='A payment2',StageName='Posted',
												CloseDate=Date.today(),Amount = 20, Pledge__c = pledge.Id);
		insert payment2;

		pledge = [Select Id,Amount_Due__c,Number_of_payments__c FROM Opportunity
						Where Id =: pledge.Id];


		System.assertEquals(460,pledge.Amount_Due__c);
		System.assertEquals(2,pledge.Number_of_Payments__c);

		payment2.Amount=50;
		update payment2;

		pledge = [Select Id,Amount_Due__c,Number_of_payments__c FROM Opportunity
						Where Id =: pledge.Id];


		System.assertEquals(430,pledge.Amount_Due__c);
		System.assertEquals(2,pledge.Number_of_Payments__c);

		delete payment1;

		pledge = [Select Id,Amount_Due__c,Number_of_payments__c FROM Opportunity
						Where Id =: pledge.Id];

		System.assertEquals(450,pledge.Amount_Due__c);
		System.assertEquals(1,pledge.Number_of_Payments__c);
	}

	@isTest static void test_dont_rollup_open() {
		Opportunity pledge = new Opportunity(RecordTypeId=UTIL_SharedCode.PledgeRecordTypeId(),
											Name='The Test Pledge',StageName='Pledged',
											CloseDate=Date.today(),Amount=500);
		insert pledge;

		Opportunity payment1 = new Opportunity(RecordTypeId=UTIL_SharedCode.PledgePaymentRecordTypeId(),
												Name ='A payment',StageName='Not Posted',
												CloseDate=Date.today(),Amount = 20, Pledge__c = pledge.Id);
		insert payment1;

		pledge = [Select Id,Amount_Due__c,Number_of_payments__c FROM Opportunity
								Where Id =: pledge.Id];
		System.assertEquals(500,pledge.Amount_Due__c);
		System.assertEquals(0,pledge.Number_of_Payments__c);
	}

	@isTest static void test_bulky() {
		Opportunity pledge = new Opportunity(RecordTypeId=UTIL_SharedCode.PledgeRecordTypeId(),
											Name='The Test Pledge',StageName='Pledged',
											CloseDate=Date.today(),Amount=10000);
		insert pledge;
		List<Opportunity> bulkOppty = new List<Opportunity>();
		Id paymentId = UTIL_SharedCode.PledgePaymentRecordTypeId();
		for(integer i = 0;i<2000;i++) {
			Opportunity oppty = new Opportunity(RecordTypeId=paymentId,
												Name ='A payment',StageName='Posted',
												CloseDate=Date.today(),Amount = 1, Pledge__c = pledge.Id);
			bulkOppty.add(oppty);
		}
		insert bulkOppty;

		pledge = [Select Id,Amount_Due__c,Number_of_payments__c FROM Opportunity
				Where Id =: pledge.Id];

		System.assertEquals(2000,pledge.Number_of_Payments__c);

	}
	
}