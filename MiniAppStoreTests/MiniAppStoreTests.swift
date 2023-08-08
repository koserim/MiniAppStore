//
//  MiniAppStoreTests.swift
//  MiniAppStoreTests
//
//  Created by 림고세 on 2023/07/01.
//

import XCTest
import Combine
@testable import MiniAppStore

final class MiniAppStoreTests: XCTestCase {
    
    private let mockURL: URL = URL(string: "https://itunes.apple.com/search?term=kakao&country=kr&entity=software&limit=10")!
    
    private var cancellables = Set<AnyCancellable>()
    private var mockNetworkManager: NetworkManager!

    override func setUpWithError() throws {
        let mockResponse = makeMockResponse()
        let urlSession = MockURLSession(response: mockResponse)
        
        mockNetworkManager = NetworkManager(session: urlSession)
    }
    
    // 검색 Request 후 resultType이 .searchResult여야 한다.
    func test_view_result_type_is_searchResult_when_searching() throws {
        let viewModel: SearchDataProvider = SearchViewModel(mockNetworkManager)
        
        viewModel.search(with: "카카오")
        
        XCTAssertEqual(viewModel.resultType, .searchResult)
    }
    
    // 검색 Request 후 resultType이 .matchedKeyword가 아니어야 한다.
    func test_view_result_type_is_not_matchedKeyword_when_searching() throws {
        let viewModel: SearchDataProvider = SearchViewModel(mockNetworkManager)
        
        viewModel.search(with: "카카오")
        
        XCTAssertNotEqual(viewModel.resultType, .matchedKeyword)
    }
    
    // 타이핑 후 resultType이 .matchedKeyword여야 한다.
    func test_view_result_type_is_matchedKeyword_when_typing() throws {
        let viewModel: SearchDataProvider = SearchViewModel(mockNetworkManager)
        
        viewModel.updateMatchedKeyword(with: "카")
        
        XCTAssertEqual(viewModel.resultType, .matchedKeyword)
    }
    
    // 타이핑 후 resultType이 .searchResult가 아니어야 한다.
    func test_view_result_type_is_not_searchResult_when_typing() throws {
        let viewModel: SearchDataProvider = SearchViewModel(mockNetworkManager)
        
        viewModel.updateMatchedKeyword(with: "카카")
        
        XCTAssertNotEqual(viewModel.resultType, .searchResult)
    }

    // 검색 Request 후 응답값을 searchResult 배열에 저장해야 한다.
    func test_get_result_when_request_is_successed() throws {
        let viewModel: SearchDataProvider = SearchViewModel(mockNetworkManager)
        
        viewModel.search(with: "카카오")
        
        XCTAssertTrue(viewModel.searchResult.value.isEmpty == false)
    }
    
    // 가장 최근에 검색한 키워드가 첫번째 최근 검색어여야 한다.
    func test_first_keyword_is_the_last_searched_keyword() throws {
        let viewModel: SearchDataProvider = SearchViewModel(mockNetworkManager)
        
        viewModel.search(with: "쇼핑")
        
        XCTAssertEqual(viewModel.reversedKeywords.value.first?.value, "쇼핑")
    }
    
    // 중복된 최근 검색어가 없어야 한다.
    func test_remove_duplicated_searched_keyword() throws {
        let viewModel: SearchDataProvider = SearchViewModel(mockNetworkManager)
        
        viewModel.search(with: "카카오")
        viewModel.search(with: "카카오")
        viewModel.search(with: "카카오뱅크")
        
        let recentKeywords = viewModel.reversedKeywords.value
        XCTAssertEqual(recentKeywords.filter({ $0.value == "카카오" }).count, 1)
    }
    
    // 입력받은 텍스트로 시작하는 최근 검색어 목록을 리턴한다.
    func test_return_matched_keyword() throws {
        let viewModel: SearchDataProvider = SearchViewModel(mockNetworkManager)
        viewModel.search(with: "카카오")
        viewModel.search(with: "카카오")
        viewModel.search(with: "카카오뱅크")
        
        viewModel.updateMatchedKeyword(with: "카")
        
        let result1 = viewModel.matchedKeywords.value.filter { $0.value == "카카오"}.count != 0
        let result2 = viewModel.matchedKeywords.value.filter { $0.value == "카카오뱅크"}.count != 0
        XCTAssertTrue(result1 && result2)
    }
    
    // 입력받은 텍스트로 시작하지 않는 최근 검색어는 리턴하지 않는다.
    func test_do_not_return_not_matched_keywords() throws {
        let viewModel: SearchDataProvider = SearchViewModel(mockNetworkManager)
        viewModel.search(with: "카카오")
        viewModel.search(with: "카카오")
        viewModel.search(with: "카카오뱅크")
        
        viewModel.updateMatchedKeyword(with: "김")
        
        let result1 = viewModel.matchedKeywords.value.filter { $0.value == "카카오"}.count != 0
        let result2 = viewModel.matchedKeywords.value.filter { $0.value == "카카오뱅크"}.count != 0
        XCTAssertFalse(result1 || result2)
    }
    
    // 최근 검색어의 개수는 10개를 넘지 않는다.
    func test_recent_keyword_max_count_is_10() throws {
        let viewModel: SearchDataProvider = SearchViewModel(mockNetworkManager)
        
        viewModel.search(with: "카카오")
        viewModel.search(with: "카카오뱅크")
        viewModel.search(with: "가나다")
        viewModel.search(with: "가나다라")
        viewModel.search(with: "마")
        viewModel.search(with: "twitter")
        viewModel.search(with: "옷")
        viewModel.search(with: "그림")
        viewModel.search(with: "피아노")
        viewModel.search(with: "뱅크")
        
        viewModel.search(with: "그림자")
        
        XCTAssertEqual(viewModel.reversedKeywords.value.count, 10)
    }
    
    // 최근 검색어가 10개를 초과하려고 하면 첫번째 최근 검색어를 삭제한다.
    func test_remove_first_recent_keyword_when_keyword_overflowed() throws {
        let viewModel: SearchDataProvider = SearchViewModel(mockNetworkManager)
        
        viewModel.search(with: "카카오")
        viewModel.search(with: "카카오뱅크")
        viewModel.search(with: "가나다")
        viewModel.search(with: "가나다라")
        viewModel.search(with: "마")
        viewModel.search(with: "twitter")
        viewModel.search(with: "옷")
        viewModel.search(with: "그림")
        viewModel.search(with: "피아노")
        viewModel.search(with: "뱅크")
        
        viewModel.search(with: "그림자")
        
        XCTAssertEqual(viewModel.reversedKeywords.value.last?.value, "카카오뱅크")
    }
    
    // Int를 "n만"으로 정상적으로 변환한다. - 12345 to 1.2만
    func test_switch_Int_to_String_with_suffix_만_12345() throws {
        let intValue = 12345
        
        let stringValue = intValue.toString()
        
        XCTAssertEqual(stringValue, "1.2만")
    }
    
    // Int를 "n만"으로 정상적으로 변환한다. - 300000 to 30만
    func test_switch_Int_to_String_with_suffix_만_300000() throws {
        let intValue = 300000
        
        let stringValue = intValue.toString()
        
        XCTAssertEqual(stringValue, "30만")
    }
    
    // Int를 "n천"으로 정상적으로 변환한다. - 3333 to 3.3천
    func test_switch_Int_to_String_with_suffix_천_3333() throws {
        let intValue = 3333
        
        let stringValue = intValue.toString()
        
        XCTAssertEqual(stringValue, "3.3천")
    }
    
    // Int를 "n천"으로 정상적으로 변환한다. - 6000 to 6천
    func test_switch_Int_to_String_with_suffix_천_6000() throws {
        let intValue = 6000
        
        let stringValue = intValue.toString()
        
        XCTAssertEqual(stringValue, "6천")
    }
    
    // Int를 "n"으로 정상적으로 변환한다. - 14 to 14
    func test_switch_Int_to_String_with_suffix_nil() throws {
        let intValue = 14
        
        let stringValue = intValue.toString()
        
        XCTAssertEqual(stringValue, "14")
    }
    
    override func tearDownWithError() throws {
        
    }

}

extension MiniAppStoreTests {
    
    private func makeMockResponse() -> MockURLSession.Response {
        let data: Data? = {
            guard let path = Bundle.main.path(forResource: "Mock1", ofType: "json") else { return nil }
            guard let jsonString = try? String(contentsOfFile: path) else { return nil }
            return jsonString.data(using: .utf8)
        }()
        let response: URLResponse? = HTTPURLResponse(url: mockURL, statusCode: 200, httpVersion: nil, headerFields: nil)
        return (data: data, response: response, error: nil)
    }
    
}
