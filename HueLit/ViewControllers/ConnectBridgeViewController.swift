//
//  ConnectBridgeViewController.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-17.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit
import Alamofire

class ConnectBridgeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bridgeTableView: UITableView!
    let defaults = UserDefaults.standard
    let url = "https://www.meethue.com/api/nupnp"
    var bridges : [BridgeInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        bridgeTableView.delegate = self
        bridgeTableView.dataSource = self
        bridgeTableView.backgroundColor = UIColor.black
        self.view.backgroundColor = UIColor.black
        print(bridges)
        animateTable()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bridges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bridgeCell", for: indexPath)
        cell.layer.borderWidth = 5.0
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = cell.frame.height / 4
        cell.backgroundColor = UIColor.lightGray
        cell.textLabel?.text = bridges[indexPath.row].internalipaddress
        cell.detailTextLabel?.text = bridges[indexPath.row].id
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaults.set(bridges[indexPath.row].internalipaddress, forKey: "bridgeIp")
        performSegue(withIdentifier: "tableViewPushLink", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableViewPushLink" {
            let pushLinkVC = segue.destination as! PushLinkViewController
            let index = bridgeTableView.indexPathForSelectedRow?.row
            pushLinkVC.bridge = bridges[index!]
        }
    }

    func animateTable(){
        bridgeTableView.reloadData()
        let cells = bridgeTableView.visibleCells
        
        let tableViewHeight = bridgeTableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05,usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseIn, .curveEaseOut], animations: {cell.transform = CGAffineTransform.identity}, completion: nil)
            delayCounter += 1
        }
    }
}
