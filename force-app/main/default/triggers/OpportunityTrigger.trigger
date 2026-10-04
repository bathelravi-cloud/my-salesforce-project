// trigger on opportunity object
//Q1. Update amount field on Account which will be aggregrate of their related opportunity
//Q2. Auto-create a Task for the owner when an Opportunity moves to "Closed Won".
trigger OpportunityTrigger on  Opportunity (after insert, after update, after delete, after undelete) {
    // 
    Set<Id> accountIdSet = new Set<Id>();
    Set<Id> opportunityOwnerIdSet = new Set<Id>();
    if(trigger.isInsert || trigger.isUndelete){
        for(Opportunity opp: trigger.new){
            accountIdSet.add(opp.Account.Id);
        }
    }
    // if is update 
    if(trigger.isUpdate){
        for(Opportunity opp: trigger.new){
            Opportunity oldOpp = trigger.oldMap.get(opp.Id);
            //check if the stage of opportunity moved to closed won
            if((opp.StageName != oldOpp.StageName) && opp.StageName == 'Closed Won'){
                opportunityOwnerIdSet.add(opp.OwnerId);
            }
            // if opportunity related account change or if the ammount change on opportunity
            if(opp.Account.Id != oldOpp.Account.Id){
                // if the related account as not null
                if(opp.Account.Id!= null){
                    accountIdSet.add(opp.Account.Id);
                }
                // if the existing was not null
                if(oldOpp.Account.Id!= null){
                    accountIdSet.add(oldOpp.Account.Id);
                }
                
            } else if(opp.Amount != oldOpp.Amount){
                accountIdSet.add(opp.Account.Id);
            }
        }
    }
    // if delete
    if(trigger.isDelete){
        for(Opportunity opp: trigger.old){
            if(opp.Account.Id != null){
                 accountIdSet.add(opp.Account.Id);
            }
        }
    }
    // update Amount on Account
    OpportunityAmountUpdateHandler.updateAccountAmount(accountIdSet);
    // create related task record when opportunity moved to closed won
    OpportunityAmountUpdateHandler.createtask(opportunityOwnerIdSet);

}