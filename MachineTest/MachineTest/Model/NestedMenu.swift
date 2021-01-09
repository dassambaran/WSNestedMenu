//
//  NestedMenu.swift
//  MachineTest
//
//  Created by SD on 08/01/21.
//

import Foundation
/*
// MARK: - NestedMenu
struct NestedMenu: Codable {
    let status: Bool?
    let code: Int?
    let data: [NestedMenuData]?
    let message: String?
}

// MARK: - Datum
struct NestedMenuData: Codable {
    let id: Int?
    let roleName: String?
    let roleType: Int?
    let company: String?
    let colour, order: String?
    let userID: Int?
    let createdAt, updatedAt: String?
    let deletedAt: String?
    let planning: Planning?

    enum CodingKeys: String, CodingKey {
        case id
        case roleName = "role_name"
        case roleType = "role_type"
        case company, colour, order
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case planning
    }
}

// MARK: - Planning
struct Planning: Codable {
    let id: Int?
    let mission, vision: String?
    let type, clientRoleID: Int?
    let year, quarter, createdAt, updatedAt: String?
    let deletedAt: String?
    let objective: [Objective]?

    enum CodingKeys: String, CodingKey {
        case id, mission, vision, type
        case clientRoleID = "client_role_id"
        case year, quarter
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case objective
    }
}

// MARK: - Objective
struct Objective: Codable {
    let id: Int?
    let contentObj: String?
    let score: String?
    //let projectID: JSONNull?
    let planningID: Int?
    let createdAt, updatedAt: String?
    let deletedAt: String?
    let keyResult: [KeyResult]?
    let majorAction: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case contentObj = "content_obj"
        case score
        //case projectID = "project_id"
        case planningID = "planning_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case keyResult = "key_result"
        case majorAction = "major_action"
    }
}

// MARK: - KeyResult
struct KeyResult: Codable {
    let id: Int?
    let keyResult, metrics: String?
    let objectiveID: Int?
    let createdAt, updatedAt: String?
    let deletedAt: String?
    let type: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case keyResult = "key_result"
        case metrics
        case objectiveID = "objective_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case type
    }
}
*/

// MARK: - NestedMenu
struct NestedMenu: Codable {
    let status: Bool?
    let code: Int?
    let data: [NestedMenuData]?
    let message: String?
}

// MARK: - Datum
struct NestedMenuData: Codable {
    let id: Int?
    let planning: Planning?
}

// MARK: - Planning
struct Planning: Codable {
    let id: Int?
    let objective: [Objective]?
}

// MARK: - Objective
struct Objective: Codable {
    let id: Int?
    let contentObj: String?
    let objective: [Objective]?

    enum CodingKeys: String, CodingKey {
        case id
        case contentObj = "content_obj"
        case objective
    }
}
