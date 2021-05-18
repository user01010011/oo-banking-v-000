class Transfer
  attr_reader :sender, :receiver, :amount
  attr_accessor :status
  
  def initialize(sender, receiver, amount)
    @sender = sender
    @receiver = receiver
    @status = "pending"
    @amount = amount
  end 

  def valid?
    sender.bank_account.valid? && receiver.bank_account.valid?
  end

  def execute_transaction
    if valid? && sender.bank_account.balance > amount && self.status == "pending"
      sender.bank_account.balance -= amount
      receiver.bank_account.balance += amount
      self.status = "complete"
    end
  end

  def reverse_transfer
    if valid? && receiver.bank_account.balance > amount && self.status == "complete"
      receiver.bank_account.balance -= amount
      sender.bank_account.balance += amount
      self.status = "reversed"
    else
      reject_transfer
    end
  end

  def reject_transfer
    self.status = "rejected"
    "Transaction rejected. Please check your account balance."
  end
end
