class Token < ApplicationRecord
  default_scope -> { where(deleted: false) }
end
