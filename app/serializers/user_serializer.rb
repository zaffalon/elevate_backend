class UserSerializer < ApplicationSerializer
  attributes :id, :email, :username, :full_name

  attribute :stats, if: Proc.new { |object, params| params[:include_stats] } do |object, params|
    Rails.cache.fetch([object, "stats"], expires_in: 5.minutes) do
      StatsSerializer.new(object, {params: {stats_by_category: object.stats_by_category}}).to_h
    end
  end
end
