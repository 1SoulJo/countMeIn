//
//  LaunchVC.swift
//  countMeIn
//
//  Created by Hansol Jo on 2021-03-24.
//

import UIKit

class LaunchVC: UIViewController {
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnSignUp.layer.cornerRadius = 5
        btnSignIn.layer.cornerRadius = 5
    }

    
    @IBAction func onSignIn(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tbc = storyBoard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        navigationController?.pushViewController(tbc, animated: true)
    }
}
