//
//  MatchInfo.swift
//  SVRGE Relax
//
//  Created by Zicount on 23.02.23.
//

import Foundation

enum Categories: String, Codable, CaseIterable, Identifiable {
	case womens = "Womens"
	case mens = "Mens"
	case mixed = "Mixed"
	
	var id: String {
		return self.rawValue.capitalized
	}
}

enum Leagues: String, Codable, Identifiable, CaseIterable {
	case championship = "Championnat"
	case junior = "Junior"
	case relax = "Relax"
	
	var id: String {
		return self.rawValue.capitalized
	}
}

enum Divisions: String, Identifiable, Codable, CaseIterable {
	// relax
	case fa, fb, fc
	case ha, hb, hc, hd
	case xa, xb, xc, xd
	
	var id: String {
		return self.rawValue.uppercased()
	}
}

var allMatches: [MatchInfo] = []

func filteredMatches(for global: GlobalVariables) -> [MatchInfo] {
	return allMatches
		.filter { $0.league == global.league }
		.filter { $0.category == global.category }
		.filter { $0.division == global.division }
		.sorted()
}

func completedMatches(for global: GlobalVariables) -> [MatchInfo] {
	return filteredMatches(for: global).filter { $0.matchComplete() }
}

struct MatchInfo: Identifiable, Comparable {
	var id: String { "\(season)-\(matchNumber)" }
	
	var season = ""							// "2022-2023"
	var date: Date = Date()					// date and time
	var location = ""						// name of venue, plus address
	var league = Leagues.relax				// Relax
	var category = Categories.womens		// Womens
	var division = Divisions.fa				// FA
	var matchNumber: String					// 31014
	
	var homeTeamName = ""					// OMM - 2
	var awayTeamName = ""					// P.V.I.
	
	var matchSets: [MatchSet] = []			// 21/25-25/15-18/25-19/25

	//MARK: Computed properties
	var bestOf: Int { league == .junior ? 3 : 5}
	
	var homeSetsWon: Int { matchSets.filter {$0.homeScore > $0.awayScore}.count }
	var awaySetsWon: Int { matchSets.filter {$0.homeScore < $0.awayScore}.count }
	
	var homePointsScored: Int { matchSets.reduce(0) { $0 + $1.homeScore } }
	var awayPointsScored: Int { matchSets.reduce(0) { $0 + $1.awayScore } }
	
	var homeTeamWon: Bool { homeSetsWon > awaySetsWon }
	var awayTeamWon: Bool { homeSetsWon < awaySetsWon }
	
	var homeTiebreakWin: Bool { homeSetsWon - awaySetsWon == 1 }
	var awayTiebreakWin: Bool { awaySetsWon - homeSetsWon == 1 }
	
	var homeStandingsPoints: Int { homeTeamWon ? (homeTiebreakWin ? 2 : 3) : (awayTiebreakWin ? 1 : 0) }
	var awayStandingsPoints: Int { awayTeamWon ? (awayTiebreakWin ? 2 : 3) : (homeTiebreakWin ? 1 : 0) }

	func matchComplete() -> Bool {
		bestOf == 3
			? (homeSetsWon == 2 || awaySetsWon == 2)
			: (homeSetsWon == 3 || awaySetsWon == 3)
	}
	
	static func < (lhs: MatchInfo, rhs: MatchInfo) -> Bool {
		return lhs.date.timeIntervalSince(rhs.date) < 0
	}
	
	static func == (lhs: MatchInfo, rhs: MatchInfo) -> Bool {
		return lhs.date == rhs.date
	}
	
	mutating func updateWithScoresInfo(from newMatch: MatchInfo) {
		if matchNumber == newMatch.matchNumber {
			matchSets = newMatch.matchSets
		}
	}
}

func standings(for global: GlobalVariables) -> [Standings] {
	let matches = completedMatches(for: global)
	
	var standings: [Standings] = []
	
	for match in matches.filter ({ $0.matchSets.count != 0}) {
		let bestOf = match.bestOf
		
		// Home Team
		var matchesWon = match.homeTeamWon ? 1 : 0
		var matchesLost = matchesWon == 1 ? 0 : 1
		
		var tieBreakWin = match.homeTiebreakWin ? 1 : 0
		var tieBreakLoss = match.awayTiebreakWin ? 1 : 0
		
		var pointsWon = match.matchSets.reduce(0) { $0 + $1.homeScore }
		var pointsLost = match.matchSets.reduce(0) { $0 + $1.awayScore }
		
		standings.append(Standings(bestOf: bestOf, name: match.homeTeamName, matchesWon: matchesWon, matchesWonInTieBreak: tieBreakWin, matchesLost: matchesLost, matchesLostInTieBreak: tieBreakLoss, setsWon: match.homeSetsWon, setsLost: match.awaySetsWon, pointsWon: pointsWon, pointsLost: pointsLost))
		
		// Away Team
		matchesWon = match.homeTeamWon ? 0 : 1
		matchesLost = matchesWon == 1 ? 0 : 1
		
		tieBreakWin = match.awayTiebreakWin ? 1 : 0
		tieBreakLoss = match.homeTiebreakWin ? 1 : 0
		
		pointsWon = match.matchSets.reduce(0) { $0 + $1.awayScore }
		pointsLost = match.matchSets.reduce(0) { $0 + $1.homeScore }
		
		standings.append(Standings(bestOf: bestOf, name: match.awayTeamName, matchesWon: matchesWon, matchesWonInTieBreak: tieBreakWin, matchesLost: matchesLost, matchesLostInTieBreak: tieBreakLoss, setsWon: match.awaySetsWon, setsLost: match.homeSetsWon, pointsWon: pointsWon, pointsLost: pointsLost))
	}
	
	return standings.sorted(by: { ($0.standingsPoints, $0.matchesWon) > ($1.standingsPoints, $1.matchesWon) })
}
