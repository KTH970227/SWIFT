//[4] 날짜 및 시간 형식 지정

import Foundation

extension Date {
    //[4] 날짜를 계산하여 반환하는 함수.
    var dayAndTimeText: String {
        //시간의 문자열을 표현하고, 그 결과를 상수에 할당한다.
        let timeText = formatted(date: .omitted, time: .shortened)
        
        //날짜가 현재 달력 날짜인지 체크함.
        if Locale.current.calendar.isDateInToday(self) {
            //결과를 timeFormat상수에 할당함.
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string")
            //시간 텍스트에 적용하여 문자열을 만들고 결과를 반환함.
            return String(format: timeFormat, timeText)
        } else {
            //formatted(_:)날짜의 문자열을 표현하고 그 결과를 dataText상수에 할당함.
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            //날짜 및 시간을 표시하기 위한 형식이 지정된 문자열을 만들고, dataAndTimeFormat상수에 할당함.
            let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            //날짜 및 시간 텍스트에 적용하여 문자열을 만들고 결과를 반환
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }
    
    //[4] 이 날짜가 현재 날짜인 경우 정적 문자열로 반환하는 함수
    var dayText: String {
        //날짜가 현재 달력 날짜인지 체크함.
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description")
        } else {
            return formatted(.dateTime.month().day().weekday(.wide))
        }
    }
}
