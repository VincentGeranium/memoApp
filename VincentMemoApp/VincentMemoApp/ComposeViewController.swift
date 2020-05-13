//
//  ComposeViewController.swift
//  VincentMemoApp
//
//  Created by 김광준 on 2020/05/13.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
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
        let newMemo = Memo(content: memo)
        Memo.dummyMemoList.append(newMemo)
        
        /// 화면을 닫기 전 노티피케이션을 전달
        /// 라디오 방송국에서 라디오 방송을 브로드캐스팅 하는 것과 같은 코드라고 생각하면 된다.
        /// 노티피케이션은 특정 객체에 바로 전달 되지 않는다, 앱을 전달하는 모든 객체에 전달된다.(브로드캐스팅) -> 엄밀히 따지면 잘못된 설명, 처음 노티에 대해 공부시 이렇게 이해해도 괜찮다
        /// 여기서 전달한 노티피케이션을 처리해야 함 -> 옵저버를 등록하고 필요한 코드를 구현하는 방식으로 처리 함.(라디오 주파수를 맞추는 것에 비유할 수 있다.) -> MemoListVC viewdidLoad 참고
        NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        
        /// new Memo 화면 닫음
        dismiss(animated: true, completion: nil)
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
}
