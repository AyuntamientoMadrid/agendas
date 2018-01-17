module StatisticsHelper
  def employee_lobbies_count(lobbies)
    hash_employed = lobbies.map { |l| [l.name, l.represented_entities.count] }.to_h
    hash_employed.select { |_key, amount| amount > 0 }.count
  end

  def self_employed_lobbies_count(lobbies)
    hash_employed = lobbies.map { |i| [i.name, i.represented_entities.count] }.to_h
    hash_employed.select { |_key, amount| amount.zero? }.count
  end
end
