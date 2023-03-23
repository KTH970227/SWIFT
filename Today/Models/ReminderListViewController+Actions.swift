//[9] 사용자 정의 버튼 동작 만들기
//[36] 미리 알림 추가 및 삭제
//[38] 모델에 새 미리 알림 추가
//[43] 세분화된 컨트롤에 작업 추가
//[50] 목록에 그라디언트 레이어 추가

import UIKit

extension ReminderListViewController {
    //[9] @objc 특성은 Objective-C 코드에서 이 메서드를 사용권한 및
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        //보낸 사람의 옵션을 id라는 상수로 래핑 해제함.
        guard let id = sender.id else { return }
        completeReminder(withId: id)
    }
    //[36]
    @objc func didPressAddButton(_ sender: UIBarButtonItem) {
        //[36] 빈 제목과 현재 날짜로 새 미리 알림을 만듦.
        let reminder = Reminder(title: "", dueDate:  Date.now)
        //[36] 완료 핸들러가 있는 인스턴스를 만듦.
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            //[38] 빈 클로저에서 didPressAddButtonaddReminder를 호출함
            self?.addReminder(reminder)
            //[38] 스냅샷을 업데이트함
            self?.updateSnapshot()
            //[38] viewController를 닫음
            self?.dismiss(animated: true)
        }
        
        //[36] ViewController의 속성을 설정함.
        viewController.isAddingNewReminder = true
        //[36] ViewController의 편집 모드를 true로 설정함.
        viewController.setEditing(true, animated: false)
        //[36] .cancel 작업을 호출하는 막대 단추 항목을 만들고, 내비게이션 항목의 .didCancelAddleftBarButtonItem에 단추를 할당함.
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(didCancelAdd(_:)))
        //[36] ViewController의 탐색 항목에 대한 제목을 제공함.
        viewController.navigationItem.title = NSLocalizedString("Add Reminder", comment: "Add Reminder view controller title")
        //[36] 알림 ViewController를 루트의 사용하여 탐색 컨트롤러를 만듦.
        let navigationController = UINavigationController(rootViewController:  viewController)
        //[36] VieController의 함수를 호출하고 navigationController를 전달한다.
        present(navigationController, animated: true)
    }
    
    //[36] ViewController를 해제하는 이름의 함수를 만듦.
    @objc func didCancelAdd(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    //[43]
    @objc func didChangeListStyle(_ sender: UISegmentedControl) {
        //[43] 세그먼트화된 컨트롤의 선택된 segmentIndex를 사용하여 새 목록 스타일을 만듦.
        listStyle = ReminderListStyle(rawValue: sender.selectedSegmentIndex) ?? .today
        //[43] 스냅샷 업데이트
        updateSnapshot()
        
        //[50]
        refreshBackground()
    }
}
