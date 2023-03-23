//[23] 구성 방법 추출
//[27] 콘텐츠 보기 완료
//[29] 날짜 및 메모에 대한 콘텐츠 보기 만들기
//[31] 텍스트 구성을 편집 가능하게 만들기
//[32] 날짜 구성을 편집 가능하게 만들기
//[33] 메모 구성을 편집 가능하게 만들기

import UIKit

extension ReminderViewController {
    //[23] 셀과 행을 받아들이고 보기 모드 적용 함수
    func defaultConfiguration(for cell: UICollectionViewListCell, at row: Row)
    -> UIListContentConfiguration
    {
        //[23] 할당을 제외한 .view의 내용을 contentConfiguration에서 새로 생성된 함수로 이동함.
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        //[23] contentConfiguration을 반환함.
        return contentConfiguration
    }
    
    //[23] headerConfiguration(for:,with)에서 셀과 제목을 받고, UIListContentConfiguration를 반환하는 이름의 새 함수를 만드는 함수
    func headerConfiguration(for cell: UICollectionViewListCell, with title: String)
    -> UIListContentConfiguration
    {
        //[23] 할당을 제외한 case의 내용을 .header에서 새로 생성된 함수로 이동함.
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = title
        //[23] contentConfiguration을 반환함.
        return contentConfiguration
    }
    
    //[27] 셀과 제목을 받고 TextFieldContentView.Configuration 반환하는 함수
    func titleConfiguration(for cell: UICollectionViewListCell, with title: String?)
    -> TextFieldContentView.Configuration
    {
        //[27] 제목을 사용하는 새 텍스트 필드 구성을 만들고 반환함.
        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.text = title
        
        //[31] 새 제목을 할당하는 핸들러를 추가함.
        contentConfiguration.onChange = { [weak self] title in
            self?.workingReminder.title = title
        }
        return contentConfiguration
    }
    //[29] 미리 알림 날짜에 대한 날짜 선택기 구성과 미리 알림 메모에 대한 TextView 구성을 만들고 반환하는 함수
    func dateConfiguration(for cell: UICollectionViewListCell, with date: Date)
    -> DatePickerContentView.Configuration
    {
        var contentConfiguration = cell.datePickerConfiguration()
        contentConfiguration.date = date
        //[32]
        contentConfiguration.onChange = { [weak self] dueDate in
            self?.workingReminder.dueDate = dueDate
        }
        return contentConfiguration
    }
    func notesConfiguration(for cell:UICollectionViewListCell, with notes: String?)
    -> TextViewContentView.Configuration
    {
        var contentConfiguration = cell.textViewConfiguration()
        contentConfiguration.text = notes
        contentConfiguration.onChange = { [weak self] notes in
            self?.workingReminder.notes = notes
        }
        return contentConfiguration
    }
    
    
    //[23] ReminderViewController.swift 에서 이동함.
    func text(for row: Row) -> String? {
        switch row {
        case .date: return reminder.dueDate.dayText
        case .notes: return reminder.notes
        case .time: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .title: return reminder.title
        //[22] default 추가
        default: return nil
        }
    }
}
