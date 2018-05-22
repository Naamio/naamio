import SwiftKuery
import SwiftKuerySQLite

import NaamioCore

public class Database {

    static let pagesTable = PagesTable()

    //let queue = DispatchQueue(label: "cloud.naamio.database", attributes: .concurrent)

    public func connectToDatabase() {
        let connection = self.createConnection()

        Log.info("Connect")
        print("Connect")

        connection.connect() { error in
            print("In")
            Log.info("Connection happened")
            if let error = error {
                Log.error("Error \(error)")
            }
            else {
                let pages: [[Any]] = [["mah", 0, 2.1], ["physics", 0, 3.9], ["history", 0, 8.3]]

                Database.pagesTable.create(connection: connection) { result in
                    if result.success == false {
                        Log.error("Error \(result.asError)")
                        return
                    }
                    else {
                        let insertQuery = Insert(into: Database.pagesTable, rows: pages)
                        connection.execute(query: insertQuery) { insertResult in
                            connection.execute(query: Select(from: Database.pagesTable)) { selectResult in
                                if let resultSet = selectResult.asResultSet {
                                    for row in resultSet.rows {
                                        Log.info("Page \(row[0] ?? ""), studying \(row[1] ?? ""), scored \(row[2] ?? "")")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        print("Hmph")
        
        //db.connect(onCompletion: (QueryError?) -> ())
    }

    func createConnection() -> Connection {
        return SQLiteConnection(filename: "/tmp/naamio/naamio.db")
    }
}

final class PagesTable: Table {
    let a = Column("a", String.self, primaryKey: true, defaultValue: "qiwi", collate: "BINARY")
    let b = Column("id", Int32.self, autoIncrement: true)
    let c = Column("value", Double.self, defaultValue: 4.95, check: "c > 0")
    
    let tableName = "pages"
}