class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\Ahttps?:\/\/www\.[a-zA-Z0-9_\-]+\.com\/[a-zA-Z0-9_\-]+\.(gif|jpg|png)\z/i
      record.errors[attribute] << (options[:message] || "is not an url #{value}")
    end
  end
end