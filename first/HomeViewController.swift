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



class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
     var eventBrowser: [EventItem] = []
        
    let config = URLSessionConfiguration.default

    @IBOutlet weak var homeTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        
        // Do any additional setup after loading the view.
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "http://localhost:5050/events")!
        
        
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
