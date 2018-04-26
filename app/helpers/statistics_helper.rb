module StatisticsHelper
  def employee_lobbies_count(lobbies)
    lobbies.select { |l| l.employee_lobby }.count
  end

  def self_employed_lobbies_count(lobbies)
    lobbies.select { |l| l.self_employed_lobby }.count
  end
end
