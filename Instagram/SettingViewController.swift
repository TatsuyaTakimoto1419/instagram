//
//  SettingViewController.swift
//  Instagram
//
//  Created by 瀧本達也 on 2020/10/02.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var displayNameTextField: UITextField!
    @IBOutlet weak var handleChangeButton: UIButton!
    @IBOutlet weak var handleLogoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.displayNameTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    
    
     //表示名を変更 ボタン
    @IBAction func handleChangeButton(_ sender: Any) {
        //表示名がnilでない時、表示名を格納 displayName
        if let displayName = displayNameTextField.text{
            
            // 表示名が入力されていない時はHUDを出して何もしない
                        if displayName.isEmpty {
                            SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
                            return
                        }
            
            // 表示名が入力された時
            //表示名を保存する
            let user = Auth.auth().currentUser
            if let user = user{
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                
            //エラーの時　　表示名を保存する
                changeRequest.commitChanges{ error in
                    
                    if let error = error{
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました。")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    
            //成功　表示名を保存する
                    
                    print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                    // HUDで完了を知らせる
                SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                    
                    
                    
                }
                
            }
        }
        // キーボードを閉じる
               self.view.endEditing(true)
        
    }
    
    //ログアウト ボタン
    @IBAction func handleLogoutButton(_ sender: Any) {
        
        // ログアウトする
               try! Auth.auth().signOut()
        
        // ログイン画面を表示する モーデル
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        present(loginViewController!, animated: true, completion: nil)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser
        if let user = user {
            // 表示名を取得してTextFieldに設定する
            displayNameTextField.text = user.displayName
            
            // ログイン画面から戻ってきた時のためにホーム画面（index = 0）を選択している状態にしておく
                   tabBarController?.selectedIndex = 0
        }
    }
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          
    if (self.displayNameTextField.isFirstResponder){
                self.displayNameTextField.resignFirstResponder()
    }
        }
    
    
    
}//end
