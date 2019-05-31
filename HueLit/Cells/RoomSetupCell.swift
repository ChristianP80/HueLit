//
//  RoomSetupCell.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-30.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit

class RoomSetupCell: UITableViewCell {

    @IBOutlet weak var roomImageView: UIImageView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var numberOfLightsLabel: UILabel!
    
    var room : (key: String, val: RoomInfo)!
    
    func setCellLayout(cell: RoomSetupCell) {
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = cell.frame.height / 4
        cell.backgroundColor = UIColor.lightGray
    }
    
    func setRoomInfo(roomInfo: (key: String, val: RoomInfo)) {
        self.room = roomInfo
        roomNameLabel.text = room.val.name
        numberOfLightsLabel.text = "\(room.val.lights.count) lights available"
    }
}
