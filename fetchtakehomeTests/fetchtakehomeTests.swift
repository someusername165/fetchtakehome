//
//  fetchtakehomeTests.swift
//  fetchtakehomeTests
//
//  Created by Ahad Islam on 2/8/25.
//

import Testing
@testable import fetchtakehome

struct fetchtakehomeTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func testNetworker() async throws {
        let networker = Networker.shared
        let recipes = try await networker.getRecipes()
        #expect(recipes.count > 0)
    }
}
