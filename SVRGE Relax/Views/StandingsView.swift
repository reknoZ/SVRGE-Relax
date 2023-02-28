//
//  StandingsView.swift
//  SVRGE Relax
//
//  Created by Zicount on 23.02.23.
//

import SwiftUI

extension HorizontalAlignment {
	enum GP: AlignmentID {
		static func defaultValue(in context: ViewDimensions) -> CGFloat {
			context[.trailing]
		}
	}
	
	static let gp = HorizontalAlignment(GP.self)
}

struct StandingsView: View {
	@Binding var global: GlobalVariables
	
	var body: some View {
		VStack {
			FilterView(global: $global)

			if (filteredMatches(for: global).filter { $0.matchComplete()} .count > 0) {
				List {
					Group {
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
					}
					.fontWeight(.bold)
					
					ForEach(selectedStats().enumerated().map {$0}, id: \.element.name) { i, stats in
						HStack {
							Text ("\(i+1)").alignmentGuide(.gp) { d in d[HorizontalAlignment.trailing] }
								.frame(width: 20)
							Text (stats.name)
							Spacer()
							Group {
								Text ("\(stats.totalMatches)")
								Text ("\(stats.standingsPoints)")
								Text ("\(stats.matchesWon)")
								Text ("\(stats.matchesLost)")
							}
							.alignmentGuide(.gp) { d in d[HorizontalAlignment.trailing] }
							.font(.caption)
							.frame(width: 20)
						}
						//						HStack {
						//							Text (stats.matchesWon)
						//							Text (stats.normalWins)
						//							Text (stats.matchesWonInTieBreak)
						//							Text (stats.matchesLost)
						//							Text (stats.normalWins)
						//							Text (stats.matchesWonInTieBreak)
						//						}
					}
					.listStyle(.plain)
				}
			} else {
				Spacer()
				Text ("Data unavailable")
				Spacer()
			}
		}
		.onAppear { global.foobar() }
	}
	
	func selectedStats() -> [Stats] {
		let stats = standings(for: global)
		
		var mergedStats = [String: Stats]()
		
		for stat in stats {
			if let mergedStat = mergedStats[stat.name] {
				// If the name is already in the dictionary, merge the stats
				mergedStats[stat.name] = mergedStat + stat
			} else {
				// If the name is not in the dictionary, add the stat to the dictionary
				mergedStats[stat.name] = stat
			}
		}
		
		// Convert the dictionary back to an array
		let mergedStatsArray = Array(mergedStats.values)
		
		return mergedStatsArray.sorted(by: { ($0.standingsPoints, $0.matchesWon) > ($1.standingsPoints, $1.matchesWon) } )
	}
}

struct StandingsView_Previews: PreviewProvider {
    static var previews: some View {
		StandingsView(global: .constant(GlobalVariables()))
    }
}
