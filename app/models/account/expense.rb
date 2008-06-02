class Account::Expense < Account::Base
  type_order 2
  type_name '費目'
  short_name '支出'
  connectable_type Account::Income

  def self.types
    []
  end

  # 指定したユーザー、期間の支出合計額（不明金を換算しない）を得る
  def self.raw_sum_of(user_id, start_date, end_date)

    # 支出項目の残高の合計を得る - 月初から月末までのAccountEntryのamount合計を得る。
    AccountEntry.sum(:amount,
      :joins => "inner join accounts on account_entries.account_id = accounts.id inner join deals on deals.id = account_entries.deal_id",
      :conditions => ["account_entries.user_id = ? and accounts.type = 'Expense' and deals.date >= ? and deals.date < ?", user_id, start_date, end_date]
    ) || 0
  end

end
