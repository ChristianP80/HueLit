//
//  PushLinkViewController.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-21.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PushLinkViewController: UIViewController {
    
    @IBOutlet weak var bridgeProgressView: UIProgressView!
    
    let defaults = UserDefaults.standard
    var url = String()
    var bridge : BridgeInfo? = nil
    let jsonBody : [String : Any] = ["devicetype" : "my_hue_app#\(UIDevice.current.name)"]
    var user : String?
    var isLooping : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLooping = true
        buildUrl()
        getUser()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isLooping = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        countDownUntilTimeout()
    }
    
    func buildUrl() {
        let ip = defaults.string(forKey: "bridgeIp") ?? String()
        print(ip)
        url = "http://\(ip)/api"
    }
    
    func getUser() {
        if isLooping {
            if user == nil {
                perform(#selector(checkIfPushLinkIsPressed), with: nil, afterDelay: 3)
                print("User is still nil")
            }
        }
    }
    
    @objc func checkIfPushLinkIsPressed() {
        print("this is the utl:\(url)")
        Alamofire.request(url, method: .post, parameters: jsonBody, encoding: JSONEncoding.default)
            .responseJSON { response in
                if response.result.isSuccess {
                    let jsonResponse = JSON(response.result.value as Any)
                    print("---------------------------------------")
                    print(jsonResponse)
                    print("---------------------------------------")
                    if jsonResponse[0]["success"].exists() {
                        print("contains success")
                        self.user = jsonResponse[0]["success"]["username"].stringValue
                        self.defaults.set(jsonResponse[0]["success"]["username"].stringValue, forKey: "bridgeUser")
                        print(self.user!)
                        let roomsVC = self.storyboard?.instantiateViewController(withIdentifier: "roomsVC") as! RoomsViewController
                        self.present(roomsVC, animated: true, completion: nil)
                    }
                    if jsonResponse[0]["error"].exists() {
                        self.getUser()
                    }
                } else {
                    print("Funkar inte")
                    print(response.error.debugDescription)
                }
        }
    }
    
    func timeOutAlert(){
        let alertController = UIAlertController(title: "Timeout", message: "You haven´t pressed the pushlink on the bridge", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.bridgeProgressView.progress = 1.0
            self.countDownUntilTimeout()
            self.getUser()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func countDownUntilTimeout() {
        let timeout : Float = 30
        var timeLeft = timeout
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            timeLeft -= 1
            let progress = timeLeft / timeout
            self.bridgeProgressView.progress = progress
            
            if timeLeft == 0{
                self.timeOutAlert()
                timer.invalidate()
            }
        }
    }
    
}



//    var url = "http://192.168.1.225/api"
