//
//  PastSearchedKeywordTableViewCell.swift
//  SearchMyMovie


import UIKit

class PastSearchedKeywordTableViewCell: UITableViewCell {

    @IBOutlet weak var keywordLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(keyword:String){
        keywordLbl.text = keyword
    }
    
}
