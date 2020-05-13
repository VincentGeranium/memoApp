//
//  DetailViewController.swift
//  VincentMemoApp
//
//  Created by 김광준 on 2020/05/13.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

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
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            
            return cell
        default:
            fatalError()
        }
    }
    
    
}
