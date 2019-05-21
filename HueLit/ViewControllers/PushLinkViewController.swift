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

    let url = "http://192.168.1.225/api"
    let jsonBody : [String : Any] = ["devicetype" : "my_hue_app#iphone peter"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfPushLinkIsPressed()
    }
    
    func checkIfPushLinkIsPressed() {
        
        Alamofire.request(url, method: .post, parameters: jsonBody, encoding: JSONEncoding.default)
            .responseJSON { response in
                if response.result.isSuccess {
                    let jsonResponse = JSON(response.result.value as Any)

                    if jsonResponse[0]["success"].exists() {
                        print("contains success")
                    }
                } else {
                    print("Funkar inte")
                    print(response.error.debugDescription)
                }
        }
        
    }

}


//print("funkar")
//print(jsonResponse.rawValue)
//print(jsonResponse[0]["success"].exists())
//print(jsonResponse[0]["error"]["description"])
