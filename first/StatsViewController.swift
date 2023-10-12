//
//  StatsViewController.swift
//  first
//
//  Created by Lecouturier Lucie on 10/10/2023.
//

import UIKit

class StatsViewController: UIViewController {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var coordinateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fetchObjectsData), userInfo: nil, repeats: true)
    }
    
    @objc func fetchObjectsData(){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "http://api.open-notify.org/iss-now.json")!
        let url_human = URL(string: "http://api.open-notify.org/astros.json")!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                    if let issPosition = json["iss_position"] as? [String: String] {
                        if let latitude = issPosition["latitude"], let longitude = issPosition["longitude"] {
                            self.updatePosition(latitude, longitude: longitude)
                        }
                    }
                }
            }
        }

        task.resume()
        
        let task2 = session.dataTask(with: url_human) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                    if
                       let number = json["number"] as? Int,
                       let people = json["people"] as? [Any]
                    {
                        self.updateLabel(number)
                    }
                }
            }
        }
        task2.resume()
    }
    
    func updateLabel(_ number: Int){
        DispatchQueue.main.async {
            self.numberLabel.text = String(number)
        }
    }
    
    func updatePosition(_ latitude: String, longitude: String){
        DispatchQueue.main.async {
            self.coordinateLabel.text = latitude + "°N " + longitude + "°E"
        }
    }
}
