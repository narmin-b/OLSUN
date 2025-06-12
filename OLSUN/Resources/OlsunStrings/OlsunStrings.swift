//
//  OlsunStrings.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 08.05.25.
//

import Foundation

enum OlsunStrings: String {
    case appleLoginText
    case bdayText
    case cancelButton
    case continueButton
    case deleteGuest_Text
    case deletePlan_Text
    case emailText
    case femaleText
    case gendertext
    case googleLoginText
    case guestDesc
    case guestName_Text
    case guestsDate_Text
    case guestsStat_Accepted
    case guestsStat_Declined
    case guestsStat_Pending
    case guestsVC_Title
    case guestText
    case homeListText
    case launchMessage
    case loginButton
    case loginVC_Message
    case maleText
    case nameText
    case nextButton
    case onboardingMessage_First
    case onboardingMessage_Second
    case onboardingtitle
    case orText
    case partnerNameText
    case passwordText
    case planName_Text
    case planningDate_Text
    case planningDesc
    case planningStat_Done
    case planningStat_Late
    case planningStat_Pending
    case planningText
    case planningVC_Title
    case pwLengthText
    case pwNumText
    case pwUCText
    case saveButton
    case signUpVC_Message
    case signUpButton
    case statusText
    case registerSuccessText
    case registerSuccess_Message
    case updateSuccessText
    case planUpdateSuccess_Message
    case networkError
    case planDelete_Message
    case planAdded_Message
    case networkError_Message
    case guestDelete_Message
    case guestUpdateSuccess_Message
    case guestAdded_Message
    case reLoginMessage
    case generalError_Message
    case jsonParsingError_Message
    case optionalText
    case accDelete_Message
    case confirmationTitle
    case deleteButton
    case accDelete_Success
    case profileText
    case logoutButton
    case deleteAccButton
    case logoutConfirmButton
    case logoutAcc_Message
    case accDeleteWarningButton
    case guestButtonText
    case warningText
    case guestAttemptLimit_Message
    case guestLogoutMessage
    case partnersText
    case partnersDesc
    case bakuText
    case beautySalonText
    case decorationText
    case khinaOrgText
    case khoncaText
    case partnersSubtitle
    case photographerText
    case serviceLocText
    case serviceTypeText
    case sweetsText
    case tuxedoText
    case weddingDressText
    case galleryText
    case contactText
    case aylakhoncaText
    case aylakhoncaDesc
    case bakuwedDesc
    case bakuwedText
    case elatusDesc
    case elatusText
    case faridAghaDesc
    case faridAghaText
    case javahirDesDesc
    case javahirDesText
    case nurkhinaDesc
    case nurkhinaText
    case revaneTortDesc
    case revaneTortText
    case romanDecDesc
    case romanDecText
    case turqayDesc
    case turqayText
    case konulKhoncaDesc
    case konulKhoncaText
    case moreText
    case wpNotAvaiTitle
    case wpNotAvaiMessage
}

extension OlsunStrings {
    var localized: String {
        return LocalizationManager.shared.localizedString(forKey: self.rawValue)
    }
}
