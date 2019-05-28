//
//  RoomInfo.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-25.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import Foundation

struct RoomInfo: Decodable {
    var roomName: String?
    var lights: [String]?
    var sensors: [String]?
    var type: String?
    var state: RoomState?
    var recycle: Bool?
    var `class` : String?
    var action: RoomAction?
}
