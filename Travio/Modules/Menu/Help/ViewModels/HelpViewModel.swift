

import UIKit

class HelpViewModel {
    var faqItems: [FAQItem]

    init() {
        self.faqItems = [
            FAQItem(question: "How can I create a new account on Travio?", answer: "To create a new account on Travio, follow these steps:", isExpanded: false),
            FAQItem(question: "How can I save a visit?", answer: "To save a visit on Travio, follow these steps:", isExpanded: false),
            FAQItem(question: "How does Travio work?", answer: "Travio is a travel planning app that helps you organize your trips. You can use it to:", isExpanded: false),
            FAQItem(question: "Is Travio available on Android?", answer: "Yes, Travio is available on both iOS and Android platforms.", isExpanded: false),
            FAQItem(question: "How do I reset my password?", answer: "To reset your password on Travio, follow these steps:", isExpanded: false),
            FAQItem(question: "What payment methods are accepted on Travio?", answer: "Travio accepts the following payment methods:", isExpanded: false),
            FAQItem(question: "Can I change my travel dates after booking?", answer: "Yes, you can change your travel dates after booking. Follow these steps to modify your booking:", isExpanded: false),
            FAQItem(question: "How can I contact Travio customer support?", answer: "To contact Travio customer support, you can:", isExpanded: false),
            FAQItem(question: "Do I need a visa to travel to international destinations?", answer: "Whether you need a visa to travel to an international destination depends on your nationality and the destination country's visa requirements. It's essential to check the visa requirements before planning your trip.", isExpanded: false),
            FAQItem(question: "What should I do if my flight is delayed or canceled?", answer: "If your flight is delayed or canceled, you should:", isExpanded: false),
            FAQItem(question: "Can I book accommodations through Travio?", answer: "Yes, you can book accommodations such as hotels, hostels, and vacation rentals through Travio's platform.", isExpanded: false),
            FAQItem(question: "How can I add travel companions to my trip?", answer: "To add travel companions to your trip on Travio, follow these steps:", isExpanded: false),
            FAQItem(question: "What is the Travio cancellation policy?", answer: "Travio's cancellation policy may vary depending on the booking and the provider. It's essential to review the cancellation policy before making a booking.", isExpanded: false),
            FAQItem(question: "Can I purchase travel insurance through Travio?", answer: "Yes, you can purchase travel insurance when booking your trip through Travio. Travel insurance provides coverage for various unexpected situations during your journey.", isExpanded: false),
            FAQItem(question: "Is my personal information secure on Travio?", answer: "Yes, Travio takes data security and privacy seriously. We use advanced security measures to protect your personal information.", isExpanded: false)
        ]
    }

    func numberOfItemsInSection(_ section: Int) -> Int {
        return faqItems.count
    }

    func item(at indexPath: IndexPath) -> FAQItem? {
        guard indexPath.row < faqItems.count else {
            return nil
        }
        return faqItems[indexPath.row]
    }

    func toggleItemExpansion(at indexPath: IndexPath) {
        guard indexPath.row < faqItems.count else {
            return
        }
        faqItems[indexPath.row].isExpanded.toggle()
    }

    func heightForText(_ text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}
