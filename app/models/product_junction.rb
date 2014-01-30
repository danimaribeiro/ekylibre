# = Informations
#
# == License
#
# Ekylibre - Simple ERP
# Copyright (C) 2009-2012 Brice Texier, Thibaud Merigon
# Copyright (C) 2012-2014 Brice Texier, David Joulin
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses.
#
# == Table: product_junctions
#
#  created_at      :datetime         not null
#  creator_id      :integer
#  id              :integer          not null, primary key
#  lock_version    :integer          default(0), not null
#  operation_id    :integer
#  originator_id   :integer
#  originator_type :string(255)
#  started_at      :datetime
#  stopped_at      :datetime
#  tool_id         :integer
#  type            :string(255)
#  updated_at      :datetime         not null
#  updater_id      :integer
#
class ProductJunction < Ekylibre::Record::Base
  include Taskable
  belongs_to :tool, class_name: "Product"
  has_many :ways, class_name: "ProductJunctionWay", inverse_of: :junction
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_length_of :originator_type, allow_nil: true, maximum: 255
  #]VALIDATORS]

  class << self

    def has_way(name, *args)
      options = args.extract_options!
      options[:nature] ||= :continuity
      code = ""
      code << "has_one :#{name}_way, -> { where(role: '#{name}') }, class_name: 'ProductJunctionWay', foreign_key: :junction_id, inverse_of: :junction\n"
      code << "has_one :#{name}, through: :#{name}_way, source: :product\n"
      # Needed to build a complete way

      code << "accepts_nested_attributes_for :#{name}_way\n"
      code << "accepts_nested_attributes_for :#{name}\n"
      # unless options[:presence].is_a?(FalseClass)
      #   code << "validates_presence_of :#{name}\n"
      # end

      code << "def self.#{name}_options\n"
      code << "  {nature: :#{options[:nature]}}\n"
      code << "end\n"

      # Shortcut
      # code << "def #{name}\n"
      # code << "  return self.#{name}_way.product if self.#{name}_way\n"
      # code << "end\n"
      # code << "def #{name}=(product)\n"
      # code << "  if self.#{name}_way\n"
      # code << "    self.self.product_way = self.ways{product: product}\n"
      # code << "end\n"
      class_eval(code)
    end

    def has_end(name, *args)
      options = args.extract_options!
      options[:nature] = :end
      has_way(name, *args, options)
    end

    def has_start(name, *args)
      options = args.extract_options!
      options[:nature] = :start
      has_way(name, *args, options)
    end

  end



end