# comment for codeclimate
class Api::V1::ProgramsController < ApplicationController

  # protect_from_forgery with: :null_session, if: proc { |c| c.request.format.json? }
  # before_action :authorize_user, except: [:index, :create]
  skip_before_action :verify_authenticity_token
  before_action :authorize_user, except: [:index, :show, :create]

  def index
    render json: { programs: Program.all }
  end

  def show
    @program = Program.find(params[:id])
    @reviews = @program.reviews.order(:created_at).reverse
    if current_user
      @user = current_user
      @userVotes = Vote.where('user_id = ? AND program_id = ?', @user.id, params[:program_id])
    else
      @userVotes = []
    end
    @usernames = @reviews.map { |i| i.user.user_name }
    render json: {
      program: @program,
      reviews: @reviews,
      user: @user,
      usernames: @usernames,
      userVotes: @userVotes
    }
  end

  def create
    @program = Program.new(program_params)
    if current_user
      @user = current_user
      @program.user = @user
    else
      return render json: { error: ['You must be logged in to do that!'] }
    end
    if @program.save
      return render json: { program: Program.find(@program.id) }
    else
      render json: { error: ['This imdb program doesn\'t look like a tv show to us!'] }, status: :unprocessable_entity
    end
  end

  def destroy
    @program = Program.find(params[:id])
    @program.destroy
    render json: { message: 'cool' }
  end

  private

  def program_params
    params.require(:program).permit(
      :title, :year, :rated, :run_time,
      :genre, :actor, :plot, :award,
      :poster_url, :imdb_rating,
      :imdb_id, :total_seasons, :user_id)
  end
end
