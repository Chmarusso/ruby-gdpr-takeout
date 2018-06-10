module GDPR
  class PrepareDir
    class << self
      def call(user_id)
        name = generate_name(user_id)
        path = tmp_dir_path(name)
        create_directory(path)
        path
      end

      private

      def tmp_dir_path(name)
        File.join(Rails.root, 'tmp', 'takeouts', name)
      end

      def generate_name(user_id)
        md5 = Digest::MD5.new
        md5 << "takeout-#{user_id}"
        "takeout_#{md5.hexdigest}"
      end

      def create_directory(path)
        Dir.mkdir(path) unless File.exists?(path)
      end
    end
  end
end
