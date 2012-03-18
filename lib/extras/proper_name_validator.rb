class ProperNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[a-zA-Z\'\-\x20]+\z/
      record.errors[attribute] << (options[:message] || "is not a proper name format")
    end
  end
end
