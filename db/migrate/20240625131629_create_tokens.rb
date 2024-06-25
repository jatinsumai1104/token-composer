class CreateTokens < ActiveRecord::Migration[6.1]
  def change
    # drop_table(Token.table_name)
    create_table :tokens, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.boolean :blocked, default: false
      t.timestamp :blocked_at
      t.timestamp :alive_till
      t.boolean :deleted, default: false
      t.timestamps
    end
    add_index(Token.table_name, %w(id blocked), where: '(NOT deleted AND NOT blocked)')
  end
end



