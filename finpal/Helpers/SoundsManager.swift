//
//  SoundsManager.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/8/25.
//

import Foundation
import AudioToolbox

final class SoundsManager: Sendable {
    static let instance = SoundsManager()
    
    private init() { }
    
    func playPaymentSuccessSound() {
        let systemSoundID: SystemSoundID = 1407
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    func playPaymentFailSound() {
        let systemSoundID: SystemSoundID = 1398
        AudioServicesPlaySystemSound(systemSoundID)
    }
}
