# frozen_string_literal: true

class UuidAsPk < ActiveRecord::Migration[7.1]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')

    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE EXTENSION IF NOT EXISTS "pgcrypto";
          CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
        SQL
      end
    end
  end
end
