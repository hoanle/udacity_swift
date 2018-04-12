//
//  ViewController.swift
//  MemeMe
//
//  Created by Hoan on 2/2/18.
//  Copyright © 2018 Hoan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var buttonCamera: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    var currentMeme: Meme?
    var canGoBack = false
    
    @IBAction func onPickerAlbum(_ sender: Any) {
        presentImagePicker(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    @IBAction func onPickerCamera(_ sender: Any) {
       presentImagePicker(UIImagePickerControllerSourceType.camera)
    }
    
    func onReset() {
        image.image = UIImage.init(named: "holder_rectangle")
        bottomText.text = "Bottom text here"
        topText.text = "Top text here"
        self.shareButton.isEnabled = false
        self.cancelBtn.isEnabled = false
    }
    
    @IBAction func onShare(_ sender: Any) {
        let meme = save()
        
        let shareItem = meme.memeImage
        
        let activityItem: [AnyObject] = [shareItem as AnyObject]
        
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        
        avc.completionWithItemsHandler = {(activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed && error == nil {
                self.onReset()
                //self.addItemToList(itemToCheck: meme)
                //let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC") as! TabBarViewController
                //self.show(vc, sender: self)
            }
        }
        self.present(avc, animated: true, completion: nil)
    }
    
    private func addItemToList(itemToCheck: Meme) {
        for index in 0..<TabBarViewController.memes.count {
            if TabBarViewController.memes[index].id == itemToCheck.id {
                TabBarViewController.memes.remove(at:  index)
                TabBarViewController.memes.append(itemToCheck)
                return
            }
        }
        TabBarViewController.memes.append(itemToCheck)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memeTextAttributes:[String:Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            NSAttributedStringKey.strokeWidth.rawValue: -3.0 ]
        
        setupTextFieldsFont(memeTextAttributes: memeTextAttributes)
        
        buttonCamera.isEnabled = isCameraAvailable()
    
        checkEditMode()
        
        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func checkEditMode() {
        if currentMeme == nil {
            enableButton(self.shareButton, false)
            setUpText(textField: bottomText, text: "Bottom text here")
            setUpText(textField: topText, text: "Top text here")
        } else {
            enableButton(self.shareButton, true)
            self.image.image = currentMeme?.originalImage
            setUpText(textField: bottomText, text: currentMeme?.bottomText)
            setUpText(textField: topText, text: currentMeme?.topText)
        }
        enableButton(self.cancelBtn, canGoBack)
    }
    
    func setUpText(textField: UITextField, text: String?) {
        textField.text = text
        textField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func cancelMemeShare(_ sender: Any) {
        onReset()
        dismiss(animated: true, completion: nil)
    }

    func enableButton(_ button: UIBarButtonItem,_ enabled: Bool){
        button.isEnabled = enabled
    }
    
    func save() -> Meme {
        var timeStamp = NSDate().timeIntervalSince1970.hashValue
        
        if currentMeme != nil {
            timeStamp = currentMeme!.id
        }
        return Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: image.image!, memeImage: generateMemedImage(), id: timeStamp)
    }
    
    func generateMemedImage() -> UIImage {
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        return memedImage
    }
    
    func setupTextFieldsFont(memeTextAttributes:[String:Any])  {
        self.bottomText.defaultTextAttributes = memeTextAttributes
        self.bottomText.borderStyle = .none
        
        self.topText.defaultTextAttributes = memeTextAttributes
        self.topText.borderStyle = .none
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder {
            self.view.frame.origin.y -= getKeyboardHeight(notification: notification)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
        
    }
    
}

extension ViewController: UIImagePickerControllerDelegate {
    
    func presentImagePicker(_ type: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = type
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func isCameraAvailable() ->  Bool {
        return UIImagePickerController.isCameraDeviceAvailable(.front) || UIImagePickerController.isCameraDeviceAvailable(.rear)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            image.image = img
            enableButton(self.shareButton, true)
            enableButton(self.cancelBtn, true)
        }
        else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            image.image = img
            enableButton(self.shareButton, true)
            enableButton(self.cancelBtn, true)
        }
        
        picker.dismiss(animated: true,completion: nil)
    }
}
