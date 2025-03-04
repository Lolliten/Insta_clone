
### The data flow works like this:

- Posts.list_posts() in your mount function queries the database
- The posts are stored in PostgreSQL (through Ecto)
- When a new post is created, it's saved to the database via Posts.save()
- PubSub broadcasts the new post to all connected clients
- The handle_info callback receives the broadcast and updates the stream

### posts.ex:

- It loads posts with their associated users and saves new posts.

### Migrate posts

mix ecto.gen.migration create_posts


mix ecto.reset

This will:
Drop the database
Create it again
Run all migrations