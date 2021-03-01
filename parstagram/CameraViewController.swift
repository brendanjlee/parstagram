//
//  CameraViewController.swift
//  parstagram
//
//  Created by Brendan Lee on 2/28/21.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Submit Button
    @IBAction func onSubmitButton(_ sender: Any) {
        
        // Create a new column post
        let post = PFObject(className: "Posts")
        post["caption"] = commentView.text
        post["author"] = PFUser.current()!
        
        let imageData = imageView.image?.pngData()
        let file = PFFileObject(data: imageData!)
        
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            if (success) {
                self.dismiss(animated: true, completion: nil)
                print("Saved")
            }
            else {
                print("Error: \(String(describing: error))")
            }
            
        }
    }
    
    // Camera Button
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        // Check if camera is avaiable
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .cameras
        }
        else {
            picker.sourceType = .photoLibrary
        }
    
        // show the photo album
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        
        imageView.image = scaledImage
        dismiss(animated: true, completion: nil)
    }

}
