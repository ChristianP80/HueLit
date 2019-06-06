//
//  CreateRoomCell.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-31.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit

protocol CreateRoomCellDelegate {
    func didTapCheckBoxButton(sender: UIButton, light: (key: String, val: LightInfo))
}

class CreateRoomCell: UITableViewCell {

    @IBOutlet weak var lightImageView: UIImageView!
    @IBOutlet weak var lightTypeLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    var delegate : CreateRoomCellDelegate?
    var light : (key: String, val: LightInfo)!
    
    @IBAction func checkBoxTapped(_ sender: UIButton) {
        delegate?.didTapCheckBoxButton(sender: sender, light: light)
    }
    
    func setCellLayout(cell: CreateRoomCell) {
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = cell.frame.height / 4
        cell.backgroundColor = UIColor.darkGray
    }
    
    func setLightInfo(lightInfo : (key: String, val: LightInfo)) {
        self.light = lightInfo
        lightTypeLabel.text = light.val.productname
        roomNameLabel.text = light.val.name
    }
    
}
