//
//  HomeViewController.swift
//  first
//
//  Created by Lucie on 10/10/2023.
//

import UIKit

struct EventItem {
    let name: String
    let description: String
    let image: String
    let location: String
    let date: String
    let hour: String
}

extension EventItem {
    init?(json: [String: String]){
        guard let name = json["name"], let image = json["img_src"], let date = json["date"], let description = json["description"], let location = json["localisation"], let hour = json["hour"]
                else
        {
            return nil
        }
        
        self.name = name
        self.description = description
        self.image = image
        self.location = location
        self.date = date
        self.hour = hour
    }
}

struct Image {
    let urlImage: String
    let title: String
    let explanation: String
}

extension Image {
    init?(json: [String: Any]) {
        guard let url = json["url"] as? String, let name = json["title"] as? String, let description = json["explanation"] as? String else {
            return nil
        }

        self.urlImage = url
        self.title = name
        self.explanation = description
    }
}



class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
     var eventBrowser: [EventItem] = []
         var browsers: [Image] = []

        
    let config = URLSessionConfiguration.default

    @IBOutlet weak var dailyImageDescription: UILabel!
    @IBOutlet weak var dailyImageTitle: UILabel!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var ImageDaily: UIImageView!

    @IBOutlet weak var ImageDailyInfosContainer: UIView!
    @IBOutlet weak var dailyImageContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        
        ImageDaily.clipsToBounds = true
        ImageDaily.layer.cornerRadius = 30
        
        dailyImageContainer.clipsToBounds = false
        dailyImageContainer.layer.cornerRadius = 30
        
        ImageDailyInfosContainer.clipsToBounds = true
        ImageDailyInfosContainer.layer.cornerRadius = 30
        ImageDailyInfosContainer.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        
        ImageDailyInfosContainer.layer.shadowColor = UIColor.lightGray.cgColor
        ImageDailyInfosContainer.layer.shadowOpacity = 1
        ImageDailyInfosContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        ImageDailyInfosContainer.layer.shadowRadius = 4
        
        let colorBorder = UIColor(red: 7/255, green: 44/255, blue: 67/255, alpha: 0.67)

        dailyImageContainer.layer.shadowColor = colorBorder.cgColor
        dailyImageContainer.layer.shadowOpacity = 1
        dailyImageContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        dailyImageContainer.layer.shadowRadius = 5
        
        dailyImageContainer.layer.borderColor = colorBorder.cgColor
        dailyImageContainer.layer.borderWidth = 1

        
        // Do any additional setup after loading the view.
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let sessionImage = URLSession.shared
        let url = URL(string: "http://localhost:5050/events")!
         let urlImage = URL(string: "https://api.nasa.gov/planetary/apod?api_key=rlaCl7XRgqzwRGiOAYQgKo7yYJ6gCb5hiHvklCos")!
        
        
        
        let nib = UINib(nibName: "CustomEventViewCell", bundle: nil)
        self.homeTableView.register(nib, forCellReuseIdentifier: "homeEventCell")
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
                    if let data = json as? [[String: AnyObject]] {
                        for item in data {
                            guard
                                    let name = item["name"] as? String,
                                    let description = item["description"] as? String,
                                    let img_src = item["img_src"] as? String,
                                    let localisation = item["localisation"] as? String,
                                    let date = item["date"] as? String,
                                    let hour = item["hour"] as? String
                                else {
                                print("ERROR in Json collection data")
                                    continue
                                }
                                let obj = EventItem(name: name, description: description, image: img_src, location: localisation, date: date, hour: hour)
                                self.eventBrowser.append(obj)
                            }
                        }
                    DispatchQueue.main.async {
                        self.homeTableView.reloadData()
                        }
                }
            }
        }
        task.resume()


        let taskImage = sessionImage.dataTask(with: urlImage) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let imageURLString = json["url"] as? String, let title = json["title"] as? String, let desc = json["explanation"] as? String {
                                if let imageURL = URL(string: imageURLString) {
                                    let imageTask = URLSession.shared.dataTask(with: imageURL) { (imageData, _, _) in
                                        if let imageData = imageData, let image = UIImage(data: imageData) {
                        
                                            DispatchQueue.main.async {
                                                self.ImageDaily.image = image
                                                self.dailyImageTitle.text = title
                                                self.dailyImageDescription.text = desc
                                            }
                                        }
                                    }
                                    imageTask.resume()
                                }
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }
            taskImage.resume()
            
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.eventBrowser.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeEventCell", for: indexPath) as? CustomEventViewCell
        
        // Configure the cell...
        cell?.configure(name: eventBrowser[indexPath.row].name, imageURL: eventBrowser[indexPath.row].image, date: eventBrowser[indexPath.row].date)
            
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "modalEvent") as? ModalEventViewController {
              vc.tableInformations = self.eventBrowser
              self.present(vc, animated: true, completion: nil)
          }
      }
    

}
