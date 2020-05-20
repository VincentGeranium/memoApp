//
//  ComposeViewController.swift
//  VincentMemoApp
//
//  Created by 김광준 on 2020/05/13.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    /// 보기화면에서 편집 버튼을 탭하면 메모가 editTarget 속성에 전달됨
    /// 이 속성에 메모가 저장되어 있다면 편집모드로 동작해야한다.
    /// 그리고 목록화면에서 + 버튼을 탭하면 전달되는 메모가 없다.
    /// 다시말해 editTarget 속성이 nil이고 이때는 새 메모쓰기 동작해야함.
    ///
    /// 보기화면에서 전달한 메모는 아래의 속성에 저장
    var editTarget: Memo?
    
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBAction func save(_ sender: Any) {
        
        /// 텍스트 뷰에 저장된 데이터를 상수에 저장.
        /// 데이터의 길이를 제약으로 걸어 0 이상인 경우 즉, 실제 데이터가 있는 경우에만 동작하게 코드를 만듦
        /// 나머지 경우에는 경고창을 띄움
        guard let memo = memoTextView.text, memo.count > 0 else {
            /// 경고창을 띄우는 메소드 사용.
            alert(message: "메모를 입력하세요")
            return
        }
        /// 텍스트가 정상적으로 입력되었을 때.
        /// 새로운 인스턴스 생성 후 배열에 저장
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)
        
        if let target = editTarget {
            target.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidChange, object: nil)
        } else {
            DataManager.shared.addNewMemo(memo)
            /// 화면을 닫기 전 노티피케이션을 전달
            /// 라디오 방송국에서 라디오 방송을 브로드캐스팅 하는 것과 같은 코드라고 생각하면 된다.
            /// 노티피케이션은 특정 객체에 바로 전달 되지 않는다, 앱을 전달하는 모든 객체에 전달된다.(브로드캐스팅) -> 엄밀히 따지면 잘못된 설명, 처음 노티에 대해 공부시 이렇게 이해해도 괜찮다
            /// 여기서 전달한 노티피케이션을 처리해야 함 -> 옵저버를 등록하고 필요한 코드를 구현하는 방식으로 처리 함.(라디오 주파수를 맞추는 것에 비유할 수 있다.) -> MemoListVC viewdidLoad 참고
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        }
        
        
        
        /// new Memo 화면 닫음
        dismiss(animated: true, completion: nil)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // 편집 모드이냐 아니면 새 메모 쓰기 이냐에 따라 title 동적으로 바뀌어야 하므로 code로 짜야함
        if let memo = editTarget {
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
        } else {
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ComposeViewController {
    /// 노티피케이션은 라디오 방송이라고 생각하면 된다.
    /// 노티피케이션 센터는 라디오 방송국이다.
    /// 라디오 방송은 주파수를 통해 구분하듯이 노티피케이션은 이름으로 구분한다.
    
    /// 노티피케이션 이름 선언
    static let newMemoDidInsert = Notification.Name("newMemoDidInsert")
    static let memoDidChange = Notification.Name("memoDidChange")
}
