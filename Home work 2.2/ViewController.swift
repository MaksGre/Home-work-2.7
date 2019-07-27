//
//  ViewController.swift
//  Home work 2.2
//
//  Created by Maksim Grebenozhko on 26/07/2019.
//  Copyright © 2019 Maksim Grebenozhko. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {
    
    struct ColorForView {
        var red: CGFloat!
        var green: CGFloat!
        var blue: CGFloat!
    }

    @IBOutlet var viewForPaint: UIView!
    
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
    
    var notification = NSNotification()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.keyboardDidShowNotification, object: nil)
//        NSNotification.Name.
        
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

        guard let string = sender.text, !string.isEmpty else { return }
        
        if let _ = Float(string) { } else { return }

        let value = Float(string)!

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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print("TextField did begin editing method called")
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // set scroll view content size height as per your need (subtract keyboard height from original)
    }
}

