//
//  MainViewController.swift
//  Od10IOSMobile
//
//  Created by Sainkhishig Ariunaa on 11/28/20.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController {
    @IBAction func btnLogout_touchUp(_ sender: Any) {
        
        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginvc") as? LoginViewController else {
                        return
                    }
        let navigationController = UINavigationController(rootViewController: rootVC)

        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
