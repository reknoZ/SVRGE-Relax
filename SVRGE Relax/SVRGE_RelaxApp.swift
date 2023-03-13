//
//  SVRGE_RelaxApp.swift
//  SVRGE Relax
//
//  Created by Zicount on 10.11.22.
//

import SwiftUI

// TODO: upload the data to Firebase for posterity.
// TODO: switch between different seasons
// TODO: track teams arcoss seasons

@main
struct SVRGE_RelaxApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
				.environmentObject(ScheduleViewModel())
        }
    }
}
