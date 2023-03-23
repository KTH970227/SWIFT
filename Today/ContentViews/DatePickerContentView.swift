//[29] 날짜 및 메모에 대한 콘텐츠 보기 만들기
//[32] 날짜 구성을 편집 가능하게 만들기

import UIKit

class DatePickerContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var date = Date.now
        
        //[32] 기본 동작으로 핸들러를 추가함.
        var onChange: (Date) -> Void = { _ in}
        
        func makeContentView() -> UIView & UIContentView {
            return DatePickerContentView(self)
        }
    }

    let datePicker = UIDatePicker()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addPinnedSubview(datePicker)
        //[32] 이벤트의 대상 및 작업을 설정함.
        datePicker.addTarget(self, action: #selector(didpick(_:)), for: .valueChanged)
        
        //[29] 이니셜라이저에서 날짜 선택기의 스타일로 변경
        datePicker.preferredDatePickerStyle = .inline
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        datePicker.date = configuration.date
    }
    
    //[32]
    @objc private func didpick(_ sender: UIDatePicker) {
        //[32] 선택적으로 속성을 상수에 guard 바인딩함.(configuration 속성에 값이 없거나 잘못된 유형인 경우 함수 호출 지점으로 돌아감)
        guard let configuration = configuration as? DatePickerContentView.Configuration else { return }
        //[32] 처리기 onChange를 호출하고 새 날짜를 전달함.
        configuration.onChange(sender.date)
    }
}

extension UICollectionViewListCell {
    func datePickerConfiguration() -> DatePickerContentView.Configuration {
        DatePickerContentView.Configuration()
    }
}
