class UserHelper
  def self.all_users
    Rails.cache.write('my_key', {a: 10, b: 20, c: 30})
    value = Rails.cache.read('my_key')
    p User.all
    p value
  end
end
