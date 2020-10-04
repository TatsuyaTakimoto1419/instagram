//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by 瀧本達也 on 2020/10/02.
//

import UIKit
import CLImageEditor


class ImageSelectViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLImageEditorDelegate {
    
    //ライブラリ　ボタン
    @IBAction func handleLibraryButton(_ sender: Any) {
        // ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        
    }
    //カメラボタン
    @IBAction func handleCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
    }
    
    //キャンセルボタン
    @IBAction func handleCancelButton(_ sender: Any) {
        //画面を閉じる
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // 写真を撮影/選択したときに呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:Any]){
        
        if info[.originalImage] != nil{
            // 撮影/選択された画像を取得する
            let image = info[.originalImage] as! UIImage
            
            // あとでCLImageEditorライブラリで加工する
            print("DEBUG_PRINT: image = \(image)")
            
            // CLImageEditorにimageを渡して、加工画面を起動する。
            let editor = CLImageEditor(image: image)!
            editor.delegate = self
            editor.modalPresentationStyle = .fullScreen
            picker.present(editor, animated: true, completion: nil)
               //  TO CLImageEditorで加工が終わったときに呼ばれるメソッド
        }
        
    }
    //キャンセル  imagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        // ImageSelectViewController画面を閉じてタブ画面に戻る
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)

    }
    
    // CLImageEditorで加工が終わったときに呼ばれるメソッド
    func imageEditor (_ editor: CLImageEditor!,didFinishEditingWith image:UIImage){
        // 投稿画面を開く
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        //PostViewController に　igame値を渡す
        postViewController.image = image //!
        
        editor.present(postViewController, animated: true, completion: nil)
    }
    
    // CLImageEditorの編集がキャンセルされた時に呼ばれるメソッド
    func imageEditorDidCancel(_ editor: CLImageEditor!){
        // ImageSelectViewController画面を閉じてタブ画面に戻る
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
}//end
