//[53] 알림 저장소 만들기
//[54] 모든 알림 읽기
//[55] 미리 알림 데이터에 대한 액세스 요청

import EventKit
import Foundation

final class ReminderStore {
    //[53]
    static let shared = ReminderStore()
    //[53]
    private let ekStore = EKEventStore()
    
    //[53] 미리 알림 권한 부여 상태인 경우 반환되는 속성 여부
    var isAvailable: Bool {
        EKEventStore.authorizationStatus(for: .reminder) == .authorized
    }
    
    //[55] 미리 알림 인증 상태 저장 함수
    func requestAccess() async throws {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        //[55] 인증 상태
        switch status {
        case .authorized: //[55] 사용자가 미리 알림 데이터에 대한 액세스 권한을 부여한 경우 호출 함수로 실행을 되돌림
            return
        case .restricted: //[55] 시스템에서 미리 알림 데이터에 대한 액세스를 제한하는 경우 오류가 발생함
            throw TodayError.accessRestricted
        case .notDetermined: //[55] 사용자가 아직 결정을 내리지 않은 경우 사용자 데이터에 대한 액세스를 요청함
            let accessGranted = try await ekStore.requestAccess(to: .reminder)
            guard accessGranted else {
                throw TodayError.accessDenied
            }
        case .denied: //[55] 사용자가 미리 알림 데이터에 대한 액세스를 허용하지 않기로 결정한 경우 오류가 발생함
            throw TodayError.accessDenied
        @unknown default: //[55] 기본의 경우 오류를 발생시킴
            throw TodayError.unknown
        }
    }
    
    //[54] 배열을 반환하는 함수
    func readAll() async throws -> [Reminder] {
        //[54] 미리 알림 액세스를 사용할 수 없는 경우 오류를 발생시킴
        guard isAvailable else {
            throw TodayError.accessDenied
        }
        
        //[54] 선택 시 특정 캘린더의 미리 알림으로 결과범위를 좁힘
        let predicate = ekStore.predicateForReminders(in: nil)
        //[54] 결과를 기다리는 ekReminders상수
        let ekReminders = try await ekStore.reminders(matching: predicate)
        //[54] reminders로 데이터를 매핑한 결과를 저장함
        let reminders: [Reminder] = try ekReminders.compactMap { ekReminder in
            //[54] 변환된 미리 알림을 반환하는 클로저에 블록을 추가
            //[54] 미리 알림에 기한이 없는 경우 catch 반환되는 블록 추가
            do {
                return try Reminder(with: ekReminder)
            } catch TodayError.reminderHasNoDueDate {
                return nil
            }
        }
        //[54] 미리 알림을 반환함.
        return reminders
    }
}
