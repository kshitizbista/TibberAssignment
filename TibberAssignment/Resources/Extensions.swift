//
//  Extensions.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-26.
//

import Foundation
import UIKit

extension UIViewController {
    func handleRetryError(title: String? = "Error", message: String? = "Unknown error occured", handle: (() -> Void)? = nil ) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action =  UIAlertAction(title: "Retry", style: .default) { _  in
            handle?()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
