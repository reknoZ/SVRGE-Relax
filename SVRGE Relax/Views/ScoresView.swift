//
//  ScoresView.swift
//  SVRGE Relax
//
//  Created by Zicount on 10.11.22.
//

import SwiftUI

struct ScoresView: View {
	@Binding var global: GlobalVariables
	@EnvironmentObject var viewModel: ScheduleViewModel

	var body: some View {
		VStack {
			FilterView(global: $global, matchesCount: viewModel.completedMatches(for: global).count)
			
			List (viewModel.completedMatches(for: global)) { matchResult in
				VStack (alignment: .leading) {
					Text(matchResult.date.toString(withFormat: "dd MMM"))
						.foregroundColor(.red)
						.padding(.top)
					
					HStack {
						VStack(alignment: .leading) {
							Text (matchResult.homeTeamName)
								.bold(matchResult.homeTeamWon)
							Text (matchResult.awayTeamName)
								.bold(!matchResult.homeTeamWon)
						}
						
						Spacer()
						
						SetsView(matchSets: matchResult.matchSets)
						
						VStack {
							Text ("\(matchResult.homeSetsWon)")
								.bold(matchResult.homeTeamWon)
								.foregroundColor(matchResult.homeTeamWon ? .green : .red)
							Text ("\(matchResult.awaySetsWon)")
								.bold(!matchResult.homeTeamWon)
								.foregroundColor(matchResult.homeTeamWon ? .red : .green)
						}
						.font(.caption)
						.frame(width: 30)
						
					}
				}
			}
			.listStyle(.plain)
		}
	}
}

struct SetsView: View {
	var matchSets: [MatchSet]
	
	var body: some View {
		HStack {
			ForEach(matchSets) { matchSet in
				VStack {
					Text ("\(matchSet.homeScore)")
						.bold(matchSet.homeTeamWon)
						.foregroundColor(matchSet.homeTeamWon ? .green : .red)
					Text ("\(matchSet.awayScore)")
						.bold(!matchSet.homeTeamWon)
						.foregroundColor(matchSet.homeTeamWon ? .red : .green)
				}
				.font(.caption)
			}
		}
	}
}

struct ScoresView_Previews: PreviewProvider {
	static var previews: some View {
		ScoresView(global: .constant(GlobalVariables()))
	}
}
