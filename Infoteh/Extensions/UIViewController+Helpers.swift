//
//  UIViewController+Helpers.swift
//  Infoteh
//
//  Created by admin on 01.08.2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiateFromAppStoryboard(appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
}
