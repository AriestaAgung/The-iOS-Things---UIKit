//
//  HomePresenter.swift
//  The iOS Things
//
//  Created by Ariesta APP on 18/12/23.
//
import Foundation
import Dispatch

protocol HomeUseCase {
    func provideHeaderArticleData(completion: @escaping ([HomeArticleModel]) -> Void)
    func provideCategoriesData(completion: @escaping ([ArticleCategory]) -> Void)
    func provideArticle(completion: @escaping ([HomeArticleModel]) -> Void)
}

class HomePresenter: HomeUseCase {
    static var shared = HomePresenter()
    var articles: [HomeArticleModel]?
    var articleCategories: [ArticleCategory]?
    var headArticles: [HomeArticleModel]?
    
    func provideHeaderArticleData(completion: @escaping ([HomeArticleModel]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            self.headArticles = NewsDummy.data.filter({$0.isHeader == true})
            completion(self.headArticles ?? [])
        })
    }
    
    func provideCategoriesData(completion: @escaping ([ArticleCategory]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
            self.articleCategories = ArticleCategory.allCases
        })
    }
    
    func provideArticle(completion: @escaping ([HomeArticleModel]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()+4, execute: {
            self.articles = NewsDummy.data
        })
    }
    
}
