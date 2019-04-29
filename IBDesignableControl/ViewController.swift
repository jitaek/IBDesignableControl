//
//  ViewController.swift
//  IBDesignableControl
//
//  Created by Jitae Kim on 4/26/19.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var control: CVZGradientControl!
    @IBOutlet weak var cvzGradientButton: CVZGradientButton!
    let anotherControl = CVZGradientControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(anotherControl)
        anotherControl.translatesAutoresizingMaskIntoConstraints = false
        anotherControl.text = "testinglongtext"
        anotherControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        anotherControl.topAnchor.constraint(equalTo: control.bottomAnchor, constant: 50).isActive = true
        anotherControl.image = UIImage(named: "chevron-large")
        anotherControl.isLeftImagePosition = false
        
        
        cvzGradientButton.setImage(UIImage(named: "chevron-large"), for: .normal)
//        cvzGradientButton.imagePadding = 16.0
        cvzGradientButton.startLoading()
        
        control.startLoading()
        control.imagePadding = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.control.finishLoading()
            self.cvzGradientButton.finishLoading()
        }
        

    }


}

