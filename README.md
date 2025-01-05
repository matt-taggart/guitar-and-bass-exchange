# GuitarAndBassExchange

A full stack e-commerce application that allows users to list their instruments for sale. Demonstrates an example of an application that leverages Phoenix LiveView for real-time updates. Not yet feature complete.

## Getting Started

Clone the repo:

`git clone https://github.com/matt-taggart/guitar-and-bass-exchange.git`

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies. This will also seed data to a local postgres database run on a Docker container.
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

Add the necessary environment variables specified in the `.env.example` file. See `Dockerfile` for example on how to build and prep for a production app. If you would like to self-host a Phoenix app with a Postgres instance, I would recommend doing so with Coolify hosted on a Digital Ocean Droplet for a low-cost solution (at least for a dev environment). 

## Built With

* Phoenix - a web framework for the Elixir programming language that gives you peace of mind from development to production.
* Phoenix LiveView - programming model that uses a process that receives events, updates its state, and renders updates to a page as diffs.
* Stripe - A fully integrated suite of financial and payments products.
* Phoenix Auth - https://fly.io/phoenix-files/phx-gen-auth/
* Tailwind CSS - A utility-first CSS framework
* Digital Ocean Spaces - S3-compatible object storage

## Features
* List a guitar, bass, or pedal for sale
* Browse featured guitars on the homepage
* Pay a premium via Stripe widget to be featured. The higher the payment, the better the feature is listed on the homepage

## Demo
Here are some screenshots from the application:

![image](https://github.com/user-attachments/assets/790bc0c9-8743-40c8-a7a7-1fd08cbcf097)

![image](https://github.com/user-attachments/assets/525607ae-c67c-40d6-8ca4-4a6b44415975)

![image](https://github.com/user-attachments/assets/3d169159-eb7e-4cac-b344-f73d8b29d951)

![image](https://github.com/user-attachments/assets/4732b99f-4e23-4927-975e-8e561ac97f80)

![image](https://github.com/user-attachments/assets/f493983a-aa45-4d05-ba83-7f6ff9e72743)

![image](https://github.com/user-attachments/assets/9fcf74c7-9df9-4065-89eb-bd843c9b8f13)

![image](https://github.com/user-attachments/assets/2abd8b01-cb88-4bf7-a384-d1b8ea37303d)

![image](https://github.com/user-attachments/assets/4445d3ab-d524-4d4c-9ded-8140b17cae33)

## Learn more about Phoenix here:

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
