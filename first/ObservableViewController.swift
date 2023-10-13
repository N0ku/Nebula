//
//  ObservableViewController.swift
//  first
//
//  Created by Lecouturier Lucie on 12/10/2023.
//

import UIKit

class ObservableViewController: UIViewController {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var observableImage: UIImageView!
    
    var observable: ObjectItem? = ObjectItem(json: [:])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descLabel.text = observable?.description
        titleLabel.text = observable?.name
       
        
        if let url = URL(string: observable!.image) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.observableImage.image = image
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
