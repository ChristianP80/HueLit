//
//  LightsCapabilities.swift
//  HueLit
//
//  Created by Christian Persson on 2019-06-01.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import Foundation

struct LightCapabilities : Decodable {
    let certified : Bool
    let control : LightCapabilitiesControl
    let streaming : LightsCapabilitiesStreaming
}
