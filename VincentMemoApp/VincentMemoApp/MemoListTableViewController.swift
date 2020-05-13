//
//  MemoListTableViewController.swift
//  VincentMemoApp
//
//  Created by 김광준 on 2020/05/13.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    /// iOS 13 버전에서는 새로운 뷰를 띄울 때 기본값이 sheet 라서 viewWillAppear 메소드 호출이 안된다.
    /// iOS 13 버전에서 full screen으로 설정하여 화면을 띄울 때, 그 때 viewWillAppear 메소드 호출이 가능하다.
    /// 화면 전환 처리 방식이 iOS 13 부터 달라짐
    /// notificationCenter로 화면 전환과 동시에 테이블 뷰 목록 업데이트 구현 -> ComposeVC extension 참조
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// 테이블 뷰의 목록 업데이트 메소드
//        tableView.reloadData()
    }
    
    /// token을 저장 할 속성
    /// addObserver가 리턴하는 속성을 여기에 저장
    var token: NSObjectProtocol?
    
    /// deinit(소멸자) 을 이용하여 옵저버 해제
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 옵저버를 추가하는 코드(라디오 주파수 맞추기)는 한번만 실행하면 되기 때문에 보통 viewDidLoad에서 구현한다.
        /// UI를 업데이트 해야 할 경우에는 항상 main thread에서 실행해야 한다. -> 모든 프로그래밍에서 기본 중 기본
        /// iOS에서는 thread를 직접 처리하지 않고 DispatchQueue나 OperationQueue에서 처리한다.
        /// using 파라미터는 클로저를 전달한다, 노티피케이션이 전달되면 using 파라미터로 전달한 클로저가 queue 파라미터로 전달한 스레드에서 실행된다.
        /// 노티피케이션에서 가장 중요한 작업은 옵저버를 해제하는 일 이다. -> 해제 해주지 않으면 메모리가 낭비된다.
        /// 아래의 addObserver 메소드는 옵저버를 해제할 때 사용하는 객체를 리턴 해준다. -> 보통 이 객체를 token이라고 부른다.
        /// viewDidLoad에서 추가한 옵저버는 뷰가 화면에서 사라지기 전에 해제하거나 소멸자에서 해제한다.
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Memo.dummyMemoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let target = Memo.dummyMemoList[indexPath.row]
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = formatter.string(from: target.insertDate)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
