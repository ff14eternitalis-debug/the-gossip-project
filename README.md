# The Gossip Project (Rails Edition)

[![CI](https://github.com/ff14eternitalis-debug/the-gossip-project/actions/workflows/ci.yml/badge.svg)](https://github.com/ff14eternitalis-debug/the-gossip-project/actions/workflows/ci.yml) [![Dependabot Updates](https://github.com/ff14eternitalis-debug/the-gossip-project/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/ff14eternitalis-debug/the-gossip-project/actions/workflows/dependabot/dependabot-updates) ![Ruby](https://img.shields.io/badge/Ruby-3.4.2-red) ![Rails](https://img.shields.io/badge/Rails-8.1.2-red) ![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3.3-purple) ![Tests](https://img.shields.io/badge/Tests-82_pass-green) ![Rubocop](https://img.shields.io/badge/Rubocop-0_offenses-green) ![Brakeman](https://img.shields.io/badge/Brakeman-0_warnings-green)

Welcome to **The Gossip Project**, a full-stack Rails application created as part of **The Hacking Project (THP)** bootcamp.
The goal of this project is to master **ActiveRecord**, complex database relationships (1-N, N-N, and polymorphic associations), **controllers**, **views** and **Bootstrap** by building a social network where users post gossips, tag them, comment (including comment-on-comment), like, follow each other, and send private messages.

## Features

- **Authentication** (Devise): sign up, sign in, sign out. Navbar shows different links when logged in (Mon compte, Deconnexion) or out (Connexion, Inscription).
- **Home page** (`/`): paginated gossips (9/page via Pagy) in Bootstrap cards with author avatar, truncated content (120 chars), publication date, comment count, like count, tags.
- **Gossip CRUD**: create, read, update, delete gossips with optional image upload (Active Storage). Only the author can edit or delete. Tags can be selected (multiple) on create/edit.
- **Gossip detail page** (`/gossips/:id`): title, content, attached image, author (avatar + link to profile), city link, tags, like/unlike button and count; list of comments (Turbo Frame for partial reload) with author avatar and date; form to add a comment (when logged in).
- **Comments**: nested under gossips; edit/delete for author only; comment-on-comment via polymorphic association.
- **Tags**: select multiple tags when creating or editing a gossip; tags displayed on show and index; page per tag (`/tags/:id`).
- **Likes**: like/unlike on gossips and comments (when logged in); like counts on gossip show and index cards.
- **Avatars** (Active Storage): upload on sign up/edit; fallback to initials badge (Bootstrap). Displayed on profile, gossip cards, gossip detail, and comments.
- **Search** (`/search`): multi-model LIKE search across gossips (title/content), users (name/email), and tags (title). Search bar in the navbar.
- **Pagination** (Pagy ~> 9.0): 9 items per page with Bootstrap-styled navigation. Eager loading (`includes`) to avoid N+1 queries.
- **Private messaging** (`/conversations`): inbox with sent/received messages, message detail with Reply button, new message form with multi-select recipients.
- **Follow system** (`/follows`): follow/unfollow button on user profiles, follower/following counters, anti-self-follow validation.
- **Activity feed** (`/feed`): paginated timeline of gossips from followed users.
- **Notifications** (`/notifications`): real-time badge counter in navbar; auto-generated on new comment, like, or follow; auto-marked as read on view.
- **Admin panel** (`/admin`): dashboard with stats (users, gossips, comments) and latest records. Accessible to admin users only.
- **Mailers**: welcome email on sign up (`deliver_later`), notification email on new comment.
- **Images on gossips** (Active Storage): optional image upload with preview in form, display on gossip show page.
- **Turbo / Stimulus**: Turbo Frame for comments section (partial page reload), Stimulus controller for auto-dismissing flash messages (3s).
- **API JSON** (`/api/v1/`): RESTful endpoints for gossips (index, show with comments) and users (index, show with gossips).
- **City page** (`/cities/:id`): gossips from users in that city.
- **User profile** (`/users/:id`): avatar, personal info, city, follow button, follower/following counts, message button, list of gossips.
- **Team page** (`/team`) and **Contact page** (`/contact`).
- **Dark theme** with Bootstrap 5.3 native dark mode and responsive navbar.

## Prerequisites

- **Ruby** 3.4.2
- **Rails** 8.1.2
- **Gems**: `devise` (authentication), `pagy` (pagination), `faker` (seed data)
- **SQLite3** (development/test)

## Database Architecture

![The Gossip Project](the-gossip-project.svg)

This project implements a relational schema to manage users, cities, gossips, tags, comments (with comment-on-comment), likes (on gossips or comments), private messages, notifications, and follows.

### Entities and Attributes (ERD)

| Table                         | Attributes                                                                                         |
| ----------------------------- | -------------------------------------------------------------------------------------------------- |
| **CITY**                      | `name`, `zip_code` (string)                                                                        |
| **USER**                      | `first_name`, `last_name`, `email` (string), `description` (text), `age` (integer), `city_id` (FK), `admin` (boolean) |
| **GOSSIP**                    | `title` (string), `content` (text), `user_id` (FK) + image (Active Storage)                        |
| **TAG**                       | `title` (string)                                                                                   |
| **JOIN_TABLE_GOSSIP_TAG**     | `gossip_id`, `tag_id` (FK)                                                                         |
| **PRIVATE_MESSAGE**           | `content` (text), `sender_id` (FK -> users)                                                        |
| **PRIVATE_MESSAGE_RECIPIENT** | `private_message_id`, `recipient_id` (FK -> users)                                                 |
| **COMMENT**                   | `content` (text), `user_id` (FK), `commentable_type`, `commentable_id` (polymorphic)               |
| **LIKE**                      | `user_id` (FK), `likeable_type`, `likeable_id` (polymorphic)                                       |
| **NOTIFICATION**              | `user_id` (FK), `notifiable_type`, `notifiable_id` (polymorphic), `action` (string), `read` (boolean) |
| **FOLLOW**                    | `follower_id`, `followed_id` (FK -> users)                                                         |

Rails automatically adds `id` (PK) and `created_at` / `updated_at` to each table.

### Relationships (ERD)

- **CITY** -> 1-N -> USER
- **USER** -> 1-N -> GOSSIP ; **GOSSIP** -> N-1 -> USER
- **GOSSIP** <-> N-N <-> TAG via JOIN_TABLE_GOSSIP_TAG
- **PRIVATE_MESSAGE** -> N-1 -> USER (sender) ; **PRIVATE_MESSAGE** <-> N-N <-> USER (recipients) via PRIVATE_MESSAGE_RECIPIENT
- **COMMENT** -> N-1 -> USER ; **COMMENT** -> polymorphic -> GOSSIP or COMMENT (comment-on-comment)
- **LIKE** -> N-1 -> USER ; **LIKE** -> polymorphic -> GOSSIP or COMMENT
- **NOTIFICATION** -> N-1 -> USER ; **NOTIFICATION** -> polymorphic -> COMMENT, LIKE or FOLLOW
- **FOLLOW** -> N-1 -> USER (follower) ; **FOLLOW** -> N-1 -> USER (followed)

### Model Relationships (code)

- **City**: A central hub. Users belong to a City.
- **User**: Has many gossips, comments, likes, notifications. Sends and receives private messages. Has followers and following (self-referential via Follow). Has avatar (Active Storage).
- **Gossip**: Belongs to a user. Has many tags through `JoinTableGossipTag`. Has many comments (as `commentable`) and likes (as `likeable`). Has optional image (Active Storage).
- **Tag**: N-N with Gossip via `JoinTableGossipTag`.
- **PrivateMessage**: Belongs to sender (User). Has many recipients (User) through `PrivateMessageRecipient`.
- **Comment**: Belongs to user and to `commentable` (polymorphic: Gossip or Comment). Has many sub-comments and likes. Creates notification on create.
- **Like**: Belongs to user and to `likeable` (polymorphic: Gossip or Comment). Creates notification on create.
- **Notification**: Belongs to user and to `notifiable` (polymorphic: Comment, Like, or Follow). Scopes: `unread`, `recent`.
- **Follow**: Belongs to follower and followed (both User). Validates uniqueness and anti-self-follow. Creates notification on create.

## Routes

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
| GET | `/conversations/:id` | `conversations#show` | Message detail with Reply button |
| GET | `/conversations/new` | `conversations#new` | New message form |
| POST | `/conversations` | `conversations#create` | Send message |
| GET | `/users/:id` | `users#show` | User profile (avatar, follow, message) |
| POST | `/follows` | `follows#create` | Follow a user (auth required) |
| DELETE | `/follows/:id` | `follows#destroy` | Unfollow a user (auth required) |
| GET | `/feed` | `feed#index` | Activity feed — gossips from followed users |
| GET | `/notifications` | `notifications#index` | Notifications page (auto-marks as read) |
| GET | `/search` | `search#index` | Search gossips, users, tags |
| GET | `/admin` | `admin/dashboard#index` | Admin dashboard (admin only) |
| GET | `/api/v1/gossips` | `api/v1/gossips#index` | API — list gossips (JSON) |
| GET | `/api/v1/gossips/:id` | `api/v1/gossips#show` | API — gossip detail with comments (JSON) |
| GET | `/api/v1/users` | `api/v1/users#index` | API — list users (JSON) |
| GET | `/api/v1/users/:id` | `api/v1/users#show` | API — user detail with gossips (JSON) |
| GET | `/team` | `static_pages#team` | Team presentation |
| GET | `/contact` | `static_pages#contact` | Contact page |
| GET | `/welcome/:first_name` | `static_pages#welcome` | Personalized landing page |

Devise routes: `/users/sign_in`, `/users/sign_up`, `/users/sign_out`, etc.

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/DevRedious/the-gossip-project.git
   cd the-gossip-project
   ```

2. **Install dependencies**:

   ```bash
   bundle install
   ```

3. **Setup the database**:

   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Seed the database**:

   ```bash
   rails db:seed
   ```

   This will populate your database with 10 cities, 10 users, 20 gossips, 10 tags (each gossip has at least one tag), 15 private messages (with one or more recipients), 20 comments (including comment-on-comment), and 20 likes on gossips or comments, using the Faker gem.

5. **Start the server**:

   ```bash
   rails server
   ```

   Then open `http://localhost:3000` in your browser.

## Testing

```bash
# Run all tests (82 tests, 123 assertions)
bin/rails test

# Run system tests (requires Chrome)
bin/rails test:system

# Linting (0 offenses)
bundle exec rubocop

# Security scan (0 warnings)
bundle exec brakeman --no-pager
```

CI runs automatically via GitHub Actions (scan_ruby, scan_js, lint, test, system-test).

## Usage

### Web Interface

- **Home** (`/`): Browse paginated gossips (9/page). Cards show avatar, title, truncated content, date, comment count, like count, tags. Click "Voir plus" for the full gossip. Logged-in users see "Nouveau potin".
- **Gossip detail** (`/gossips/:id`): Full content, attached image, author (avatar + link to profile), city link, tags, like/unlike and count. Comments section (Turbo Frame) with avatars; form to add a comment when logged in. Author sees "Modifier" and "Supprimer".
- **User profile** (`/users/:id`): Avatar, personal info, city, follower/following counts, Follow/Unfollow button, "Envoyer un message" button, list of gossips.
- **Activity feed** (`/feed`): Timeline of gossips from users you follow, paginated.
- **Notifications** (`/notifications`): Badge counter in navbar; lists comments, likes, and follows. Auto-marked as read on view.
- **Inbox** (`/conversations`): List of sent and received messages; click to view details and reply; new message with multi-select recipients.
- **Search** (`/search`): Search across gossips, users, and tags from the navbar search bar.
- **Admin** (`/admin`): Dashboard with stats and latest records (admin users only, link visible in navbar).
- **City** (`/cities/:id`): Gossips from users in that city.
- **Tag** (`/tags/:id`): Gossips with that tag.
- **Team** (`/team`) and **Contact** (`/contact`).
- **Auth**: Sign up (with optional avatar), sign in, sign out via navbar.

### API JSON

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

### Rails Console

```bash
rails console
```

```ruby
# User's gossips, city, followers
User.first.gossips
User.first.city
User.first.followers
User.first.following

# Gossip's tags (N-N through)
Gossip.first.tags

# PrivateMessage sender and recipients
PrivateMessage.first.sender
PrivateMessage.first.recipients

# Comment-on-comment (polymorphic)
Comment.where(commentable_type: "Comment").first.commentable
Comment.first.comments

# Likes on gossips or comments (polymorphic)
Gossip.first.likes
Comment.first.likes

# Notifications
User.first.notifications.unread
User.first.notifications.recent
```

## Key Concepts Learned

### 1. Advanced ActiveRecord Associations

- **has_many :through**: Used to link Gossips and Tags via `JoinTableGossipTag`, PrivateMessages to multiple recipients via `PrivateMessageRecipient`, and followers/following via `Follow`.
- **Polymorphic associations**: Comments can belong to a Gossip or to another Comment (`commentable`). Likes can belong to a Gossip or a Comment (`likeable`). Notifications can reference a Comment, Like, or Follow (`notifiable`).
- **class_name / foreign_key**: Used on Follow (follower/followed), PrivateMessage (sender/recipients), and related User associations.
- **Self-referential**: Follow model with `follower_id` and `followed_id` both referencing users.

### 2. Active Storage

- Avatar uploads on User (with initials fallback helper).
- Image attachments on Gossip (optional, with preview in form).

### 3. Turbo & Stimulus (Hotwire)

- Turbo Frame for partial page reload of the comments section.
- Stimulus controller for auto-dismissing flash messages.

### 4. API Design

- Namespaced JSON API (`Api::V1::BaseController` inheriting `ActionController::API`).
- Separate from HTML controllers; returns structured JSON with nested associations.

### 5. Pagination & Performance

- Pagy gem for efficient pagination with Bootstrap styling.
- Eager loading (`includes`) to prevent N+1 queries on the index page.

### 6. Notifications & Real-time

- Polymorphic notification system with `after_create_commit` callbacks.
- Unread badge counter in the navbar.

### 7. Testing & Quality

- 82 Minitest tests (model + controller + system) with fixtures.
- Rubocop for code style (0 offenses).
- Brakeman for security analysis (0 warnings).
- GitHub Actions CI pipeline.

### 8. Database Migrations

- Generating tables in dependency order (cities before users, users before gossips, etc.).
- Using `references` with `polymorphic: true` and `foreign_key: { to_table: :users }` for custom foreign keys.

### 9. Data Integrity & Seeding

- Writing a robust `seeds.rb` that respects creation order and uses Faker and `.sample` for realistic, randomized data. Destroying in reverse order to respect foreign keys.
- `dependent: :destroy` on associations to maintain referential integrity.

## Documentation

- [`docs/DOCUMENTATION.md`](docs/DOCUMENTATION.md) — Documentation technique
- [`docs/PLAN_PHASES.md`](docs/PLAN_PHASES.md) — Plan de developpement (10 phases)
- [`docs/SUGGESTIONS.md`](docs/SUGGESTIONS.md) — Pistes d'amelioration
- [`docs/DEPLOI_HEROKU_POSTGRESQL.md`](docs/DEPLOI_HEROKU_POSTGRESQL.md) — Mise en ligne Heroku, PostgreSQL
- [`CHANGELOG.md`](CHANGELOG.md) — Historique des versions
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — Guide pour contribuer
- [`CONTRIBUTORS.md`](CONTRIBUTORS.md) — Contributeurs du projet

### Icons

Favicon and app icon: [`public/icon.svg`](public/icon.svg) (used in the layout). The PWA manifest references `public/icon.png` (512x512). To generate it from the SVG (e.g. with ImageMagick): `convert -background none -resize 512x512 public/icon.svg public/icon.png`. Without `icon.png`, only the SVG favicon is used; PNG is needed for installable PWA icons.

## Related projects (THP BDD)

- [FreeDoc](https://github.com/ValVoy/THP---FreeDoc-Project) — Doctors, patients, appointments, specialties (N-N associations).
- [DogBnB](https://github.com/ff14eternitalis-debug/dogbnb) — Dog rental (relational model).

## Authors

Projet a visee pedagogique (The Hacking Project). Voir [CONTRIBUTORS.md](CONTRIBUTORS.md) pour la liste des contributeurs.

[Morgan](https://github.com/DevRedious), [Romain](https://github.com/ff14eternitalis-debug)

_The Hacking Project 2026_
