//
//  ViewController.swift
//  Silly Song
//
//  Created by Hoan on 14/12/17.
//  Copyright © 2017 Hoan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lyricsView: UITextView!
    @IBOutlet weak var nameField: UITextField!
    
    let bananaFanaTemplate = [
        "<FULL_NAME>, <FULL_NAME>, Bo B<SHORT_NAME>",
        "Banana Fana Fo F<SHORT_NAME>",
        "Me My Mo M<SHORT_NAME>",
        "<FULL_NAME>"].joined(separator: "\n")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func reset(_ sender: Any) {
        nameField.text = ""
        lyricsView.text = ""
    }
    
    @IBAction func displayLyrics(_ sender: Any) {
        let name = nameField.text
        if !(name ?? "").trimmingCharacters(in: .whitespaces).isEmpty {
            var newLyrics = lyricsForName(lyricsTemplate: bananaFanaTemplate, fullName: name!)
            lyricsView.text = newLyrics
        }
    }
    
    func shortNameForName(name: String) -> String {
        let lowercaseName = name.lowercased()
        let vowelSet = CharacterSet(charactersIn: "aeiou")
        
        if let hasVowel = lowercaseName.rangeOfCharacter(from: vowelSet) {
            return String(name[hasVowel.lowerBound...])
        } else {
            return name
        }
    }
    
    func lyricsForName(lyricsTemplate: String, fullName: String) -> String {
        
        let shortName = shortNameForName(name: fullName)
        
        let lyrics = lyricsTemplate
            .replacingOccurrences(of: "<FULL_NAME>", with: fullName)
            .replacingOccurrences(of: "<SHORT_NAME>", with: shortName)
        
        return lyrics
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

