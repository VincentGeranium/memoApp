//
//  DataManager.swift
//  VincentMemoApp
//
//  Created by 김광준 on 2020/05/20.
//  Copyright © 2020 VincentGeranium. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    /// Singleton
    static let shared = DataManager()
    private init() {
        
    }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// 메모를 데이터베이스에서 읽어오는 코드
    /// 메모를 저장할 배열 선언과 동시에 빈배열로 초기화
    var memoList = [Memo]()
    
    func fetchMemo() {
        /// 데이터를 데이터베이스에서 읽어오는 다양한 용어가 있다. iOS에서는 이것을 fetch라고 한다.
        /// 데이터를 데이터베이스에서 읽어 올 때는 먼저, fetchRequest를 만들어야 한다.
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        /// Core Data가 return 해주는 데이터는 기본적으로 정렬되어 있지 않다.
        /// 그래서 Sort Descriptor 를 만든 다음 우리가 원하는 방법대로 정렬해야 한다.
        /// 이 앱에서는 날짜를 내림차순으로 정렬한다. -  아래 코드는 날자 기준으로 내림차순 한 코드.
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        /// request를 실행하고 데이터를 가져오는 코드
        /// fetch request를 사용할 때는 context 객체가 제공하는 fetch 메소드를 사용한다.
        /// throws 키워드가 있는 메소드는 실행시 예외가 발생할 수 있다는 뜻이다 그래서 일반 메소드처럼 그냥 호출하면 error.
        /// 이런 메소드들은 do-catch 블록을 이용하여 호출 해야한다. do 블록 안에 메소드를 넣어주고 앞에 try 키워드를 만들어줘야 한다.
        /// fetch request 가 return 하는 데이터는 memoList에 저장한다.
        /// 이렇게 하면 데이터베이스에 저장되어 있는 메모가 날자를 기준으로 내림차순으로 정렬된 다음 최종결과가 memoList에 저장된다.
        
        do {
            memoList = try mainContext.fetch(request)
        } catch {
            print(error)
        }
        
    }
    
    func addNewMemo(_ memo: String?) {
        /// 새로운 memo instance 생성
        /// Memo 클래스는 core data에서 만든 클래스, 내가 만들 클래스가 아님.
        /// 그래서 생성자를 만들 때 context를 전달해야함.
        /// 이렇게 하면 데이터베이스에 메모를 저장하는데 필요한 비어있는 instance 생성
        let newMemo = Memo(context: mainContext)
        newMemo.content = memo
        newMemo.insertDate = Date()
        
        /// 배열에 추가하는 메서드이지만 append는 배열에 마지막에 데이터가 추가되고
        /// insert는 원하는 곳에 넣어줄 수 있다.
        /// fetchMemo 메소드를 다시 호출한 것과 동일한 결과를 얻을 수 있다.
        /// 불필요한 데이터 베이스 작업이 줄어들기 때문에 효율적이다.
        memoList.insert(newMemo, at: 0)
        
        
        
        /// 위와 같이 인스턴스를 생성하고 데이터를 넣어줬다고 실제로 데이터베이스에 저장되는 것이 아니다
        /// 데이터 베이스에 데이터를 저장하고 싶다면 context를 저장해야한다.
        /// context를 저장하는 메소드는 saveContext ()
        
        saveContext()
        
    }
    
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "VincentMemoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
