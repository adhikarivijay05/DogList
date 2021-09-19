//
//  LoadingSpinner.swift
//  DogProject
//
//  Created by Vijay Adhikari on 18/9/21.
//

import Foundation
import MBProgressHUD

class LoadingSpinner:NSObject {
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension LoadingSpinner {
    
    func showIndicator(spinnerView: UIView?, withTitle title: String?) {
        guard let LoadingSpinnerView = spinnerView else { return }
        DispatchQueue.main.async {
            let progressHUD = MBProgressHUD.showAdded(to: LoadingSpinnerView, animated: true)
            progressHUD.label.text = title ?? ""
            progressHUD.isUserInteractionEnabled = false
            progressHUD.show(animated: true)
        }
    }
    
    func hideIndicator(spinnerView:UIView?) {
        guard let LoadingSpinnerView = spinnerView else { return }
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: LoadingSpinnerView, animated: true)
        }
    }
}
