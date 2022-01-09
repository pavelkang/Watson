//
//  TodoView.swift
//  Watson
//
//  Created by Kai Kang on 12/22/20.
//

import SwiftUI

struct TodoView: View {

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {}) {
                Text("􀄴 Add todo")
                    .font(.title3)
                    .frame(width: 100, height: 30, alignment: .center)
                    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
            }
            .buttonStyle(LinkButtonStyle())
            .foregroundColor(Color.FloralWhite)
            .background(Color.accentColor)
            .cornerRadius(5.0)
            .font(.title)
            Text("Buy Dog Food").font(.title)
            Spacer()
        }.padding(EdgeInsets(top: 10, leading: 5, bottom: 5, trailing: 5))
    }
}

struct CheckView: View {
   @State var isChecked:Bool = false
   var title:String
   func toggle(){isChecked = !isChecked}
   var body: some View {
       Button(action: toggle){
           HStack{
               Image(systemName: isChecked ? "checkmark.square": "square")
               Text(title)
           }

       }

   }

}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
    }
}
