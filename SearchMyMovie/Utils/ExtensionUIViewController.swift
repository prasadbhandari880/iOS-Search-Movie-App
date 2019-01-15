//
//  ExtensionUIViewController.swift
//  SearchMyMovie


import Foundation
import UIKit

extension UIViewController{
    func showAlertWith(message:String){
        let alertController = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
