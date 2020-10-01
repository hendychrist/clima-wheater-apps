
//  Clima
//  WheaterManager.swift

//  Created by Hendy Christian 14/07/2020.
//  Copyright © 2020 Hendy Christian. All rights reserved.

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWheater(_ weatherManager: WeatherManager , weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=955031b7440565053e3f09a599aae1f6&units=metric"

    // So which ever class set them selft as a WeatherManagerDelegate
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        self.performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees,longitute: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
        
    // 1. Create a URL
        
        if let url = URL(string: urlString){
            
            // 2. Create a URLSession
                let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
                let task = session.dataTask(with: url) { (data, response, error) in
                
                    if error != nil{
                        
                        self.delegate?.didFailWithError(error: error!)
                        
                    }// Close if error
                       
                       if let safeData = data {
                        
//                            let dataString = String(data: safeData, encoding: .utf8)
//                            print(dataString)

                            // Data isn't always a  String lets convert it into a String
                        
                            if let weather = self.parseJSON(safeData){
                                self.delegate?.didUpdateWheater(self, weather: weather)
                            }

                       }// Close safeData
                
            }
             
            // 4. Start the task
                task.resume()
            
        }
    }
    
    func parseJSON(_ weatherData: Data ) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode( WeatherData.self, from: weatherData)
            
            print(" City        : \(decodedData.name)")
            print(" Temperatur  : \(decodedData.main.temp) C")
            print(" Description : \(decodedData.weather[0].description! as Any)")
            
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
            print("Weather Condition : ", weather.conditionName)
            print("Weather Temperature : ", weather.temperatureString)
            
        }catch{
            
            delegate?.didFailWithError(error: error)
            print(error)
            return nil
            
        }
        
    }
    

    
}
