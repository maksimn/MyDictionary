//
//  LangPickerView.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import SwiftUI

struct LangPickerView: View {

    let allLangs: [Lang]
    let store: StoreOf<LangPicker>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Picker(
                    "Languages",
                    selection: viewStore.binding(
                        get: { $0.lang.name },
                        send: { name in
                            guard let lang = allLangs.first(where: { $0.name == name }) else { return .none }

                            return .langChanged(lang)
                        }
                    )
                ) {
                    ForEach(allLangs.map { LangDO(name: $0.name) }) { lang in
                        Text(lang.name)
                    }
                }
                .frame(height: 100)
                Button(action: {
                    viewStore.send(.hide)
                }) {
                    Text("Select")
                        .padding(.init(top: 2, leading: 20, bottom: 2, trailing: 20))
                        .foregroundColor(.white)
                        .background(Color(red: 0.34, green: 0.34, blue: 0.34))
                }
                .cornerRadius(8)
                .padding(.init(top: 0, leading: 0, bottom: 12, trailing: 0))
            }
            .pickerStyle(.wheel)
        }
    }
}

private struct LangDO: Identifiable {
    var name: String
    var id: String { self.name }
}
