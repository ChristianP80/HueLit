//
//  RoomAction.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-28.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import Foundation

struct RoomAction: Decodable {
    var on: Bool
    var bri: Double
    var hue: Double
    var sat: Double
    var effect: String
    var xy: [Double]
    var ct: Double
    var alert: String
    var colormode: String
}
