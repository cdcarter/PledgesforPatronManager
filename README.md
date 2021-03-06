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
* Rollups between `Pledges` and `PledgePayments`
* A button to create pledgepayments off of pledges.
* Two useful reports that show as of any given date, the status of all open pledges, as well as the book value of your contributions. 

What you should do to use it:
* Assure that your PledgePayment recordtype is NOT included in any rollups. Check in Organizational Settings as well as actual rollup definitions on Account.
  * This involves contacting PatMan and tweaking `PatronDonate__First_Donation_Date__c`, `PatronDonate__Last_Donation_Date__c`, `PatronDonate__Lifetime_Donation_History_Amount__c`, `PatronDonate__Lifetime_Donation_History_Number__c`, and `PatronDonate__This_Year_Donation_History_Amount__c`.
  * Let the author note that those rollups are weird out-of-the-box anyway, and should probably not be used without first adjusting them with PatronManager CLient Support to meet your Organizations reporting requirements. 
* Know that Pledge donations SHOULD be rolled up in all cases. Pledges will be considered closed/won, because we want to accrue them.
* Know that there is a Process you can activate that will take Opportunities with pledge__c set and turn them into PledgePayments. There's an override checkbox too, only visible to Admins.

TODO:
* Docs
* Batch process (and maybe scheduled job) to rollup any pledges
* Better writeoff handling -- the standard Amount field on the Pledge should be Pledged Amount less any writeoff. This means we need to add a Pledged_Amount__c field, a trigger to update Amount, rework the formula for Amount_Due__c, and the formula for Pledge_Amount__c on Payments, and of course the rollups!
* A writeoff report, and new stages (Paid in Full, Partially Written Off, Partially Paid, Lost).
* Open Pledge Report don't show closed pledges. 
