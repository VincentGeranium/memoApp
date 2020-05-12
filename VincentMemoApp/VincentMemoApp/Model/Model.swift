//
//  Model.swift
//  VincentMemoApp
//
//  Created by 김광준 on 2020/05/12.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import Foundation

class Memo {
    // 메모 내용 저장
    var content: String
    
    // 메모 추가 날자 저장
    var insertDate: Date
    
    /// 클래스 초기화
    init(content: String) {
        self.content = content
        /// insertDate는 현재 날자를 바로 받으면 되므로 별도의 parameter로 받을 필요 없음
        insertDate = Date()
    }
    
    /// 테이블 뷰에 필요한 더미 데이터
    static var dummyMemoList = [
        Memo(content: "Hello"),
        Memo(content: "World"),
    ]
}
