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
	
}