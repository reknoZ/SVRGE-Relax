//
//  ScoresView.swift
//  SVRGE Relax
//
//  Created by Zicount on 10.11.22.
//

import SwiftUI

struct ScoresView: View {
	@Binding var global: GlobalVariables
	
	var body: some View {
		VStack {
			FilterView(global: $global)
			
			Text ("\(filteredMatches(for: global).filter { $0.matchComplete()}.count) matches")
			
			List {
				ForEach(filteredMatches(for: global)) { matchResult in
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
								Text ("\(matchResult.awaySetsWon)")
									.bold(!matchResult.homeTeamWon)
							}
							.frame(width: 30)
							
						}
					}
				}
			}
		}
		.navigationTitle ("Scores")
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
					Text ("\(matchSet.awayScore)")
						.bold(!matchSet.homeTeamWon)
				}
				.font(.subheadline)
			}
		}
	}
}

struct ScoresView_Previews: PreviewProvider {
	static var previews: some View {
		ScoresView(global: .constant(GlobalVariables()))
	}
}
