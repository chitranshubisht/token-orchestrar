class KeysController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_key, only: [:show, :destroy, :update, :keep_alive]
  
    def create
      token = SecureRandom.hex(16)
      key = Key.new(token: token)
  
      if key.save
        render json: { token: key.token }, status: :created
      else
        render json: key.errors, status: :unprocessable_entity
      end
    end
  
    def index
      key = Key.where(blocked: false).order("RANDOM()").first
  
      if key
        key.update(blocked: true, blocked_at: Time.current)
        KeyUnblockJob.set(wait: 60.seconds).perform_later(key.id)
        render json: { keyId: key.token }
      else
        render json: {}, status: :not_found
      end
    end
  
    def show
      render json: {
        isBlocked: @key.blocked,
        blockedAt: @key.blocked_at,
        createdAt: @key.created_at
      }
    end
  
    def destroy
      @key.destroy
      render json: { message: "Destroyed!!!"}
    end
  
    def update
      if @key.update(blocked: false, blocked_at: nil)
        render json: { message: "Updated!!!"}
      else
        render json: @key.errors, status: :unprocessable_entity
      end
    end
  
    def keep_alive
      if key.update(keep_alive: true)
        render json: { message: "Updated!!!"}
      else
        render json: key.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_key
      @key = Key.find_by(token: params[:id])
      render json: {}, status: :not_found unless @key
    end
end
  