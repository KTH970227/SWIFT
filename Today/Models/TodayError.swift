//[51] 미리 알림을 비동기식으로 가져오기
//[52] 모델 유형 간 변환
//[54] 모든 알림 읽기
//[55] 미리 알림 데이터에 대한 액세스 요청

import Foundation

enum TodayError: LocalizedError {
    //[54] 케이스 추가
    case accessDenied
    //[55] 케이스 추가
    case accessRestricted
    //[51] 케이스 추가
    case failedReadingReminders
    //[52] 케이스 추가
    case reminderHasNoDueDate
    //[55] 케이스 추가
    case unknown
    
    //[51] 오류를 설명하는 속성 추가
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return NSLocalizedString("The app doesn't have permission to read reminders.", comment: "access denied error description")
        case .accessRestricted:
            return NSLocalizedString("This device doesn't allow access to reminders.", comment: "access restricted error description")
        case .failedReadingReminders:
            return NSLocalizedString("Failed to read reminders.", comment: "failed reading reminders error description")
        case .reminderHasNoDueDate:
            return NSLocalizedString("A reminder has no due date", comment: "reminder has no due date error description")
        case .unknown:
            return NSLocalizedString("An unknown error occurred", comment: "unknown error description")
        }
    }
}
