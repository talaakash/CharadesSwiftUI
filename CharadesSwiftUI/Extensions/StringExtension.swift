//
//  StringExtension.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//

import Foundation

extension String{
    func localize() -> String{
        let language = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, bundle: bundle!, comment: "")
    }
}
