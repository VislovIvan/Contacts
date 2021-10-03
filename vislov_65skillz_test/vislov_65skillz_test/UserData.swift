//
//  UserData.swift
//  vislov_65skillz_test
//
//  Created by Ivan Vislov on 02.10.2021.
//

import SwiftUI
import Combine

final class UserData: ObservableObject {
    @Published var showFavoritesOnly = false
    @Published var contacts = contactData
}
