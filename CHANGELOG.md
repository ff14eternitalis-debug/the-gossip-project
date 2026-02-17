# Changelog

Toutes les modifications notables du projet sont documentees dans ce fichier.

## [1.0.0] - 2026-02-17

### Ajoute

- **Phase 6 — Pagination et accueil** : gem `pagy ~> 9.0` (9 items/page, style Bootstrap), troncature du contenu (120 car.), date de publication sur les cards, eager loading (`includes`) pour eviter les requetes N+1
- **Phase 7 — Messagerie privee** : `ConversationsController` (index, show, new, create), inbox avec liste des messages envoyes/recus, vue message avec bouton Repondre, formulaire avec select multiple destinataires, validation `content` sur PrivateMessage, autorisation (expediteur + destinataires), lien Messagerie dans la navbar, bouton "Envoyer un message" sur le profil utilisateur
- **Phase 8 — Tests** : 9 fichiers fixtures, 7 fichiers tests modeles (City, User, Gossip, Tag, Comment, Like, PrivateMessage), 5 fichiers tests controllers (Gossips, Comments, Likes, Conversations, Search), 1 test systeme Capybara (index, show, create gossip) — 82 tests, 123 assertions, 0 failures
- **Phase 9 — Avatars** : Active Storage (`has_one_attached :avatar` sur User), upload dans inscription/edition Devise, `configure_permitted_parameters` dans ApplicationController, helper `user_avatar(user, size:)` avec fallback initiales (pastille Bootstrap), affichage sur profil (64px), index gossips (20px), show gossip (28px), commentaires (22px)
- **Phase 9 — Recherche** : `SearchController#index` avec recherche LIKE multi-modele (gossips par titre/contenu, users par nom/email, tags par titre), page `/search` avec resultats par section, barre de recherche dans la navbar
- **Phase 10.1 — Turbo / Stimulus** : Turbo Frame wrappant la section commentaires (rechargement partiel sans full page reload), Stimulus controller `flash` pour auto-dismiss des alertes apres 3 secondes
- **Phase 10.2 — API JSON** : namespace `/api/v1/`, `Api::V1::BaseController` heritant de `ActionController::API`, endpoints gossips (index + show avec commentaires) et users (index + show avec gossips)
- **Phase 10.3 — Notifications** : table `notifications` (polymorphique, `read` default false), callbacks `after_create_commit` sur Comment, Like et Follow, `NotificationsController` avec marquage lu automatique, page `/notifications` avec affichage par type, badge compteur non-lus dans la navbar
- **Phase 10.4 — Follow / Fil d'actualite** : table `follows` avec index unique + FK vers users, modele Follow avec validation anti-self-follow, `FollowsController` (create/destroy), bouton Follow/Unfollow sur profil utilisateur, compteurs abonnes/abonnements, `FeedController` avec pagination pagy, page `/feed` (potins des utilisateurs suivis), lien "Mon fil" dans la navbar
- **Phase 10.5 — Admin** : colonne `admin` (boolean, default false) sur users, `Admin::BaseController` avec guard `require_admin!`, `Admin::DashboardController` avec stats (users, gossips, commentaires) et derniers enregistrements, page `/admin`, lien Admin dans la navbar (visible admin uniquement)
- **Phase 10.6 — Mailers** : `UserMailer` avec email de bienvenue (`after_create_commit :send_welcome_email`, `deliver_later`) et notification nouveau commentaire, vues HTML dans `app/views/user_mailer/`
- **Phase 10.7 — Images sur gossips** : `has_one_attached :image` sur Gossip, champ file upload dans le formulaire `_form.html.erb` avec preview, affichage sur la page show gossip, `:image` dans strong params

### Corrige

- **Gossip#join_table_gossip_tags** : ajout `dependent: :destroy` pour corriger une erreur FK constraint lors de la suppression d'un gossip ayant des tags

### Modifie

- **Rubocop** : 83 fichiers, 0 offenses
- **Brakeman** : 0 warnings de securite
- **CI** : GitHub Actions deja configuree (scan_ruby, scan_js, lint, test, system-test)
- Suppression du `hello_controller.js` par defaut de Stimulus
- Formulaire commentaire passe de `local: true` a Turbo-compatible (suppression du `local: true`)

## [0.5.0] - 2026-02-16

### Ajoute

- **Phase 4 — Commentaires** : liste sur page gossip, formulaire de creation (connecte), edit/destroy (auteur), compteur de commentaires sur l'index
- **Phase 5 — Tags** : selection multiple a la creation/edition du potin, affichage des tags (show et index), page `/tags/:id` (potins par tag)
- **Phase 5 — Likes** : bouton Like/Unlike sur potins et commentaires, validation unicite (user + likeable), compteurs sur page gossip et index

## [0.4.0] - 2026-02-16

### Ajoute

- **Phase 3 — CRUD gossips** : formulaires new/edit, create, update, destroy ; authentification requise pour les actions d'écriture ; autorisation (auteur seul pour modifier/supprimer)
- **Phase 3** : page ville (`/cities/:id`) avec liste des potins des utilisateurs de la ville
- **Phase 3** : liens vers la ville depuis la page user et la page gossip (avec garde si city nil)

## [0.3.0] - 2026-02-16

### Ajoute

- **Phase 1 — Fondations** : validations sur User, Gossip, Comment, Tag, City
- **Phase 1** : `rescue_from ActiveRecord::RecordNotFound` et page 404 dans `ApplicationController`
- **Phase 1** : partial flash messages (`notice` / `alert`) avec Bootstrap dans le layout
- **Phase 2 — Authentification** : gem Devise, inscription, connexion, déconnexion
- **Phase 2** : vues Devise (sessions, registrations, passwords) stylées Bootstrap
- **Phase 2** : navbar conditionnelle (Connexion/Inscription ou Mon compte/Déconnexion)
- **Phase 2** : ville optionnelle sur User pour inscription minimale (email + mot de passe)

## [0.2.1] - 2026-02-16

### Ajoute

- **Analyse du projet** : fichier `docs/SUGGESTIONS.md` avec toutes les pistes d'amelioration identifiees
  - 6 fonctionnalites manquantes prioritaires (auth, CRUD, commentaires, likes, tags, messagerie)
  - 4 ameliorations techniques (validations, tests, gestion erreurs, pagination)
  - 5 ameliorations UX/UI (formulaires, flash messages, avatars, recherche)
  - 7 fonctionnalites avancees (Turbo/Stimulus, API JSON, notifications, follow, admin, mailers, images)
  - Tableau de priorite avec niveaux de complexite

## [0.2.0] - 2026-02-16

### Ajoute

- **Pages statiques** : page Team (`/team`) et page Contact (`/contact`)
- **Bootstrap 5.3.3** via CDN (CSS + JS) avec theme dark (`data-bs-theme="dark"`)
- **Navbar** responsive dans le layout avec liens Accueil, Team, Contact
- **Landing page personnalisee** : `/welcome/:first_name` affiche un message de bienvenue dynamique
- **Page d'accueil** (`/`) : liste de tous les potins en cards Bootstrap (titre + auteur + lien "Voir plus")
- **Page detail potin** (`/gossips/:id`) : titre, contenu, auteur cliquable, date de creation
- **Page profil utilisateur** (`/users/:id`) : infos personnelles + liste de ses potins
- **Controllers** : `GossipsController` (index, show), `UsersController` (show), `StaticPagesController` (team, contact, welcome)
- **Documentation** dans `docs/`

## [0.1.0] - 2026-02-16

### Ajoute

- Initialisation du projet Rails 8.1.2 (Ruby 3.4.2, SQLite3)
- Import des migrations depuis le projet backend original (9 tables)
- Import des models avec associations :
  - 1-N : City -> Users, User -> Gossips, User -> Comments, User -> Likes
  - N-N : Gossip <-> Tag (via JoinTableGossipTag), PrivateMessage <-> User (via PrivateMessageRecipient)
  - Polymorphique : Comment (commentable: Gossip/Comment), Like (likeable: Gossip/Comment)
- Import du fichier seeds avec donnees Faker
- Gem `faker` ajoutee au Gemfile
