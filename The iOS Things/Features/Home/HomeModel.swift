//
//  HomeModel.swift
//  The iOS Things
//
//  Created by Ariesta APP on 18/12/23.
//

import Foundation
import UIKit

enum ArticleCategory: String, CaseIterable {
    case Tutorial
    case TipsTrick = "Tips & Tricks"
    case none = "Uncategorized"
    
    func description() -> String {
        switch self {
        case .Tutorial:
            "Tutorial"
        case .TipsTrick:
            "Tips & Tricks"
        case .none:
            "Uncategorized"
        }
    }
    func getBGColor() -> UIColor {
        switch self {
        case .Tutorial:
            .green
        case .TipsTrick:
            .blue
        case .none:
            .gray
        }
    }
    
    func getFontColor() -> UIColor {
        switch self {
        case .Tutorial:
            #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        case .TipsTrick:
            #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        case .none:
            .black
        }
    }
}

struct HomeArticleModel: Identifiable {
    let id: UUID = UUID()
    let thumbnail: String?
    let title: String?
    let excerpt: String?
    let body: String?
    let category: ArticleCategory?
    let publisher: String?
    let isHeader: Bool?
    
    
    init(_ thumbnail: String?,_ title: String?,_ excerpt: String?,_ body: String?,_ category: ArticleCategory?,_ publisher: String?, isheader: Bool?) {
        self.thumbnail = thumbnail
        self.title = title
        self.excerpt = excerpt
        self.body = body
        self.category = category
        self.publisher = publisher
        self.isHeader = isheader
    }
}
