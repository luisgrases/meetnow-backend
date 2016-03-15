require('api_constraints')
Rails.application.routes.draw  do
  
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :events do
        member do
          get 'invited_contacts_counter'
          get 'assisting_people'
          get 'not_assisting_people'
          get 'pending_people'
          post 'change_member_privilege'
          post 'assist'
          post 'not_assist'
          post 'invite_contact'
          post 'cancel'
          post 'leave'
        end
      end

      resources :members

      resources :friendships do
        collection do
          get 'all'
          post 'accept'
        end
      end
      resources :users do
        collection do
          get 'search'
          get 'me'
        end
      end
    end
  end
  mount_devise_token_auth_for 'User', at: 'auth'
end
