class Api::V1::SynonymsController < ApplicationController
  before_action :authorize_admin, only: [:admin_index, :admin_update, :admin_destroy]

  def index
    render json: Synonym.where(approved: true).pluck(:word, :synonym)
  end

  def create
    synonym = Synonym.new(synonym_params)
    synonym.approved = false
    if synonym.save
      render json: synonym, status: :created
    else
      render json: { errors: synonym.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def admin_index
    render json: Synonym.all
  end

  def admin_update
    synonym = Synonym.find(params[:id])
    synonym.update(approved: true)
    render json: synonym
  end

  def admin_destroy
    Synonym.find(params[:id]).destroy
    head :no_content
  end

  private

  def synonym_params
    params.require(:synonym).permit(:word, :synonym)
  end

  def authorize_admin
    token = extract_token_from_headers
    if token && valid_token?(token)
      user = User.find_by(id: @decoded_token['id'])

      unless user && user.admin?
        render json: { error: 'Unauthorized' }, status: :unauthorized  
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def extract_token_from_headers
    auth_header = request.headers['Authorization']
    token = auth_header&.split(' ')&.last
  end

  def valid_token?(token)
    @decoded_token ||= JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
      
    true
  rescue JWT::DecodeError
    false
  end
end
