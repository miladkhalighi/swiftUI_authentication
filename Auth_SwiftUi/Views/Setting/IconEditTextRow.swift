//
//  IconEditTextRow.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-08-02.
//

import SwiftUI

struct IconEditTextRow: View {
    
    var icon : String
    var titlePlaceholder : String
    var fontWeight : Font.Weight = .regular
    @Binding var text : String
    @Binding var itemSelected : Bool
    
    var body: some View {
        HStack(spacing: 16){
            AngularIcon(icon: icon, selected: $itemSelected)
            TextField(titlePlaceholder, text: $text)
                .foregroundColor(.white)
                .fontWeight(fontWeight)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 52)
        .padding(.horizontal,8)
        .background(Color("secondaryBackground").opacity(0.5), in: RoundedRectangle(cornerRadius: 16,style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16,style: .continuous).stroke(.gray)
        }
        .preferredColorScheme(.dark)
    }

}

struct IconEditTextRow_Previews: PreviewProvider {
    static var previews: some View {
        IconEditTextRow(icon: "person", titlePlaceholder:"Milad k",text: .constant(""), itemSelected: .constant(true))
    }
}
