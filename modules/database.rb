require 'sqlite3'

class Storage
    def initialize
        unless File.exist?('database/results.sqlite')
            # Creating DB file in case it doesn't exist
            puts "[DATABASE]: Database file not found, creating new one."

            @db = SQLite3::Database.new "database/results.sqlite"

            # Creating tables
            create_table
        else
            @db = SQLite3::Database.open "database/results.sqlite"
        end
    end

    def create_table
        # Creating table
        begin
            @db.execute "CREATE TABLE results(id INTEGER PRIMARY KEY, color TEXT, number INTEGER, date TEXT)"
            puts "[DATABASE]: Table created successfully."
        rescue => exception
            puts "[DATABASE]: Exception occured: #{exception}"
        end
    end

    def store_result(result)
        # Validating the data
        if result['color'] == nil || result['number'] == nil || result['date'] == nil
            puts "[DATABASE]: Invalid data provided."
            return false
        end

        # Storing the data
        begin
            @db.execute "INSERT INTO results(color, number, date) VALUES (?, ?, ?)",
                [result['color'], result['number'], result['date']]
        rescue => exception
            puts "[DATABASE]: Exception occured: #{exception}"
        end
    end
end