//  Clima
//  Created by Hendy Christian on 17/06/20.

import UIKit
import CoreLocation // L 1

class WeatherViewController: UIViewController{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager() //L 2
    
    //IBoutlet for search TextField
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         locationManager.delegate = self
        
        //L ASK user are you want app knows your location 3
        locationManager.requestWhenInUseAuthorization()
        
        // 4 This is a delegate method
        locationManager.requestLocation()
       
        weatherManager.delegate = self
        searchTextField.delegate = self
        
    }
    
    // Ketika tanda panah di Click lakukan ini
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK : - UITextFieldDelegate

// Extension

extension WeatherViewController: UITextFieldDelegate{
    
    // When user Click Search Button Do Here
    @IBAction func searchPressed(_ sender: UIButton) {
        
        // Pada saat setelah di search keyboard di iPhone akan tutup otomatis
        searchTextField.endEditing(true)
        
        print(searchTextField.text!)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Pada saat setelah di search keyboard di iPhone akan tutup otomatis
        searchTextField.endEditing(true)
        
        print(searchTextField.text!)
        return true
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
       
        if textField.text != "" {
            return true
        }else{
            textField.placeholder = "Insert Your City Name"
            return false
        }
        
    }
    
    // Ketika textField Done With Editing do here
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            
            weatherManager.fetchWeather(cityName: city)
            
        }
        
        // Use searcTextField.text to get the weather for that city
        
        // Clear all text field when click GO
        searchTextField.text = ""
    
    }
}

//MARK : - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    
    // UPDATE
    func didUpdateWheater(_ weatherManager: WeatherManager , weather: WeatherModel){
        print(weather.temperature)
            
            DispatchQueue.main.sync {
                
                // Change label to tthe UI
                self.temperatureLabel.text = weather.temperatureString
                
                // Change Symbol to the UI
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
                
                // Change the city label
                self.cityLabel.text = weather.cityName
                
            }
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK : - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // If location is not nill do this
        if let location = locations.last{
            
            locationManager.stopUpdatingLocation()
            
            let lat = location.coordinate.latitude  // Latitude   : Garis Lintang
            let lon = location.coordinate.longitude // Longitute : Garis bujur
            
            weatherManager.fetchWeather(latitude: lat, longitute: lon )
        
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
