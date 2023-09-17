//
//  DetailsViewController.swift
//  WeatherApp
//
//  Created by Burak Cavusoğlu on 17.09.2023.
//

import UIKit
import CoreLocation

class DetailsViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet private weak var collectionView: UICollectionView!
   
    var currentLocation: CLLocation? = nil
    var wheaterModel: [WeatherCollectionViewCellModel] = []
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "WeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WeatherCollectionViewCell")
        
        fetchDetail()
    }

    // MARK: - UICollectionViewDataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wheaterModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCollectionViewCell", for: indexPath) as? WeatherCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: wheaterModel[indexPath.row])
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout Methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 4
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    private func fetchDetail() {
        guard let location = currentLocation else { return }
        
        let long = location.coordinate.longitude
        let lat = location.coordinate.latitude
        
        let url = Urls.weatherDetail(lat: lat, long: long, apiKey: Constant.apiKey).url
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let jsonData = data, error == nil else { return }

            do {
                let currentDate = Date.now
                let detailData = try JSONDecoder().decode(DetailResponseModel.self, from: jsonData)
                guard let list = detailData.list else {
                    return
                }
               
                let dateList = list.map { list in
                    Date().fromString(date: list.dtTxt ?? " " )
                }
                for element in list {
                    let hours: String
                    var iconData = Data()
                    if let icon = element.weather?.first?.icon,
                        let iconURL = URL(string: "https://openweathermap.org/img/w/\(icon).png"),
                        let imageData = try? Data(contentsOf: iconURL) {
                        DispatchQueue.main.async {
                            iconData = imageData
                        }
                    }
                    let date = Date().fromString(date: element.dtTxt ?? " " )
                    self.dateFormatter.dateFormat = "HH:mm"
                    let formattedDate = self.dateFormatter.string(from: date ?? .now)
                    hours = formattedDate
                    
                    
                    if let iconImage = UIImage(data: iconData) {
                        if let temp = element.main?.temp {
                            let tempCalcius = "\(Int(temp) - 273)°"
                            let model = WeatherCollectionViewCellModel(hours: hours,
                                                                       icon: iconImage,
                                                                       temp: "\(tempCalcius)")
                            self.wheaterModel.append(model)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch {
                print(error)
                print("Failed to decode weather data: \(error.localizedDescription)")
            }
        }.resume()
    }
}
extension Date {
    class Format {
        public static var dateWithClock: String = "yyyy-MM-dd HH:mm:ss"
    }
    func fromString(date: String, withFormat format: String = Format.dateWithClock) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: date)
    }
}
