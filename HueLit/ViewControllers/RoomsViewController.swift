//
//  RoomsViewController.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-22.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RoomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var roomsTableView: UITableView!
    let url = "http:192.168.1.225/api/CX0XuJlmCpBkjKepii0zJl6P3i7J77-dduoNjiTM/groups"
    var roomJSON : JSON? = JSON.null
    var roomInfo : [RoomInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        roomsTableView.delegate = self
        roomsTableView.dataSource = self
        roomsTableView.backgroundColor = UIColor.darkGray
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    self.roomJSON = JSON(response.result.value!)
//                    print(self.roomJSON!)
                    for room in self.roomJSON! {
                        print(room.1["name"])
                        print(room.1["lights"])
                        print(room.1["action"])
                        let someRoom = RoomInfo(roomName: room.1["name"].stringValue)
                        self.roomInfo.append(someRoom)

//                        let roomInfo = RoomInfo(roomName: room.1["name"].stringValue, lights: room.1["lights"].arrayValue, action: room["actions"])
                    }
                    print("--------------")
                    print(self.roomInfo.count)
                }
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = roomsTableView.dequeueReusableCell(withIdentifier: "roomCell") as! RoomCell
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = cell.frame.height / 4
        cell.backgroundColor = UIColor.lightGray
        cell.roomNameLabel.text = "TypAvRum\(indexPath.row)"
//        cell.roomNameLabel.text = roomInfo[indexPath.row].roomName
        cell.lightsInfoLabel.text = "Alla lampor är av"
        cell.lightSwitch.isOn = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "YOUR ROOMS"
    }
}


//http://192.168.1.225/api/CX0XuJlmCpBkjKepii0zJl6P3i7J77-dduoNjiTM/groups/1/action

//Alamofire.request(url, method: .get)
//    .responseJSON { response in
//        if response.result.isSuccess {
//            self.bridgeJSON = JSON(response.result.value!)
//            print(self.bridgeJSON!)
//            print(self.bridgeJSON![0]["internalipaddress"])
//            print(self.bridgeJSON![0]["id"])
//
//            for bridge in self.bridgeJSON! {
//                let bridgeInfo = BridgeInfo(ip: bridge.1["internalipaddress"].stringValue, id: bridge.1["id"].stringValue)
//                self.bridges.append(bridgeInfo)
//                self.bridges.append(bridgeInfo)
//                self.bridges.append(bridgeInfo)
//                self.bridges.append(bridgeInfo)
//
//                print(self.bridges)
//                if self.bridges.count > 0 {
//                    self.perform(#selector(self.updateSearchUI), with: nil, afterDelay: 3)
//                }
//            }
//        }
//}
