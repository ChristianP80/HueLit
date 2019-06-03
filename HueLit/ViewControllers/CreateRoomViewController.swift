//
//  CreateRoomViewController.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-31.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit

class CreateRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var lightsTableView: UITableView!
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var typeOfRoomLabel: UILabel!
    
    let bridgeUser = UserDefaults.standard.string(forKey: "bridgeUser")
    let bridgeIp = UserDefaults.standard.string(forKey: "bridgeIp")
    let jsonUrl = "http:192.168.1.225/api/mooY-Ctmw5-YSLO4m0Uyw30BBAvzjJYInxzmCzA8/lights"
    let createUrl = "http:192.168.1.225/api/mooY-Ctmw5-YSLO4m0Uyw30BBAvzjJYInxzmCzA8/groups"
    var lightInfo : [String:LightInfo] = [:]
    var lightArray : [(key: String, val: LightInfo)] = []
    var lightsToBeAdded : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomNameTextField.delegate = self
        lightsTableView.delegate = self
        lightsTableView.dataSource = self
        lightsTableView.rowHeight = 60
        setupKeyboardDismissRecognizer()
        getAllLights()
        print(typeOfRoomLabel.text!)
        print(lightArray.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllLights()
    }
    
    func getAllLights() {
        guard let url = URL(string: jsonUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                print(data)
                self.lightInfo = try JSONDecoder().decode([String:LightInfo].self, from: data)
                print(self.lightInfo)
                self.lightArray = self.lightInfo.map{$0}
                self.lightArray = self.lightArray.sorted(by: { $0.0 < $1.0})
                print("kommer hit")
                print(type(of: self.lightArray))
                print(self.lightArray.count)
                for item in self.lightArray {
                    print(item)
                }
            } catch let error {
                print("Error:", error)
            }
            DispatchQueue.main.async {
                self.lightsTableView.reloadData()
            }
            }.resume()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        roomNameTextField.resignFirstResponder()
        return true
    }
    
    func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(CreateRoomViewController.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @IBAction func searchLightsButton(_ sender: Any) {
        let searchNewLightsVC = self.storyboard?.instantiateViewController(withIdentifier: "searchNewLights") as! SearchNewLightsViewController
        self.present(searchNewLightsVC, animated: true, completion: nil)
    }
    

    @IBAction func cancelCreate(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveRoom(_ sender: Any) {
        let roomName = roomNameTextField.text!
        let roomType = typeOfRoomLabel.text!
        let json : [String : Any] = ["name": roomName, "type": "Room", "class": roomType, "lights": lightsToBeAdded]

        guard let url = URL(string: createUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do{
            print("Trying to create body")
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
        } catch let error{
            print(error.localizedDescription)
        }
        URLSession.shared.dataTask(with: request) {data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            print("Room created!")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lightArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = lightsTableView.dequeueReusableCell(withIdentifier: "CreateRoomCell") as! CreateRoomCell
        cell.delegate = self
        cell.setLightInfo(lightInfo: lightArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Lights selection"
    }
}

extension CreateRoomViewController : CreateRoomCellDelegate {
    func didTapCheckBoxButton(sender: UIButton, light: (key: String, val: LightInfo)) {
        if sender.isSelected {
            sender.isSelected = false
            if let index = lightsToBeAdded.firstIndex(of: light.key) {
                lightsToBeAdded.remove(at: index)
                print(lightsToBeAdded)
            }
        } else {
            sender.isSelected = true
            self.lightsToBeAdded.append(light.key)
            print(lightsToBeAdded)
        }
    }
}

