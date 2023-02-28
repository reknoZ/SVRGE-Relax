//
//  ScheduleRow.swift
//  SVRGE Relax
//
//  Created by Zicount on 24.02.23.
//

import SwiftUI

struct ScheduleRow: View {
	var match: MatchInfo
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text (match.date.toString(withFormat: "E dd.MM.yyyy @ HH:mm"))
					.foregroundColor(.red)
					.bold()
				Spacer()
				Text (match.matchNumber)
			}
			HStack {
				Text (match.homeTeamName)
					.bold()
				Spacer()
				Text (match.awayTeamName)
			}
			Text (match.location)
		}
	}
}

struct ScheduleRow_Previews: PreviewProvider {
	static var previews: some View {
		ScheduleRow(match: MatchInfo(location: "Gymnase de Divonne, allée Saint Exupéry, 01220 Divonne-les-Bains, France", matchNumber: "11071", homeTeamName: "Blackfrogs", awayTeamName: "Champelles Volley", matchSets: [MatchSet(homeScore: 13, awayScore: 25), MatchSet(homeScore: 12, awayScore: 25), MatchSet(homeScore: 19, awayScore: 25)]))
	}
}
