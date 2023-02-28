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
	
    var body: some View {
		TabView {
			StandingsView(global: $global)
				.tabItem {
					Label ("Standings", systemImage: "person.3")
				}

			ScoresView(global: $global)
				.tabItem {
					Label ("Scores", systemImage: "exclamationmark.circle")
				}
			
			ScheduleView(global: $global)
				.tabItem {
					Label ("Schedule", systemImage: "calendar")
				}			
		}
		.task {
			await fetchSchedule()
			await updateWithScores()
		}
    }
	
	func fetchSchedule() async {
		let url = URL(string: relaxScheduleURLString)
		guard let requestURL = url else { fatalError("Incorrect URL") }
		
		for division in Divisions.allCases {
			var request = URLRequest(url: requestURL)
			request.httpMethod = "POST"
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
								if columns.count == 6 { // VALIDATION 1: the data has the right number of columns
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
										if dateStringElements[0] != "00" { // VALIDATION 3: date is filled in
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
													
													allMatches.append(scheduledMatch)
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
	
	func updateWithScores() async {
		let url = URL(string: relaxScoresURLString)
		guard let requestURL = url else { fatalError("Incorrect URL") }
		
		for division in Divisions.allCases {
			var request = URLRequest(url: requestURL)
			request.httpMethod = "POST"
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
						let scoresTable = try document.select(".cal_table").first()!
						
						let rows = try scoresTable.select("tr")
						let _ = rows.dropFirst() // the header row is only <tr> not <th>
						for row in rows.array() {
							
							let columns = try row.select("td")
							if columns.count == 12 {
								let matchNumber = try columns[0].text()
								
								let homeTeam = try columns[1].text()
								let awayTeam = try columns[2].text()
																
								let matchSets = try columns[4].text()
																
								var setResults: [MatchSet] = []
								let setScores = matchSets.split(separator: "-")
								for setScore in setScores {
									let score = setScore.split(separator: "/")
									let homeScore = Int(score[0]) ?? -1
									let awayScore = Int(score[1]) ?? -1
									setResults.append(MatchSet(homeScore: homeScore, awayScore: awayScore))
								}
								
								var category = Categories.womens
								switch division {
									case .fa, .fb, .fc: category = .womens
									case .ha, .hb, .hc, .hd: category = .mens
									case .xa, .xb, .xc, .xd: category = .mixed
								}
								
								let matchResult = MatchInfo(
									season: "2022-2023",
									location: "address missing",
									league: .relax, category: category, division: division, matchNumber: matchNumber,
									homeTeamName: homeTeam, awayTeamName: awayTeam,
									matchSets: setResults)
								
								if let oldMatchIndex = allMatches.firstIndex(where: {$0.matchNumber == matchResult.matchNumber}) {
									allMatches[oldMatchIndex].matchSets = matchResult.matchSets
								} else {
									if matchResult.homeTeamName != "Domicile" {
										print ("ERROR: Match \(matchResult.matchNumber) has results but it's not found on the schedule.")
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
