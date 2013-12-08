# -*- coding: utf-8 -*-
# == License
# Ekylibre - Simple ERP
# Copyright (C) 2008-2011 Brice Texier, Thibaud Merigon
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
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

class Backend::LandParcelsController < Backend::MattersController

  list() do |t|
    t.column :name, url: true
    t.column :identification_number
    t.column :work_number
    #t.column :description
    #t.column :real_quantity
    #t.column :unit
    #t.column :started_on
    #t.column :stopped_on
    # t.action :divide
    t.action :edit
    t.action :destroy
  end

end