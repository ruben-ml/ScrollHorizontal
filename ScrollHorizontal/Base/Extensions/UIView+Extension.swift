//
//  UIView+Extension.swift
//  ScrollHorizontal
//
//  Created by Rubén Muñoz López on 10/9/24.
//

import Foundation
import UIKit

extension UIView {
    @discardableResult
    func addSubviews(views: UIView...) -> UIView {
        views.forEach(addSubview)
        return self
    }
}
