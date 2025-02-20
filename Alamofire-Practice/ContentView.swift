//
//  ContentView.swift
//  Alamofire-Practice
//
//  Created by Đoàn Văn Khoan on 20/2/25.
//

import SwiftUI
import Foundation

struct Weather: Codable {
    var location: Location
    var forecast: Forecast
}

struct Location: Codable {
    var name: String
}

struct Forecast: Codable {
    var forecastday: [ForecastDay]
}

struct ForecastDay: Codable, Identifiable {
    var date_epoch: Int
    var id: Int {
        date_epoch
    }
    var day: Day
}

struct Day: Codable {
    var avgtemp_c: Double
    var condition: Condition
}

struct Condition: Codable {
    var text: String
}

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Toronto")
                .font(.system(size: 35))
                .bold()
            Text("\(Date().formatted(date: .complete, time: .omitted))")
                .font(.system(size: 18))
            Text("☀️")
                .font(.system(size: 180))
                .shadow(radius: 75)
            Text("0ºC")
                .font(.system(size: 70))
                .bold()
            Text("Moderately cold")
                .font(.system(size: 22))
                .bold()
            Spacer()
            Spacer()
            Spacer()
            List {
                Text("Text 1")
                Text("Text 2")
                Text("Text 3")
            }
            Spacer()
            Text("Data supplied by Weather API")
                .font(.system(size: 14))
        }
    }
    
    func getWeatherEmoji(text: String) -> String {
        
        var weatherEmoji: String = "☀️"
        let conditionText = text.lowercased()
        
        if conditionText.contains("snow") || conditionText.contains("blizzard") {
            weatherEmoji = "🌨️"
        } else if conditionText.contains("rain") {
            weatherEmoji = "🌧️"
        } else if conditionText.contains("partly cloudy") {
            weatherEmoji = "⛅️"
        } else if conditionText.contains("cloudy") || conditionText.contains("overcast") {
            weatherEmoji = "☁️"
        } else if conditionText.contains("clear") || conditionText.contains("sunny") {
            weatherEmoji = "☀️"
        }
        
        return weatherEmoji
    }
    
    
}

#Preview {
    ContentView()
}
