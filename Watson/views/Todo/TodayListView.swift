//
//  TodayListView.swift
//  Watson
//
//  Created by Kai Kang on 1/18/22.
//

import SwiftUI

struct TodayListView: View {
    
    var todayItems: [TodayItem]
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(self.todayItems) { today in
                HStack {
                    Image(systemName: "square")
                    Text(today.content)
                }
            }
        }
    }
}

struct TodayListView_Previews: PreviewProvider {
    static var previews: some View {
        TodayListView(todayItems: [
            TodayItem(content: "write a blog"),
            TodayItem(content: "Implement function A")
        ])
    }
}
