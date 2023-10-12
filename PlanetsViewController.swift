//
//  PlanetsViewController.swift
//  first
//
//  Created by Killian on 11/10/2023.
//

import UIKit

struct Exoplanet {
    let kepler_name: String
}

extension Exoplanet {
    init?(json: [String: AnyObject]) {
        guard let kepler_name = json["kepler_name"] as? String
        else {
            return nil
        }
        
        self.kepler_name = kepler_name
    }
}

private let reuseIdentifier = "planetCell"

class PlanetsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var planetCollectionView: UICollectionView!
    
    var exoplanets : Array<Exoplanet> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.planetCollectionView.backgroundColor = UIColor.clear
        self.planetCollectionView?.backgroundView = UIView(frame: CGRect.zero)
        
        let layout = PlanetsViewControllerLayout()
        planetCollectionView.collectionViewLayout = layout
        
        planetCollectionView.dataSource = self
        planetCollectionView.delegate = self
        
        let nib = UINib(nibName: "PlanetViewCell", bundle: nil)
                   planetCollectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "https://exoplanetarchive.ipac.caltech.edu/TAP/sync?query=select+kepler_name+from+keplernames&format=json")!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
                        if let jsonArray = json as? [[String: AnyObject]] {
                            for item in jsonArray {
                                guard
                                    let kepler_name = item["kepler_name"] as? String
                                else {
                                    continue
                                }
                                
                                let obj =  Exoplanet(kepler_name: kepler_name)
                                self.exoplanets.append(obj)
                                                        }
                        }
                    }
            }
            DispatchQueue.main.async {
                            self.planetCollectionView.reloadData()
                        }
        }
        task.resume()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.exoplanets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PlanetViewCell
        cell?.configure(name: exoplanets[indexPath.row].kepler_name, imageURL: "data:image/jpeg;base64,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" )
        // Configure the cell
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "exoplanet")as? ExoplanetViewController {
                vc.kepler_name = self.exoplanets[indexPath.row].kepler_name
                
                self.present(vc, animated: true, completion: nil)
            }
    }
}


