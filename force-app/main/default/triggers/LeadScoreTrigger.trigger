trigger LeadScoreTrigger on Lead(before insert) {

	if(Trigger.isInsert){
		LeadScoringController.scoreLead(Trigger.new);
	}
}