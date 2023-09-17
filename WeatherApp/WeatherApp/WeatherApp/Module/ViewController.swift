//
//  ViewController.swift
//  WeatherApp
//
//  Created by Burak Cavusoğlu on 17.09.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        locationManager.stopUpdatingLocation()
        getWeatherData()
    }

    func getWeatherData() {
        guard let currentLocation = currentLocation else { return }
     
        let url = Urls.weather(lat: currentLocation.coordinate.latitude,
                               long: currentLocation.coordinate.longitude,
                               apiKey: Constant.apiKey).url
        
            URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    
                    if let temp = weatherData.main?.temp {
                        self.temperatureLabel.text = "\(Int(temp))°"
                    }
                    
                    if let name = weatherData.name {
                        self.cityLabel.text = name
                    }
                    
                    if let description = weatherData.weather?.first?.description {
                        self.descriptionLabel.text = description
                    }
                }

                if let icon = weatherData.weather?.first?.icon,
                   let iconURL = URL(string: "https://openweathermap.org/img/w/\(icon).png"),
                   let data = try? Data(contentsOf: iconURL) {
                    DispatchQueue.main.async {
                        self.weatherImageView.image = UIImage(data: data)
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
   
    @IBAction func detailsButtonTapped(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyBoard.instantiateViewController(withIdentifier: "detail") as! DetailsViewController
        detailViewController.currentLocation = self.currentLocation
        self.present(detailViewController, animated: true, completion: nil)
       
    }
    
}
