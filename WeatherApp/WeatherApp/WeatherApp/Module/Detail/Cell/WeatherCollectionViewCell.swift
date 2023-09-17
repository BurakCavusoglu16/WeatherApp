//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Burak Cavusoğlu on 17.09.2023.
//

import UIKit

struct WeatherCollectionViewCellModel {
    let hours: String
    let icon: UIImage
    let temp: String
}

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hourlyLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .red
    }
    
    func configure(with model: WeatherCollectionViewCellModel) {
        hourlyLabel.text = model.hours
        tempLabel.text = model.temp
        iconImageView.image = model.icon
    }
}
