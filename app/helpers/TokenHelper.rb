class TokenHelper
  def generate_token
    token = Token.create({alive_till: Time.zone.now + 1.minutes})
    self.class.delay_for(1.minutes).auto_delete_key(token.id, token.alive_till.to_s)
    "Token Generated Successfully!"
  end

  # We can sync this method so that no two user can access the same token
  def fetch_random_token
    token = Token.where(blocked: false).first
    raise ::ActiveRecord::RecordNotFound if token.blank?
    token.update_columns(blocked: true, blocked_at: Time.zone.now)
    self.class.delay_for(30.seconds).unblock_key(token.id)
    # To sync the block, I apply redis lock on token id and inside block we first check if blocked is still false
    {keyId: token.id}
  end

  def get_token(id)
    token = Token.find(id)
    {"isBlocked" => token.blocked, "Blocked At": token.blocked_at, createdAt: token.created_at}
  end

  def delete_token(id)
    token = Token.find(id)
    token.update_columns(deleted: true)
    "Token #{id} Deleted Successfully!"
  end

  def unblock_token(id)
    token = Token.find(id)
    token.update_columns(blocked: false, blocked_at: nil)
    "Token #{id} Unblocked Successfully!"
  end

  def update_alive_till(id)
    token = Token.find(id)
    token.update_columns(alive_till: Time.zone.now + 1.minutes)
    self.class.delay_for(1.minutes).auto_delete_key(token.id, token.alive_till.to_s)
    "Token #{id} alive till is updated. It will be alive for next 5 minute"
  end

  def self.unblock_key(id)
    Rails.logger.info("Unblocking key: #{id}")
    new.unblock_token(id)
  end

  def self.auto_delete_key(id, alive_till)
    Rails.logger.info("Auto deleting key: #{id}")
    new.auto_delete_key(id, alive_till)
  end

  def auto_unblock_key(id)
    token = Token.where(id: id).last
    token.update_columns(blocked: false, blocked_at: nil)
  end

  def auto_delete_key(id, alive_till)
    token = Token.where(id: id).last
    return if token.blank? || Time.zone.parse(alive_till) != Time.zone.parse(token.alive_till.to_s)
    token.update_columns(deleted: true)
    Rails.logger.info("Token Deleted: #{id}")
  end
end
