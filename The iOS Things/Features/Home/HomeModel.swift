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
            .white
        case .TipsTrick:
            .white
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
