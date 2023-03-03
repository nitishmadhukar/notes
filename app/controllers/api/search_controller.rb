# frozen_string_literal: true

# API module

module Api
  # Controller for search
  class SearchController < ApplicationController
    before_action :authenticate_user!
    before_action :set_note, only: %i[search]

    def search
      search_term = params[:q]
      notes = @notes.where({ '$text' => { '$search' => search_term } })
      render json: notes, status: :ok
    end

    private

    def set_note
      @notes = current_user.notes
    end
  end
end
