//
//  ViewController.swift
//  MemeV1
//
//  Created by Divya Kabra on 5/11/17.
//  Copyright © 2017 Divya Kabra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Properties
   
    var meme: Meme?

    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    let memeTextAttributes: [String: Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size:30)!,
        NSStrokeWidthAttributeName: -3.0] //Check the difference b/w -3 n +3
    
    // MARK: Functions
    
    func save() {
        meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        
        return memedImage
    }
    
    // MARK: Override functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // shareButton.isEnabled = false
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        configureTextField(topTextField)
        configureTextField(bottomTextField)
        shareButton.isEnabled = false // Don't put it in viewWillAppear
    }
    
    // Function to avoid repetitive blocks of code
    func configureTextField(_ textField: UITextField){
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func pickingImage(_ sourceType: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Actions


    @IBAction func pickImageFromAlbum(_ sender: Any) {
        pickingImage(.photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickingImage(.camera)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let image = generateMemedImage()
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        activity.completionWithItemsHandler = {_ in
            self.save()
            self.dismiss(animated: true, completion: nil)
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imageView.image = nil
        shareButton.isEnabled = false
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Text Field Delegates' Necessities

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.contains("TOP") || textField.text!.contains("BOTTOM"){
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}

