require "application_system_test_case"

class GossipsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers

  setup do
    @alice = users(:alice)
  end

  test "visiting the index" do
    visit root_url
    assert_selector "h1", text: "Bienvenue sur The Gossip Project"
  end

  test "viewing a gossip" do
    visit root_url
    click_on "Voir plus", match: :first
    assert_selector "h1"
  end

  test "creating a gossip" do
    sign_in @alice
    visit new_gossip_url

    fill_in "Titre (3 à 14 caractères)", with: "MyGossip"
    fill_in "Contenu", with: "This is a test gossip content."
    click_on "Publier"

    assert_text "Potin créé avec succès"
  end
end
