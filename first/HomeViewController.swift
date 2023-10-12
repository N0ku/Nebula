//
//  HomeViewController.swift
//  first
//
//  Created by Lecouturier Lucie on 10/10/2023.
//

import UIKit

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

class HomeViewController: UIViewController {
    
    var browsers: [Image] = []
    
    @IBOutlet weak var ImageDaily: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("1")
        // Créez une instance de URLSession
        let session = URLSession.shared
        
        
        let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=rlaCl7XRgqzwRGiOAYQgKo7yYJ6gCb5hiHvklCos")!
        
            
            
            let task = session.dataTask(with: url) { (data, response, error) in
                print("2")
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let imageURLString = json["url"] as? String, let _ = json["title"] as? String, let _ = json["explanation"] as? String {
                                if let imageURL = URL(string: imageURLString) {
                                    // Utilisez URLSession pour télécharger l'image
                                    print("Image URL: \(imageURLString)")
                                    let imageTask = URLSession.shared.dataTask(with: imageURL) { (imageData, _, _) in
                                        if let imageData = imageData, let image = UIImage(data: imageData) {
                                            // Mettez à jour l'interface utilisateur sur le thread principal
                                            print("Image URL: \(imageURLString)")
                                            DispatchQueue.main.async {
                                                self.ImageDaily.image = image
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
            task.resume()
            
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
