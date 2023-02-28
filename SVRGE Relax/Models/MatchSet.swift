//
//  MatchSet.swift
//  SVRGE Relax
//
//  Created by Zicount on 26.02.23.
//

import Foundation

struct MatchSet: Codable, Identifiable {
	var id = UUID().uuidString
	var homeScore: Int
	var awayScore: Int
	
	var homeTeamWon: Bool { homeScore > awayScore }
}
