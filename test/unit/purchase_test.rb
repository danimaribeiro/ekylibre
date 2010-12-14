# = Informations
# 
# == License
# 
# Ekylibre - Simple ERP
# Copyright (C) 2009-2010 Brice Texier, Thibaud Merigon
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
# == Table: purchases
#
#  accounted_at        :datetime         
#  amount              :decimal(16, 2)   default(0.0), not null
#  comment             :text             
#  company_id          :integer          not null
#  confirmed_on        :date             
#  created_at          :datetime         not null
#  created_on          :date             
#  creator_id          :integer          
#  currency_id         :integer          
#  delivery_contact_id :integer          
#  id                  :integer          not null, primary key
#  journal_entry_id    :integer          
#  lock_version        :integer          default(0), not null
#  moved_on            :date             
#  number              :string(64)       not null
#  paid_amount         :decimal(16, 2)   default(0.0), not null
#  planned_on          :date             
#  pretax_amount       :decimal(16, 2)   default(0.0), not null
#  reference_number    :string(255)      
#  responsible_id      :integer          
#  state               :string(64)       
#  supplier_id         :integer          not null
#  updated_at          :datetime         not null
#  updater_id          :integer          
#


require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
