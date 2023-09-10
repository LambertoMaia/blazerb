require "net/http"
require "json"

require_relative "settings"
require_relative "database"

class Blaze
    def initialize
        @api_url    = URI("https://blaze-1.com/api/roulette_games/current")
        @settings   = Settings.new
        @storage    = Storage.new
    end

    def read_api
        http = Net::HTTP.new(@api_url.host, @api_url.port)
        http.use_ssl = true

        request     = Net::HTTP::Get.new(@api_url)
        response    = http.request(request)

        if response.code != "200"
            return false
        end

        return JSON.parse(response.body)
    end

    def get_result
        response = read_api

        if response == false
            return false
        end

        while response['status'] != "complete"
            sleep(1) # wait for 1 second before calling again
            response = read_api
        end

        color = response['color']

        case color
        when 1 
            color = "red"
        when 2
            color = "black"
        when 0
            color = "white"
        else
            color = "unknown"
        end

        data = {
            "id"        => response['id'],
            "color"     => color,
            "number"    => response['roll'],
            "date"      => response['created_at']
        }

        if @settings.get_setting("store_results") == true
            # Saving the result to the database
            @storage.store_result(data)
        end

        return data
    end

    def run_bot
        puts "Running Bot. Press CTRL+C to stop."

        while true
            result = get_result

            if result == false
                puts "[BOT]: Error while getting result, ending bot."
                break
            end

            puts "[BOT]: Result: #{result['color']} #{result['number']}"

            sleep(6)
        end
    end     
end