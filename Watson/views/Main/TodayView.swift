//
//  TodoView.swift
//  Watson
//
//  Created by Kai Kang on 12/22/20.
//

import SwiftUI


struct TodayView: View {
    var payload: TodayItem
    @ObservedObject var viewModel: WatsonViewModel
    @State var isChecked: Bool = false
    func toggle() {isChecked = !isChecked}
    
    var body: some View {
            HStack {
                Image(systemName: isChecked ? "checkmark.square": "square")
                Text(viewModel.getPayload(at: "content") as! String)
            }
    }
}

struct TodayView_Previews: PreviewProvider {
    
    static var payload: PayloadTrait = TodayItem(content: "Write a blog")
    static var suggestion: Suggestion = Suggestion.FromNew(payload: payload, qas: [])
    
    static var previews: some View {
        TodayView(payload: TodayItem(content: "Write a blog"), viewModel: WatsonViewModel(withSuggestion: suggestion))
    }
}
