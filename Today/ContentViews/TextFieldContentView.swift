//[25] 텍스트 필드가 있는 사용자 지정 보기 만들기
//[26] 콘텐츠 보기 프로토콜 준수
//[27] 콘텐츠 보기 완료
//[31] 텍스트 구성을 편집 가능하게 만들기

import UIKit

//[26] 프로토콜에 적합성을 추가함. UIContentView
class TextFieldContentView: UIView, UIContentView {
    //[26] Configuartion를 준수하는 내부 구조를 만듦.
    struct Configuration: UIContentConfiguration {
        //[26] text 빈 문자열의 기본값으로 선택적 문자열 속성을 만듦.
        var text: String? = ""
        
        //[31] 기본 빈 작업이 포함된 핸들러 추가함.
        var onChange: (String) -> Void = { _ in }
        
        //[26] 프로토콜을 준수하는 a를 반환하는 이름이 지정된 함수
        func makeContentView() -> UIView & UIContentView {
            //[26] self를 사용하여 새 텍스트 필드 콘텐츠 보기를 반환함.
            return TextFieldContentView(self)
        }
    }
    
    //[25] .textFieldUITextField의 인스턴스인 상수 속성을 추가함.
    let textField = UITextField()
    
    //[26] configuration 유형이라는 변수 속성을 추가함.
    var configuration: UIContentConfiguration {
        //[27] 새 함수를 호출하는 관찰자를 구성 속성에 추가함.
        didSet {
            configure(configuration: configuration)
        }
    }

    //[25] 고유한 콘텐츠 크기(44)를 재정의 및 액세스 가능한 컨트롤의 최소 크기인 지점의 높이를 고정함.
    //이 속성을 설정하면 사용자 지정 View가 기본 크기를 레이아웃 시스템에 전달할 수 있음.
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    //[25] 인수가 없는 이니셜라이저 : 먼저 크기 없이 보기를 초기화한 후 다음 제약 조건을 사용하여 최종 레이아웃을 제어함.
    //[26] 이니셜라이저에서 콘텐츠 구성을 수락하고 매개변수의 값을 속성에 할당함.
    init(_ configuration: UIContentConfiguration) {
        //[26] 구성으로 초기화
        self.configuration = configuration
        //[25] super.init(frame:).zero의 프레임 크기로 호출함.
        super.init(frame: .zero)
        //[25] textField를 고정한 다음 수평 패딩 삽입을 제공함.
        addPinnedSubview(textField, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        
        //[31] 이벤트의 대상 및 작업을 설정함
        textField.addTarget(self, action: #selector(didChange(_:)), for: .editingChanged)
        
        //[25] textField를 .whileEditing으로 설정함.
        textField.clearButtonMode = .whileEditing
    }
    
    //[25] UIView 커스텀 이니셜라이저를 구현하는 서브 클래스는 필수로 구현해야 함.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //[27] configure(configuration:) 매개변수를 허용하는 함수
    func configure(configuration: UIContentConfiguration) {
        //[27] 매개 configure 변수를, 그렇지 않으면 함수 호출 지점으로 돌아감.
        guard let configuration = configuration as? Configuration else { return }
        //[27] text에서 textField의 값을 업데이트함.
        textField.text = configuration.text
    }
    
    //[31]
    @objc private func didChange(_ sender: UITextField) {
        //[31] guard 문을 사용하여 선택적으로 속성을 configuration 상수에 바인딩함.
        guard let configuration = configuration as? TextFieldContentView.Configuration else { return }
        //[31] 핸들러 호출 및 textField의 내용을 전달함(text 속성이 onChange인 경우 빈 문자열을 전달)
        configuration.onChange(textField.text ?? "")
    }
}

extension UICollectionViewListCell {
    //[27] new를 반환하는 이름이 지정된 함수
    func textFieldConfiguration() -> TextFieldContentView.Configuration {
        TextFieldContentView.Configuration()
    }
}
