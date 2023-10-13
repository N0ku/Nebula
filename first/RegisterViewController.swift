//
//  RegisterViewController.swift
//  first
//
//  Created by Lecouturier Lucie on 10/10/2023.
//

import UIKit
import AVFoundation
import AVKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var confirmPasswordLabel: UITextField!
    @IBOutlet weak var videoBackground: UIView!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var textLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func register(_ sender: Any) {
    }
    
}
