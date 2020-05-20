//
//  DetailViewController.swift
//  VincentMemoApp
//
//  Created by 김광준 on 2020/05/13.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit
// 보기화면
class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var memoTableView: UITableView!
    
    /// 이전 화면에서 전달할 데이터를 저장
    /// VC가 초기화 되는 시점에는 데이터가 없으므로 옵셔널로 설정
    /// MemoListTableViewController의 prepare 메소드를 통해 전달한 데이터는 아래의 memo 속성에 저장된다.
    /// 이곳에 저장된 데이터를 DetailViewController와 연결된 화면에 표시
    var memo: Memo?
    
    /// DateFormatter
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController {
            vc.editTarget = memo
        }
    }
    
    /// 노티피케이션 토큰 저장
    var token: NSObjectProtocol?
    
    /// 옵저버 해제 코드 구현
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        /// 옵저버 추가 코드 구현
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidChange, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            self?.memoTableView.reloadData()
        })
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

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    /// 테이블 뷰는 이 메소드를 호출하면서 indexPath 파라미터로 셀 위치를 알려준다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// switch 문으로 indexPath를 분기
        /// indexPath의 row 속성으로 접근하면 몇 번째 cell인지 확인 가능
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
            
            /// 첫 번째 Cell에는 memo를 표시
            cell.textLabel?.text = memo?.content
            
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            
            /// 두 번째 Cell에는 날자를 표시
            /// 날자를 표시하려면 문자열로 바꿔야 하며, 문자열로 바꾸려면 DateFormatter를 활용한다.
            /// DetailViewController의 memo 속성은 옵셔널로 저장되어 있어 DateFormatter의 string(from: Date) 속성을 사용하지 못한다.
            /// 옵셔널 바인딩을 사용하거나 string(for: Any?)를 사용해야 한다.
            
            if let memoInsertDate = memo?.insertDate {
                cell.textLabel?.text = formatter.string(from: memoInsertDate)
            } else {
                fatalError()
            }
            
//            cell.textLabel?.text = formatter.string(for: memo?.insertDate)
            
            return cell
        default:
            fatalError()
        }
    }
    
    
}
