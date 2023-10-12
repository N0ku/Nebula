//
//  ObservableObjectsViewController.swift
//  first
//
//  Created by Lecouturier Lucie on 11/10/2023.
//

import UIKit

struct ObjectItem {
   let name: String
   let description: String
   let image: String
}

extension ObjectItem {
   init?(json: [String: String]){
       guard let name = json["name"], let image = json["img_src"],  let description = json["description"]
               else
       {
           return nil
       }
       self.name = name
       self.description = description
       self.image = image
   }
}

private let reuseIdentifier = "observableCell"

class ObservableObjectsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets.zero
        collectionView.backgroundView = nil;
        collectionView.backgroundColor = UIColor.clear
                collectionView?.backgroundView = UIView(frame: CGRect.zero)

        collectionView.collectionViewLayout = CustomCollectionViewFlowLayout()

        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
           collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        fetchObjectsData()
        // Do any additional setup after loading the view.
    }
    
    var objectItems = [ObjectItem]()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func fetchObjectsData(){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "http://localhost:5050/observables")!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) {
                    if let jsonArray = json as? [[String: AnyObject]] {
                        for item in jsonArray {
                            guard
                                let name = item["name"] as? String,
                                let description = item["description"] as? String,
                                let img_src = item["img_src"] as? String
                            else {
                                continue
                            }
                            let obj =  ObjectItem(name: name, description: description, image: img_src)
                            self.objectItems.append(obj)
                                                    }
                    }
                }
            }
            DispatchQueue.main.async {
                           self.collectionView.reloadData()
                       }
        }
        task.resume()
    }


    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return objectItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ObservableCollectionViewCell
        cell?.configure(name: objectItems[indexPath.row].name, imageURL: objectItems[indexPath.row].image)
        
        cell?.setupCellAppearance(index: indexPath.item)

        // cell.descriptionLabel.text = objectItem.description
        return cell!
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "exoplanet")as? ExoplanetViewController {
                vc.kepler_name = self.exoplanets[indexPath.row].kepler_name
                
                self.present(vc, animated: true, completion: nil)
            }
    }

}
