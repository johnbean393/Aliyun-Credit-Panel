//
//  Extension+View.swift
//  Aliyun Credit Panel
//
//  Created by John Bean on 4/24/25.
//

import SwiftUI

extension View {
    
    @ViewBuilder public func `if`<Content: View>(
        _ conditional: Bool,
        content: (Self) -> Content
    ) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
    
}
