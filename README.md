# The Gossip Project (Rails Edition)

[![CI](https://github.com/ff14eternitalis-debug/the-gossip-project/actions/workflows/ci.yml/badge.svg)](https://github.com/ff14eternitalis-debug/the-gossip-project/actions/workflows/ci.yml) [![Dependabot](https://github.com/ff14eternitalis-debug/the-gossip-project/actions/workflows/dependabot/dependabot-updates/badge.svg)](https://github.com/ff14eternitalis-debug/the-gossip-project/actions/workflows/dependabot/dependabot-updates) ![Ruby](https://img.shields.io/badge/Ruby-3.4.2-red) ![Rails](https://img.shields.io/badge/Rails-8.1.2-red) ![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3.3-purple) ![Tests](https://img.shields.io/badge/Tests-82_pass-green) ![Rubocop](https://img.shields.io/badge/Rubocop-0_offenses-green) ![Brakeman](https://img.shields.io/badge/Brakeman-0_warnings-green)

Full-stack Rails social network built for [The Hacking Project](https://www.thehackingproject.org/) (THP): users post gossips, tag them, comment (including nested comments), like, follow each other, and send private messages.

**Stack:** Ruby 3.4, Rails 8.1, SQLite3, Devise, Bootstrap 5, Turbo/Stimulus, Pagy, Active Storage.

---

## Features

| Area | Features |
|------|----------|
| **Auth** | Sign up / sign in / sign out (Devise). Navbar adapts to logged-in state. |
| **Gossips** | CRUD with optional image; tags (multi-select); only author can edit/delete. |
| **Comments** | Nested under gossips; comment-on-comment (polymorphic); edit/delete for author. |
| **Likes** | Like/unlike gossips and comments; counts on cards and detail page. |
| **Users** | Profile (avatar, city, bio); follow/unfollow; follower/following counts. |
| **Messaging** | Inbox, thread view, new message with multi-select recipients. |
| **Feed & notifs** | Activity feed from followed users; notification badge and list (comment, like, follow). |
| **Other** | Search (gossips, users, tags); city and tag pages; admin dashboard; JSON API; dark theme. |

---

## Prerequisites

- Ruby 3.4.2, Rails 8.1.2  
- SQLite3 (dev/test)  
- Gems: `devise`, `pagy`, `faker` (see Gemfile)

---

## Database (overview)

Relational schema: **users**, **cities**, **gossips**, **tags** (N-N), **comments** (polymorphic: gossip or comment), **likes** (polymorphic), **private_messages** + recipients, **notifications** (polymorphic), **follows** (self-referential).

![Schema](public/icons/the-gossip-project.svg)

Full ERD, table list, and associations: **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)**.

---

## Routes (summary)

Main resources: `gossips` (nested `comments`), `users`, `cities`, `tags`, `likes`, `conversations`, `follows`, `notifications`, `feed`, `search`, `admin`. Devise handles `/users/sign_in`, `/users/sign_up`, `/users/sign_out`. Static: `/team`, `/contact`, `/welcome/:first_name`.

Full route table and API examples: **[docs/ROUTES.md](docs/ROUTES.md)**.

---

## Installation

```bash
git clone https://github.com/DevRedious/the-gossip-project.git
cd the-gossip-project
bundle install
rails db:create db:migrate db:seed
rails server
```

Open **http://localhost:3000**. Seed creates cities, users, gossips, tags, messages, comments, and likes (Faker).

---

## Testing & quality

```bash
bin/rails test          # 82 tests
bin/rails test:system   # system tests (Chrome)
bundle exec rubocop     # lint
bundle exec brakeman --no-pager  # security
```

CI runs via GitHub Actions (lint, test, system tests).

---

## Usage (quick)

- **Home** (`/`): paginated gossips; “See more” for full post; “New gossip” when logged in.  
- **Gossip** (`/gossips/:id`): content, image, author, city, tags, like/unlike, comments (Turbo Frame), add comment.  
- **Profile** (`/users/:id`): avatar, info, follow button, message, list of gossips.  
- **Feed** (`/feed`), **Notifications** (navbar), **Inbox** (`/conversations`), **Search** (navbar), **Admin** (`/admin` for admins).

**API:** `GET /api/v1/gossips`, `/api/v1/gossips/:id`, `/api/v1/users`, `/api/v1/users/:id` — see [docs/ROUTES.md](docs/ROUTES.md).

---

## Documentation

| Document | Description |
|----------|-------------|
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Database schema, relationships, technical concepts |
| [docs/ROUTES.md](docs/ROUTES.md) | Full route table and API examples |
| [docs/DOCUMENTATION.md](docs/DOCUMENTATION.md) | Technical documentation (French) |
| [docs/PLAN_PHASES.md](docs/PLAN_PHASES.md) | Development plan |
| [docs/SUGGESTIONS.md](docs/SUGGESTIONS.md) | Improvement ideas |
| [docs/DEPLOI_HEROKU_POSTGRESQL.md](docs/DEPLOI_HEROKU_POSTGRESQL.md) | Deployment (Heroku, PostgreSQL) |
| [CHANGELOG.md](CHANGELOG.md) | Version history |
| [CONTRIBUTING.md](CONTRIBUTING.md) | How to contribute |
| [CONTRIBUTORS.md](CONTRIBUTORS.md) | Contributors |

**Icons:** Favicon and PWA icon in `public/icons/` (`icon.svg`, `favicon.svg`). For installable PWA, generate `public/icons/icon.png` (e.g. 512×512) from `icon.svg`.

---

## Related projects (THP)

- [FreeDoc](https://github.com/ValVoy/THP---FreeDoc-Project) — Doctors, patients, appointments (N-N).  
- [DogBnB](https://github.com/ff14eternitalis-debug/dogbnb) — Dog rental (relational model).

---

## Authors

Educational project (The Hacking Project). See [CONTRIBUTORS.md](CONTRIBUTORS.md) for the full list.

[Morgan](https://github.com/DevRedious), [Romain](https://github.com/ff14eternitalis-debug) — _The Hacking Project 2026_
