//
//  ConnectBridgeViewController.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-17.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ConnectBridgeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bridgeTableView: UITableView!
    let url = "https://www.meethue.com/api/nupnp"
    var bridges : [BridgeInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        bridgeTableView.delegate = self
        bridgeTableView.dataSource = self
        print(bridges)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return bridges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bridgeCell", for: indexPath)
        cell.textLabel?.text = bridges[indexPath.row].id
        cell.detailTextLabel?.text = bridges[indexPath.row].ip
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
