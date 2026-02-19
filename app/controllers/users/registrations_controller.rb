class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.persisted? && params.dig(:user, :remember_me) == "1"
        resource.remember_me!
      end
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    resource_updated = update_resource(resource, account_update_params)

    if resource_updated
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
      redirect_to after_update_path_for(resource), notice: "Profil mis à jour avec succès."
    else
      clean_up_passwords resource
      set_minimum_password_length
      render :edit, status: :unprocessable_entity
    end
  end
end
