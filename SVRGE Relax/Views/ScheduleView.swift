//
//  ScheduleView.swift
//  SVRGE Relax
//
//  Created by Zicount on 23.02.23.
//

import SwiftUI

struct ScheduleView: View {
	@Binding var global: GlobalVariables
	
	var body: some View {
		NavigationView {
			VStack {
				FilterView(global: $global)

				Text ("\(filteredMatches(for: global).count) matches")
				
				List(filteredMatches(for: global)) { scheduledMatch in
					ScheduleRow(match: scheduledMatch)
				}
			}
			.navigationTitle ("Schedule")
		}
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
		ScheduleView(global: .constant(GlobalVariables()))
    }
}
