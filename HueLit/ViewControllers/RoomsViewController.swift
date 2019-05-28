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
    let jsonUrl = "http:10.206.9.199/api/poV2ob5w8BJN0Vw7gQz8-VqXt883Qz46mwc2a6Pn/groups"
    //let jsonUrl = "http:\(bridgeIp!)/api/\(bridgeUser!)/groups"
    var roomJSON : JSON? = JSON.null
    var roomInfo : [RoomInfo] = []
    var test : [String : Any] = [:]
    let bridgeUser = UserDefaults.standard.string(forKey: "bridgeUser")
    let bridgeIp = UserDefaults.standard.string(forKey: "bridgeIp")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        roomsTableView.delegate = self
        roomsTableView.dataSource = self
        roomsTableView.backgroundColor = UIColor.darkGray
        searchForRooms()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        searchForRooms()
//        roomsTableView.reloadData()
//        print("in viewDidAppear: \(roomInfo.count)")
//    }
    
    func searchForRooms() {
        
        guard let url = URL(string: jsonUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let rooms = try JSONSerialization.jsonObject(with: data) as! [String:Any]
                print(rooms)
            } catch let error {
                print("Error:", error)
            }
            }.resume()
        
//        Alamofire.request(jsonUrl, method: .get)
//            .responseJSON { response in
//                if response.result.isSuccess {
//                    self.roomJSON = JSON(response.result.value!)
//                    print(self.roomJSON!)
//                    for room in self.roomJSON! {
//                        print(room.1["name"])
//                        print(room.1["lights"])
//                        print(room.1["action"])
//                        print(room.1["state"])
//                        let someRoom = RoomInfo(roomName: room.1["name"].stringValue)
//                        print(someRoom)
//                        let actionJSON = JSON(room.1["action"])
//                        print(actionJSON)
//                        print("xxxxxxxxxxxxxxxxxxx")
//                        //                        print(actionJSON)
//                        //                        let room = RoomInfo(roomName: room.1["name"].stringValue, lights: room.1["lights"].arrayObject, action: room.1["actions"].arrayValue)
//                        let room = RoomInfo(roomName: room.1["name"].stringValue)
//                        print("printing someroom: \(room.roomName!)")
//                        self.roomInfo.append(room)
//                    }
//                    print("--------------")
//                    print(self.roomInfo.count)
//                    self.roomsTableView.reloadData()
//                }
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = roomsTableView.dequeueReusableCell(withIdentifier: "roomCell") as! RoomCell
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = cell.frame.height / 4
        cell.backgroundColor = UIColor.lightGray
//        cell.roomNameLabel.text = "TypAvRum\(indexPath.row)"
        cell.roomNameLabel.text = roomInfo[indexPath.row].roomName
        cell.lightsInfoLabel.text = "Alla lampor är av"
        cell.lightSwitch.isOn = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "YOUR ROOMS"
    }
}


//http://192.168.1.225/api/CX0XuJlmCpBkjKepii0zJl6P3i7J77-dduoNjiTM/groups/1/action
//875058
//D66B18
//

//från fjället CX0XuJlmCpBkjKepii0zJl6P3i7J77-dduoNjiTM

//guard let url = URL(string: jsonUrl) else { return }
//
//URLSession.shared.dataTask(with: url) { (data, response, error) in
//    guard let data = data else { return }
//    do {
//        let rooms = try JSONDecoder().decode(RoomInfo.self, from: data)
//        print(rooms)
//        print(data)
//        print(response!)
//    } catch let error {
//        print("Error:", error)
//    }
//    }.resume()
