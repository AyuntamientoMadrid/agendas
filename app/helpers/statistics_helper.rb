module StatisticsHelper
  def self_employed(value)
    hash_employed = Organization.lobby.map { |i| [i.name, i.represented_entities.count] }.to_h
    ret = if value
            hash_employed.select { |_key, amount| amount > 0 }
          else
            hash_employed.select { |_key, amount| amount.zero? }
          end
    ret
  end
end
