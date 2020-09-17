# frozen_string_literal: true

class AuthorsService
  def initialize(params)
    @search_term = params[:search_term]
    @page = params[:page]
    @per_page = params[:per_page]
    @order_by = params[:order_by]&.to_h
  end

  def self.search(params)
    new(params).search
  end

  def search
    authors = Author.available.page(page).per(per_page)
    authors = authors.find_matches(name: search_term) if search_term.present?
    authors = authors.order(order_by) if order_by.present?
    authors
  end

  private

  attr_reader :search_term, :page, :per_page, :order_by
end
