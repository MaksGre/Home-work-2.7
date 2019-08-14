//
//  ViewController.swift
//  Home work 2.7
//
//  Created by Maksim Grebenozhko on 13/08/2019.
//  Copyright © 2019 Maksim Grebenozhko. All rights reserved.
//

import UIKit

enum KeyboardAction {
    case willChangeFrame
}

struct ColorForView {
    
    var red: Float = 0.5
    var green: Float = 0.5
    var blue: Float = 0.5
}

class SetColorViewController: UIViewController {

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
        
    var colorForView: ColorForView!
    let notification = NotificationCenter.default
    var keyboardFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var sliderMaximum: Float = 0
    
    weak var delegate: SetColorViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notification.addObserver(self,
                           selector: #selector(keyboardChange),
                           name: UIResponder.keyboardWillChangeFrameNotification,
                           object: nil)
        
        viewForPaint.layer.cornerRadius = 10
        
        redSlider.value = Float(colorForView.red)
        greenSlider.value = Float(colorForView.green)
        blueSlider.value = Float(colorForView.blue)
        
        redLabel.text = String(format: "%.2f", redSlider.value)
        greenLabel.text = String(format: "%.2f", greenSlider.value)
        blueLabel.text = String(format: "%.2f", blueSlider.value)
        
        redTextField.text = redLabel.text
        greenTextField.text = greenLabel.text
        blueTextField.text = blueLabel.text
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
                
        viewForPaint.backgroundColor = UIColor(red: colorForView.red, green: colorForView.green, blue: colorForView.blue, alpha: 1)
    }

    @IBAction func didMoveSlider(_ sender: UISlider) {
        
        var label: UILabel!
        var textField: UITextField!
        
        switch sender {
        case redSlider:
            label = redLabel
            textField = redTextField
            colorForView.red = sender.value
        case greenSlider:
            label = greenLabel
            textField = greenTextField
            colorForView.green = sender.value
        case blueSlider:
            label = blueLabel
            textField = blueTextField
            colorForView.blue = sender.value
        default:
            return
        }

        label.text = String(format: "%.2f", sender.value)
        textField.text = label.text
        viewForPaint.backgroundColor = UIColor(red: colorForView.red, green: colorForView.green, blue: colorForView.blue, alpha: 1)
    }
    
    @IBAction func didEditTextField(_ sender: UITextField) {
        guard let string = sender.text, !string.isEmpty, let value = Float(string) else { return }

        var slider: UISlider!
        var label: UILabel!

        switch sender {
        case redTextField:
            slider = redSlider
            label = redLabel
            colorForView.red = value
        case greenTextField:
            slider = greenSlider
            label = greenLabel
            colorForView.green = value
        case blueTextField:
            slider = blueSlider
            label = blueLabel
            colorForView.blue = value
        default:
            return
        }
        
        slider.value = value
        label.text = sender.text
        viewForPaint.backgroundColor = UIColor(red: colorForView.red, green: colorForView.green, blue: colorForView.blue, alpha: 1)
    }
    
    @IBAction func doneEditing() {
        redTextField.resignFirstResponder()
        greenTextField.resignFirstResponder()
        blueTextField.resignFirstResponder()
        viewForDone.isHidden = true
    }
    
    @IBAction func backButtonPressed() {
        guard let colorForPaint = viewForPaint.backgroundColor,
            let delegate = delegate else { return }
        
        delegate.didSetColor(colorForPaint)
    }
    
    // MARK: - Notification
    
    @objc func keyboardChange(notification: NSNotification) {
        guard action(from: notification.name) != nil else { return }
        
        guard let userInfo = notification.userInfo,
            let frame    = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        
        viewForDone.frame = CGRect(x: frame.origin.x, y: frame.origin.y - viewForDone.frame.size.height, width: frame.size.width, height: viewForDone.frame.size.height)
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

extension SetColorViewController: UITextFieldDelegate {
    
//использую textFieldShouldEndEditing для обработки значения до передачи его другим элементам
    func textFieldShouldEndEditing(_ sender: UITextField) -> Bool {
        var label: UILabel!
        
        switch sender {
        case redTextField: label = redLabel
        case greenTextField: label = greenLabel
        case blueTextField: label = blueLabel
        default: return true
        }
        
        guard let string = sender.text, !string.isEmpty, let value = Float(string) else {
            sender.text = label.text
            return true
        }
        
        if value > redSlider.maximumValue {
            sender.text = String(format: "%.2f", sliderMaximum)
        } else {
            sender.text = String(format: "%.2f", value)
        }
        
        return true
    }
    
}

extension UIColor {
    convenience init(red: Float, green: Float, blue: Float, alpha: Float) {
        self.init(red: CGFloat(red),
                  green: CGFloat(green),
                  blue: CGFloat(blue),
                  alpha: CGFloat(alpha))
    }
}
