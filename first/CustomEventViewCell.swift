//
//  CustomEventViewCell.swift
//  first
//
//  Created by zook on 12/10/2023.
//

import UIKit

class CustomEventViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
        
    @IBOutlet weak var EventimageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var seeMoreButton: UIButton!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        
    public func configure(name: String, imageURL: String, date: String) {
            nameLabel.text = name
            
            if let url = URL(string: imageURL) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.EventimageView.image = image
                            self.nameLabel.text = name
                            self.descriptionLabel.text = date
                        }
                    }
                }.resume()
            }
        }
    
}
