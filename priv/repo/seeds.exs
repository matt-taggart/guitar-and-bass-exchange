# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GuitarAndBassExchange.Repo.insert!(%GuitarAndBassExchange.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Faker.start()

alias GuitarAndBassExchange.Chat.Room
alias GuitarAndBassExchange.Chat
alias GuitarAndBassExchange.Accounts
alias GuitarAndBassExchange.Post
alias GuitarAndBassExchange.Repo

# Create rooms
{:ok, weekend_room} =
  Repo.insert(%Room{name: "weekend-plans", description: "Let's plan for the weekend!"})

{:ok, sre_room} = Repo.insert(%Room{name: "sre-team", description: "The SRE team's channel"})

# Create some users
users =
  for _n <- 1..10 do
    name = Faker.Person.first_name()
    email = "#{String.downcase(name)}@streamchat.io"
    {:ok, user} = Accounts.register_user(%{email: email, password: "passw0rd!passw0rd!"})
    user
  end

# Create messages
for _n <- 1..100 do
  Chat.create_message(%{
    content: Faker.Lorem.sentence(),
    room_id: Enum.random([weekend_room.id, sre_room.id]),
    sender_id: Enum.random(users).id
  })
end

# Extended list of guitar/bass brands
brands = [
  "Fender",
  "Gibson",
  "Ibanez",
  "Yamaha",
  "Epiphone",
  "PRS",
  "Rickenbacker",
  "Gretsch",
  "Jackson",
  "ESP",
  "Schecter",
  "Squier",
  "Martin",
  "Taylor",
  "Guild",
  "Washburn",
  "Dean",
  "B.C. Rich",
  "Ernie Ball Music Man",
  "G&L",
  "Danelectro",
  "Godin",
  "Suhr",
  "Charvel",
  "EVH",
  "Reverend",
  "Alvarez",
  "Cort",
  "Takamine",
  "Ovation",
  "Lakland",
  "Spector",
  "Warwick",
  "Hofner",
  "Sandberg",
  "Dingwall",
  "Fodera",
  "Sadowsky",
  "Alembic",
  "Strandberg",
  "Kiesel",
  "Caparison",
  "Mayones",
  "Ormsby",
  "Eastman",
  "Chapman",
  "Sterling by Music Man"
]

# List of colors
colors = [
  "Black",
  "White",
  "Sunburst",
  "Red",
  "Blue",
  "Green",
  "Yellow",
  "Natural",
  "Purple",
  "Orange"
]

# List of conditions
conditions = ["Mint", "Excellent", "Very Good", "Good", "Fair", "Poor"]

# List of countries
countries = [
  "USA",
  "Japan",
  "Mexico",
  "China",
  "Indonesia",
  "Korea",
  "Germany",
  "Canada",
  "Czech Republic",
  "Vietnam"
]

# Create 100 posts
for _ <- 1..100 do
  shipping = Faker.random_between(0, 1) == 1
  status = Enum.random([:draft, :completed])
  current_step = if status == :completed, do: 3, else: Faker.random_between(1, 2)

  post_params = %{
    title: "#{Enum.random(brands)} #{Faker.Commerce.product_name()}",
    brand: Enum.random(brands),
    model: Faker.Commerce.product_name(),
    year: Faker.random_between(1950, 2023),
    color: Enum.random(colors),
    country_built: Enum.random(countries),
    number_of_strings: Faker.random_between(4, 8),
    condition: Enum.random(conditions),
    description: Faker.Lorem.paragraph(),
    shipping: shipping,
    shipping_cost: if(shipping, do: Faker.Commerce.price(), else: 0.0),
    price: Faker.Commerce.price(),
    status: status,
    current_step: current_step,
    user_id: Enum.random(users).id,
    featured: Faker.random_between(0, 1) == 1
  }

  %Post{}
  |> Post.changeset(post_params)
  |> Repo.insert!()
end

IO.puts("Seeding completed: 100 posts have been created.")
