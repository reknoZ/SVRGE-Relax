//
//  GlobalVariables.swift
//  SVRGE Relax
//
//  Created by Zicount on 26.02.23.
//

import Foundation

struct GlobalVariables {
	var league: Leagues = .relax
	var category: Categories = .womens
	var division: Divisions = .fa
	
	mutating func foobar() {
		switch category {
			case .womens:
				division = .fa
			case .mens:
				division = .ha
			case .mixed:
				division = .xa
		}
	}
}
