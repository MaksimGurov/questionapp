# frozen_string_literal: true

class QuestionsController < ApplicationController
  include QuestionsAnswers
  before_action :set_question!, only: %i[show destroy edit update]
  before_action :fetch_tags, only: %i[new edit]

  def show
    load_questions_answers
    # @answers = @question.answers.order(created_at: :desc).page(params[:page])
    # @answers = Answer.where(question: @question).limit(2).order created_at: :desc
  end

  def destroy
    @question.destroy
    flash[:success] = 'Question destroy'
    redirect_to questions_path
  end

  # что нужно сделать, чтобы была возможность добавлять много вариантов ответов на один вопрос
  # каждому пользователю выбирать ответ и отображать его

  def edit; end

  def update
    if @question.update question_params
      flash[:success] = 'Question updated!'
      redirect_to questions_path
    else
      render :edit
    end
  end

  def index
    @pagy, @questions = pagy Question.order(created_at: :desc)
    @questions = @questions.decorate
    @questions = @questions.includes(:user)
    # @questions = Question.order(created_at: :desc).page params[:page] #page разбивает коллекцию по страницам
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build question_params
    if @question.save
      flash[:success] = 'Question create'
      redirect_to questions_path
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, tag_ids: [])
  end

  # переменная образца класса
  def set_question!
    @question = Question.find params[:id]
  end

  def fetch_tags
    @tags = Tag.all
  end
end
