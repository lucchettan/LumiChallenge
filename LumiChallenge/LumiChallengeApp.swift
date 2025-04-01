//
//  LumiChallengeApp.swift
//  LumiChallenge
//
//  Created by Nicolas Lucchetta on 01/04/2025.
//

import SwiftUI
import SwiftData

@main
struct LumiChallengeApp: App {
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.systemBlue
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray4
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
