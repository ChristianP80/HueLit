//
//  CreateRoomViewController.swift
//  HueLit
//
//  Created by Christian Persson on 2019-05-31.
//  Copyright © 2019 Christian Persson. All rights reserved.
//

import UIKit

class CreateRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var lightsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomNameTextField.delegate = self
        lightsTableView.delegate = self
        lightsTableView.dataSource = self
        lightsTableView.rowHeight = 60
        setupKeyboardDismissRecognizer()
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

    @IBAction func cancelCreate(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveRoom(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = lightsTableView.dequeueReusableCell(withIdentifier: "CreateRoomCell") as! CreateRoomCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Lights selection"
    }
}
