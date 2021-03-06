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
    @IBOutlet weak var roomsNavBar: UINavigationBar!
    
    var jsonUrl = ""
    var changeStateUrl = ""
    var roomInfo : [String:RoomInfo] = [:]
    let bridgeUser = UserDefaults.standard.string(forKey: "bridgeUser") ?? String()
    let bridgeIp = UserDefaults.standard.string(forKey: "bridgeIp") ?? String()
    var roomArray : [(key: String, val: RoomInfo)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        buildJsonUrl()
        buildChangeStateUrl()
        roomsNavBar.topItem?.title = "Rooms"
        roomsTableView.delegate = self
        roomsTableView.dataSource = self
        roomsTableView.reloadData()
        searchForRooms()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchForRooms()
    }
    
    func buildJsonUrl() {
        jsonUrl = "http:\(bridgeIp)/api/\(bridgeUser)/groups"
    }
    
    func buildChangeStateUrl() {
        changeStateUrl = "http:\(bridgeIp)/api/\(bridgeUser)/groups/action"
    }
    
    func searchForRooms() {
        guard let url = URL(string: jsonUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                self.roomInfo = try JSONDecoder().decode([String:RoomInfo].self, from: data)
                self.roomArray = self.roomInfo.map{$0}
                self.roomArray = self.roomArray.sorted(by: { $0.0 < $1.0})
                print("kommer hit")
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
            let lightsSetupVC = self.storyboard?.instantiateViewController(withIdentifier: "searchNewLights") as! SearchNewLightsViewController
            self.present(lightsSetupVC, animated: true, completion: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeColor" {
            let selectedRoomVC = segue.destination as! SelectedRoomViewController
            let index = roomsTableView.indexPathForSelectedRow?.row
            selectedRoomVC.room = roomArray[index!]
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedRoomVC = self.storyboard?.instantiateViewController(withIdentifier: "selectedRoomVC") as! SelectedRoomViewController
//        self.present(selectedRoomVC, animated: true, completion: nil)
        performSegue(withIdentifier: "changeColor", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if roomArray[indexPath.row].val.state?.all_on ?? false || roomArray[indexPath.row].val.state?.any_on ?? false {
            return 100
        } else{
            return 60
        }
    }
}

extension RoomsViewController : RoomCellDelegate {

    func didChangeLightSlider(sender: CustomSlider, room: (key: String, val: RoomInfo), event: UIEvent) {
        print(sender.value)
        sender.isContinuous = true
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                print("began")
            //                slider.trackHeight = 100
            case .moved:
                print("moved")
//                let bri = UInt8(sender.value)
//                print(bri)
//                changeLightState(room: room, bri: bri)
            //                slider.trackHeight = 100
            case .ended:
                print("ended")
                let bri = UInt8(sender.value)
                print(bri)
                changeLightState(room: room, bri: bri)
            //                slider.trackHeight = 25
            default:
                break
            }
        }
    }

    func didtapLightSwitch(isOn: Bool, room: (key: String, val: RoomInfo)){
        print(room.key)
        print(room)
        print(isOn)
        let jsonUrl = "http:192.168.1.225/api/u2q1iWISCdcW2bOee7ixyRlli9Sd5p-G4PM0ZNUI/groups/\(room.key)/action"
        let body = ["on": isOn]
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
        self.searchForRooms()
    }
    
    func changeLightState(room: (key: String, val: RoomInfo), bri: UInt8) {
        let jsonUrl = "http:192.168.1.225/api/u2q1iWISCdcW2bOee7ixyRlli9Sd5p-G4PM0ZNUI/groups/\(room.key)/action"
        let body = ["bri": bri]
        guard let url = URL(string: jsonUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        URLSession.shared.uploadTask(with: request, from: jsonData) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else { return }
            if (200...209).contains(response.statusCode) {
                
            }
        }.resume()
    }
}

