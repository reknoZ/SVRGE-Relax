//
//  ScheduleView.swift
//  SVRGE Relax
//
//  Created by Zicount on 23.02.23.
//

import SwiftUI

struct ScheduleView: View {
	@Binding var global: GlobalVariables
	@EnvironmentObject var viewModel: ScheduleViewModel
	
	var body: some View {
		VStack {
			FilterView(global: $global, matchesCount: viewModel.filteredMatches(for: global).count)
			
			List(viewModel.filteredMatches(for: global)) { scheduledMatch in
				ScheduleRow(match: scheduledMatch)
			}
			.listStyle(.plain)
		}
	}
}

struct ScheduleView_Previews: PreviewProvider {
	static var previews: some View {
		ScheduleView(global: .constant(GlobalVariables()))
	}
}
