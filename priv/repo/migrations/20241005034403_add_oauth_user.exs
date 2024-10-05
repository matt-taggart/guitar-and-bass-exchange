defmodule GuitarAndBassExchange.Repo.Migrations.AddOauthUser do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :is_oauth_user, :boolean, default: false
      modify :hashed_password, :string, null: true
    end
  end

  def down do
    alter table(:users) do
      remove :is_oauth_user
      modify :hashed_password, :string, null: false
    end
  end
end
