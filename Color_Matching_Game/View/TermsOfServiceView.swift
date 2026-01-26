//
//  TermsOfServiceView.swift
//  Color_Matching_Game
//
//  Created by COBSCCOMP242P-001 on 2026-01-26.
//

import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Terms of Service")
                    .font(.largeTitle.bold())
                
                Text("Last Updated: January 26, 2026")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Group {
                    Text("1. Acceptance of Terms")
                        .font(.headline)
                    Text("By downloading and playing Color Snap, you agree to these terms. This app is provided for educational and entertainment purposes as part of a computing degree research module.")
                }

                Group {
                    Text("2. License for Use")
                        .font(.headline)
                    Text("Users are granted a personal, non-exclusive license to play the game on their own devices. Modification or redistribution of the application is prohibited without developer consent.")
                }

                Group {
                    Text("3. Disclaimer")
                        .font(.headline)
                    Text("Color Snap is provided 'as is' without warranties of any kind. The developer, Sithumini Mahinsala, is not liable for any data loss or device issues arising from the use of this software.")
                }
            }
            .padding()
        }
        .navigationTitle("Terms & Service")
        .navigationBarTitleDisplayMode(.inline)
    }
}
