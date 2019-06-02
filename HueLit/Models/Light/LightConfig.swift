//
//  LightConfig.swift
//  HueLit
//
//  Created by Christian Persson on 2019-06-01.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import Foundation

struct LightConfig : Decodable {
    let archetype : String
    let function : String
    let direction : String
    let startup : LightConfigStartUp
}
