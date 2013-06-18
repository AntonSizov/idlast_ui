class Ability
  include CanCan::Ability

  def initialize(user)

    if user # authorized user abilities

      can [:statistics, :vectors, :illustrations, :photos, :index], Pioneer
      can :create, Pioneer do |pioneer|
        user.timezone_presented?
      end

      can [:vote_up, :vote_down], Pioneer
      # 'destroy' action raise mongoid excepion when
      # using load_and_authorize_resource
      can [:update, :destroy], Pioneer, user_id: user.id

      can :create, Comment
      can :destroy, Comment, user_id: user.id

      can [:change_timezone, :change_article_notification, :show], User, id: user.id
      can :update_pass, User

      if user.admin # admin user abilities
        can :manage, :all
      end

    end

  end

end
