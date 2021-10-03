//
//  vislov_65skillz_testApp.swift
//  vislov_65skillz_test
//
//  Created by Ivan Vislov on 26.09.2021.
//

import SwiftUI

@main
struct vislov_65skillz_testApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(contact: contactData[0])
                .environmentObject(UserData())
        }
    }
}
