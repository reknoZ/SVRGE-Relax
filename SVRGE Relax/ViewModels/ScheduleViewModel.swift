//
//  ScheduleViewModel.swift
//  SVRGE Relax
//
//  Created by Zicount on 12.03.23.
//

import Foundation

class ScheduleViewModel: ObservableObject {
	@Published var allMatches: [MatchInfo] = []
}
