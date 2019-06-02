//
//  LightCapabilitiesControll.swift
//  HueLit
//
//  Created by Christian Persson on 2019-06-01.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import Foundation

struct LightCapabilitiesControl : Decodable {
    let mindimlevel : Double
    let maxlumen : Double
    let colorgamuttype : String
    let colorgamut : [[Double]]
    let ct : LightCapabilitiesControlCt
}
