//
//  AutoFocusTextField.swift
//  SaldoMate
//
//  Created by naswakhansa on 06/05/25.
//

import SwiftUI

struct AutoFocusTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFirstResponder: Bool
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: AutoFocusTextField
        init(parent: AutoFocusTextField) { self.parent = parent }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.parent.text = textField.text ?? ""
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = "Input Category"
        textField.borderStyle = .roundedRect
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        if isFirstResponder && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        }
    }
}
