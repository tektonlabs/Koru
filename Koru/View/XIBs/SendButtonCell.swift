/* 

=========================================================================== 
Koru GPL Source Code 
Copyright (C) 2017 Tekton Labs
This file is part of the Koru GPL Source Code.
Koru Source Code is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, either version 3 of the License, or 
(at your option) any later version. 

Koru Source Code is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Koru Source Code. If not, see <http://www.gnu.org/licenses/>. 
=========================================================================== 

*/

import UIKit

protocol SendButtonCellDelegate: class {
    func sendButtonCell(cell: SendButtonCell, didTapSendButton button: LoadingButton)
}

class SendButtonCell: UITableViewCell {
    
    @IBOutlet weak var sendButton: LoadingButton!
    weak var delegate: SendButtonCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.sendButton.setTitle("Enviar", for: .normal)
    }
    
    @IBAction func didTapSendButton(_ sender: UIButton) {
        sendButton.loading = true
        self.delegate?.sendButtonCell(cell: self, didTapSendButton: sendButton)
    }
}
