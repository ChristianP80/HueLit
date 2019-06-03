//
//  RoomCell.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-25.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit

protocol RoomCellDelegate {
    func didtapLightSwitch(isOn: Bool, room: (key: String, val: RoomInfo ))
}

class RoomCell: UITableViewCell {

    @IBOutlet weak var roomTytpeImage: UIImageView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var lightsInfoLabel: UILabel!
    @IBOutlet weak var lightSwitch: UISwitch!
    
    var delegate : RoomCellDelegate?
    var room : (key: String, val: RoomInfo)!
    
    func setCellLayout(cell: RoomCell) {
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 25
        cell.backgroundColor = UIColor.lightGray
    }
    
    func setRoomInfo(roomInfo: (key: String, val: RoomInfo)) {
        self.room = roomInfo
        roomNameLabel.text = room.val.name
        lightsInfoLabel.text = "All lights are of!"
        if room.val.state?.all_on ?? false || room.val.state?.any_on ?? false {
            lightSwitch.isOn = true
        } else {
            lightSwitch.isOn = false
        }
    }
    
    @IBAction func lightSwitchPressed(_ sender: UISwitch) {
        delegate?.didtapLightSwitch(isOn: sender.isOn, room: room)
    }
    
}
