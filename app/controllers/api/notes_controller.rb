# frozen_string_literal: true

# API module

module Api
  # Controller for notes
  class NotesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_note, only: %i[show update destroy share]

    def index
      @notes = current_user.notes.pluck(:id, :title)
      render json: @notes, status: :ok
    end

    def show
      render json: @note, status: :ok
    end

    def create
      @note = current_user.notes.build(note_params)
      if @note.save
        render json: @note, status: :created
      else
        render json: { error: @note.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end

    def update
      if @note.update(note_params)
        render json: @note, status: :ok
      else
        render json: { error: @note.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end

    def destroy
      @note.destroy
      head :no_content
    end

    private

    def note_params
      params.permit(:title, :body)
    end

    def set_note
      @note = current_user.notes.find(params[:id])
    end
  end
end
