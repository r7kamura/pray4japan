ActiveRecord::Schema.define(:version => 0) do
  create_table :poormans_crons, :force => true do |t|
    t.column :id,           :integer
    t.column :name,         :string
    t.column :interval,     :integer
    t.column :in_progress,  :boolean, :default => true
    t.column :performed_at, :datetime
    t.column :wait_time,    :integer
    t.column :async,        :boolean, :default => true
    t.column :lock_version, :integer, :default => 0
  end
end
