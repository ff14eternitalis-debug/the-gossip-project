module Api
  module V1
    class GossipsController < BaseController
      def index
        gossips = Gossip.includes(:user, :tags).order(created_at: :desc).limit(20)
        render json: gossips.map { |g| gossip_json(g) }
      end

      def show
        gossip = Gossip.includes(:user, :tags, :comments).find(params[:id])
        render json: gossip_json(gossip, details: true)
      end

      private

      def gossip_json(gossip, details: false)
        data = {
          id: gossip.id,
          title: gossip.title,
          content: gossip.content,
          created_at: gossip.created_at,
          author: { id: gossip.user.id, first_name: gossip.user.first_name, last_name: gossip.user.last_name },
          tags: gossip.tags.map { |t| { id: t.id, title: t.title } },
          comments_count: gossip.comments.size,
          likes_count: gossip.likes.size
        }
        if details
          data[:comments] = gossip.comments.includes(:user).map do |c|
            { id: c.id, content: c.content, author: c.user.first_name, created_at: c.created_at }
          end
        end
        data
      end
    end
  end
end
