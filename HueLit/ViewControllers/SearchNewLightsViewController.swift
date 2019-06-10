//
//  SearchNewLightsViewController.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-31.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit

class SearchNewLightsViewController: UIViewController {
    
    @IBOutlet weak var serialNumber1Label: UITextField!
    @IBOutlet weak var serialNumber2Label: UITextField!
    @IBOutlet weak var serialNumber3Label: UITextField!
    @IBOutlet weak var serialNumber4Label: UITextField!
    @IBOutlet weak var serialNumber5Label: UITextField!
    
    var snArray : [String] = []
    let bridgeUser = UserDefaults.standard.string(forKey: "bridgeUser") ?? String()
    let bridgeIp = UserDefaults.standard.string(forKey: "bridgeIp") ?? String()
    var jsonUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildJsonUrl()
    }
    
    func buildJsonUrl() {
        jsonUrl = "http:\(bridgeIp)/api/\(bridgeUser)/lights"
    }
    
    @IBAction func cancelNewLights(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func searchForNewLights(_ sender: Any) {
        snArray = []
        createArray()
        print(snArray)
        
        guard let url = URL(string: jsonUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do{
            print("Trying to search for new lights")
            let object = ["deviceid": snArray]
            let jsonData = try JSONSerialization.data(withJSONObject: object)
            request.httpBody = jsonData
        } catch let error{
            print(error.localizedDescription)
        }
        URLSession.shared.dataTask(with: request) {data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            print("Lights were found")
            print(response)
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            }.resume()
    }
    
    func createArray() {
        if serialNumber1Label.hasText {
            snArray.append(serialNumber1Label.text!)
        }
        if serialNumber2Label.hasText {
            snArray.append(serialNumber2Label.text!)
        }
        if serialNumber3Label.hasText {
            snArray.append(serialNumber3Label.text!)
        }
        if serialNumber4Label.hasText {
            snArray.append(serialNumber4Label.text!)
        }
        if serialNumber5Label.hasText {
            snArray.append(serialNumber5Label.text!)
        }
    }
    
}
