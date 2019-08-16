module Fastlane # rubocop:disable FrozenStringLiteralComment
  module Actions
    module SharedValues # rubocop:disable Documentation
      NEW_BUILD_NUMBER ||= :NEW_BUILD_NUMBER
    end

    # Action implementation
    class IncrementAgBuildAction < Action
      def self.run(params)
        file_path = params[:xcconfig]
        build_number = params[:build_number]
        build_number_var = params[:build_number_var] ? params[:build_number_var] : "AG_BUILD"

        UI.message("Running increment_ag_build action")
        UI.message("File path is '#{file_path}'")
        UI.message("Build number variable is '#{build_number_var}'")
        if !build_number
          UI.message("Build number is not set -- we will increment the current one")
        else
          UI.message("Build number is '#{build_number}'")
        end

        xcconfig_content = ""
        new_build_number = 0

        open(file_path, "r").readlines.each do |l|
          kv = l.split("=")
          if kv.length == 2 && kv[0].strip! == build_number_var
            current_build_number = kv[1].strip!
            UI.message("Current build number is '#{current_build_number}'")

            if build_number
              new_build_number = build_number
              l = "#{build_number_var} = #{new_build_number}\n"
              UI.message("New build number is #{new_build_number}") 
            elsif current_build_number.to_i.to_s == current_build_number
              new_build_number = (current_build_number.to_i + 1).to_s
              l = "#{build_number_var} = #{new_build_number}\n"
              UI.message("New build number is #{new_build_number}")
            else
              UI.user_error!("'#{current_build_number}' must be integer!")
            end

            xcconfig_content += l
          else
            xcconfig_content += l
          end
        end

        if new_build_number == 0
          UI.user_error!("Could not find #{build_number_var} in the #{file_path}")
        end

        File.write(file_path, xcconfig_content)
        UI.message("New build number has been written to #{file_path}")
        Actions.lane_context[SharedValues::NEW_BUILD_NUMBER] = new_build_number
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'Increments AG_BUILD value in the xcconfig file'
      end

      def self.available_options
        # Define all options your action supports.
        [
          FastlaneCore::ConfigItem.new(key: :build_number,
                                       env_name: 'AG_BUILD_NUMBER',
                                       description: 'Change to a specific version',
                                       optional: true,
                                       is_string: false),
          FastlaneCore::ConfigItem.new(key: :xcconfig,
                                       env_name: 'AG_XCONFIG_PATH',
                                       description: 'You must specify the path to your main xconfig file',
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!('Could not find xconfig file') if !File.exist?(value) && !Helper.test?
                                       end),
          FastlaneCore::ConfigItem.new(key: :build_number_var,
                                       env_name: 'AG_BUILD_NUMBER_VAR',
                                       description: 'Change the build number variable name (default is AG_BUILD)',
                                       optional: true),
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        [
          ['NEW_BUILD_NUMBER', 'The new build number']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
        'The new build number'
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["AdGuard"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
