require 'json'

class Settings
    def initialize
        # Checking if the config file exists
        if File.exist?('config/settings.json')
            # Checking if the config file is empty
            if File.zero?('config/settings.json')
                @settings = {
                    "store_results" => true,
                }

                # Writing new config file
                File.write('config/settings.json', JSON.pretty_generate(@settings))
            else
                @settings = JSON.parse(File.read('config/settings.json'))
            end
        else
            @settings = {
                "store_results" => true,
            }

            # Creating new config file
            puts "[SETTINGS]: Creating new config file"

            File.open('config/settings.json', 'w') do |file|
                file.write(JSON.pretty_generate(@settings))
            end

            puts "[SETTINGS]: Config file created"
        end
    end

    def get_settings
        return @settings
    end

    def get_setting(setting)
        # Checking if the setting exists
        if @settings.key?(setting)
            return @settings[setting]
        else
            return false
        end
    end
end