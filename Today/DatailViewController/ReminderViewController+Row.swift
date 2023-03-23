//[14] 행에 대한 열거 생성
//[22] 편집 모드에서 헤더 표시
//[28] 콘텐츠 보기 표시
//[29] 날짜 및 메모에 대한 콘텐츠 보기 만들기

import UIKit

extension ReminderViewController {
    //[14] Row 열거형을 만듦.
    enum Row: Hashable {
        case header(String) //[22]
        case date
        case notes
        case time
        case title
        case editableDate(Date)//[29]
        case editableText(String?)//[28]
        
        //각각 SF 기호 이름을 반환함
        var imageName: String? {
            switch self {
            case .date: return "calendar.circle"
            case .notes: return "square.and.pencil"
            case .time: return "clock"
            default: return nil
            }
        }
        
        //Image 이름을 기반으로 이미지를 반환하는 속성이름을 추가함.
        //이미지에 적용할 텍스트 두께, 글꼴, 포인트 크기 및 배율을 포함한 스타일 지정 입력을 포함할 수 있음.
        //즉, 이러한 세부 정보를 사용하여 사용할 이미지 변형과 이미지 스타일 지정 방법을 결정함.
        var image: UIImage? {
            guard let imageName = imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }
        
        //각각 관련된 textStyle을 반환하는 계산된 속성을 추가함.
        var textStyle: UIFont.TextStyle {
            switch self {
            //headline 글꼴을 사용하여 각 미리 알림의 제목을 강조함.
            case .title: return .headline
            default: return .subheadline
            }
        }
    }
}
