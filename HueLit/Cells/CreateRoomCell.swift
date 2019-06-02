//
//  CreateRoomCell.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-31.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit

class CreateRoomCell: UITableViewCell {

    @IBOutlet weak var lightImageView: UIImageView!
    @IBOutlet weak var lightTypeLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    var light : (key: String, val: LightInfo)!
    
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
    
    func setLightInfo(lightInfo : (key: String, val: LightInfo)) {
        self.light = lightInfo
        lightTypeLabel.text = light.val.productname
        roomNameLabel.text = light.val.name
    }
    
}
