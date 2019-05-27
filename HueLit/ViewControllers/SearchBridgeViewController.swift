//
//  SearchBridgeViewController.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-19.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchBridgeViewController: UIViewController {
    let defaults = UserDefaults.standard
    let url = "https://www.meethue.com/api/nupnp"
    var bridgeJSON : JSON? = JSON.null
    var bridges : [BridgeInfo] = []
    
    @IBOutlet weak var searchActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchForBridge()
    }
    
    func searchForBridge() {
        bridges = []
        searchTextLabel.text = "Searching"
        searchActivityIndicator.isHidden = false
        searchActivityIndicator.startAnimating()
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    self.bridgeJSON = JSON(response.result.value!)
                    print(self.bridgeJSON!)
                    print(self.bridgeJSON![0]["internalipaddress"])
                    print(self.bridgeJSON![0]["id"])
                    
                    for bridge in self.bridgeJSON! {
                        let bridgeInfo = BridgeInfo(ip: bridge.1["internalipaddress"].stringValue, id: bridge.1["id"].stringValue)
                        self.bridges.append(bridgeInfo)
                        self.bridges.append(bridgeInfo)
                        self.bridges.append(bridgeInfo)
                        self.bridges.append(bridgeInfo)

                        print(self.bridges)
                        if self.bridges.count > 0 {
                            self.perform(#selector(self.updateSearchUI), with: nil, afterDelay: 3)
                        }
                    }
                }
        }
    }
    
    @objc func updateSearchUI() {
        searchActivityIndicator.stopAnimating()
        searchActivityIndicator.isHidden = true
        self.searchTextLabel.text = "\(bridges.count) bridges found"
    }
    
    @IBAction func connectToBridge(_ sender: Any) {
        switch bridges.count {
        case 1:
            defaults.set(bridges[0].ip, forKey: "bridgeIp")
            performSegue(withIdentifier: "pushLink", sender: self)
        case let count where count > 1:
            performSegue(withIdentifier: "selectBridge", sender: self)
        default:
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectBridge" {
            let selectBridgeVC = segue.destination as! ConnectBridgeViewController
            selectBridgeVC.bridges = bridges
        }
        if segue.identifier == "pushLink" {
            let pushLinkVC = segue.destination as! PushLinkViewController
            pushLinkVC.bridge = bridges[0]
        }
    }
    
}


//{
//    "on": true,
//    "hue": 2000,
//    "effect": "colorloop"
//}

///api/<username>/groups/<id>/action



//http://192.168.1.225/api/CX0XuJlmCpBkjKepii0zJl6P3i7J77-dduoNjiTM/groups/1/action


//        let url = "http://192.168.1.225/api/CX0XuJlmCpBkjKepii0zJl6P3i7J77-dduoNjiTM/groups/1/action"
//        let jsonBody : [String : Any] = ["on": true, "hue": 2000, "effect": "colorloop"]
//        let messageBody = JSONSerialization.isValidJSONObject(jsonBody)
//        print(messageBody)
//        print(jsonBody)
//
//        Alamofire.request(url, method: .put, parameters: jsonBody, encoding: JSONEncoding.default)
//            .responseJSON { response in
//                if response.result.isSuccess {
//                    print("It worked")
//                }
//        }
