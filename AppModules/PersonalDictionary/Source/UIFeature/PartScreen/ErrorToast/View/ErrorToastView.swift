//
//  ErrorToastView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 02.06.2023.
//

import ComposableArchitecture
import SwiftUI

struct ErrorToastView: View {

    let store: StoreOf<ErrorToast>
    let theme: Theme

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                if viewStore.isVisible {
                    VStack {
                        Text(viewStore.text)
                            .padding(.init(top: 8, leading: 8, bottom: 8, trailing: 8))
                            .foregroundColor(theme.inversedTextColor)
                            .lineLimit(2)
                    }
                    .padding(.init(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .background(Color.red)
                    .cornerRadius(8)
                    Spacer().frame(height: 20)
                }
            }
            .onAppear {
                viewStore.send(.initialize)
            }
        }
    }
}
