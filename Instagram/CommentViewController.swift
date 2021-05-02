
import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController {
    
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentAdd: UIButton!
    @IBOutlet weak var commentCancel: UIButton!
    
    var postData :PostData?
    
    @IBAction func commentAddButton(_ sender: Any) {
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData!.id)
        
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()

        // FireStoreに投稿データを保存する
        let name = Auth.auth().currentUser?.displayName
        let comment = name! + " : " + self.commentTextField.text!
        let comments = FieldValue.arrayUnion([comment])
        postRef.updateData(["comment": comments])
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "コメントしました")
        
        // 投稿処理が完了したので先頭画面に戻る
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func commentAddCancel(_ sender: Any) {
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var commentAll = ""
        for comment in postData!.comment {
              commentAll += "\(comment!)\n"
        }
        comments!.text! = commentAll
    }
    
}
