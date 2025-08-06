//
//  UIStackView + Ext.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import UIKit

public extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
