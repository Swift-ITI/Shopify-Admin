//
//  LoginVC.swift
//  Shopify-Admin
//
//  Created by Adham Samer on 02/03/2023.
//

import SwiftyGif
import UIKit
class LoginVC: UIViewController {
    @IBOutlet var pwTxtField: UITextField! {
        didSet {
            pwTxtField.delegate = self
            pwTxtField.layer.cornerRadius = 10
            pwTxtField.layer.borderColor = UIColor(named: "SecondaryColor")?.cgColor
            pwTxtField.layer.borderWidth = 2
        }
    }

    @IBOutlet var loginImage: UIImageView! {
        didSet {
//            let gif = try! UIImage(gifName: "cart")
//            loginImage.setGifImage(gif,loopCount: -1)
            loginImage.image = UIImage(named: "Splash")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginBtn(_ sender: Any) {
        if pwTxtField.text == "1234" {
            performSegue(withIdentifier: "goToTabBar", sender: self)
        } else {
            showAlert()
        }
    }

    func showAlert() {
        let alert = UIAlertController(title: "Wrong Credentials!", message: "Enter new password", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pwTxtField.endEditing(true)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

