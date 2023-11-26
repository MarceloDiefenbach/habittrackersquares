//
//  EmojiPickerView.swift
//  SquareHabitsTracker
//
//  Created by Marcelo Diefenbach on 25/11/23.
//

import Foundation
import SwiftUI

struct EmojiPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedEmoji: String

    let emojiUnicodes = ["1F600", "1F603", "1F604", "1F601", "1F606", "1F605", "1F923", "1F602", "1F4BB", "1F9F6", "1F9F5", "1F4A6", "1F34E", "1F346", "1F951", "1F37A", "1F377", "1F943", "1F37D", "26BD", "1F3C0", "1F3C8", "26BE", "1F94E", "1F3BE", "1F3D0", "1F3C9", "1F3B1", "1F93F", "1F6F9", "1F947", "1F3A4", "1F3B8", "1F4F1", "231A", "1F48A", "1F4C5", "1F4D5", "1F4DA", "2764"]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 20) {
                ForEach(emojiUnicodes, id: \.self) { unicode in
                    let emoji = String(UnicodeScalar(Int(unicode, radix: 16)!)!)
                    Text(emoji)
                        .font(.largeTitle)
                        .padding(16)
                        .background(Color("EmojiBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .onTapGesture {
                            selectedEmoji = unicode
                            dismiss()
                        }
                }
            }
            .padding(.top, 16)
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .background(Color("backgroundColor"))
        }
    }
}

#Preview {
    EmojiPickerView(selectedEmoji: .constant("1F600"))
}
