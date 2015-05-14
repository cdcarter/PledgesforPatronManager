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


TODO:
* Reports
* Docs
* Error Handling