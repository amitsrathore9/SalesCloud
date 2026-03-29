/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : LeadScoringController
 * Author          : Amit Singh Rathaur
 * Created Date    : Feb 27, 2026
 * Last Modified By: Amit Singh Rathaur
 * Last Modified On: Feb 27, 2026
 * Description     : This class implements for calculating lead score basis on its data.
 *  
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  Feb 27, 2026  │ Amit Singh Rathaur   │ Initial version
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

public class LeadScoringController {

	public static void scoreLead(List<Lead> leadList) {

		List<Task> taskList = new List<Task>();
		for(Lead ld : leadList){
			
			Integer score = 0;

			//Company Size
			if(ld.NumberOfEmployees != null && ld.NumberOfEmployees > 250){
				score +=30;
			}
			// Industry
			if (ld.Industry == 'IT') {
				score += 20;
			}

			// Budget
			if (ld.Budget__c != null && ld.Budget__c > 50000) {
				score += 25;
			}

			// Title
			if (ld.Title == 'Director' || ld.Title == 'CEO') {
				score += 15;
			}

			// Email Domain
			if (ld.Email != null && ld.Email.contains('@')) {
				String domain = ld.Email.substringAfter('@').toLowerCase();
				if (domain == 'gmail.com' || domain == 'yahoo.com') {
					score -= 10;
				}
			}

			ld.Score__c = score;

			if (score >= 80) {
				ld.QualificationStatus__c = 'Qualified';
				ld.Rating = 'Hot';

				Task tk = new Task();
				tk.Subject = 'Follow up with the Lead';
				tk.WhatId = ld.Id;
				tk.OwnerId = ld.OwnerId;
				tk.Priority = 'High';
				tk.Status = 'Not Started';
				taskList.add(tk);

			} else if (score >= 50) {
				ld.QualificationStatus__c = 'Qualified';
				ld.Rating = 'Warm';

				Task tk = new Task();
				tk.Subject = 'Follow up with the Lead';
				tk.WhatId = ld.Id;
				tk.OwnerId = ld.OwnerId;
				tk.Priority = 'Medium';
				tk.Status = 'Not Started';
				taskList.add(tk);
			} else {
				ld.QualificationStatus__c = 'Nurture';
				ld.Rating = 'Cold';
			}
		}

		insert taskList;
	}
}