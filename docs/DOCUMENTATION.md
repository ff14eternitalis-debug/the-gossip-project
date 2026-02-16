# The Gossip Project - Documentation technique

## 1. Presentation du projet

**The Gossip Project** est une application web construite avec Ruby on Rails dans le cadre du bootcamp **The Hacking Project (THP)**. Il s'agit d'un reseau social de potins ou les utilisateurs peuvent publier des gossips, les commenter (y compris des commentaires de commentaires), les liker et s'envoyer des messages prives.

Le projet se decompose en deux phases :
1. **Backend** : conception de la base de donnees, models ActiveRecord et associations avancees (1-N, N-N, polymorphiques)
2. **Frontend** : controllers, vues, integration Bootstrap et navigation

### Auteurs

Morgan, Romain & Valentin - The Hacking Project 2026

---

## 2. Stack technique

| Composant | Version / Detail |
|---|---|
| **Ruby** | 3.4.2 |
| **Rails** | 8.1.2 |
| **Base de donnees** | SQLite3 (via gem `sqlite3 >= 2.1`) |
| **Serveur** | Puma (>= 5.0) |
| **CSS** | Bootstrap 5.3.3 (CDN) avec theme dark |
| **Assets** | Propshaft |
| **JavaScript** | Importmap-rails, Turbo, Stimulus |
| **Seed data** | Faker |

### Gems principales

```ruby
gem "rails", "~> 8.1.2"
gem "propshaft"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "faker"
```

---

## 3. Installation et lancement

### Pre-requis

- Ruby 3.4.2
- Rails 8.1.x
- SQLite3

### Etapes

```bash
# 1. Cloner le repo
git clone <url-du-repo>
cd the-gossip-project

# 2. Installer les dependances
bundle install

# 3. Creer et peupler la base de donnees
rails db:create db:migrate db:seed

# 4. Lancer le serveur
rails server
```

L'application est accessible sur `http://localhost:3000`.

---

## 4. Architecture de la base de donnees

### 4.1. Schema des tables

La base contient **9 tables** gerees par ActiveRecord :

#### cities
| Colonne | Type | Contrainte |
|---|---|---|
| `id` | integer | PK (auto) |
| `name` | string | - |
| `zip_code` | string | - |
| `created_at` | datetime | NOT NULL |
| `updated_at` | datetime | NOT NULL |

#### users
| Colonne | Type | Contrainte |
|---|---|---|
| `id` | integer | PK (auto) |
| `first_name` | string | - |
| `last_name` | string | - |
| `email` | string | - |
| `description` | text | - |
| `age` | integer | - |
| `city_id` | integer | FK -> cities, NOT NULL |
| `created_at` | datetime | NOT NULL |
| `updated_at` | datetime | NOT NULL |

#### gossips
| Colonne | Type | Contrainte |
|---|---|---|
| `id` | integer | PK (auto) |
| `title` | string | - |
| `content` | text | - |
| `user_id` | integer | FK -> users, NOT NULL |
| `created_at` | datetime | NOT NULL |
| `updated_at` | datetime | NOT NULL |

#### tags
| Colonne | Type | Contrainte |
|---|---|---|
| `id` | integer | PK (auto) |
| `title` | string | - |
| `created_at` | datetime | NOT NULL |
| `updated_at` | datetime | NOT NULL |

#### join_table_gossip_tags
| Colonne | Type | Contrainte |
|---|---|---|
| `id` | integer | PK (auto) |
| `gossip_id` | integer | FK -> gossips, NOT NULL |
| `tag_id` | integer | FK -> tags, NOT NULL |
| `created_at` | datetime | NOT NULL |
| `updated_at` | datetime | NOT NULL |

#### private_messages
| Colonne | Type | Contrainte |
|---|---|---|
| `id` | integer | PK (auto) |
| `content` | text | - |
| `sender_id` | integer | FK -> users, NOT NULL |
| `created_at` | datetime | NOT NULL |
| `updated_at` | datetime | NOT NULL |

#### private_message_recipients
| Colonne | Type | Contrainte |
|---|---|---|
| `id` | integer | PK (auto) |
| `private_message_id` | integer | FK -> private_messages, NOT NULL |
| `recipient_id` | integer | FK -> users, NOT NULL |
| `created_at` | datetime | NOT NULL |
| `updated_at` | datetime | NOT NULL |

#### comments (polymorphique)
| Colonne | Type | Contrainte |
|---|---|---|
| `id` | integer | PK (auto) |
| `content` | text | - |
| `user_id` | integer | FK -> users, NOT NULL |
| `commentable_type` | string | NOT NULL (ex: "Gossip", "Comment") |
| `commentable_id` | integer | NOT NULL |
| `created_at` | datetime | NOT NULL |
| `updated_at` | datetime | NOT NULL |

#### likes (polymorphique)
| Colonne | Type | Contrainte |
|---|---|---|
| `id` | integer | PK (auto) |
| `user_id` | integer | FK -> users, NOT NULL |
| `likeable_type` | string | NOT NULL (ex: "Gossip", "Comment") |
| `likeable_id` | integer | NOT NULL |
| `created_at` | datetime | NOT NULL |
| `updated_at` | datetime | NOT NULL |

### 4.2. Diagramme des relations

```
CITY ──1:N──> USER ──1:N──> GOSSIP ──N:N──> TAG
                |               |         (via JoinTableGossipTag)
                |               |
                |               ├── polymorphic ──> COMMENT (commentable)
                |               └── polymorphic ──> LIKE (likeable)
                |
                ├──1:N──> COMMENT ──> sous-commentaires (self-referential)
                |                └── polymorphic ──> LIKE (likeable)
                ├──1:N──> LIKE
                |
                ├── sender ──> PRIVATE_MESSAGE
                └── recipient ──> PRIVATE_MESSAGE (via PrivateMessageRecipient)
```

### 4.3. Foreign keys en base

```ruby
add_foreign_key "comments", "users"
add_foreign_key "gossips", "users"
add_foreign_key "join_table_gossip_tags", "gossips"
add_foreign_key "join_table_gossip_tags", "tags"
add_foreign_key "likes", "users"
add_foreign_key "private_message_recipients", "private_messages"
add_foreign_key "private_message_recipients", "users", column: "recipient_id"
add_foreign_key "private_messages", "users", column: "sender_id"
add_foreign_key "users", "cities"
```

---

## 5. Models et associations ActiveRecord

### 5.1. City

```ruby
class City < ApplicationRecord
  has_many :users
end
```

Une ville possede plusieurs utilisateurs.

### 5.2. User

```ruby
class User < ApplicationRecord
  belongs_to :city
  has_many :gossips
  has_many :comments
  has_many :likes
  has_many :sent_messages, foreign_key: :sender_id, class_name: "PrivateMessage"
  has_many :private_message_recipients, foreign_key: :recipient_id
  has_many :received_messages, through: :private_message_recipients, source: :private_message
end
```

Le model central. Un utilisateur :
- Appartient a une ville
- Peut publier des gossips, des commentaires et des likes
- Peut envoyer des messages prives (`sent_messages`) via `foreign_key: :sender_id`
- Peut recevoir des messages prives (`received_messages`) via la table de jointure `PrivateMessageRecipient`

### 5.3. Gossip

```ruby
class Gossip < ApplicationRecord
  belongs_to :user
  has_many :join_table_gossip_tags
  has_many :tags, through: :join_table_gossip_tags
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
end
```

Un gossip appartient a un utilisateur, possede des tags via une table de jointure N-N, et peut recevoir des commentaires et des likes via des associations polymorphiques. La suppression d'un gossip entraine la suppression en cascade de ses commentaires et likes.

### 5.4. Tag & JoinTableGossipTag

```ruby
class Tag < ApplicationRecord
  has_many :join_table_gossip_tags
  has_many :gossips, through: :join_table_gossip_tags
end

class JoinTableGossipTag < ApplicationRecord
  belongs_to :gossip
  belongs_to :tag
end
```

Association N-N classique via `has_many :through`.

### 5.5. Comment (polymorphique + self-referential)

```ruby
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
end
```

Le champ `commentable` est polymorphique : un commentaire peut etre lie a un **Gossip** (`commentable_type: "Gossip"`) ou a un autre **Comment** (`commentable_type: "Comment"`), ce qui permet le systeme de reponses imbriquees.

### 5.6. Like (polymorphique)

```ruby
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true
end
```

Un like peut porter sur un **Gossip** ou un **Comment** via `likeable_type` / `likeable_id`.

### 5.7. PrivateMessage & PrivateMessageRecipient

```ruby
class PrivateMessage < ApplicationRecord
  belongs_to :sender, class_name: "User"
  has_many :private_message_recipients
  has_many :recipients, through: :private_message_recipients, class_name: "User"
end

class PrivateMessageRecipient < ApplicationRecord
  belongs_to :private_message
  belongs_to :recipient, class_name: "User"
end
```

Un message prive a un seul expediteur (`sender`) et un ou plusieurs destinataires via la table de jointure. L'option `class_name: "User"` est utilisee car les colonnes ne portent pas le nom standard (`sender_id` au lieu de `user_id`).

---

## 6. Routes

Fichier `config/routes.rb` :

```ruby
root 'gossips#index'

resources :gossips, only: [:index, :show]
resources :users, only: [:show]

get '/team', to: 'static_pages#team'
get '/contact', to: 'static_pages#contact'
get '/welcome/:first_name', to: 'static_pages#welcome', as: 'welcome'
```

### Tableau recapitulatif

| Helper | Methode | URI | Action | Description |
|---|---|---|---|---|
| `root_path` | GET | `/` | `gossips#index` | Page d'accueil avec la liste des potins |
| `gossips_path` | GET | `/gossips` | `gossips#index` | Idem (alias) |
| `gossip_path(id)` | GET | `/gossips/:id` | `gossips#show` | Detail d'un potin |
| `user_path(id)` | GET | `/users/:id` | `users#show` | Profil d'un utilisateur |
| `team_path` | GET | `/team` | `static_pages#team` | Page de l'equipe |
| `contact_path` | GET | `/contact` | `static_pages#contact` | Page de contact |
| `welcome_path(first_name:)` | GET | `/welcome/:first_name` | `static_pages#welcome` | Landing page personnalisee |

---

## 7. Controllers

### 7.1. GossipsController

```ruby
class GossipsController < ApplicationController
  def index
    @gossips = Gossip.all
  end

  def show
    @gossip = Gossip.find(params[:id])
  end
end
```

- **index** : recupere tous les gossips pour les afficher sur la page d'accueil
- **show** : recupere un gossip specifique par son `id` (leve `ActiveRecord::RecordNotFound` si non trouve)

### 7.2. UsersController

```ruby
class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
end
```

- **show** : recupere un utilisateur par son `id` pour afficher son profil

### 7.3. StaticPagesController

```ruby
class StaticPagesController < ApplicationController
  def team
  end

  def contact
  end

  def welcome
    @first_name = params[:first_name]
  end
end
```

- **team** : page statique sans donnees
- **contact** : page statique sans donnees
- **welcome** : recupere le `first_name` depuis l'URL pour personnaliser le message d'accueil

---

## 8. Vues

### 8.1. Layout (`app/views/layouts/application.html.erb`)

Le layout global contient :
- **Bootstrap 5.3.3** charge via CDN (CSS dans `<head>`, JS avant `</body>`)
- **Theme dark** active via `<html data-bs-theme="dark">`
- **Navbar** responsive avec :
  - Brand "The Gossip Project" (lien vers l'accueil)
  - Liens Accueil, Team, Contact (alignes a droite)
  - Toggler hamburger pour mobile
- Zone `<%= yield %>` pour le contenu de chaque page

### 8.2. Gossips

#### index.html.erb - Page d'accueil
- Message de bienvenue
- Grille de **cards Bootstrap** (3 colonnes sur desktop) pour chaque gossip :
  - Titre du gossip
  - Prenom de l'auteur
  - Bouton "Voir plus" vers la page detail

#### show.html.erb - Detail d'un potin
- Titre en `<h1>`
- Auteur (prenom cliquable vers son profil via `user_path`) + date formatee `dd/mm/yyyy a HHhMM`
- Contenu dans une card
- Bouton "Retour aux potins"

### 8.3. Users

#### show.html.erb - Profil utilisateur
- Prenom + nom en titre
- Card avec informations : email, age, ville, description
- Section "Ses potins" : grille de cards avec les gossips de l'utilisateur (ou message si aucun)
- Bouton "Retour aux potins"

### 8.4. Static Pages

#### team.html.erb
- Titre + description
- Cards pour chaque membre de l'equipe (Morgan, Romain)

#### contact.html.erb
- Titre + description
- Liste des coordonnees : email, Twitter, adresse

#### welcome.html.erb
- Message "BIENVENUE {prenom} !" centre
- Description du site
- Bouton "Voir les potins" vers l'accueil

---

## 9. Donnees de seed

Le fichier `db/seeds.rb` utilise la gem **Faker** pour generer des donnees realistes. L'ordre de creation respecte les dependances de foreign keys :

| Ordre | Entite | Quantite | Detail |
|---|---|---|---|
| 1 | Cities | 10 | Nom + code postal aleatoires |
| 2 | Users | 10 | Prenom, nom, email, age (18-70), description, ville aleatoire |
| 3 | Gossips | 20 | Titre (3 mots), contenu (4 phrases), auteur aleatoire |
| 4 | Tags | 10 | Mot prefixe d'un `#` |
| 5 | GossipTag | variable | Chaque gossip recoit 1 a 3 tags |
| 6 | PrivateMessages | 15 | Contenu + expediteur aleatoire + 1 a 3 destinataires |
| 7 | Comments | 20 | 12 sur des gossips + 8 sur des commentaires existants |
| 8 | Likes | 20 | Sur des gossips ou commentaires, avec unicite user+likeable |

Le nettoyage (`destroy_all`) se fait en ordre inverse pour respecter les foreign keys.

---

## 10. Arborescence des fichiers cles

```
the-gossip-project/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── gossips_controller.rb          # index, show
│   │   ├── users_controller.rb            # show
│   │   └── static_pages_controller.rb     # team, contact, welcome
│   ├── models/
│   │   ├── application_record.rb
│   │   ├── city.rb
│   │   ├── user.rb
│   │   ├── gossip.rb
│   │   ├── tag.rb
│   │   ├── join_table_gossip_tag.rb
│   │   ├── comment.rb
│   │   ├── like.rb
│   │   ├── private_message.rb
│   │   └── private_message_recipient.rb
│   └── views/
│       ├── layouts/
│       │   └── application.html.erb       # Bootstrap CDN + navbar dark
│       ├── gossips/
│       │   ├── index.html.erb             # Cards des potins
│       │   └── show.html.erb              # Detail potin + lien auteur
│       ├── users/
│       │   └── show.html.erb              # Profil utilisateur
│       └── static_pages/
│           ├── team.html.erb
│           ├── contact.html.erb
│           └── welcome.html.erb
├── config/
│   └── routes.rb
├── db/
│   ├── migrate/                           # 9 fichiers de migration
│   ├── schema.rb
│   └── seeds.rb
├── docs/
│   ├── DOCUMENTATION.md                   # Ce fichier
│   └── CHANGELOG.md
├── Gemfile
└── PLAN.md
```
