//
//  ExoplanetViewController.swift
//  first
//
//  Created by Killian on 12/10/2023.
//

import UIKit

class ExoplanetViewController: UIViewController {

    @IBOutlet weak var textField: UILabel!
    
    var kepler_name = "kepler name"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textField.text = self.kepler_name
        // Do any additional setup after loading the view.
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
