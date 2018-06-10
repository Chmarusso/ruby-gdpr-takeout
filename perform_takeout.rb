require 'securerandom'

module GDPR
  class PerformTakeout
    class << self
      TAKEOUTS_PATH = File.join(Rails.root, 'public', 'system', 'takeouts')

      def call(user_id)
        user = User.find(user_id)
        path = prepare_directory(user_id)
        export_records(path, user_id)
        archive_directory(path)
      end

      private

      def prepare_directory(user_id)
        GDPR::PrepareDir.call(user_id)
      end

      def export_records(path, user_id)
        GDPR::ExportRecords.call(path, User.where(id: user_id), [])
        GDPR::ExportRecords.call(path, Comment.where(user_id: user_id), [])
        GDPR::ExportRecords.call(path, Vote.where(user_id: user_id), [])
      end

      def archive_directory(takeout_path)
        password = SecureRandom.urlsafe_base64(12)
        archive_name = "#{File.basename(takeout_path)}.zip"
        archive_path = File.join(TAKEOUTS_PATH, archive_name)
        system("zip --password #{password} -j -r9 #{archive_path} #{takeout_path}")

        [archive_path, password]
      end
    end
  end
end
