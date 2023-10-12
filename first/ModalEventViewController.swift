//
//  ModalEventViewController.swift
//  first
//
//  Created by zook on 12/10/2023.
//

import UIKit

class ModalEventViewController: UIViewController {
    
    var tableInformations: EventItem!
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventDescription: UILabel!
    
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var eventHour: UILabel!
    
    @IBOutlet weak var eventLocation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageURL = self.tableInformations.image
        print(imageURL)
        if let url = URL(string: imageURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.eventImage.image = image
                        self.eventName.text = self.tableInformations.name
                        self.eventDate.text = self.tableInformations.date
                        self.eventDescription.text = self.tableInformations.description
                        self.eventHour.text = self.tableInformations.hour
                        self.eventLocation.text = self.tableInformations.location
                    }
                }
            }.resume()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
