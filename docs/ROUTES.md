# Routes reference

Complete list of application routes and API usage.

## Web routes

| Method | URI | Controller#Action | Description |
|--------|-----|-------------------|-------------|
| GET | `/` | `gossips#index` | Home — paginated gossips (9/page) |
| GET | `/gossips/new` | `gossips#new` | New gossip form (auth required) |
| POST | `/gossips` | `gossips#create` | Create gossip (auth required) |
| GET | `/gossips/:id` | `gossips#show` | Gossip detail (comments, likes, tags, image) |
| GET | `/gossips/:id/edit` | `gossips#edit` | Edit gossip form (author only) |
| PATCH/PUT | `/gossips/:id` | `gossips#update` | Update gossip (author only) |
| DELETE | `/gossips/:id` | `gossips#destroy` | Delete gossip (author only) |
| POST | `/gossips/:gossip_id/comments` | `comments#create` | Add comment (auth required) |
| GET | `/comments/:id/edit` | `comments#edit` | Edit comment (author only) |
| PATCH | `/comments/:id` | `comments#update` | Update comment (author only) |
| DELETE | `/comments/:id` | `comments#destroy` | Delete comment (author only) |
| GET | `/cities/:id` | `cities#show` | City page — gossips from users in that city |
| GET | `/tags/:id` | `tags#show` | Tag page — gossips with that tag |
| POST | `/likes` | `likes#create` | Like a gossip or comment (auth required) |
| DELETE | `/likes/:id` | `likes#destroy` | Remove like (auth required) |
| GET | `/conversations` | `conversations#index` | Inbox — sent and received messages |
| GET | `/conversations/:id` | `conversations#show` | Message detail with Reply |
| GET | `/conversations/new` | `conversations#new` | New message form |
| POST | `/conversations` | `conversations#create` | Send message |
| GET | `/users/:id` | `users#show` | User profile (avatar, follow, message) |
| POST | `/follows` | `follows#create` | Follow a user (auth required) |
| DELETE | `/follows/:id` | `follows#destroy` | Unfollow (auth required) |
| GET | `/feed` | `feed#index` | Activity feed — gossips from followed users |
| GET | `/notifications` | `notifications#index` | Notifications (auto-marks as read) |
| GET | `/search` | `search#index` | Search gossips, users, tags |
| GET | `/admin` | `admin/dashboard#index` | Admin dashboard (admin only) |
| GET | `/team` | `static_pages#team` | Team presentation |
| GET | `/contact` | `static_pages#contact` | Contact page |
| GET | `/welcome/:first_name` | `static_pages#welcome` | Personalized landing page |

**Authentication (Devise):** `/users/sign_in`, `/users/sign_up`, `/users/sign_out`, etc.

---

## API (JSON)

| Method | URI | Description |
|--------|-----|-------------|
| GET | `/api/v1/gossips` | List gossips |
| GET | `/api/v1/gossips/:id` | Gossip detail with comments |
| GET | `/api/v1/users` | List users |
| GET | `/api/v1/users/:id` | User detail with gossips |

### Examples

```bash
# List gossips
curl http://localhost:3000/api/v1/gossips

# Gossip detail with comments
curl http://localhost:3000/api/v1/gossips/1

# List users
curl http://localhost:3000/api/v1/users

# User detail with gossips
curl http://localhost:3000/api/v1/users/1
```
