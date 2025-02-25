//
//  ContentView.swift
//  Alamofire-Practice
//
//  Created by Đoàn Văn Khoan on 20/2/25.
//

import SwiftUI
import Foundation
import Alamofire

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
    
    @State private var results = [ForecastDay]()
    
    let blueSky = Color.init(red: 135/255, green: 206/255, blue: 235/255)
    let greySky = Color.init(red: 47/255, green: 79/255, blue: 79/255)
    
    @State var backgroundColor = Color.init(red: 135/255, green: 206/255, blue: 235/255)
    @State var weatherEmoji = "☀️"
    @State var currentTemp = 0
    @State var conditionText = "Slightly Overcast"
    @State var cityName = "Toronto"
    @State var loading = true
    
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
        .task {
            await fetchWeather()
        }
    }
    
    func fetchWeather() async {
        let request = AF.request("http://api.weatherapi.com/v1/forecast.json?key=5490adc7793a49c38fb72346252502&q=M1G3T8&days=3&aqi=no&alerts=no")
        
        request.responseDecodable(of: Weather.self) { response in
            
            switch response.result {
                
            case .success(let weather):
                dump(weather)
                
                cityName = weather.location.name
                results = weather.forecast.forecastday
                currentTemp = Int(results[0].day.avgtemp_c)
                backgroundColor = getBackgroundColor(text: results[0].day.condition.text)
                weatherEmoji = getWeatherEmoji(text: results[0].day.condition.text)
                conditionText = results[0].day.condition.text
                loading = false
                
                
            case.failure(let error):
                print(error)
            }
            
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
    
    func getBackgroundColor(text: String) -> Color {
        var backgroundColor = blueSky
        let conditionText = text.lowercased()
        
        if !(conditionText.contains("clear")) || conditionText.contains("sunny") {
            backgroundColor = greySky
        }
        
        return backgroundColor
    }
    
    func getShortDate(epoch: Int) -> String {
        return Date(timeIntervalSince1970: TimeInterval(epoch)).formatted(Date.FormatStyle().weekday(.abbreviated))
    }
}

#Preview {
    ContentView()
}
