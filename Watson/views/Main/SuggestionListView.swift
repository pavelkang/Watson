//
//  SuggestionListView.swift
//  Watson
//
//  Created by Kai Kang on 12/26/20.
//

import SwiftUI

// MARK: SuggestionItemView

// conditional view modifier

extension View {
   @ViewBuilder
   func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}

struct SuggestionItemView: View {

    var text: String
    var selected: Bool = false
    var hovered: Bool = false
    
    let bgCornerRadius: CGFloat = 5.0
    let bgPad: EdgeInsets = EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
    let activeFGColor: Color = Color.FloralWhite
    let activeBGColor: Color = Color.SlateGray
    let inactiveFGColor: Color = Color.SlateGray
    let hoveredBGColor = Color.red

    var body: some View {
        let fgColor = (selected || hovered) ? activeFGColor : inactiveFGColor
        let bgColor = selected ? activeBGColor : (hovered ? hoveredBGColor : Color.white)
        
        Text(text)
            .frame(maxWidth: .infinity, maxHeight: 0, alignment: .leading)
            .padding(bgPad)
            .foregroundColor(fgColor)
            .if(selected || hovered) { content in
                content.background(bgColor)
            }
            .cornerRadius(bgCornerRadius)
    }
}

struct SuggestionItemControlledView: View {
    
    var suggestion: Suggestion
    @ObservedObject var viewModel: WatsonViewModel
    @State var hovering: Bool = false
    
    var body: some View {
        let selected: Bool = viewModel.selectedSuggestion == suggestion
        SuggestionItemView(text: suggestion.displayText, selected: selected, hovered: self.hovering)
            .onHover(perform: { hovering in
                self.hovering = hovering
            })
            .onTapGesture(perform: {
                viewModel._selectSuggestion(suggestion: suggestion)
            })

    }
}

// MARK: SuggestionSectionView

struct SuggestionSectionView: View {
    @ObservedObject var viewModel: WatsonViewModel
    var suggestionSection: SuggestionSection
        
    var sectionHeader: some View {
        HStack {
            Image(systemName: suggestionSection.sfSymbolName)
            Text(suggestionSection.name)
        }.foregroundColor(.primary)
    }

    var body: some View {
        
        Section(header: sectionHeader) {
            ForEach(suggestionSection.suggestions) { suggestion in
                SuggestionItemControlledView(suggestion: suggestion, viewModel: self.viewModel)
            }
        }
    }
}

// MARK: SuggestionListView

struct SuggestionListView: View {
    
    @ObservedObject var viewModel: WatsonViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.suggestionResult.content) { section in
                SuggestionSectionView(viewModel: viewModel, suggestionSection: section)
            }
        }.listStyle(SidebarListStyle())
    }
}

struct SuggestionListView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionListView(viewModel: WatsonViewModel()).frame(width:200)
    }
}
