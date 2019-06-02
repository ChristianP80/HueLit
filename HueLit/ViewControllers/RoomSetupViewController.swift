//
//  RoomSetupViewController.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-30.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit

class RoomSetupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var roomSetupNavBar: UINavigationBar!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var roomTableView: UITableView!
    
    let jsonUrl = "http:192.168.1.225/api/mooY-Ctmw5-YSLO4m0Uyw30BBAvzjJYInxzmCzA8/groups"
    var roomInfo : [String:RoomInfo] = [:]
    var roomArray : [(key: String, val: RoomInfo)] = []
    let bridgeUser = UserDefaults.standard.string(forKey: "bridgeUser")
    let bridgeIp = UserDefaults.standard.string(forKey: "bridgeIp")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomTableView.delegate = self
        roomTableView.dataSource = self
        roomTableView.estimatedRowHeight = 80
        roomTableView.rowHeight = 60
        roomSetupNavBar.topItem?.title = "Room Setup"
        createButton.layer.cornerRadius = 5
        getRoomSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRoomSetup()
    }
    
    @IBAction func closeRoomSetup(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createNewRoomClicked(_ sender: Any) {
        let createRoomVC = self.storyboard?.instantiateViewController(withIdentifier: "createRoomVC") as! CreateRoomViewController
        self.present(createRoomVC, animated: true, completion: nil)
    }
    
    func getRoomSetup() {
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
                self.roomTableView.reloadData()
            }
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = roomTableView.dequeueReusableCell(withIdentifier: "roomSetupCell") as! RoomSetupCell
        cell.setCellLayout(cell: cell)
        cell.setRoomInfo(roomInfo: roomArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "AVAILABLE ROOMS"
    }
    
}
