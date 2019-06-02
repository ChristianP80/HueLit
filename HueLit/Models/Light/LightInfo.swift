//
//  LightsInfo.swift
//  HueLit
//
//  Created by Christian Persson on 2019-06-01.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import Foundation

struct LightsInfo : Decodable {
    let state : LightState
    let swupdate : LightSwUpdate
    let type : String
    let name : String
    let modelid : String
    let manufacturername : String
    let productname : String
    let capabilities : LightCapabilities
    let config : LightConfig
    let uniqueid : String
    let swversion : String
    let swconfigid : String
    let productid : String
}
