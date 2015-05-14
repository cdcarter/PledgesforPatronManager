trigger PledgeRollupTrigger on Opportunity (after insert, after update, after delete) {
	Set<Id> pledgeIds = new Set<Id>();
	List<Opportunity> oppsToUpdate = new List<Opportunity>();

	for(Opportunity opp : trigger.isDelete ? trigger.Old : trigger.new){
		pledgeIds.add(opp.Pledge__c);
	}

	List<Opportunity> allPayments = [Select Id,Name,Amount,PatronDonate__Check_Date__c,Pledge__c
									 From Opportunity WHERE Pledge__c IN :pledgeIds];

	Map<Id,Opportunity[]> pledgeMap = new Map<Id,Opportunity[]>();

	for (Opportunity payment :allPayments) {
		if(pledgeMap.containsKey(payment.Pledge__c)) {
			pledgeMap.get(payment.Pledge__c).add(payment);
		} else {
			pledgeMap.put(payment.Pledge__c,new List<Opportunity> {payment});
		}
	}

	for (Id pledgeId : pledgeMap.keySet()) {
		List<Opportunity> ppayments = pledgeMap.get(pledgeId);
		Decimal paid = 0;
		Integer payments = 0;

		for (Opportunity payment : ppayments) {
			if(payment.Amount != null) {
				paid = (paid + payment.Amount);
				payments = (payments + 1);
			}
		}
		if (pledgeId!=null) {
			Opportunity pledge = new Opportunity(Id=pledgeId,
											Amount_Paid__c=paid,
											Number_of_Payments__c=payments);
			oppsToUpdate.add(pledge);
		}
	}
	update oppsToUpdate;
}