//[19] 편집 모드용 섹션 만들기

import Foundation

extension ReminderViewController {
    //[19] Section : 암시적으로 Int값을 저장하고 Hashable로 열거형을 만듦.
    enum Section: Int, Hashable {
        case view
        case title
        case date
        case notes
        
        //[19] name각 섹션의 제목 텍스트를 계산하는 속성을 만듦.
        var name: String {
            switch self {
            case .view: return ""
            case .title:
                return NSLocalizedString("Title", comment: "Title section name")
            case .date:
                return NSLocalizedString("Date", comment: "Date section name")
            case .notes:
                return NSLocalizedString("Notes", comment: "Notes section name")
            }
        }
    }
}
