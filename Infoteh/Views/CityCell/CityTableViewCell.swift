//
//  CityTableViewCell.swift
//  Infoteh
//
//  Created by admin on 01.08.2022.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    //Constants
    struct Constants {
        static let imageUrlForPaired: String = "https://infotech.gov.ua/storage/img/Temp3.png"
        static let imageUrlForUnpaired: String = "https://infotech.gov.ua/storage/img/Temp1.png"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCityData(index: Int, cityModel: CityModel?) {
        guard let cityModel = cityModel else { return }
        self.cityNameLabel.text = cityModel.name
        if index % 2 == 0 {
            self.pictureImageView.downloaded(from: Constants.imageUrlForPaired)
            self.stackView.semanticContentAttribute = .forceLeftToRight
        } else {
            self.pictureImageView.downloaded(from: Constants.imageUrlForUnpaired)
            self.stackView.semanticContentAttribute = .forceRightToLeft
        }
    }
    
}
