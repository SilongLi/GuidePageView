module Fastlane
  module Actions
    module SharedValues
      REMOVE_TAG_CUSTOM_VALUE = :REMOVE_TAG_CUSTOM_VALUE
    end

    class RemoveTagAction < Action
      def self.run(params)
          # 接收外部参数
          tagName = params[:tag]
          isRemoveLocalTag = params[:isRemoveLocal]
          isRemoveRemoteTag = params[:isRemoveRemote]

          # 1. 先定义一个数组，用来存储所有需要执行的命令
          cmds = []

          # 2. 添加命令

          # 删除本地标签 git tag -d "xxx"
          if isRemoveLocalTag
              cmds << "git tag -d #{tagName}"
          end

          # 删除远程标签  git push origin :"xxx"
          if isRemoveRemoteTag
            cmds << "git push origin :#{tagName}"
          end

          # 3. 执行命令
          # 数组中的命令，用“&”做连接符分开, 如： git tag -d "xxx" & git push origin :"xxx"
          Actions.sh(cmds.join('&'));

      end

      def self.description
        "删除本地和远程的标签"
      end

      def self.details
        "使用此action，删除本地和远程的标签。"
      end

      def self.available_options
        # 接收的参数类型定义
        [
          FastlaneCore::ConfigItem.new(key: :tag,
                                      description: "即将被删除的标签名称",
                                      is_string: true,
                                      optional:false),

          FastlaneCore::ConfigItem.new(key: :isRemoveLocal, 
                                       description: "是否需要删除本地标签",
                                       is_string: false, 
                                       optional: true,
                                       default_value: true),

          FastlaneCore::ConfigItem.new(key: :isRemoveRemote, 
                                       description: "是否需要删除远程标签",
                                       is_string: false,
                                       optional: true,
                                       default_value: true) 
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
