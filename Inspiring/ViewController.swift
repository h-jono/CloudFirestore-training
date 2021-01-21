//
//  ViewController.swift
//  Inspiring
//
//  Created by 城野 on 2021/01/20.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var quoteTextField: UITextField!
    
    @IBOutlet weak var authorTextField: UITextField!
    
    var docRef: DocumentReference!
    var quoteListener: ListenerRegistration!
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let quoteText = quoteTextField.text, !quoteText.isEmpty else { return }
        guard let authorText = authorTextField.text, !authorText.isEmpty else { return }
        let dataToSave: [String: Any] = ["quote": quoteText, "author": authorText]
        docRef.setData(dataToSave){ (error) in
            if let error = error{
                print("Oh no! Got an error: \(error.localizedDescription)")
            }else{
                print("Data has been saved!")
            }
        }
    }
    
    @IBAction func fetchTapped(_ sender: UIButton) {
        docRef.getDocument{ (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else{ return }
            let myData = docSnapshot.data()
            let latestQuote = myData?["quote"] as? String ?? ""
            let quoteAuthor = myData?["author"] as? String ?? "(none)"
            self.quoteLabel.text = "\"\(latestQuote)\" -- \(quoteAuthor)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        quoteListener = docRef.addSnapshotListener{ (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else{ return }
            let myData = docSnapshot.data()
            let latestQuote = myData?["quote"] as? String ?? ""
            let quoteAuthor = myData?["author"] as? String ?? "(none)"
            self.quoteLabel.text = "\"\(latestQuote)\" -- \(quoteAuthor)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        quoteListener.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        docRef = Firestore.firestore().document("sampleData/inspiration")
        
    }
    
    
}

