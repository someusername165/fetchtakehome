//
//  EmptyStateView.swift
//  fetchtakehome
//
//  Created by Ahad Islam on 2/8/25.
//

import SwiftUI

struct EmptyStateView: View {
    let action: (() async -> Void)?
    var body: some View {
        VStack {
            Text("Recipe List is Empty")
            Button("Refresh") {
                Task {
                    if let action {
                        await action()
                    }
                }
            }.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    EmptyStateView(action: nil)
}
