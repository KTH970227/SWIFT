//[51] 미리 알림을 비동기식으로 가져오기

import EventKit
import Foundation

extension EKEventStore {
    //[51] 조건자를 받아들이고 배열을 반환하는 async함수를 만듦
    func reminders(matching predicate: NSPredicate) async throws -> [EKReminder] {
        //[51] 계속 작업이 재개될 때까지 작업이 일시 중단됨을 나타냄
        try await withCheckedThrowingContinuation { continuation in
            //[51] EventKit 메서드 호출
            fetchReminders(matching: predicate) { reminders in
                //[51] if - let 미리 알림을 로컬 상수에 바인딩하는 조건문
                if let reminders {
                    //[51] 성공 시 계속 재개 및 미리 알림을 반환
                    continuation.resume(returning: reminders)
                } else {
                    //[51] 실패 시 계속 진행하여 오류 발생 시킴
                    continuation.resume(throwing: TodayError.failedReadingReminders)
                    
                }
            }
        }
        
    }
}
