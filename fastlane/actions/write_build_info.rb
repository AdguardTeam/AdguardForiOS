module Fastlane
  module Actions
    module SharedValues
      BUILD_NUMBER = :BUILD_NUMBER
      VERSION = :VERSION
    end

    class WriteBuildInfoAction < Action
      def self.run(params)
        output_path = params[:build_info_output] ? params[:build_info_output] : "build.txt"
        file_path = params[:xcconfig]
        build_number_var = params[:build_number_var] ? params[:build_number_var] : "AG_BUILD"
        version_var = params[:version_var] ? params[:version_var] : "AG_VERSION"

        UI.message("Running write_build_info action")
        UI.message("Output path is '#{output_path}'")
        UI.message("File path is '#{file_path}'")
        UI.message("Build number variable is '#{build_number_var}'")
        UI.message("Version variable is '#{version_var}'")

        current_build_number = 0
        current_version = ""

        open(file_path, "r").readlines.each do |l|
          kv = l.split("=")

          if kv.length == 2
            name = kv[0].strip!
            if name == build_number_var
              current_build_number = kv[1].strip!
            elsif name == version_var
              current_version = kv[1].strip!
            end
          end
        end

        if current_build_number == 0
          UI.user_error!("Could not find #{build_number_var} in the #{file_path}")
        end

        if current_version == ""
          UI.user_error!("Could not find #{version_var} in the #{file_path}")
        end

        output = "version=#{current_version}\nbuild_number=#{current_build_number}"
        File.write(output_path, output)
        UI.message("Build info has been written to #{output_path}")
        Actions.lane_context[SharedValues::BUILD_NUMBER] = current_build_number
        Actions.lane_context[SharedValues::VERSION] = current_version
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Writes version and build number to the specified file"
      end

      def self.available_options
        # Define all options your action supports.
        [
          FastlaneCore::ConfigItem.new(key: :build_info_output,
                                       env_name: "AG_BUILD_INFO_OUTPUT", # The name of the environment variable
                                       description: "Path to the output file", # a short description of this parameter
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :xcconfig,
                                       env_name: "AG_XCONFIG_PATH",
                                       description: "You must specify the path to your main xconfig file",
                                       optional: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Could not find xconfig file") if !File.exist?(value) && !Helper.test?
                                       end),
          FastlaneCore::ConfigItem.new(key: :build_number_var,
                                       env_name: "AG_BUILD_NUMBER_VAR",
                                       description: "Change the build number variable name (default is AG_BUILD)",
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :version_var,
                                       env_name: "AG_VERSION_VAR",
                                       description: "Change the version variable name (default is AG_VERSION)",
                                       optional: true),
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ["BUILD_NUMBER", "Build number"],
          ["VERSION", "Version"],
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["AdGuard"]
      end

      def self.is_supported?(platform)
        # you can do things like
        #
        #  true
        #
        #  platform == :ios
        #
        #  [:ios, :mac].include?(platform)
        #
        [:ios, :mac].include?(platform)
      end
    end
  end
end
