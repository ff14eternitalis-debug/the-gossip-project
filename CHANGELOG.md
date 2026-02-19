# Changelog

Toutes les modifications notables du projet sont documentees dans ce fichier.

## [1.3.0] - 2026-02-19

### Ajoute

- **Documentation correspondance Semaine 4 THP** : `docs/CORRESPONDANCE_SEMAINE_04_THP.md` — analyse point par point et jour par jour (Jour 1 à 5) vs programme THP, plus section bonus hors THP
- **Systeme de cookies "Se souvenir de moi"** : implementation complete via le module Devise `:rememberable` (deja present) :
  - **Connexion** : checkbox "Se souvenir de moi" deja presente sur le formulaire (`sessions/new`) — fonctionnelle avec le cookie Devise
  - **Inscription** : checkbox "Se souvenir de moi" ajoutee au formulaire `registrations/new` ; si cochee, `remember_me!` est appele apres la creation du compte via la surcharge de l'action `create` dans `Users::RegistrationsController`
  - **Duree du cookie** : `config.remember_for = 2.weeks` dans `devise.rb` — le cookie expire automatiquement apres 2 semaines
  - **Deconnexion** : `config.expire_all_remember_me_on_sign_out = true` (deja present) — le cookie est supprime a la deconnexion

### Corrige

- **Tests CI — `GossipsControllerTest`** : `sign_in @alice` ajoute aux tests `show displays gossip` et `show returns 404 for unknown gossip` (l'action `show` requiert desormais une authentification)
- **Tests CI — `GossipsTest` (system)** : `click_on "Create Gossip"` remplace par `click_on "Publier"` pour correspondre au libelle reel du bouton de soumission

### Modifie

- **`configure_permitted_parameters`** : `:remember_me` ajoute aux params autorises pour `:sign_up` dans `ApplicationController`

## [1.2.0] - 2026-02-19

### Ajoute

- **Modale d'ajout de commentaire sur `gossips#show`** : bouton "Commenter" (icone `comment.svg`) ouvre une modale Bootstrap `#commentModal` stylisee (fond `#161b33`, bordure cyan) contenant un textarea et un bouton "Publier" (icone `send.svg`) ; remplace l'ancien formulaire inline sous le potin
- **Affichage des commentaires sur `gossips#show`** : liste des commentaires sous la carte du potin (avatar, nom cliquable, date, contenu), triee par date croissante ; boutons Modifier/Supprimer visibles uniquement pour l'auteur du commentaire
- **Edition de commentaire inline** : clic sur "Modifier" remplace la carte du commentaire par un formulaire inline via Turbo Frame (`dom_id(comment)`) sans redirection ; bordure cyan indique l'etat actif ; "Annuler" restaure le commentaire sans rechargement de page

### Corrige

- **Alignement date/Modifier/Supprimer dans carte commentaire** : `d-inline-flex align-items-center m-0` sur le form genere par `button_to` + `line-height:1` pour aligner correctement les trois elements sur la meme ligne

### Modifie

- **Accessibilite WCAG 2.1 AA** — corrections appliquees sur l'ensemble du site :
  - **Layout** : balise `<main>` englobant le contenu principal ; `aria-controls`, `aria-expanded`, `aria-label="Basculer la navigation"` sur le bouton hamburger ; `<label for="search_q" class="visually-hidden">` + `role="search"` sur la barre de recherche
  - **Flash messages** : `aria-live="polite"` sur les notices, `aria-live="assertive"` sur les alertes, `aria-atomic="true"` sur les deux
  - **Images decoratives** : `alt=""` + `aria-hidden="true"` sur toutes les icones SVG non-informatives (`like.svg`, `comment.svg`, `send.svg`, `follow.svg`, `validate_follow.svg`, `follower.svg`) dans tous les fichiers concernes
  - **Boutons Like/Unlike** : `aria-label` contextualises ("J'aime [titre]" / "Retirer j'aime de [titre]") sur `gossips#index`, `gossips#show`, `cities#show`
  - **Liens "Voir plus"** : `aria-label="Voir plus : [titre du potin]"` sur tous les liens generiques de `gossips#index`, `users#show`, `cities#show`
  - **Compteurs** : `aria-label` avec texte complet ("X commentaire(s)", "X j'aime") sur les spans de comptage
  - **Autocomplete messagerie** : `for="recipient_search"` sur le label Destinataire(s) ; `aria-autocomplete="list"`, `aria-haspopup="listbox"` sur le champ de saisie ; `aria-live="polite"` sur la zone de selection des chips

## [1.1.0] - 2026-02-18

### Ajoute

- **Likes sur index et cities** : boutons Like/Unlike affiches sur la page d'accueil (`gossips#index`) et la page ville (`cities#show`), en plus de la page `gossips#show` deja existante ; compteur de likes ajoute sur `cities#show`
- **Champ ville dans les formulaires Devise** : select `city_id` ajoute aux formulaires d'inscription (`new`) et d'edition de compte (`edit`), liste triee par nom, option vide incluse
- **Modification du profil utilisateur** : bouton "Modifier mon profil" sur la page `users#show` (visible uniquement pour le compte courant), redirigeant vers `edit_user_registration_path`
- **Formulaire d'edition complet** : champs `first_name`, `last_name`, `age`, `description` ajoutes au formulaire `devise/registrations/edit`
- **Champs prenom/nom a l'inscription** : champs `first_name` et `last_name` ajoutes au formulaire `devise/registrations/new`
- **Background etoile anime** : fond noir avec etoiles et scintillement via images CDN (S3), animation `move-background` sur toutes les pages via le layout
- **Fusee decorative** : element CSS pur (rouge/blanc/cyan) positionne en bas a droite, animation `rocketfly` + flamme `fire`, `pointer-events: none`
- **Bouton "Nouveau potin" stylise** : classes `button--primary` + `button--take-off` avec SVG fusee, animation `readyRocket` et `flyRocket` au survol
- **Icones SVG integrees** :
  - `favicon.svg` : favicon du site (remplace `icon.png` / `icon.svg`)
  - `like.svg` : compteur de likes + boutons Like/Unlike sur `gossips#index`, `gossips#show` (potin et commentaires) et `cities#show`
  - `comment.svg` : compteur de commentaires sur `gossips#index`
  - `send.svg` : bouton "Publier" dans le formulaire gossip et bouton "Envoyer" dans la messagerie
  - `follow.svg` : bouton "Suivre" sur le profil utilisateur
  - `validate_follow.svg` : bouton "Ne plus suivre" sur le profil utilisateur
  - `follower.svg` : compteur d'abonnes sur le profil utilisateur

### Corrige

- **`gossips#show` non protege** : ajout de `:show` dans `before_action :authenticate_user!` — un visiteur non connecte est desormais redirige vers la page de connexion
- **Menu burger mobile non refermable** : Bootstrap JS deplace du `<body>` vers le `<head>` pour eviter le double enregistrement des event listeners lors des navigations Turbo
- **Barre de recherche chevauche le burger** : ajout de `mt-2 mt-lg-0` sur le formulaire de recherche pour creer un espacement correct en vue mobile
- **Barre de recherche etire en desktop** : remplacement de `w-100` par une largeur fixe `220px` sur le champ de recherche
- **Erreur `Cannot get a signed_id for a new record`** : ajout de `resource.avatar.attachment.persisted?` dans la condition d'affichage de l'avatar sur le formulaire d'edition Devise
- **Erreur `Missing template devise/registrations/update`** : creation de `Users::RegistrationsController` surchargeant l'action `update` pour faire un `render :edit` propre en cas d'erreur (incompatibilite Devise 5 + gem `responders`)

### Modifie

- **Routes Devise** : `devise_for :users` pointe desormais vers `controllers: { registrations: "users/registrations" }`
- **`CitiesController`** : ajout de `includes(:likes)` pour eviter les requetes N+1 lors de l'affichage des boutons Like sur la page ville
- **Navbar** : `me-3` remplace par `me-lg-3` sur le formulaire de recherche pour un rendu correct sur desktop et mobile
- **`.container` CSS renomme en `.rocket-scene`** pour eviter le conflit avec la classe Bootstrap `.container`
- **Couleurs custom navbar et cards** : navbar `#0a0b1e` et cards `#161b33` via regles CSS `!important` surpassant Bootstrap
- **Couleur bouton \"Nouveau potin\"** : palette changee de vert vers cyan `#00bdf2` (texte/icone `#0a0b1e`) pour coherence avec le theme spatial

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
