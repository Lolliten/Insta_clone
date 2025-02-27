# InstaClone

InstaClone is a social media application built with Elixir and Phoenix Framework. This README provides step-by-step instructions on how to set up the project from scratch, install dependencies, and get started with different LiveViews.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Setting Up the Database](#setting-up-the-database)
- [Running the Application](#running-the-application)
- [Using LiveViews](#using-liveviews)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- [Elixir](https://elixir-lang.org/install.html) (version 1.12 or later)
- [Erlang](https://www.erlang.org/downloads) (version 24 or later)
- [Node.js](https://nodejs.org/) (version 14 or later)
- [PostgreSQL](https://www.postgresql.org/download/) (version 12 or later)

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/instaclone.git
   cd instaclone

   Or start from scratch:
   mix phx.new <name>
   cd <name>
   ```

2. **Install Elixir dependencies:**

   ```bash
   Fetch and install dependencies? [Yn] Y
    * running mix deps.get
    * running mix assets.setup
    * running mix deps.compile
   ```


## Setting Up the Database

1. **Create and migrate the database:**

   ```bash
   mix ecto.create
   mix ecto.migrate
   ```

2. **Seed the database (optional):**

   If you have a seed file, you can populate your database with initial data:

   ```bash
   mix run priv/repo/seeds.exs
   ```

## Running the Application

1. **Start the Phoenix server:**

   ```bash
   mix phx.server
   ```

2. **Visit the application in your browser:**

   Open your browser and navigate to [http://localhost:4000](http://localhost:4000).

## Using LiveViews

InstaClone utilizes Phoenix LiveView for real-time features. Here are some key LiveViews you can access:

- **Home Page:**
  - Navigate to `/home` to view the feed and create new posts.

- **User Registration:**
  - Navigate to `/users/register` to create a new account.

- **User Login:**
  - Navigate to `/users/log_in` to log into your account.

- **User Settings:**
  - Navigate to `/users/settings` to update your account settings.

### Creating a New Post

1. Click the "Create Post" button on the home page.
2. Fill in the required fields (caption and image).
3. Click "Create Post" to submit.

### Real-Time Updates

The application supports real-time updates for posts. When a new post is created, it will automatically appear in the feed without needing to refresh the page.

## Contributing

Contributions are welcome! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/YourFeature`).
3. Make your changes and commit them (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/YourFeature`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
