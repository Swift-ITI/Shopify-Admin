//
//  ProductDetailsVC.swift
//  Shopify-Admin
//
//  Created by Adham Samer on 27/02/2023.
//

import UIKit

class ProductDetailsVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var nameTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func imageUplod(_ sender: Any) {
//        let imgPicker = UIImagePickerController()
//        imgPicker.delegate = self
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
//            imgPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
//            self.present(imgPicker, animated: true)
//        }
        
    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        productImage.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        print(productImage!)
//        dismiss(animated: true)
//    }
    
}

