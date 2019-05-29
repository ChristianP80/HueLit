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
    let jsonUrl = "http:192.168.1.225/api/u2q1iWISCdcW2bOee7ixyRlli9Sd5p-G4PM0ZNUI/groups"
    //let jsonUrl = "http:\(bridgeIp!)/api/\(bridgeUser!)/groups"
    var roomJSON : JSON? = JSON.null
    var roomInfo : [String:RoomInfo] = [:]
    var rooms : [RoomInfo] = []
    let bridgeUser = UserDefaults.standard.string(forKey: "bridgeUser")
    let bridgeIp = UserDefaults.standard.string(forKey: "bridgeIp")
    var roomArray : [(key: String, val: RoomInfo)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchForRooms()
        roomsTableView.delegate = self
        roomsTableView.dataSource = self
        roomsTableView.backgroundColor = UIColor.darkGray
        roomsTableView.reloadData()

    }
    
    func searchForRooms() {
        
        guard let url = URL(string: jsonUrl) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                self.roomInfo = try JSONDecoder().decode([String:RoomInfo].self, from: data)
                self.roomArray = self.roomInfo.map{$0}
                print(type(of: self.roomArray))
                print(self.roomArray.count)
                for item in self.roomArray {
                    print(item)
                }
            } catch let error {
                print("Error:", error)
            }
            DispatchQueue.main.async {
                self.roomsTableView.reloadData()
            }
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = roomsTableView.dequeueReusableCell(withIdentifier: "roomCell") as! RoomCell
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = cell.frame.height / 4
        cell.backgroundColor = UIColor.lightGray
        cell.roomNameLabel.text = roomArray[indexPath.row].val.name
        cell.lightsInfoLabel.text = "Alla lampor är av"
        if roomArray[indexPath.row].val.state.any_on == true || roomArray[indexPath.row].val.state.all_on == true {
            cell.lightSwitch.isOn = true
        } else {
            cell.lightSwitch.isOn = false
        }
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
