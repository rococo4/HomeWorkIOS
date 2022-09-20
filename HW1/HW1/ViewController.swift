//
//  ViewController.swift
//  HW1
//
//  Created by Lebedev A on 20.09.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var views:[UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func changeColorButtonPressed(_ sender: Any) {
        var set = Set<UIColor>()
        while set.count < views.count {
            set.insert (
                UIColor(red: .random(in: 0...1),
                        green: .random(in: 0...1),
                        blue: CGFloat.random(in: 0...1),
                        alpha: CGFloat.random(in: 0...1)
                )
            )
        }
        let button = sender as? UIButton
        button?.isEnabled = false;
        UIView.animate(withDuration: 2, animations: {
         for view in self.views {
             view.layer.cornerRadius = .random(in: 1...100)
             view.backgroundColor = set.popFirst()
         }
         }) { completion in
         button?.isEnabled = true
         }
    }
    
}

