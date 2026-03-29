/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : OpportunityHealthService
 * Author          : <Amit Singh>
 * Created Date    : Mar 2, 2026
 * Last Modified By: <Amit>
 * Last Modified On: Mar 2, 2026
 * Description     : This class implements for check critical opportunity.
 *  
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  Mar 2, 2026  │ <Amit>   │ Initial version
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

public class OpportunityHealthService implements Schedulable {

	public static String CRON_EXP = '0 0 * * *';

	public void execute(SchedulableContext ctx) {
		List<Opportunity> oppList = [SELECT Id,Name,StageName,CloseDate, LastActivityDate FROM Opportunity WHERE CloseDate > TODAY AND IsClosed = FALSE];
		if(!oppList.isEmpty()){
			Map<Id,Opportunity> oppMapIdVsOpp = new Map<Id,Opportunity>(oppList);

			List<OpportunityFieldHistory> oppHistoryList = [SELECT CreatedDate,Field,OldValue,OpportunityId, NewValue FROM OpportunityFieldHistory WHERE Field = 'StageName' AND OpportunityId IN: oppMapIdVsOpp.Keyset() ORDER BY CreatedDate DESC];
			
			Map<Id,OpportunityFieldHistory> oppIdVsOppHistoryMap = new Map<Id,OpportunityFieldHistory>();
			
			for(OpportunityFieldHistory history : oppHistoryList){
				if(!oppIdVsOppHistoryMap.containsKey(history.OpportunityId)){
					oppIdVsOppHistoryMap.put(history.OpportunityId,history);
				}
			}

			for(Opportunity opp : oppList){
				Integer  score = 0;

				//score based on LastActivity
				if(opp.LastActivityDate != null){
					Integer daysDifference = opp.LastActivityDate.daysBetween(Date.today());
					if(daysDifference > 14){
						score += 10;
					}else if(daysDifference < 14 && daysDifference > 7){
						score += 20;
					}else if(daysDifference < 7){
						score += 30;
					}
				}

				//score based on stageChange
				if(oppIdVsOppHistoryMap.containsKey(opp.Id) && oppIdVsOppHistoryMap.get(opp.Id).CreatedDate != null){
					Date fieldsChangeDate = oppIdVsOppHistoryMap.get(opp.Id).CreatedDate.Date();
					Integer fieldChangeDateDiff = fieldsChangeDate.daysBetween(Date.today());
					if(fieldChangeDateDiff >= 14){
						score += 10;
					}else if(fieldChangeDateDiff < 14 && fieldChangeDateDiff >= 7){
						score += 20;
					}else if(fieldChangeDateDiff < 7){
						score += 30;
					}
				}

				//score based on CloseDate
				if(opp.CloseDate != null){
					Integer closeDateDiff = Date.today().daysBetween(opp.CloseDate);
					if(closeDateDiff >= 14){
						score += 30;
					}else if(closeDateDiff < 14 && closeDateDiff >= 7){
						score += 20;
					}else if(closeDateDiff < 7 && closeDateDiff > 0 ){
						score += 10;
					}else {
						score-=10;
					}
				}

				if(score >= 50){
					opp.Risk_Status__c = 'Healthy';
				}else if(score < 50 && score >= 30){
					opp.Risk_Status__c = 'Watch';
				}else if(score < 30){
					opp.Risk_Status__c = 'At Risk';
				}
			}

			update oppList;
		}
	}
}