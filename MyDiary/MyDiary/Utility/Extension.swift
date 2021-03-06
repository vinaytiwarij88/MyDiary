//
//  Extension.swift
//  MyDiary
//
//  Created by PCQ224 on 16/09/20.
//  Copyright © 2020 PCQ224. All rights reserved.
//

import Foundation
import UIKit

//MARK: - UIViewController
extension UIViewController {
    
    @discardableResult
    
    func showAlert(title: String?,
                   message: String?,
                   buttonTitles: [String]? = nil,
                   highlightedButtonIndex: Int? = nil,
                   completion: ((Int) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var allButtons = buttonTitles ?? [String]()
        if allButtons.count == 0 {
            allButtons.append("OK")
        }
        
        for index in 0..<allButtons.count {
            
            let buttonTitle = allButtons[index]
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: { (_) in
                completion?(index)
            })
            alertController.addAction(action)
            if let highlightedButtonIndex = highlightedButtonIndex, index == highlightedButtonIndex {
                if #available(iOS 9.0, *) {
                    alertController.preferredAction = action
                }
            }
        }
        present(alertController, animated: true, completion: nil)
        return alertController
    }
}

//MARK: - UITableView
extension UITableView {
    func cellRegistration<T:UITableViewCell>(cell identifier:T.Type) -> T?{
        let cellID = String(describing: identifier)
        if let cell = self.dequeueReusableCell(withIdentifier: cellID) as? T {
            return cell
        } else {
            self.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
            return self.dequeueReusableCell(withIdentifier: cellID) as? T
        }
    }
}

//MARK: - UIView
extension UIView {
    ///`CornerRadius`
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    ///`Add Shadow`
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func getViewOfType<T:UIView>(type:T.Type) -> T {
        guard let XIB = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: [:])?.first as? T else {
            fatalError(String(describing: T.self) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
        }
        return XIB
    }
}

//MARK: - DateFormatter
let DateManager = DateFormatter.AppDateFormatters()

extension DateFormatter {
    
    struct AppDateFormatters {
        
        let dateStyleServerDate = DateFormats.getDateFormatter(dateFormat: .dateStyleServerDate)
        let monthInitial        = DateFormats.getDateFormatter(dateFormat: .monthInitial)
    }
    
    private enum DateFormats : String {
        
        case dateStyleServerDate    = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case monthInitial           = "MMM-yyyy"
        static func dateFormat(dateFormatter: DateFormats)-> String{
            return dateFormatter.rawValue
        }
        
        static func dateFormatType(format: String)-> DateFormats{
            return DateFormats.init(rawValue: format)!
        }
        
        static func getDateFormatter(dateFormat: DateFormats, withIsUtc isUtc: Bool = false)-> DateFormatter {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat.rawValue
            if isUtc { dateFormatter.timeZone = TimeZone(abbreviation: "UTC") }
            return dateFormatter;
        }
        
    }
}

//MARK: - UIStackView
extension UIStackView {
    
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
    
    func removeArrangedSubviews() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}

//MARK: - String

extension String {
    
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
