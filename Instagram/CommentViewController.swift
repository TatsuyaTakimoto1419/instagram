//
//  CommentViewController.swift
//  Instagram
//
//  Created by 瀧本達也 on 2020/10/04.
//

import UIKit
import Firebase

class CommentViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var CommentTextField: UITextField!
    
    @IBOutlet weak var backButoon: UIButton!
    
    //PostDataを受け取る HomeViewControllerより
    var postdata : PostData!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView
        tableView.delegate = self
        tableView.dataSource = self
        self.CommentTextField.delegate = self
        
    }
    
    
    @IBAction func BackButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func sendButton(_ sender: Any) {
        //TextField からText取得
        var commentText:String?
        commentText = CommentTextField.text!
        
        
        commentText = (Auth.auth().currentUser!.displayName!) + ":" + commentText!
        
       var updateValue:FieldValue
        
        // 今回新たにいいねを押した場合は、commentidを追加する更新データを作成
        updateValue = FieldValue.arrayUnion([commentText!])
        
        
        //アップデートする
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postdata.id)
        postRef.updateData(["comment":updateValue])
        
       
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //tableViewにコメントを反映させる
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postdata.comment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell (withIdentifier:"Cell", for: indexPath)
        
        
        let commentArray = postdata.comment
        
        Cell.textLabel?.text = commentArray[indexPath.row]
        
        return Cell
    }
    
    
    

    
    func textFieldShouldReturn(_ CommentTextField: UITextField) -> Bool {
        CommentTextField.resignFirstResponder()
        
        print("dismiss Keyboard")
        return true
    }
   
    
    
    

}
