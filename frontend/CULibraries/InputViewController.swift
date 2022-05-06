//
//  InputViewController.swift
//  CULibraries
//
//  Created by 过仲懿 on 2022-04-18.
//

import UIKit

extension UITextField {
    static func fieldTitle (text: String?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(hexString: "#B31B1B")
        label.font = .systemFont(ofSize: 16)
        return label
    }
}

class Input: UITextField {
    var decodeType: DecodeType
    
    var title : String?
    
    init(title: String, decodeType: DecodeType = .text) {
        self.title = title
        self.decodeType = decodeType
        super.init(frame: .zero)
//        attributedPlaceholder = PlacerHolder
//        self.placeholder = title
        font = .systemFont(ofSize: 18)
        textColor = UIColor(hexString: "#B31B1B")
        backgroundColor = .systemGray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Input {
    enum DecodeType {
        case text
        case time
    }
    func decodeText() -> String? {
        guard let text = text, !text.isEmpty else { return nil }
        return text
    }
}
