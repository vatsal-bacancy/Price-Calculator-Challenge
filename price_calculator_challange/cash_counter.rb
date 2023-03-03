require_relative 'lib/total_price_calculation'

class CashCounter
  include PriceCalculatorLib

  def run
    fetch_purchased_items
    generate_bill
  rescue StandardError => _e
    puts 'Something went Wrong!'
  end

  def fetch_purchased_items
    puts 'Please enter all the items purchased separated by a comma'
    @splitted_items = gets.chomp.split(',').map! { |item| item.strip.capitalize }
  end

  def generate_bill
    result = calculate_total_price @splitted_items

    final_generated_hash = result[0]
    total_unit_price = result[1]

    total_price = final_generated_hash.reduce(0) do |sum, (_item_name, item_data)|
      sum + item_data[:total_price]
    end

    transformed_hash = final_generated_hash.map do |item_name, item_info|
      [item_name, item_info[:total_units], "$#{item_info[:total_price]}"]
    end

    transformed_hash.unshift(%w[Item Quantity Price])

    table = [
      transformed_hash.first.map { |cell| cell.to_s.ljust(10) }.join(' '),
      '------------------------------------'
    ]

    table << transformed_hash.drop(1).map do |row|
      row.map { |cell| cell.to_s.ljust(10) }.join(' ')
    end
    saving = total_unit_price - total_price
    puts "\n#{table.join("\n")}\n"
    puts "\nTotal price : $#{total_price.round(2)}"
    puts "You saved $#{saving.round(2)} today."
  end
end

