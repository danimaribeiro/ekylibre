# FIXME Not absolute name. Rename to ProductNatureVariantsExchanger (don't forget nomenclature)
class Ekylibre::VariantsExchanger < ActiveExchanger::Base

  # Create or updates variants
  def import
    currency = Preference[:currency] || "EUR"

    s = Roo::OpenOffice.new(file)
    w.count = s.sheets.count

    # file format
    # A "Variant name in DB"
    # B "Variant reference_name CF NOMENCLATURE"
    # C "Variant code in DB"
    # D "Variety CF NOMENCLATURE"
    # E "Derivative CF NOMENCLATURE"
    # F "Purchase pretax amount price"
    # G "Sale pretax amount price"
    # H "Price unity"
    # I "Indicators - HASH"

    s.sheets.each do |sheet_name|
      s.sheet(sheet_name)
      # first line are headers
      2.upto(s.last_row) do |row|
        next if s.cell('A', row).blank?
        r = {:name => s.cell('A', row).blank? ? nil : s.cell('A', row).to_s.strip,
             :variant_reference_name => s.cell('B', row).blank? ? nil : s.cell('B', row).downcase.to_sym,
             :work_number => s.cell('C', row).blank? ? nil : s.cell('C', row).to_s.strip,
             :variety => s.cell('D', row).blank? ? nil : s.cell('D', row).to_s.strip,
             :derivative_of => s.cell('E', row).blank? ? nil : s.cell('E', row).to_s.strip,
             :purchase_unit_pretax_amount => s.cell('F', row).blank? ? nil : s.cell('F', row).to_d,
             :stock_unit_pretax_amount => s.cell('G', row).blank? ? nil : s.cell('G', row).to_d,
             :sale_unit_pretax_amount => s.cell('H', row).blank? ? nil : s.cell('H', row).to_d,
             :price_unity => s.cell('I', row).blank? ? nil : s.cell('I', row).to_s.strip.split(/[\,\.\/\\\(\)]/),
             :indicators => s.cell('J', row).blank? ? {} : s.cell('J', row).to_s.strip.split(/[[:space:]]*\;[[:space:]]*/).collect{|i| i.split(/[[:space:]]*\:[[:space:]]*/)}.inject({}) { |h, i|
               h[i.first.strip.downcase.to_sym] = i.second
               h
             }
            }.to_struct

        if r.variant_reference_name
          # force import variant from reference_nomenclature and update his attributes.
          variant = ProductNatureVariant.import_from_nomenclature(r.variant_reference_name, true)
          # update variant with attributes in the current row
          variant.name = r.name if r.name
          variant.number = r.work_number if r.work_number
          variant.save!


          if r.price_unity
            # Find unit and matching indicator

            default_indicators = {
              mass: :net_mass,
              volume: :net_volume
            }.with_indifferent_access

            unit = r.price_unity.first

            if unit.present? and !Nomen::Units[unit]
              if u = Nomen::Units.find_by(symbol: unit)
                unit = u.name.to_s
                measure_unit_price = Measure.new(1.00, unit.to_sym) if unit
              else
                raise ActiveExchanger::NotWellFormedFileError, "Unknown unit #{unit.inspect} for variant #{variant.name.inspect}."
              end
            end

            unless indicator = (unit.blank? ? :population : r.price_unity.second)
              dimension = Measure.dimension(unit)
              indics = variant.indicators.select do |indicator|
                next unless indicator.datatype == :measure
                Measure.dimension(indicator.unit) == dimension
              end.map(&:name)
              if indics.count > 1
                if indics.include?(default_indicators[dimension].to_s)
                  indicator = default_indicators[dimension]
                else
                  raise ActiveExchanger::NotWellFormedFileError, "Ambiguity on unit #{unit.inspect} for variant #{variant.name.inspect} between #{indics.to_sentence(locale: :eng)}. Cannot known what is wanted, insert indicator name after unit like: '#{unit} (#{indics.first})'."
                end
              elsif indics.empty?
                if unit == "hour"
                  indicator = "working_duration"
                else
                  raise ActiveExchanger::NotWellFormedFileError, "Unit #{unit.inspect} is invalid for variant #{variant.name.inspect}. No indicator can be used with this unit."
                end
              else
                indicator = indics.first
              end
            end
            # Find ratio to store the good price link to existing variant indicator
            variant_default_population = variant.send(indicator.to_sym)
            ratio = (variant_default_population.to_d(unit.to_sym) / measure_unit_price.to_d(unit.to_sym)).to_d
          else
            ratio = 1.0
          end

          # create a purchase price if needed
          if r.purchase_unit_pretax_amount and catalog = Catalog.where(usage: :purchase).first
            variant.catalog_items.create!(catalog: catalog, all_taxes_included: false, amount: (r.purchase_unit_pretax_amount * ratio), currency: currency)
          end


          # create a stock price if needed
          if r.stock_unit_pretax_amount and catalog = Catalog.where(usage: :stock).first and variant.catalog_items.where(catalog_id: catalog.id).empty?
            variant.catalog_items.create!(catalog: catalog, all_taxes_included: false, amount: r.stock_unit_pretax_amount * ratio, currency: currency)
          end
          # create a sale price if needed
          if r.sale_unit_pretax_amount and catalog = Catalog.where(usage: :sale).first and variant.catalog_items.where(catalog_id: catalog.id).empty?
            variant.catalog_items.create!(catalog: catalog, all_taxes_included: false, amount: r.sale_unit_pretax_amount * ratio, currency: currency)
          end

          w.check_point
        else
          w.warn "Need a Variant for #{r.name}"
        end
      end
    end
  end

end
