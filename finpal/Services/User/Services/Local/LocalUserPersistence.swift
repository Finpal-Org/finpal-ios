//
//  LocalUserPersistence.swift
//  finpal
//
//  Created by Abdulkarim Koshak on 4/6/25.
//

import Foundation

protocol LocalUserPersistence {
    func getCurrentUser() -> UserModel?
    func saveCurrentUser(user: UserModel?) throws
}
