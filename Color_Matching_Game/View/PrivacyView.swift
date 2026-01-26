//
//  PrivacyView.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-26.
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Privacy Policy")
                    .font(.largeTitle.bold())
                
                Text("Last Updated: January 26, 2026")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Group {
                    Text("1. Data Collection")
                        .font(.headline)
                    Text("Color Snap does not collect any personal data or transmit information to external servers. All game progress, including high scores and your username, is stored locally on your device using Apple's UserDefaults system.")
                }

                Group {
                    Text("2. Third-Party Services")
                        .font(.headline)
                    Text("The app does not use third-party tracking, analytics, or advertising frameworks.")
                }

                Group {
                    Text("3. Data Deletion")
                        .font(.headline)
                    Text("Users can delete all stored game data at any time via the 'Reset All Data' option in the app's Settings menu.")
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}
