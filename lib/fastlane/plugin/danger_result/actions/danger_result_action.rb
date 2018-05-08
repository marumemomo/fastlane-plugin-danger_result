require 'fastlane/action'
require_relative '../helper/danger_result_helper'

module Fastlane
  module Actions
    class DangerResultAction < Action
      def self.run(params)
        d = ''
        d = other_action.danger(
          use_bundle_exec: params[:use_bundle_exec],
          verbose: params[:verbose],
          danger_id: params[:danger_id],
          dangerfile: '../' + (params[:dangerfile] || 'Dangerfile'),
          github_api_token: params[:github_api_token],
          fail_on_errors: params[:fail_on_errors],
          new_comment: params[:new_comment],
          base: params[:base],
          head: params[:head],
          pr: params[:pr]
        )
        d.gsub!(/(\e\[31m|\e\[32m|\e\[33m|\e\[0m|\n)/, '')
        res = d.split('Results:')[1]
        result = {
          errors: [],
          warnings: []
        }
        if /Errors:/ =~ res
          result[:errors] = res.split("Errors:")[1].split("Warnings:")[0].sub(/- \[ \] /, '').split('- [ ] ')
        end
        if /Warnings:/ =~ res
          result[:warnings] = res.split("Warnings:")[1].sub(/- \[ \] /, '').split('- [ ] ')
        end
        result
      end

      def self.description
        "Get danger data plugin."
      end

      def self.authors
        ["marumemomo"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        ""
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :use_bundle_exec,
                                       env_name: "FL_DANGER_USE_BUNDLE_EXEC",
                                       description: "Use bundle exec when there is a Gemfile presented",
                                       is_string: false,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :verbose,
                                       env_name: "FL_DANGER_VERBOSE",
                                       description: "Show more debugging information",
                                       is_string: false,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :danger_id,
                                       env_name: "FL_DANGER_ID",
                                       description: "The identifier of this Danger instance",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :dangerfile,
                                       env_name: "FL_DANGER_DANGERFILE",
                                       description: "The location of your Dangerfile",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :github_api_token,
                                       env_name: "FL_DANGER_GITHUB_API_TOKEN",
                                       description: "GitHub API token for danger",
                                       sensitive: true,
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :fail_on_errors,
                                       env_name: "FL_DANGER_FAIL_ON_ERRORS",
                                       description: "Should always fail the build process, defaults to false",
                                       is_string: false,
                                       optional: true,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :new_comment,
                                       env_name: "FL_DANGER_NEW_COMMENT",
                                       description: "Makes Danger post a new comment instead of editing its previous one",
                                       is_string: false,
                                       optional: true,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :base,
                                       env_name: "FL_DANGER_BASE",
                                       description: "A branch/tag/commit to use as the base of the diff. [master|dev|stable]",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :head,
                                       env_name: "FL_DANGER_HEAD",
                                       description: "A branch/tag/commit to use as the head. [master|dev|stable]",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :pr,
                                       env_name: "FL_DANGER_PR",
                                       description: "Run danger on a specific pull request. e.g. \"https://github.com/danger/danger/pull/518\"",
                                       is_string: true,
                                       optional: true)
        ]
      end

      def self.is_supported?(platform)
        true
      end

      def self.example_code
        [
          'danger_result',
          'danger_result(
            danger_id: "unit-tests",
            dangerfile: "tests/MyOtherDangerFile",
            github_api_token: ENV["GITHUB_API_TOKEN"],
            verbose: true
          )'
        ]
      end
    end
  end
end
