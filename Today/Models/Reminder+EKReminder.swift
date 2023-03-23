//[51] 미리 알림을 비동기식으로 가져오기

import EventKit
import Foundation

extension Reminder {
    
    //[51] 이니셜라이즈
    init(with ekReminder: EKReminder) throws {
        //[51] 미리 알림의 첫 번째 알람의 절대 날짜를 바인딩하는 문을 추가(오늘의 알림이 없으면 오류 발생)
        guard let dueDate = ekReminder.alarms?.first?.absoluteDate else {
            throw TodayError.reminderHasNoDueDate
        }
        //[51] 속성 id에 달력 ID(식별자)를 할당함
        id = ekReminder.calendarItemIdentifier
        
        //[51] title,dueDate,notes,isComplete 및 속성을 할당
        title = ekReminder.title
        self.dueDate = dueDate
        notes = ekReminder.notes
        isComplete = ekReminder.isCompleted
    }
}
