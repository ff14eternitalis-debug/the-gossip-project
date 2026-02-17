module ApplicationHelper
  include Pagy::Frontend

  def user_avatar(user, size: 32)
    if user.avatar.attached?
      image_tag user.avatar, width: size, height: size,
        class: "rounded-circle", style: "object-fit: cover"
    else
      initials = "#{user.first_name&.first}#{user.last_name&.first}".upcase
      content_tag :span, initials,
        class: "rounded-circle d-inline-flex align-items-center justify-content-center bg-secondary text-white fw-bold",
        style: "width: #{size}px; height: #{size}px; font-size: #{size / 2.5}px"
    end
  end
end
