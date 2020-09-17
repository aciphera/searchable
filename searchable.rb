# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
  end

  module ClassMethods
    def find_matches(attributes = {})
      where(build_conditions(table_name, attributes).join(' OR '))
    end

    def build_conditions(table_name, attributes = {})
      attributes.map do |column_name, value|
        if value.is_a?(Hash)
          build_conditions(column_name, value)
        else
          "#{table_name}.#{column_name} ILIKE " \
          "'%#{value.try(:gsub, "'", "''")}%'"
        end
      end
    end
  end
end
