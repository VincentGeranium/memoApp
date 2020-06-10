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
    
    // 편집 이전의 메모 저장
    var originalMemoContents: String?
    
    
    
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
            originalMemoContents = memo.content
        } else {
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
        
        memoTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // presentationController 델리게이트 설정
        // 편집 화면이 표시되기 직전에 델리게이트로 설정
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 편집 화면이 사라지기 직전에 델리게이트가 해제됨.
        navigationController?.presentationController?.delegate = nil
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

extension ComposeViewController: UITextViewDelegate {
    // 텍스트 뷰에서 텍스트를 편집 할 때마다 반복해서 호출되는 메서드
    func textViewDidChange(_ textView: UITextView) {
        
        // 오리지널 메모와 편집된 메모를 상수에 저장
        if let original = originalMemoContents, let edited = textView.text {
            // 모달 방식으로 동작해야 하는지 결정하는 플래그로 사용된다
            // true 저장시 시트가 모달 방식으로 동작, 풀다운으로 시트가 닫히기 전 델리게이트 메소드를 호출해준다.
            // 이 속성은 iOS 13에서 새로 추가되었기 때문에 iOS 13에서만 실행되도록 available condition을 설정해 주어야 한다.
            // 오리지널 메모와 편집된 메모가 다를 때 isModalInPresentation 속성에 true를 저장한다.
            // 이렇게 하면 텍스트 뷰에서 메모를 할 때마다 원본과 다른지 비교 후 원본과 다르다면 메모가 편집된 것으로 판단한다.
            if #available(iOS 13.0, *) {
                isModalInPresentation = original != edited
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

extension ComposeViewController: UIAdaptivePresentationControllerDelegate {
    // isModalInPresentation = original != edited 위 코드에서 true가 저장된 상태에서 시트를 풀 다운 시키면
    // 시트가 사라지지 않고 아래의 메소드가 호출된다.
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "알림", message: "편집된 내용을 저장하시겠습니까?", preferredStyle: .alert)
        
        // UIAlertAction에서는 마지막 parameter가 가장 중요하다
        // parameter로 closure를 전달하는데 경고창에서 "확인"버튼은 누르면 이 closure가 실행된다
        // 이 closure 내부에서 저장 기능을 구현해도 되지만 메모를 저장하는 기능은 save 메소드에 이미 구현되어 있으므로 그냥 가져다 사용하면된다.
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
            self?.save(action)
        }
        // okAction을 alertController에 추가
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] (action) in
            self?.close(action)
        }
        // cancelAction alertController에 추가
        alert.addAction(cancelAction)
        
        // present 메소드로 경고창을 표시
        present(alert, animated: true, completion: nil)
    }
}


extension ComposeViewController {
    /// 노티피케이션은 라디오 방송이라고 생각하면 된다.
    /// 노티피케이션 센터는 라디오 방송국이다.
    /// 라디오 방송은 주파수를 통해 구분하듯이 노티피케이션은 이름으로 구분한다.
    
    /// 노티피케이션 이름 선언
    static let newMemoDidInsert = Notification.Name("newMemoDidInsert")
    static let memoDidChange = Notification.Name("memoDidChange")
}
