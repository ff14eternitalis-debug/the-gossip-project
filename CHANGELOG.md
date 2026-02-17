# Changelog

Toutes les modifications notables du projet sont documentees dans ce fichier.

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
