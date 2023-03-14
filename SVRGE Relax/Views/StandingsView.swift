//
//  StandingsView.swift
//  SVRGE Relax
//
//  Created by Zicount on 23.02.23.
//

import SwiftUI

struct StandingsView: View {
	@Binding var global: GlobalVariables
	@EnvironmentObject var viewModel: ScheduleViewModel
	
	var body: some View {
		VStack {
			FilterView(global: $global, matchesCount: viewModel.completedMatches(for: global).count)
			
			if (viewModel.completedMatches(for: global).count > 0) {
				List {
					HStack {
						Text ("#")
							.frame(width: 20)
						Text ("Team")
						Spacer ()
						Group {
							Text ("GP")
							Text ("Pts")
							Text ("W")
							Text ("L")
						}
					}
					.fontWeight(.bold)
					
					ForEach(selectedStandings().enumerated().map {$0}, id: \.element.name) { i, standings in
						HStack {
							Text ("\(i+1)").alignmentGuide(.gp) { d in d[HorizontalAlignment.trailing] }
								.frame(width: 20)
							Text (standings.name)
								.font(.subheadline)
							Spacer()
							Group {
								Text ("\(standings.totalMatches)")
								Text ("\(standings.standingsPoints)")
								Text ("\(standings.matchesWon)")
								Text ("\(standings.matchesLost)")
							}
							.alignmentGuide(.gp) { d in d[HorizontalAlignment.trailing] }
							.font(.caption2)
							.frame(width: 25)
						}
					}
					.listStyle(.plain)
				}
				.listStyle(.plain)
			} else {
				Spacer()
				Text ("Data unavailable")
				Spacer()
			}
		}
	}
	
	func selectedStandings() -> [Standings] {
		let standings = viewModel.standings(for: global)
		
		var mergedStandings = [String: Standings]()
		
		for standing in standings {
			if let mergedStanding = mergedStandings[standing.name.lowercased()] {
				// If the name is already in the dictionary, merge the standings
				mergedStandings[standing.name.lowercased()] = mergedStanding + standing
			} else {
				// If the name is not in the dictionary, add the standing to the dictionary
				mergedStandings[standing.name.lowercased()] = standing
			}
		}
		
		// Convert the dictionary back to an array
		let mergedStatsArray = Array(mergedStandings.values)
		
		return mergedStatsArray.sorted(by: { ($0.standingsPoints, $0.matchesWon) > ($1.standingsPoints, $1.matchesWon) } )
	}
}

struct StandingsView_Previews: PreviewProvider {
	static var previews: some View {
		StandingsView(global: .constant(GlobalVariables()))
			.environmentObject(ScheduleViewModel())
	}
}

extension HorizontalAlignment {
	enum GP: AlignmentID {
		static func defaultValue(in context: ViewDimensions) -> CGFloat {
			context[.trailing]
		}
	}
	
	static let gp = HorizontalAlignment(GP.self)
}

