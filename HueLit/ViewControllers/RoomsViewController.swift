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
    @IBAction func addClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Setup", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Room setup", style: .default, handler: { (_) in
            print("User clicked RoomSetup")
            let roomSetupVC = self.storyboard?.instantiateViewController(withIdentifier: "roomSetupVC") as! RoomSetupViewController
            self.present(roomSetupVC, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Light setup", style: .default, handler: { (_) in
            print("User clicked Light setup")
        }))
        
        alert.addAction(UIAlertAction(title: "Accessory setup", style: .default, handler: { (_) in
            print("User clicked Accessory setup")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("User clicked cancel")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = roomsTableView.dequeueReusableCell(withIdentifier: "roomCell") as! RoomCell
        cell.delegate = self
        cell.setCellLayout(cell: cell)
        cell.setRoomInfo(roomInfo: roomArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "YOUR ROOMS"
    }
}

extension RoomsViewController : RoomCellDelegate {
    
    func didtapLightSwitch(isOn: Bool, room: (key: String, val: RoomInfo)){
        print(room.key)
        print(room)
        print(isOn)
        let jsonUrl = "http:192.168.1.225/api/u2q1iWISCdcW2bOee7ixyRlli9Sd5p-G4PM0ZNUI/groups/\(room.key)/action"
        let body = ["on": isOn]
        let session = URLSession.shared
        let url = URL(string: jsonUrl)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            
        }
        task.resume()
    }
    
    
}


//http://192.168.1.225/api/CX0XuJlmCpBkjKepii0zJl6P3i7J77-dduoNjiTM/groups/1/action
//875058
//D66B18
//

//från fjället CX0XuJlmCpBkjKepii0zJl6P3i7J77-dduoNjiTM
