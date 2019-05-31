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
    
    var roomArray : [(key: String, val: RoomInfo)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomTableView.delegate = self
        roomTableView.dataSource = self
        roomTableView.estimatedRowHeight = 80
        roomTableView.rowHeight = 60
        roomSetupNavBar.topItem?.title = "Room Setup"
        createButton.backgroundColor = UIColor.cyan
        createButton.layer.cornerRadius = 5
        print(roomArray[1])
        print(roomArray.count)    }
    
    @IBAction func closeRoomSetup(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createNewRoomClicked(_ sender: Any) {
    }
    
    func getRoomSetup() {
        
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
