//
//  Stats.swift
//  SVRGe
//
//  Created by Zicount on 27.02.23.
//

import Foundation

struct Stats: Identifiable {
	var id = UUID().uuidString
	var bestOf: Int
	var name = ""
	var matchesWon = 0
	var matchesWonInTieBreak = 0
	var matchesLost = 0
	var matchesLostInTieBreak = 0
	var setsWon = 0
	var setsLost = 0
	var pointsWon = 0
	var pointsLost = 0
	
	var normalWins : Int { matchesWon - matchesWonInTieBreak }
	var normalLosses : Int { matchesLost - matchesLostInTieBreak }
	
	var standingsPoints: Int {
		bestOf == 3 ? 3 * matchesWon : 3*normalWins + 2*matchesWonInTieBreak + matchesLostInTieBreak
	}
	
	var standingsPointsString: String { "\(standingsPoints)" }
	
	var totalMatches: Int { matchesWon + matchesLost }
	
	var totalMatchesString: String { "\(totalMatches)" }
	
	static func + (lhs: Stats, rhs: Stats) -> Stats {
		var result = lhs
		
		result.setsWon += rhs.setsWon
		result.setsLost += rhs.setsLost
		
		result.pointsWon += rhs.pointsWon
		result.pointsLost += rhs.pointsLost
		
		result.matchesWon += rhs.matchesWon
		result.matchesLost += rhs.matchesLost
		
		result.matchesWonInTieBreak += rhs.matchesWonInTieBreak
		result.matchesLostInTieBreak += rhs.matchesLostInTieBreak
		
		return result
	}
}
