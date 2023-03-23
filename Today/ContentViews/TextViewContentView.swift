//[29] 날짜 및 메모에 대한 콘텐츠 보기 만들기
//[33] 메모 구성을 편집 가능하게 만들기

import UIKit

class TextViewContentView: UIView, UIContentView {
    //[29] TextView 및 구성 속성을 설정하는 초기화 및 configure(configuration:) 텍스트 보기의 text 속성을 설정하는 함수를 추가함.
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        
        //[33] 기본동작으로 핸들러를 추가함.
        var onChange: (String) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return TextViewContentView(self)
        }
    }

    let textView = UITextView()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        //[29] 이니셜라이저에서 높이가 200인 고정된 하위 보기로 텍스트 보기를 추가함.
        addPinnedSubview(textView, height: 200)
        //[29] 이니셜라이저에서 TextView의 선택적 배경색을 nil로 설정함(배경색을 투명색으로)
        textView.backgroundColor = nil
        //[33] self TextView의 delegate로 설정함.
        textView.delegate = self
        //[29] 편집가능한 메모 TextView에서 텍스트를 입력할 수 있음.
        textView.font = UIFont.preferredFont(forTextStyle: .body)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textView.text = configuration.text
    }
}

extension UICollectionViewListCell {
    func textViewConfiguration() -> TextViewContentView.Configuration {
        TextViewContentView.Configuration()
    }
}

//[33] 확장자 추가
extension TextViewContentView: UITextViewDelegate {
    //[33] 사용자 상호 작용을 감지할 때마다 함수 호출
    func textViewDidChange(_ textView: UITextView) {
        //[33] 해당 이벤트 핸들러를 호출하기 전에 구성이 textView 구성인지 확인
        guard let configuration = configuration as? TextViewContentView.Configuration else { return }
        //[33] 핸들러를 호출하고 TextView의 내용을 전달함.
        configuration.onChange(textView.text)
    }
}
