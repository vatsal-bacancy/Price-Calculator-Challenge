module PriceCalculatorLib
  PRICING_TABLE = {
    'Milk' => { unit_price: 3.97, sale_quantity: 2, sale_price: 5.00 },
    'Bread' => { unit_price: 2.17, sale_quantity: 3, sale_price: 6.00 },
    'Banana' => { unit_price: 0.99, sale_quantity: nil, sale_price: nil },
    'Apple' => { unit_price: 0.89, sale_quantity: nil, sale_price: nil }
  }.freeze

  def generate_item_hash(item_name, item_quantity)
    item_price = PRICING_TABLE[item_name]
    unit_price = item_price[:unit_price]

    total_price = if item_price[:sale_quantity] && item_quantity >= item_price[:sale_quantity]
                    sale_units = item_quantity / item_price[:sale_quantity]
                    sale_units * item_price[:sale_price] + (item_quantity % item_price[:sale_quantity]) * unit_price
                  else
                    item_quantity * unit_price
                  end

    { item_name => { total_units: item_quantity, total_price: total_price } }
  end

  def calculate_total_price(items)
    unique_items_count = items.tally

    total_unit_price = unique_items_count.sum do |item, count|
      PRICING_TABLE[item][:unit_price] * count
    end

    [unique_items_count.map { |k, v| generate_item_hash(k, v) }.reduce({}, :merge), total_unit_price]
  end
end
