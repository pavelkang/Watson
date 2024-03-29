//
//  SuggestionDetailView.swift
//  Watson
//
//  Created by Kai Kang on 12/28/20.
//

import SwiftUI

struct DetailViewWrapper<Content>: View where Content: View {

    let content: () -> Content
    var selectedQAIndex: Int
    var quickActions: [QuickAction]

    init(quickActions:[QuickAction], selectedQAIndex: Int, @ViewBuilder content: @escaping () -> Content) {
        self.quickActions = quickActions
        self.selectedQAIndex = selectedQAIndex
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading) {
            QuickActionControlPanel(quickActionsList:quickActions, spacing: 10, selectedIndex: selectedQAIndex)
            Divider()
            Spacer()
            content()
            Spacer()
        }.padding(EdgeInsets(top: 10, leading: 5, bottom: 5, trailing: 5))
    }

}

struct SuggestionDetailView: View {

    @ObservedObject var viewModel: WatsonViewModel
    var suggestion: Suggestion
    
    func makeContent() -> some View {
        switch suggestion.payload.app {
        // TODO: should be app-ignorant
        case .CheatsheetAppType:
            return AnyView(
                DetailViewWrapper(quickActions: viewModel.getCurrentQuickActions(), selectedQAIndex: viewModel.selectedQAIndex) {
                    CheatSheetControlledView(payload: suggestion.payload as! CheatItem, viewModel: viewModel)}
            )
        case .TodoAppType:
            return AnyView(
                DetailViewWrapper(quickActions: viewModel.getCurrentQuickActions(), selectedQAIndex: viewModel.selectedQAIndex) {
                    TodayView(payload: suggestion.payload as! TodayItem, viewModel: viewModel)}
            )
        default:
            fatalError("Error rendering: " + suggestion.displayText)
        }
    }
    
    var body: some View {
        makeContent()
    }
}

struct SuggestionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionDetailView(viewModel: WatsonViewModel(), suggestion: Suggestion(id: "test", displayText: "Hello", payload: CheatItem(content: "hi", title: "title")))
    }
}
