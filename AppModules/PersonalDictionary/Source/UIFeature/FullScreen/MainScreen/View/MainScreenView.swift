//
//  MainScreen.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 07.05.2023.
//

import ComposableArchitecture
import SwiftUI

private let activityCountStore = StoreOf<ActivityIndicator>(
    initialState: .init(),
    reducer: ActivityIndicator(activityCount: ActivityCount.instance)._printChanges()
)
private let errorToastStore = StoreOf<ErrorToast>(
    initialState: .init(),
    reducer: ErrorToast(
        errorMessageStream: ErrorMessageStreamImpl.instance,
        clock: ContinuousClock(),
        durationSeconds: 3
    )._printChanges()
)

struct MainScreenView: View {

    let title: String
    let allLangs: [Lang]
    let store: StoreOf<MainScreen>
    let theme: Theme

    var body: some View {
        NavigationStack {
            ZStack {
                MainWordListView(
                    store: store.scope(state: \.mainWordList, action: MainScreen.Action.mainWordList)
                )
                VStack {
                    Spacer()
                    ErrorToastView(
                        store: errorToastStore,
                        theme: theme
                    )
                    LinkToNewWordView(
                        allLangs: allLangs,
                        store: store.scope(state: \.linkToNewWord, action: MainScreen.Action.linkToNewWord)
                    )
                }
            }
            .background(theme.backgroundColor)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ActivityIndicatorView(store: activityCountStore)
                }
            }
            .navigationTitle(title)
        }
    }
}
