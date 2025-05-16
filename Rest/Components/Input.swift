//
//  Input.swift
//  Rest
//
//  Created by Me Tomm on 22/3/2568 BE.
//
import Foundation

public func isValidInput(email: String, password: String) -> Bool {
    return !email.isEmpty && !password.isEmpty
}
