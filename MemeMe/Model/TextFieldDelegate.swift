//
//  TextFieldDelegate.swift
//  ImagePickerExperiment
//
//  Created by Edgar Cobos on 2019-05-31.
//  Copyright © 2019 Edgar Cobos. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
