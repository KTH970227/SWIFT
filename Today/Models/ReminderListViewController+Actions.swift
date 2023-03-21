//[9] 사용자 정의 버튼 동작 만들기

import UIKit

extension ReminderListViewController {
    //[9] @objc 특성은 Objective-C 코드에서 이 메서드를 사용권한 및
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        //보낸 사람의 옵션을 id라는 상수로 래핑 해제함.
        guard let id = sender.id else { return }
        completeReminder(withId: id)
    }
}
