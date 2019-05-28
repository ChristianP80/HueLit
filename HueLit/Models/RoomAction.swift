//
//  RoomAction.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-28.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import Foundation

struct RoomAction: Decodable {
    let on: Bool
    let bri: Double
    let hue: Double
    let sat: Double
    let effect: String
    let xy: [Double]
    let ct: Double
    let alert: String
    let colormode: String
}
