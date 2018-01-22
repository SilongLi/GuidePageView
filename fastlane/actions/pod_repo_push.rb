module Fastlane
  module Actions
    module SharedValues
      POD_REPO_PUSH_CUSTOM_VALUE = :POD_REPO_PUSH_CUSTOM_VALUE
    end

    class PodRepoPushAction < Action
      def self.run(params)

         # 接收外部参数
          repoName    = params[:repo]
          podspecName = params[:podspec]

          # 1. 先定义一个数组，用来存储所有需要执行的命令
          cmds = []

          # 2. 添加命令

          # pod repo push [repoName]  xxx.podspec 
          cmds << "pod repo push #{repoName} #{podspecName}.podspec --allow-warnings"

          # 3. 执行命令
          # 数组中的命令，用“&”做连接符分开, 如： git tag -d "xxx" & git push origin :"xxx"
          Actions.sh(cmds.join('&'));

      end

      def self.description
        "推送podspec文件到私有的索引库中。"
      end

      def self.details
        "使用此action，推送podspec文件到私有的索引库中。"
      end

      def self.available_options
        # 接收的参数类型定义
        [
          FastlaneCore::ConfigItem.new(key: :repo,
                                      description: "私有索引库",
                                      is_string: true,
                                      optional:false),

          FastlaneCore::ConfigItem.new(key: :podspec,
                                      description: "podspec文件名",
                                      is_string: true,
                                      optional:false)
        ]
      end

      def self.output

      end

      def self.return_value
        nil
      end

      def self.authors
        ["lisilong"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
