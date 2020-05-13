//
//  UIViewcontroller+Alert.swift
//  VincentMemoApp
//
//  Created by 김광준 on 2020/05/13.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import UIKit

/// UIVIewController를 상속하는 모든 곳에서 사용할 수 있도록 extension을 이용하여 메소드 구현

extension UIViewController {
    /// 경고창 제목과 메시지를 받는 메소드 선언
    func alert(title: String = "알림", message: String) {
        /// 경고창을 사용할 땐 UIAlertController를 사용한다.
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        /// 경고창에 나오는 버튼 생성, UIAlertAction으로 생성.
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        /// 버튼 생성 후 UIAlertController에 추가.
        alert.addAction(okAction)
        
        /// Present Method를 이용하여 경고창을 화면에 표시
        present(alert, animated: true, completion: nil)
    }
}
