# Architecture & technical concepts

Database schema, relationships, and main technical choices for The Gossip Project.

## Database schema (ERD)

![The Gossip Project](../public/icons/the-gossip-project.svg)

The application uses a relational schema: users, cities, gossips, tags, comments (including comment-on-comment), likes (gossips or comments), private messages, notifications, and follows.

### Entities and attributes

| Table                         | Attributes                                                                                         |
| ----------------------------- | -------------------------------------------------------------------------------------------------- |
| **CITY**                      | `name`, `zip_code` (string)                                                                        |
| **USER**                      | `first_name`, `last_name`, `email` (string), `description` (text), `age` (integer), `city_id` (FK), `admin` (boolean) |
| **GOSSIP**                    | `title` (string), `content` (text), `user_id` (FK) + image (Active Storage)                        |
| **TAG**                       | `title` (string)                                                                                   |
| **JOIN_TABLE_GOSSIP_TAG**     | `gossip_id`, `tag_id` (FK)                                                                         |
| **PRIVATE_MESSAGE**           | `content` (text), `sender_id` (FK → users)                                                        |
| **PRIVATE_MESSAGE_RECIPIENT** | `private_message_id`, `recipient_id` (FK → users)                                                 |
| **COMMENT**                   | `content` (text), `user_id` (FK), `commentable_type`, `commentable_id` (polymorphic)               |
| **LIKE**                      | `user_id` (FK), `likeable_type`, `likeable_id` (polymorphic)                                       |
| **NOTIFICATION**              | `user_id` (FK), `notifiable_type`, `notifiable_id` (polymorphic), `action` (string), `read` (boolean) |
| **FOLLOW**                    | `follower_id`, `followed_id` (FK → users)                                                         |

Rails adds `id` (PK) and `created_at` / `updated_at` to each table.

### Relationships

- **CITY** → 1-N → USER  
- **USER** → 1-N → GOSSIP ; **GOSSIP** → N-1 → USER  
- **GOSSIP** ↔ N-N ↔ TAG via JOIN_TABLE_GOSSIP_TAG  
- **PRIVATE_MESSAGE** → N-1 → USER (sender) ; **PRIVATE_MESSAGE** ↔ N-N ↔ USER (recipients) via PRIVATE_MESSAGE_RECIPIENT  
- **COMMENT** → N-1 → USER ; **COMMENT** → polymorphic → GOSSIP or COMMENT (comment-on-comment)  
- **LIKE** → N-1 → USER ; **LIKE** → polymorphic → GOSSIP or COMMENT  
- **NOTIFICATION** → N-1 → USER ; **NOTIFICATION** → polymorphic → COMMENT, LIKE or FOLLOW  
- **FOLLOW** → N-1 → USER (follower) ; **FOLLOW** → N-1 → USER (followed)

### Model associations (Rails)

- **City**: Users belong to a city.  
- **User**: `has_many` gossips, comments, likes, notifications; sends/receives private messages; followers and following (self-referential via Follow); avatar (Active Storage).  
- **Gossip**: `belongs_to` user; `has_many` tags through `JoinTableGossipTag`; `has_many` comments (as `commentable`) and likes (as `likeable`); optional image (Active Storage).  
- **Tag**: N-N with Gossip via `JoinTableGossipTag`.  
- **PrivateMessage**: `belongs_to` sender (User); `has_many` recipients (User) through `PrivateMessageRecipient`.  
- **Comment**: `belongs_to` user and polymorphic `commentable` (Gossip or Comment); `has_many` sub-comments and likes; creates notification on create.  
- **Like**: `belongs_to` user and polymorphic `likeable` (Gossip or Comment); creates notification on create.  
- **Notification**: `belongs_to` user and polymorphic `notifiable` (Comment, Like, Follow); scopes: `unread`, `recent`.  
- **Follow**: `belongs_to` follower and followed (User); uniqueness and anti-self-follow validations; creates notification on create.

---

## Technical concepts

### ActiveRecord

- **has_many :through**: Gossips–Tags (`JoinTableGossipTag`), PrivateMessages–recipients (`PrivateMessageRecipient`), followers/following (`Follow`).  
- **Polymorphic associations**: `commentable` (Gossip / Comment), `likeable` (Gossip / Comment), `notifiable` (Comment / Like / Follow).  
- **class_name / foreign_key**: Follow (follower/followed), PrivateMessage (sender/recipients).  
- **Self-referential**: Follow with `follower_id` and `followed_id` both referencing users.

### Active Storage

- User avatar (with initials fallback).  
- Optional image on Gossip.

### Hotwire (Turbo & Stimulus)

- Turbo Frame for partial reload of the comments section.  
- Stimulus controller for auto-dismissing flash messages (3s).

### API

- Namespaced JSON API (`Api::V1::*`, `ActionController::API`).  
- Separate from HTML controllers; JSON with nested associations.

### Performance

- Pagy for pagination; `includes` to avoid N+1 on index.

### Notifications

- Polymorphic notifications with `after_create_commit` callbacks; unread badge in navbar.

### Data integrity

- `dependent: :destroy` on associations; seed order and Faker; migrations in dependency order.
