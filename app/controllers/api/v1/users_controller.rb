module Api
  module V1
    class UsersController < BaseController
      def index
        users = User.includes(:city).order(:first_name).limit(20)
        render json: users.map { |u| user_json(u) }
      end

      def show
        user = User.includes(:city, :gossips).find(params[:id])
        render json: user_json(user, details: true)
      end

      private

      def user_json(user, details: false)
        data = {
          id: user.id,
          first_name: user.first_name,
          last_name: user.last_name,
          city: user.city&.name,
          gossips_count: user.gossips.size
        }
        if details
          data[:email] = user.email
          data[:age] = user.age
          data[:description] = user.description
          data[:gossips] = user.gossips.map { |g| { id: g.id, title: g.title } }
        end
        data
      end
    end
  end
end
