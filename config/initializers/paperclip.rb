require 'paperclip/media_type_spoof_detector'
# we have a case where zip files have a .ngz extension and
# paperclip doesn't like this. This is a workaround for
# the resulting error.
# See https://github.com/thoughtbot/paperclip/issues/1470
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end

Paperclip.interpolates('icon_type_extension') do |attachment, style|
  ext = attachment.instance.icon_file_name.split('.').last.downcase
  unless %w(jpg jpeg png gif).include?(ext)
    ext = attachment.instance.icon_content_type.split('/').last
  end
  ext
end


# monkey-patching Paperclip v4.2.4
# when S3 versioning is enabled, and a custom 'original' style is defined,
# you would normally end up with duplicate versions of 'original' as soon
# as an attachment is uploaded. The true original will go in, and then the
# custom 'original' will overwrite the true original. We don't need that
# true original, and this method will delete that version.
module Paperclip
  module Storage
    module S3

      def after_flush_writes
        # do the normal Paperclip::Attachment after_flush_writes
        super
        # must not have been modified
        return unless instance.created_at == instance.updated_at
        # must have S3 versioning enabled
        return unless s3_bucket.versioning_enabled?
        # the original size must exist
        return unless exists?(:original)
        return unless original = s3_object(:original)
        version_array = original.versions.to_a
        # and there must be exactly two of them
        # (the true original and our modified, sometimes smaller version)
        return if version_array.length != 2
        # delete the first one which is now a duplicate
        version_array.sort_by(&:last_modified).first.delete
      end

    end
  end
end
