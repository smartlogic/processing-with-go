class TotalsJob
  @queue = "totals"

  def self.perform(user_id)
    user = User.find(user_id)
    total = user.items.sum(:count)
    user.totals.create(:total => total)
  end
end
