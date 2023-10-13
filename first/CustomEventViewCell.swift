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
    
    @IBOutlet weak var shadow: UIView!
    @IBOutlet weak var wrapper: UIView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            setupCellAppearance()
        }
    
    func setupCellAppearance() {
        wrapper.clipsToBounds = true
        shadow.clipsToBounds = false
        let borderColor = UIColor(red: 84/255, green: 145/255, blue: 168/255, alpha: 1)

        wrapper.layer.cornerRadius = 20
        shadow.layer.cornerRadius = 20
        wrapper.layer.borderWidth = 2
        wrapper.layer.borderColor = borderColor.cgColor
        
        shadow.layer.shadowColor = borderColor.cgColor
        shadow.layer.shadowOpacity = 1
        shadow.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadow.layer.shadowRadius = 4
        
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
