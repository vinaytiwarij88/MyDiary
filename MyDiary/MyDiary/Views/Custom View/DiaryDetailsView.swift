
import UIKit
import RxSwift
import RxCocoa

final class DiaryDetailsView: UIView {
    
    //MARK: - Outlets
    @IBOutlet private weak var vwParent: UIView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblDesc: UILabel!
    @IBOutlet private weak var lblDateTime: UILabel!
    @IBOutlet private weak var btnEdit: UIButton!
    @IBOutlet private weak var btnDelete: UIButton!
    
    //MARK: - Callbacks
    var editTap:((String) -> Void)?
    var deleteTap:((String) -> Void)?
    
    //MARK: - Variables
    var disposeBag = DisposeBag()
    
    //MARK: - Property Observers
    var diaryDetail : DiaryData! {
        didSet {
            prapareActionMethods()
            lblTitle.text = diaryDetail.title
            lblDesc.text = diaryDetail.content
            DispatchQueue.main.async {
                self.vwParent.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
            }
        }
    }
    
    var diaryType : DiaryType! {
        didSet {
            if let date = diaryDetail.date {
                switch  diaryType {
                case .today, .yesterday:
                    lblDateTime.text = getHourDifference(from: date)
                case .old:
                    lblDateTime.text = getWeekDifference(from: date)
                case .none:
                    break
                }
            }
        }
    }
    
    //MARK: - Action Methods
    private func prapareActionMethods() {
        btnEdit.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = `self` else {
                return
            }
            self.editTap?(self.diaryDetail.id ?? "")
        }).disposed(by: disposeBag)
        
        btnDelete.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = `self` else {
                return
            }
            self.deleteTap?(self.diaryDetail.id ?? "")
        }).disposed(by: disposeBag)
    }
    
    //MARK: - Helper Methods
    private func getHourDifference(from date : Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: date, to: Date())
        let hours = components.hour ?? 0
        return " \(abs(hours)) hours ago"
    }
    
    private func getWeekDifference(from date : Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date, to: Date())
        let weeks = Int((components.day ?? 0) / 7)
        return " \(abs(weeks)) weeks ago"
    }
}
