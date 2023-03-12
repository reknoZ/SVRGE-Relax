//
//  FilterView.swift
//  SVRGe
//
//  Created by Zicount on 17.02.23.
//

import SwiftUI

struct FilterView: View {
	@Binding var global: GlobalVariables
	var matchesCount: Int
	
	var body: some View {
		Group {
			HStack(alignment: .top) {
				Image("svrge-logo")
					.resizable()
					.scaledToFit()
					.frame(height: 80)
					.padding(.leading)
				Spacer()
				VStack(alignment: .trailing) {
					Text ("Ver: \(Bundle.main.cleanReleaseVersion)")
					Text ("\(matchesCount) matches")
				}
				.padding(.horizontal)
				.font(.caption)
			}
			
			Picker ("Gender", selection: $global.category) {
				ForEach(Categories.allCases) {
					Text ($0.id).tag($0)
				}
			}
			.pickerStyle(SegmentedPickerStyle())
			
			switch global.category {
				case .womens:
					Picker ("Women's Leagues", selection: $global.division) {
						Text ("FA").tag(Divisions.fa)
						Text ("FB").tag(Divisions.fb)
						Text ("FC").tag(Divisions.fc)
					}
					.pickerStyle(SegmentedPickerStyle())

				case .mens:
					Picker ("Men's Leagues", selection: $global.division) {
						Text ("HA").tag(Divisions.ha)
						Text ("HB").tag(Divisions.hb)
						Text ("HC").tag(Divisions.hc)
						Text ("HD").tag(Divisions.hd)
					}
					.pickerStyle(SegmentedPickerStyle())

				case .mixed:
					Picker ("Mixed Leagues", selection: $global.division) {
						Text ("XA").tag(Divisions.xa)
						Text ("XB").tag(Divisions.xb)
						Text ("XC").tag(Divisions.xc)
						Text ("XD").tag(Divisions.xd)
					}
					.pickerStyle(SegmentedPickerStyle())

			}
		}
		.padding(.horizontal)
		.onChange(of: global.category) { _ in global.foobar() }
		.onChange(of: global.league) { _ in global.foobar() }
	}
}

struct FilterView_Previews: PreviewProvider {
	static var previews: some View {
		FilterView(global: .constant(GlobalVariables()), matchesCount: 5)
	}
}
