// handler for trigger
public with sharing class OpportunityAmountUpdateHandler {
    
    public static void updateAccountAmount(Set<Id> accountsIds){
        Map<Id, Decimal> idVsAmountMap = new Map<Id, Decimal>();
        for(AggregateResult ar: [SELECT AccountId, SUM(Amount) totalAmount
                                        FROM Opportunity
                                        WHERE AccountId IN: accountsIds
                                        GROUP BY AccountId]){
            idVsAmountMap.put(
                (Id)ar.get('AccountId'), 
                (Decimal) ar.get('totalAmount')
            );

        }
        List<Account> accountsToUpdate = new List<Account>();
        for(Id accountId: idVsAmountMap.keySet()){
            accountsToUpdate.add(new Account(
                Id = accountId,
                Amount__c = idVsAmountMap.get(accountId)
            ));
        }
        update accountsToUpdate;

    }
    public static void createtask(Set<Id> opportunityOwnerIdSet){
        List<Task> taskToInsert = new List<Task>();
        try {
            // create task records
            for(Id ownerId: opportunityOwnerIdSet){
                // 1. Initialize a new Task object
                Task taskObj = new Task();

                // 2. Populate required and custom fields
                taskObj.Subject = 'Follow-up Call with Client';
                taskObj.Status = 'Not Started';              // Standard statuses: Not Started, In Progress, Completed
                taskObj.Priority = 'Normal';                 // Standard priorities: High, Normal, Low
                taskObj.ActivityDate = Date.today().addDays(3); // Set due date to 3 days from now
                taskObj.Description = 'Call the client to discuss the updated project proposal.';
                taskObj.OwnerId = ownerId;
                taskToInsert.add(taskObj);
            }
            
            insert taskToInsert;
        } catch (DmlException e) {
            System.debug('An error occurred while creating the task: ' + e.getMessage());
        }
    }
}