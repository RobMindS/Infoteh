//
//  AppStoryboard.swift
//  Infoteh
//
//  Created by admin on 01.08.2022.
//

import Foundation
import UIKit

enum AppStoryboard: String {
    
    case MainStoryboard, CityDetailStoryboard
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
    
}
