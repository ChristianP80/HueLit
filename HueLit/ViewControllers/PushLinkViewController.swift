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
    
    func buildUrl() {
        let ip = defaults.string(forKey: "bridgeIp") ?? String()
        print(ip)
        url = "http://\(ip)/api"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isLooping = false
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
}



//    var url = "http://192.168.1.225/api"
