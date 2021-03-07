//
//  QueryView.swift
//  Watson
//
//  Created by Kai Kang on 12/26/20.
//

import SwiftUI

struct QueryView: View {
    @State private var textStyle = NSFont.TextStyle.largeTitle
    @ObservedObject var viewModel: WatsonViewModel
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass").font(.title)
            WatsonTextField(
                text: Binding<String>(
                    get: {self.viewModel.query}, set: {viewModel.updateQuery(to: $0)}
                ),
                textStyle: $textStyle,
                onMoveUp: {
                    viewModel.moveUp()
                },
                onMoveDown: {
                    viewModel.moveDown()
                },
                onTab: {
                    viewModel.tab()
                },
                onEnter: {
                    viewModel.enter()
                },
                onEsc: {
                    viewModel.esc()
                },
                onMouseDown: {
                    viewModel.onMouseDownQueryField()
                },
                focusing: viewModel.focusOnQuery
            )
        }.padding(10).font(.title2)
    }
}

struct QueryView_Previews: PreviewProvider {
    static var previews: some View {
        QueryView(viewModel: WatsonViewModel()).frame(height:60)
    }
}
