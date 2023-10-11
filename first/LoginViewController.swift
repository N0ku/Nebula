//
//  ViewController.swift
//  first
//
//  Created by Lecouturier Lucie on 09/10/2023.
//

import UIKit
import AVFoundation
import AVKit

class LoginViewController: UIViewController {

    @IBOutlet weak var videoBackground: UIView!
    
    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadVideoBackground()
    }

    private func loadVideoBackground(){
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "sky", ofType: "mp4")!)
        
        let player = AVPlayer(url: path)
        
        let layer = AVPlayerLayer(player: player)
        layer.frame = self.videoBackground.frame
        self.videoBackground.layer.addSublayer(layer)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        player.play()
        
        player.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        
        NotificationCenter.default.addObserver(self,selector: #selector(LoginViewController.videoDidPlayToEnd(_:)),name:NSNotification.Name("AVPlayerItemDidPlayToEndTimeNotification"),object: player.currentItem)
    }
     
    @objc func videoDidPlayToEnd(_ notification: Notification){
        let player: AVPlayerItem = notification.object as! AVPlayerItem
        player.seek(to: CMTime.zero)
    }
    
    @IBAction func login(_ sender: Any) {
        if self.loginTextField.text == "admin" && self.passwordTextField.text == "admin" {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Home") as? HomeViewController {
                
                // Navigation Bar
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

