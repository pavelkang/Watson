//
//  CheatSheetView.swift
//  Watson
//
//  Created by Kai Kang on 12/22/20.
//

import SwiftUI

struct CheatSheetViewConstants {
    static let width: CGFloat = 300
    static let height: CGFloat = 300
}


struct CheatSheetControlledView: View {
    var payload : CheatItem
    @ObservedObject var viewModel: WatsonViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            EditableTextView(
                placeholder: "Add Title Here",
                text: viewModel.getPayload(at: "title") as! String,
                onChange: { newValue in
                    viewModel.setPayload(at: "title", with: newValue)
                },
                onEnter: viewModel.enter
            )
            EditableTextArea(
                content: viewModel.getPayload(at: "content") as! String,
                onChange: {
                    newValue in
                    viewModel.setPayload(at: "content", with: newValue)
                }
            )
        }
    }
}


struct CheatSheetControlledView_Previews: PreviewProvider {
    static var previews: some View {
        CheatSheetControlledView(
            payload: CheatItem(content: "https://www.thefarmersdog.com", title: "dog food"),
            viewModel: WatsonViewModel()
        )
    }
}
