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
    
    let url = "https://www.meethue.com/api/nupnp"
    var bridgeJSON : JSON? = JSON.null
    var bridges : [BridgeInfo] = []
    var user : String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
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
                        print(self.bridges)
                    }
                }
        }
    }
    
    @IBAction func connectToBridge(_ sender: Any) {

        if let bridgeUser = user, !user!.isEmpty {
            performSegue(withIdentifier: "selectBridge", sender: self)
        } else {
            performSegue(withIdentifier: "pushLink", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectBridge" {
            let selectBridgeVC = segue.destination as! ConnectBridgeViewController
            selectBridgeVC.bridges = bridges
        }
        if segue.identifier == "pushLink" {
            let pushLinkVC = segue.destination as! PushLinkViewController
        }
    }
    
}


//{
//    "on": true,
//    "hue": 2000,
//    "effect": "colorloop"
//}

///api/<username>/groups/<id>/action

//david.neess@ericsson.com


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
