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
    func didChangeLightSlider(sender: CustomSlider, room: (key: String, val: RoomInfo), event: UIEvent)
}

class RoomCell: UITableViewCell {

    @IBOutlet weak var roomTytpeImage: UIImageView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var lightsInfoLabel: UILabel!
    @IBOutlet weak var lightSwitch: UISwitch!
    @IBOutlet weak var lightSlider: CustomSlider!
    
    var delegate : RoomCellDelegate?
    var room : (key: String, val: RoomInfo)!
    
    func setCellLayout(cell: RoomCell) {
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.layer.cornerRadius = 15
        cell.backgroundColor = UIColor.lightGray
    }
    
//    func addSliderTarget() {
//        lightSlider.addTarget(self, action: #selector(lightSliderChanged(_:forEvent:)), for: .valueChanged)
//    }
    
    func setRoomInfo(roomInfo: (key: String, val: RoomInfo)) {
        self.room = roomInfo
        guard let sliderValue = (roomInfo.val.action?.bri) else { return }
        lightSlider.value = Float(sliderValue)
        roomNameLabel.text = room.val.name
        roomTytpeImage.image = UIImage(named: "rooms\(roomInfo.val.class)")
        if room.val.state?.all_on ?? false || room.val.state?.any_on ?? false {
            lightSwitch.isOn = true
            lightSlider.isHidden = false
            lightsInfoLabel.text = "Lights are on"
        } else {
            lightSwitch.isOn = false
            lightSlider.isHidden = true
            lightsInfoLabel.text = "Lights are off"
        }
    }
    
    @IBAction func lightSwitchPressed(_ sender: UISwitch) {
        delegate?.didtapLightSwitch(isOn: sender.isOn, room: room)
    }
    
    @IBAction func lightSliderChanged(_ sender: CustomSlider, forEvent event: UIEvent) {
        delegate?.didChangeLightSlider(sender: sender, room: room, event: event)
    }
}
