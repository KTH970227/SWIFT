//[40] 미리 알림 필터링
//[42] 분할된 컨트롤 표시

import Foundation

enum ReminderListStyle: Int {
    case today
    case future
    case all
    
    //[42] 각 스타일의 이름을 반환하는 계산된 속성을 추가함
    var name: String {
        switch self {
        case .today:
            return NSLocalizedString("Today", comment: "Today style name")
        case .future:
            return NSLocalizedString("Future", comment: "Future style name")
        case .all:
            return NSLocalizedString("All", comment: "All style name")
        }
    }
    
    
    //[40] 사용자가 선택한 목록 스타일과 일치하는지 감지하는 함수
    func shouldInclude(date: Date) -> Bool {
        //[40] 함수의 맨 위에 이름이 지정된 isInToday Bool상수를 추가
        let isInToday = Locale.current.calendar.isDateInToday(date)
        
        //[40] 각 스타일에 지정된 날짜가 포함되는지 여부를 나타내는 bool값을 반환함.
        switch self {
        case .today:
            return isInToday
        case .future:
            return (date > Date.now) && !isInToday
        case .all:
            return true
        }
    }
}
