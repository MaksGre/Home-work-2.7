//
//  MainViewController.swift
//  Home work 2.2
//
//  Created by Maksim Grebenozhko on 13/08/2019.
//  Copyright © 2019 Maksim Grebenozhko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    

    @IBOutlet var navigationBar: UINavigationBar!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Segue" else { return }
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.view.backgroundColor?.getRed(&red,
                                          green: &green,
                                          blue: &blue,
                                          alpha: &alpha)

        let setColorVC = segue.destination as! SetColorViewController
        setColorVC.delegate = self
        setColorVC.colorForView = ColorForView(red: Float(red),
                                               green: Float(green),
                                               blue: Float(blue))
        
    }
    
    @IBAction func unwindSegie(_ sender: UIStoryboardSegue) {
    }

}

extension MainViewController: SetColorViewControllerDelegate {
    
    func didSetColor(_ color: UIColor) {
        self.view.backgroundColor = color
    }
    
}
