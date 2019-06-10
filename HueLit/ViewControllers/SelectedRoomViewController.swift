//
//  SelectedRoomViewController.swift
//  HueLit
//
//  Created by Christian Persson on 2019-06-04.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit

class SelectedRoomViewController: UIViewController {

    var room : (key: String, val: RoomInfo)? = nil
    let bridgeUser = UserDefaults.standard.string(forKey: "bridgeUser") ?? String()
    let bridgeIp = UserDefaults.standard.string(forKey: "bridgeIp") ?? String()
//    let changeStateURL = "http:192.168.1.225/api/mooY-Ctmw5-YSLO4m0Uyw30BBAvzjJYInxzmCzA8/groups/"
    var jsonUrl = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildJsonUrl()
        print(room!)
    }
    
    func buildJsonUrl() {
        jsonUrl = "http:\(bridgeIp)/api/\(bridgeUser)/groups/\(room!.key)/action"
    }
    
    @IBAction func changeColor(_ sender: RoundButton) {
        var hue : Int = 0
        switch sender.tag {
        case 1:
            hue = 64201
        case 2:
            hue = 25600
        case 3:
            hue = 46586
        default:
            return
        }
        print(hue)
        
        let body = ["hue": hue,
                    "on": true,
                    "bri": room!.val.action!.bri] as [String : Any]
        print(body)
        guard let url = URL(string: jsonUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
            guard let response = response as? HTTPURLResponse else { return }
            if (200...209).contains(response.statusCode) {
                
            }
        }.resume()
    }
    
    
    @IBAction func closeSelectedRoom(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

