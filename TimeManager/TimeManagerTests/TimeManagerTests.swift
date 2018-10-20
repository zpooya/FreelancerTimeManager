//
//  TimeManagerTests.swift
//  TimeManagerTests
//
//  Created by Zamzam Pooya on 10/18/18.
//  Copyright © 2018 ZDevelop. All rights reserved.
//

import XCTest
@testable import TimeManager

/// ProjectsPresenterTested
class TimeManagerTests: XCTestCase {
    let handleEmptyProjectsMock = DataManagerMock(projectsModel: [])
    let setProjectsMock = DataManagerMock(projectsModel: [ProjectModel(id: 1, title: "something", desc: nil, times: nil, customerName: "some name", customerMobile: nil, customerEmail: nil)])
    
    func testEmptyProject() {
        let projectsViewControllerMock = ProjectsViewControllerMock()
        let projectsPresenterUnderTest = ProjectsPresenter(delegate: projectsViewControllerMock, dataManager: handleEmptyProjectsMock)
        projectsPresenterUnderTest.getProjects()
        XCTAssertTrue(projectsViewControllerMock.handleEmptyProjectsCalled)
    }
    func testHandleEmptyProjects() {
        let projectsViewControllerMock = ProjectsViewControllerMock()
        let projectsPresenterUnderTest = ProjectsPresenter(delegate: projectsViewControllerMock, dataManager: setProjectsMock)
        
        projectsPresenterUnderTest.getProjects()
        XCTAssertTrue(projectsViewControllerMock.setProjectsCalled)

        
    }
    func testDeletingProject() {
        let projectsViewControllerMock = ProjectsViewControllerMock()
        let projectsPresenterUnderTest = ProjectsPresenter(delegate: projectsViewControllerMock, dataManager: handleEmptyProjectsMock)
        projectsPresenterUnderTest.deleteProject(projectId: 0)
        XCTAssertTrue(projectsViewControllerMock.projectDeletedCalled)

    }
}
