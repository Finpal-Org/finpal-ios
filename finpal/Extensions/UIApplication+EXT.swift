//
//  UIApplication+EXT.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 2/21/25.
//

import UIKit

extension UIApplication {
    
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }
        
        return window
    }
}
