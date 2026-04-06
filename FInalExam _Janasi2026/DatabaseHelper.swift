import Foundation
import SQLite3

struct Location {
    var id: Int32
    var name: String
    var latitude: Double
    var longitude: Double
}

class DatabaseHelper {
    static let shared = DatabaseHelper()
    var db: OpaquePointer?
    
    private init() {
        db = openDatabase()
        createTable()
    }
    
    func openDatabase() -> OpaquePointer? {
        var db: OpaquePointer?
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("SearchLocations.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
            return nil
        }
        print("Database successfully allocated at paths:\n \(fileURL.path)")
        return db
    }
    
    func createTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS search_results(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        latitude REAL,
        longitude REAL);
        """
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("search_results table created.")
            } else {
                print("search_results table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertLocation(name: String, latitude: Double, longitude: Double) {
        let insertStatementString = "INSERT INTO search_results (name, latitude, longitude) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 2, latitude)
            sqlite3_bind_double(insertStatement, 3, longitude)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func getAllLocations() -> [Location] {
        let queryStatementString = "SELECT id, name, latitude, longitude FROM search_results;"
        var queryStatement: OpaquePointer?
        var locations: [Location] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(cString: sqlite3_column_text(queryStatement, 1))
                let latitude = sqlite3_column_double(queryStatement, 2)
                let longitude = sqlite3_column_double(queryStatement, 3)
                locations.append(Location(id: id, name: name, latitude: latitude, longitude: longitude))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return locations
    }
}
