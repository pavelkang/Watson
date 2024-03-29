//
//  WatsonViewModel.swift
//  Watson
//
//  Created by Kai Kang on 12/16/20.
//

import SwiftUI

enum ViewState : String {
    case empty = "empty"
    case loading = "loading"
    case editing = "editing"
    case finished = "finished"
}


class WatsonViewModel: ObservableObject {
    @Published private(set) var query: String = ""
    @Published private(set) var viewState: ViewState = .empty
    @Published private(set) var suggestionResult: SuggestionResult
    @Published private(set) var selectedSuggestion: Suggestion? = nil
    @Published private(set) var selectedQAIndex: Int = 0
    @Published var payloadBeingEdited: PayloadTrait? = nil
    @Published private(set) var focusOnQuery: Bool = true
    
    private var backend: WatsonBackend = WatsonBackend()
    
    
    init() {
        suggestionResult = SuggestionResult(content: [])
    }
    
    // for preview
    init(withQuery: String, withState: ViewState) {
        query = withQuery
        suggestionResult = SuggestionResult(content: [])
        self.updateQuery(to: query)
    }
    
    init(withSuggestion: Suggestion) {
        suggestionResult = SuggestionResult(content:[])
        selectedSuggestion = withSuggestion
        payloadBeingEdited = withSuggestion.payload
        viewState = .finished
    }
        
    var isEmptyState: Bool {
        return viewState == ViewState.empty
    }
    
    // User Interactions
    
    /// User types in the input bar
    /// - Parameter to: new search string
    func updateQuery(to: String) -> Void {
        query = to
        if (query.count == 0) {
            resetState()
            return
        }
        // Search for query
        suggestionResult = backend.search(query: query)
        print(suggestionResult)
        if (suggestionResult.isEmpty) {
            viewState = .empty
            selectedSuggestion = nil
        } else {
            selectedSuggestion = suggestionResult.content[0].suggestions[0]
            payloadBeingEdited = selectedSuggestion?.payload
            viewState = .finished
        }
    }
    
    // MARK: State changing Functions
    func resetState() -> Void {
        query = ""
        viewState = .empty
        suggestionResult = SuggestionResult(content: [])
        selectedSuggestion = nil
        selectedQAIndex = 0
        payloadBeingEdited = nil
    }
    
    // MARK: Helper Functions
    
    
    func getPayload(at key: String) -> Any? {
        print("Get Payload", key, "_")
        return payloadBeingEdited?.get(key: key)
        // TOOD: Each
        // app implements update payload method
    }
    
    func setPayload(at key: String, with value: Any?) -> Void {
        //TODO can we avoid update everything??
        print("set payload", key, value, "__")
        if let newPayload = payloadBeingEdited?.set(key: key, with: value) {
            payloadBeingEdited = newPayload
            if let newSuggestion = selectedSuggestion?.updatePayload(with: newPayload) {
                selectedSuggestion = newSuggestion
                suggestionResult = suggestionResult.updateSuggestion(with: newSuggestion)
            }
        }
        print("new", payloadBeingEdited, selectedSuggestion, suggestionResult)
    }
    
    
    /// Find suggestion's position in current suggerstion result
    /// - Parameter suggestion: target suggestion
    /// - Returns: (i, j) if suggerstion is in section i, number j. nil if cannot be found
    func _findContentIndex(of suggestion: Suggestion) -> (Int, Int)? {
        for (sectionIndex, section) in self.suggestionResult.content.enumerated() {
            if let idx = section.suggestions.firstIndex(where: {$0.id == suggestion.id}) {
                return (sectionIndex, idx)
            }
        }
        return nil
    }
    
    func _findSuggestion(on position: (Int, Int)) -> Suggestion? {
        print("find suggestion", position)
        if (position.0 < 0 || position.1 < 0) {
            return nil
        }
        if self.suggestionResult.content.count <= position.0 {
            return nil
        } else {
            if self.suggestionResult.content[position.0].suggestions.count <= position.1 {
                return nil
            }
        }
        return self.suggestionResult.content[position.0].suggestions[position.1]
    }
    
    func _selectSuggestion(suggestion: Suggestion) {
        self.selectedSuggestion = suggestion
        self.payloadBeingEdited = suggestion.payload
        selectedQAIndex = 0
    }
    
    // MARK: Move Keyboard functions
    func moveDown() -> Void {
        if let suggestion = self.selectedSuggestion {
            if let position = _findContentIndex(of: suggestion) {
                if let nextSuggestion = self._findSuggestion(on: (position.0, position.1 + 1)) {
                    // Same section, next item
                    _selectSuggestion(suggestion: nextSuggestion)
                } else if let nextSuggestion = self._findSuggestion(on: (position.0 + 1, 0)) {
                    // Next section, first item
                    _selectSuggestion(suggestion: nextSuggestion)
                }
                // Keep current selection otherwise
            }
        }
    }
    
    func moveUp() -> Void {
        if let suggestion = self.selectedSuggestion {
            if let position = _findContentIndex(of: suggestion) {
                if let prevSuggestion = self._findSuggestion(on: (position.0, position.1 - 1)) {
                    // Same section, previous item
                    _selectSuggestion(suggestion: prevSuggestion)
                } else {
                    // Previous section, last item
                    if position.0 == 0 {
                        return
                    }
                    guard let prevSuggestion = self._findSuggestion(
                        on: (position.0 - 1,
                             self.suggestionResult.content[position.0 - 1].suggestions.count - 1)
                    ) else {
                        fatalError("Guaranteed to find prev suggestion in prev section)")
                    }
                    _selectSuggestion(suggestion: prevSuggestion)
                }
                // Keep current selection otherwise
            }
        }
    }
    
    func enter() -> Void {
        print("Pressed enter")

        let currentQAs = getCurrentQuickActions()
        print(currentQAs[self.selectedQAIndex].identifier)
        currentQAs[self.selectedQAIndex].getAction()()
    }
    
    func tab() -> Void {
        print("Pressed tab")
        if let actions = self.selectedSuggestion?.quickActions {
            selectedQAIndex = (selectedQAIndex + 1) % actions.count
        }
    }
    
    func esc() -> Void {
        if isEmptyState {
            // hide window
            hideWindow()
        } else {
            resetState()
        }
    }
    
    func getCurrentQuickActions() -> [QuickAction] {
        if let suggestion = selectedSuggestion {
            _ = suggestion.quickActions.map({ qa in
                qa.contextualize(
                    payload: payloadBeingEdited,
                    onFinishFn: {
                        self.resetState()
                        self.hideWindow()
                    }
                )
            })
            return suggestion.quickActions
        }
        return []
    }
    
    // MARK: UI Controls
    func onMouseDownQueryField() -> Void {
        /*
        let alert = NSAlert()
        alert.messageText = "Give Up Editing?"
        alert.informativeText = "Your current item is not saved"
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")
        alert.beginSheetModal(for: NSApplication.shared.keyWindow!, completionHandler: {
            (response) in print(response)
        })*/
    }
    
    func onAppear() -> Void {
        // NO-OP
        focusOnQuery = true
    }
 
    func hideWindow() -> Void {
        guard let appDelegate =
          NSApplication.shared.delegate as? AppDelegate else {
          return
        }
        // appDelegate.window.makeFirstResponder(nil)
        appDelegate.window.orderOut(nil)
    }
    
    func getTodayItems() -> [TodayItem] {
        guard let appDelegate =
          NSApplication.shared.delegate as? AppDelegate else {
          return []
        }
        let moc = appDelegate.persistentContainer.viewContext

        
        let todayItemEntFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TodayItemEnt")
        var fetchedTodayItemEnts: [TodayItemEnt] = []
        do {
            fetchedTodayItemEnts = try moc.fetch(todayItemEntFetch) as! [TodayItemEnt]
        } catch {
            fatalError("Failed to fetch todays: \(error)")
        }
        return fetchedTodayItemEnts.map{ todayItemEnt in
            TodayItem(fromEnt: todayItemEnt)
        }
    }
    
}
