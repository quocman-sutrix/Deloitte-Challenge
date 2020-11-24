//
//  MockedData.swift
//  Deloitte ChallengeTests
//
//  Created by Lu Quoc Man on 11/24/20.
//  Copyright © 2020 Lu Quoc Man. All rights reserved.
//

import Foundation
import UIKit

/// Contains all available Mocked data.
public final class MockedData {
    public static let MovieDetailNoDataResponse: URL = Bundle(for: MockedData.self).url(forResource: "MovieDetailNoDataResponse", withExtension: "json")!
    public static let MovieDetailResponse: URL = Bundle(for: MockedData.self).url(forResource: "MovieDetailResponse", withExtension: "json")!
    public static let MovieListNoDataResponse: URL = Bundle(for: MockedData.self).url(forResource: "MovieListNoDataResponse", withExtension: "json")!
    public static let MovieListResponse: URL = Bundle(for: MockedData.self).url(forResource: "MovieListResponse", withExtension: "json")!
}

internal extension URL {
    /// Returns a `Data` representation of the current `URL`. Force unwrapping as it's only used for tests.
    var data: Data {
        return try! Data(contentsOf: self)
    }
}
