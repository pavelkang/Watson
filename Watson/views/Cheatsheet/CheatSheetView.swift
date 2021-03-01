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

struct CheatSheetView: View {
    
    var title: String = ""
    var content: String
    @ObservedObject var viewModel: WatsonViewModel
    
        
    var body: some View {
        VStack(alignment: .leading) {
            EditableTextView(
                placeholder: "Add Title Here",
                text: Binding<String>(get: {
                    viewModel.getPayload(at: "title") as! String
                }, set: {
                    viewModel.setPayload(at: "title", with: $0)
                })
            )
            EditableTextArea(content: content)
        }
    }
}

struct CheatSheetControlledView: View {
    var cheatItem : CheatItem
    @ObservedObject var viewModel: WatsonViewModel
    
    init(cheatItem: CheatItem, viewModel: WatsonViewModel) {
        self.cheatItem = cheatItem
        self.viewModel = viewModel
    }
    
    var body: some View {
        CheatSheetView(
            title: cheatItem.title ?? "",
            content: cheatItem.content,
            viewModel: viewModel
        )
    }
}


struct CheatSheetView_Previews: PreviewProvider {
    static var previews: some View {
        CheatSheetView(
            title: "Healthy Dog Food",
            content: "https://www.thefarmersdog.com",
            viewModel: WatsonViewModel()
        )
        CheatSheetView(
            title: "", content: "test content",
            viewModel: WatsonViewModel()
        )
    }
}
