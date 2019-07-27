//
//  ViewController.swift
//  Home work 2.2
//
//  Created by Maksim Grebenozhko on 26/07/2019.
//  Copyright © 2019 Maksim Grebenozhko. All rights reserved.
//

import UIKit

public enum KeyboardAction {
    case willChangeFrame
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    struct ColorForView {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
    }

    @IBOutlet var viewForPaint: UIView!
    @IBOutlet var viewForDone: UIView!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!

    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
        
    var colorForView = ColorForView()
    let notification = NotificationCenter.default
    var keyboardFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var sliderMaximum: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notification.addObserver(self,
                           selector: #selector(keyboardChange),
                           name: UIResponder.keyboardWillChangeFrameNotification,
                           object: nil)
        
        viewForPaint.layer.cornerRadius = 10
        
        colorForView.red = CGFloat(redSlider.value)
        colorForView.green = CGFloat(greenSlider.value)
        colorForView.blue = CGFloat(blueSlider.value)
        
        redLabel.text = String(format: "%.2f", redSlider.value)
        greenLabel.text = String(format: "%.2f", greenSlider.value)
        blueLabel.text = String(format: "%.2f", blueSlider.value)
        
        redTextField.text = redLabel.text
        greenTextField.text = greenLabel.text
        blueTextField.text = blueLabel.text
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self

        sliderMaximum = redSlider.maximumValue
            
        viewForPaint.backgroundColor = .init(red: colorForView.red, green: colorForView.green, blue: colorForView.blue, alpha: 1)
    }

    @IBAction func sliderMove(_ sender: UISlider) {
        
        var label: UILabel!
        var textField: UITextField!
        
        switch sender {
        case redSlider:
            label = redLabel
            textField = redTextField
            colorForView.red = CGFloat(sender.value)
        case greenSlider:
            label = greenLabel
            textField = greenTextField
            colorForView.green = CGFloat(sender.value)
        case blueSlider:
            label = blueLabel
            textField = blueTextField
            colorForView.blue = CGFloat(sender.value)
        default:
            break
        }
        
        label.text = String(format: "%.2f", sender.value)
        textField.text = label.text
        viewForPaint.backgroundColor = .init(red: colorForView.red, green: colorForView.green, blue: colorForView.blue, alpha: 1)
    }
    
    @IBAction func textFieldEdit(_ sender: UITextField) {

        guard let string = sender.text, !string.isEmpty, let value = Float(string) else { return }

        var slider: UISlider!
        var label: UILabel!

        switch sender {
        case redTextField:
            slider = redSlider
            label = redLabel
            colorForView.red = CGFloat(value)
        case greenTextField:
            slider = greenSlider
            label = greenLabel
            colorForView.green = CGFloat(value)
        case blueTextField:
            slider = blueSlider
            label = blueLabel
            colorForView.blue = CGFloat(value)
        default:
            break
        }
        
        slider.value = value
        label.text = sender.text
        viewForPaint.backgroundColor = .init(red: colorForView.red, green: colorForView.green, blue: colorForView.blue, alpha: 1)
    }
    
    @IBAction func doneEditing() {
        redTextField.resignFirstResponder()
        greenTextField.resignFirstResponder()
        blueTextField.resignFirstResponder()
        viewForDone.isHidden = true
    }
    
    func textFieldShouldEndEditing(_ sender: UITextField) -> Bool {
        
        var label: UILabel!
        
        switch sender {
        case redTextField: label = redLabel
        case greenTextField: label = greenLabel
        case blueTextField: label = blueLabel
        default: break
        }
        
        guard let string = sender.text, !string.isEmpty, let value = Float(string) else {
            sender.text = label.text
            return true
        }
        
        if value > sliderMaximum {
            sender.text = String(format: "%.2f", sliderMaximum)
        } else {
            sender.text = String(format: "%.2f", value)
        }
        
        return true
    }
    
    @objc func keyboardChange(notification: NSNotification) {
        guard let action = action(from: notification.name) else { return }
        
        guard let userInfo = notification.userInfo,
            let frame    = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        
        viewForDone.frame = CGRect(x: frame.origin.x, y: frame.origin.y - viewForDone.frame.size.height, width: viewForDone.frame.size.width, height: viewForDone.frame.size.height)
        viewForDone.isHidden = false
    }

    private func action(from notificationName: NSNotification.Name) -> KeyboardAction? {
        switch notificationName {
        case UIResponder.keyboardWillChangeFrameNotification:
            return .willChangeFrame
        default:
            return nil
        }
    }
}

