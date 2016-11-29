//
//  DatabaseHelper.swift
//  jillderon-pset5
//
//  Created by Jill de Ron on 28-11-16.
//  Copyright © 2016 Jill de Ron. All rights reserved.
//

import Foundation
import SQLite

class DatabaseHelper {
    
    
    private let todosTable = Table("todosTable")
    private let listTable = Table("listTable")
    
    private let id = Expression<Int64>("id")
    private let todo = Expression<String?>("todo")
    private let completed = Expression<Bool>("completed")
    private let listid = Expression<Int64>("listid")
    private let name = Expression<String?>("name")

    // Create connection with database
    private var database: Connection?

    private func setupDatabase() throws {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            database = try Connection("\(path)/db.sqlite3")
            try createTodosTable()
            try createListTable()
        } catch {
            throw error
        }
        
    }
    
    init?(){
        do {
            try setupDatabase()
        } catch {
            return nil
        }
    }
    
    /// CREATE TABLES
    private func createTodosTable() throws {
        do {
            try database!.run(todosTable.create(ifNotExists: true) {
                t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(todo)
                t.column(completed)
                t.column(listid)
            })
            
        } catch {
            throw error
        }
    }
    
    private func createListTable() throws {
        do {
            try database!.run(listTable.create(ifNotExists: true) {
                t in
                
                t.column(id, primaryKey: .autoincrement)
                t.column(name)
            })
            
        } catch {
            throw error
        }
    }
    
    /// INSERT INTO TABLES
    func createTodo(todo: String, listid: Int64) throws {
        let insert = todosTable.insert(self.todo <- todo, self.completed <- false, self.listid <- listid)
        do {
            let rowId = try database!.run(insert)
            print(rowId)
        } catch {
            throw error
        }
        
    }
    
    func createList(name: String) throws {
        let insert = listTable.insert(self.name <- name)
        do {
            let rowId = try database!.run(insert)
            print(rowId)
        } catch {
            throw error
        }
        
    }
    
    /// REMOVE FROM DATABASE
    func removeTodo(withName name: String) throws {
        let item = todosTable.filter(todo == name)
        let _ = try database!.run(item.delete())
    }
    
    
    func removeList(withName name: String) throws {
        let item = listTable.filter(self.name == name)
        let _ = try database!.run(item.delete())
    }
    
    
}
