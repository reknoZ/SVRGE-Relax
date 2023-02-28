//
//  Standings.swift
//  SVRGE Relax
//
//  Created by Zicount on 23.02.23.
//

import Foundation

struct Standings {
	var ranking = 0
	var teamName: String = ""

	var rankingsPoints = 0

	var winPlus = 0
	var winMinus = 0 // 3:2
	var lossPlus = 0
	var lossMinus = 0 // 2:3

	var setsWon = 0
	var setsLost = 0
	
	var playedPointsWon = 0
	var playedPointsLost = 0
	
	var matchCount = 0
}
