//
//  CreateRoomViewController.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-31.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit

class CreateRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var lightsTableView: UITableView!
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var typeOfRoomLabel: UILabel!
    @IBOutlet weak var roomTypePicker: UIPickerView!
    
    let bridgeUser = UserDefaults.standard.string(forKey: "bridgeUser") ?? String()
    let bridgeIp = UserDefaults.standard.string(forKey: "bridgeIp") ?? String()
    var jsonUrl = ""
    var createUrl = ""
    var lightInfo : [String:LightInfo] = [:]
    var lightArray : [(key: String, val: LightInfo)] = []
    var lightsToBeAdded : [String] = []
    var roomType : String = ""
    let roomTypePickerData : [String] = ["Attic", "Bathroom", "Bedroom", "Computer", "Dining", "Garage", "Guestroom", "Gym", "Hallway", "Kidsbedroom", "Kitchen", "Laundryroom", "Living", "Mancave", "Office", "Other", "Staircase", "Studio", "Terrace", "Toilet", ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildJsonUrl()
        buildCreateUrl()
        roomTypePicker.delegate = self
        roomTypePicker.dataSource = self
        roomNameTextField.delegate = self
        lightsTableView.delegate = self
        lightsTableView.dataSource = self
        lightsTableView.rowHeight = 60
        lightsTableView.backgroundColor = UIColor.black
        setupKeyboardDismissRecognizer()
        getAllLights()
        print(lightArray.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAllLights()
    }
    
    func buildJsonUrl() {
        jsonUrl = "http:\(bridgeIp)/api/\(bridgeUser)/lights"
    }
    
    func buildCreateUrl() {
        createUrl = "http:\(bridgeIp)/api/\(bridgeUser)/groups"
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
        cell.setCellLayout(cell: cell)
        cell.setLightInfo(lightInfo: lightArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Lights selection"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.black
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor.white
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roomTypePickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roomTypePickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        roomType = roomTypePickerData[row]
        print(roomType)
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

