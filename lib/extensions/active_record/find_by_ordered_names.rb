# NOTE: don't include a frozen string literal comment here
# Taken from
# https://www.justinweiss.com/articles/how-to-select-database-records-in-an-arbitrary-order/
module Extensions
  module ActiveRecord
    module FindByOrderedNames
      extend ActiveSupport::Concern

      module ClassMethods
        def find_ordered_names(names:)
          order_clause = "CASE name "
          names.each_with_index do |name, index|
            order_clause << sanitize_sql_array(["WHEN ? THEN ? ", name, index])
          end
          order_clause << sanitize_sql_array(["ELSE ? END", names.length])
          order(Arel.sql(order_clause))
        end
      end
    end
  end
end

ActiveRecord::Base.include(Extensions::ActiveRecord::FindByOrderedNames)
