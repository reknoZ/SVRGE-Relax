//
//  MainView.swift
//  SVRGE Relax
//
//  Created by Zicount on 23.02.23.
//

import SwiftUI
import SwiftSoup

let relaxScheduleURLString = "https://svrge.org/Cale_new.php"
let relaxScoresURLString = "https://www.svrge.org/Resu_new.php"

struct MainView: View {
	@State var global = GlobalVariables()
	@EnvironmentObject var viewModel: ScheduleViewModel
	
	var body: some View {
		TabView {
			ScheduleView(global: $global)
				.tabItem {
					Label ("Schedule", systemImage: "calendar")
				}
			
			ScoresView(global: $global)
				.tabItem {
					Label ("Scores", systemImage: "exclamationmark.circle")
				}

			StandingsView(global: $global)
				.tabItem {
					Label ("Standings", systemImage: "person.3")
				}
		}
		.task {
			await fetchSchedule()
			await updateWithScores()
		}
	}
	
	func fetchSchedule() async {
		guard let requestURL = URL(string: relaxScheduleURLString) else { fatalError("Incorrect URL") }
		var request = URLRequest(url: requestURL)
		request.httpMethod = "POST"

		for division in Divisions.allCases {
			request.httpBody = "vlili=\(division.id)".data(using: String.Encoding.utf8)
			
			let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
				// Check for Error
				if let error = error {
					print("Error took place \(error)")
					return
				}
				
				if let data = data, let html = String(data: data, encoding: .utf8) {
					do {
						let document = try SwiftSoup.parse(html)
						if let scoresTable = try document.select(".cal_table").first() {
							
							let rows = try scoresTable.select("tr")
							let _ = rows.dropFirst() // the header row is only <tr> not <th>
							for row in rows.array() {
								
								let columns = try row.select("td")
								if columns.count == 6 { // VALIDATION 1
									let matchNumber = try columns[0].text()
									
									let homeTeam = try columns[1].text()
									let awayTeam = try columns[2].text()
									
									var dateString = try columns[3].text()
									
									if dateString != "Date" { // VALIDATION 2: not the header row
										let monthDictionary = [
											"Jan": "01", "Fév": "02", "Mars": "03",
											"Avr": "04", "Mai": "05", "Juin": "06",
											"Sept": "09",
											"Oct": "10", "Nov": "11", "Déc": "12"
										]
										
										var dateStringElements = dateString.components(separatedBy: "-")
										if dateStringElements[0] != "00" { // VALIDATION 3
											if let month = monthDictionary[dateStringElements[1]] { // VALIDATION 4: array conversion successful
												dateStringElements[1] = month
												dateString = dateStringElements.joined(separator: ".")
												
												var timeString = try columns[4].text()
												
												let address = try columns[5].text()
												
												if timeString.count == 2 {
													timeString = timeString + "h00"
												}
												
												if timeString.count == 3 {
													timeString = timeString + "00"
												}
												
												timeString = timeString.prefix(2) + ":" + timeString.suffix(2)
												
												if let dateTime = "\(dateString) \(timeString)".toDate() { // VALIDATION 5: date is valid
													
													var category = Categories.womens
													switch division {
														case .fa, .fb, .fc: category = .womens
														case .ha, .hb, .hc, .hd: category = .mens
														case .xa, .xb, .xc, .xd: category = .mixed
													}
													
													let scheduledMatch = MatchInfo(season: "2022-2023", date: dateTime, location: address, category: category, division: division, matchNumber: matchNumber, homeTeamName: homeTeam, awayTeamName: awayTeam)
													
													DispatchQueue.main.async {
														viewModel.allMatches.append(scheduledMatch)
													}
												}
											}
										}
									}
								}
							}
						}
					} catch {
						print ("Error")
					}
				}
			}
			task.resume()
		}
	}
	
	@MainActor
	func updateWithScores() async {
		guard let requestURL = URL(string: relaxScoresURLString) else { fatalError("Incorrect URL") }
		var request = URLRequest(url: requestURL)
		request.httpMethod = "POST"
		
		for division in Divisions.allCases {
			request.httpBody = "vlili=\(division.id)".data(using: String.Encoding.utf8)
			
			let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
				// Check for Error
				if let error = error {
					print("Error took place \(error)")
					return
				}
				
				if let data = data, let html = String(data: data, encoding: .utf8) {
					do {
						let document = try SwiftSoup.parse(html)
						if let scoresTable = try document.select(".cal_table").first() {
							
							let rows = try scoresTable.select("tr")
							let _ = rows.dropFirst() // the header row is only <tr> not <th>
							
							for row in rows.array() {
								
								let columns = try row.select("td")
								if columns.count == 12 { // VALIDATION 1
									let matchNumber = try columns[0].text()
									
									let matchSets = try columns[4].text()

									var setResults: [MatchSet] = []
									let setScores = matchSets.split(separator: "-")
									for setScore in setScores {
										let score = setScore.split(separator: "/")
										let homeScore = Int(score[0]) ?? -1
										let awayScore = Int(score[1]) ?? -1
										setResults.append(MatchSet(homeScore: homeScore, awayScore: awayScore))
									}
									let finalSetResults = setResults
																		
									DispatchQueue.main.async {
										viewModel.update(matchNumber, with: finalSetResults)
									}
								}
							}
						}
					} catch {
						print ("Error")
					}
				}
			}
			task.resume()
		}
	}
}

struct MainView_Previews: PreviewProvider {
	static var previews: some View {
		MainView()
	}
}
