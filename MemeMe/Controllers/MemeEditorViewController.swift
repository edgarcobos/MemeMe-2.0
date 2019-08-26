//
//  MemeEditorViewController.swift
//  ImagePickerExperiment
//
//  Created by Edgar Cobos on 2019-05-20.
//  Copyright © 2019 Edgar Cobos. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navbar: UINavigationBar!
    
    let textFieldDelegate = TextFieldDelegate()

    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -4
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField(topField)
        configureTextField(bottomField)
        configureButton(imageChosen: false)
        cancelButton.isEnabled = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func configureTextField(_ textField: UITextField) {
        textField.delegate = textFieldDelegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
    }
    
    func configureButton(imageChosen: Bool) {
        if imageChosen {
            shareButton.isEnabled = true
            cancelButton.isEnabled = true
        }
        else {
            shareButton.isEnabled = false
            cancelButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        suscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        unsuscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func suscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsuscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType.photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType.camera)
    }
    
    func chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
        configureButton(imageChosen: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveMeme() {
        let meme = Meme(topText: topField.text!, bottomText: bottomField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage { UIGraphicsBeginImageContext(self.view.frame.size)
        
        toolbar.isHidden = true
        navbar.isHidden = true
        
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolbar.isHidden = false
        navbar.isHidden = false
        
        return memedImage
    }

    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, completed, items, error) in
            if completed {
                self.saveMeme()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        imagePickerView.image = UIImage()
        topField.text = "TOP"
        bottomField.text = "BOTTOM"
        dismiss(animated: true, completion: nil)
        configureButton(imageChosen: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

