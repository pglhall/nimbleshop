#
# empty spaces should be saved as NULL in database
# before values are saved string values should undergo strip
#
module ActiveRecord
  class Base
    before_validation do |record|
      record.attributes.each do |attr, value|
        record[attr] = value.blank? ? nil : value.strip if value.respond_to?(:strip)
      end
    end
  end
end
