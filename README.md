# Pledges for PatronManager

Pledges for PatronManager is a program to build out better pledge tracking for users of PatronManager CRM. 

We assume:
* that your organization operates on an accrual basis
* that you book in your finances the full value of a pledge when it is pledged
* that you might recieve multiple payments against that pledge
* that your development department wants to track the dates that payments are made

What this project consists of:
* An Opportunity RecordType for `Pledges`
  * custom fields to track amount due on the pledge, number of payments, etc...
* An Opportunity RecordType for `PledgePayments`
  * Check Date represents payment date.
* Rollups between `Pledges` and `PledgePayments`
* Useful reporting structure

What you should do to use it:
* Assure that your PledgePayment recordtype is NOT included in any rollups. Check in Organizational Settings as well as actual rollup definitions on Account.
  * This involves contacting PatMan and tweaking `PatronDonate__First_Donation_Date__c`, `PatronDonate__Last_Donation_Date__c`, `PatronDonate__Lifetime_Donation_History_Amount__c`, `PatronDonate__Lifetime_Donation_History_Number__c`, and `PatronDonate__This_Year_Donation_History_Amount__c`.
  * Let the author note that those rollups are quite freaking annoying anyway, and should probably not be used without first adjusting them with PatronManager CLient Support to meet your Organizations reporting requirements. 
* Know that Pledge donations SHOULD be rolled up in all cases. Pledges will be considered closed/won, because we want to accrue them.
* Know that there is a Process you can activate that will take Opportunities with pledge__c set and turn them into PledgePayments. There's an override checkbox too, only visible to Admins.

TODO:
* Reports
  * All open pledges with status as of a given date.
  * Donations including pledged amts but not payments as of a given date.
* Docs
