# Suggestions d'ameliorations - The Gossip Project

> Analyse realisee le 16/02/2026 sur la base de la v0.2.0

---

## Etat actuel du projet

Le projet dispose d'une base solide :
- Schema de BDD complet (9 tables, relations 1-N, N-N, polymorphiques)
- Models ActiveRecord fonctionnels
- Lecture seule (index, show) pour Gossips et Users
- Pages statiques (Team, Contact, Welcome)
- Bootstrap 5.3.3 dark theme + navbar responsive

---

## 1. Fonctionnalites manquantes prioritaires

### 1.1 Authentification utilisateur
- **Quoi** : Inscription, connexion, deconnexion
- **Comment** : Gem `devise` ou `bcrypt` + sessions manuelles (le champ `bcrypt` est deja commente dans le Gemfile)
- **Impact** : Prerequis pour toute action d'ecriture (creer un potin, commenter, liker)

### 1.2 CRUD complet sur les Gossips
- **Quoi** : Creer, modifier, supprimer un potin
- **Manque** : Actions `new`, `create`, `edit`, `update`, `destroy` dans `GossipsController`
- **Vues** : Formulaires `_form.html.erb`, `new.html.erb`, `edit.html.erb`
- **Routes** : Passer de `resources :gossips, only: [:index, :show]` a `resources :gossips`

### 1.3 Affichage des commentaires
- **Quoi** : Le modele `Comment` existe avec l'association polymorphique, mais aucune vue ne les affiche
- **Ou** : Sur la page `gossips#show`, afficher les commentaires + formulaire pour en ajouter
- **Bonus** : Commentaires imbriques (reponses a des commentaires, deja supporte par le modele)

### 1.4 Systeme de Likes
- **Quoi** : Le modele `Like` existe (polymorphique), mais aucune interaction en front
- **Comment** : Bouton like/unlike sur les gossips et commentaires
- **Bonus** : Afficher le compteur de likes sur les cards de la page d'accueil

### 1.5 Tags et filtrage
- **Quoi** : La table `tags` et `join_table_gossip_tags` existent mais ne sont pas exploitees
- **Comment** : Afficher les tags sur chaque gossip, page `/tags/:id` pour voir les gossips par tag
- **Bonus** : Barre de recherche / filtrage par tag sur la page d'accueil

### 1.6 Messagerie privee (UI)
- **Quoi** : Les modeles `PrivateMessage` et `PrivateMessageRecipient` existent sans aucune vue
- **Comment** : Inbox, conversation, formulaire d'envoi
- **Bonus** : Notifications de nouveaux messages

---

## 2. Ameliorations techniques

### 2.1 Validations des modeles
- Aucune validation n'existe actuellement sur les modeles
- A ajouter :
  - `User` : presence et unicite de l'email, format email, age > 0
  - `Gossip` : presence du titre et du contenu, longueur min/max
  - `Comment` : presence du contenu
  - `Tag` : presence et unicite du titre
  - `City` : presence du nom, format du code postal

### 2.2 Tests
- Le dossier `test/` est vide (uniquement des fichiers `.keep`)
- A ecrire :
  - **Tests modeles** : Validations, associations, scopes
  - **Tests controllers** : Reponses HTTP, assignation de variables
  - **Tests systeme** (Capybara) : Parcours utilisateur complet
  - **Tests d'integration** : Flux multi-pages

### 2.3 Gestion des erreurs
- Pas de pages d'erreur personnalisees (404, 500)
- Pas de gestion des cas `record not found` dans les controllers
- Ajouter `rescue_from ActiveRecord::RecordNotFound` dans `ApplicationController`

### 2.4 Pagination
- La page d'accueil charge TOUS les gossips en une seule requete
- Gem `pagy` ou `kaminari` pour paginer les resultats

---

## 3. Ameliorations UX/UI

### 3.1 Formulaires
- Aucun formulaire n'existe dans l'application
- Necessaires pour : creation de potin, commentaires, inscription, connexion, messages prives
- Utiliser les composants Bootstrap (form-control, form-floating, alerts pour les erreurs)

### 3.2 Flash messages
- Aucun message flash n'est affiche dans le layout
- Ajouter dans `application.html.erb` un partial pour les notices/alertes Bootstrap

### 3.3 Avatars utilisateurs
- Pas de photo de profil
- Option : Active Storage (deja disponible dans Rails 8) ou Gravatar via email

### 3.4 Amelioration de la page d'accueil
- Afficher un apercu du contenu (troncature) sur les cards
- Ajouter la date de publication
- Afficher le nombre de commentaires et likes
- Trier par date (plus recent en premier)

### 3.5 Recherche
- Pas de fonctionnalite de recherche
- Recherche par titre/contenu de gossip, par nom d'utilisateur, par tag

---

## 4. Fonctionnalites avancees (bonus)

### 4.1 Temps reel avec Turbo/Stimulus
- Turbo et Stimulus sont deja dans le Gemfile mais non utilises
- **Turbo Frames** : Mise a jour partielle des pages (ex: ajouter un commentaire sans recharger)
- **Turbo Streams** : Notifications en temps reel, nouveau gossip qui apparait live
- **Stimulus** : Interactions JS (toggle like, preview du contenu, compteur de caracteres)

### 4.2 API JSON
- `jbuilder` est dans le Gemfile mais aucune vue JSON n'existe
- Creer des endpoints API (`/api/v1/gossips.json`, etc.)
- Permettrait une future app mobile ou un frontend JS separe

### 4.3 Systeme de notifications
- Notifier un utilisateur quand quelqu'un commente son gossip ou le like
- Table `notifications` avec polymorphisme

### 4.4 Systeme de follow/abonnement
- Suivre d'autres utilisateurs
- Fil d'actualite personnalise (gossips des utilisateurs suivis)
- Nouvelle table `follows` (follower_id, followed_id)

### 4.5 Roles et administration
- Role admin pour moderer les gossips et commentaires
- Dashboard admin (stats, gestion des utilisateurs)
- Gem `pundit` ou `cancancan` pour les autorisations

### 4.6 Mailers
- Email de bienvenue a l'inscription
- Notification par email (nouveau commentaire, nouveau message prive)
- Action Mailer est disponible nativement dans Rails

### 4.7 Upload d'images
- Ajouter des images aux gossips
- Active Storage est deja configure dans Rails 8
- `image_processing` est deja dans le Gemfile

---

## 5. DevOps et qualite de code

| Element | Etat actuel | Suggestion |
|---------|-------------|------------|
| Tests | Aucun | Ecrire tests modeles + controllers + systeme |
| CI/CD | `.github/workflows/` vide | Ajouter un workflow GitHub Actions (tests + lint) |
| Linter | `rubocop` present dans Gemfile | Executer et corriger les offenses |
| Securite | `brakeman` present dans Gemfile | Executer un scan de securite |
| Docker | Dockerfile present | Tester le build et le deploiement |
| Seeds | Fonctionnels avec Faker | Ajouter plus de variete et de volume |

---

## 6. Ordre de priorite recommande

| Priorite | Tache | Complexite |
|----------|-------|------------|
| 1 | Validations des modeles | Faible |
| 2 | Authentification (devise ou bcrypt) | Moyenne |
| 3 | CRUD Gossips (new, create, edit, destroy) | Moyenne |
| 4 | Flash messages dans le layout | Faible |
| 5 | Affichage + creation de commentaires | Moyenne |
| 6 | Systeme de likes (bouton + compteur) | Moyenne |
| 7 | Affichage et filtrage par tags | Faible |
| 8 | Gestion des erreurs (404, 500) | Faible |
| 9 | Messagerie privee (UI) | Elevee |
| 10 | Pagination | Faible |
| 11 | Tests | Moyenne |
| 12 | Turbo/Stimulus (temps reel) | Elevee |
| 13 | Systeme de follow | Elevee |
| 14 | API JSON | Moyenne |
| 15 | Notifications | Elevee |
