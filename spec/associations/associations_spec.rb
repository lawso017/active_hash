require 'spec/spec_helper'

describe ActiveHash::Base, "associations" do

  before do
    build_model :countries do
    end

    class City < ActiveHash::Base
      field :country_id
      include ActiveHash::Associations
    end

    class Author < ActiveHash::Base
      include ActiveHash::Associations
      field :publisher_id
      field :city_id
    end

    build_model :books do
      integer :author_id
    end
  end

  after do
    Object.send :remove_const, :Author
  end

  describe "#has_many" do

    context "with ActiveRecord children" do
      before do
        @included_book_1  = Book.create! :author_id => 1
        @included_book_2  = Book.create! :author_id => 1
        @excluded_book    = Book.create! :author_id => 2
      end

      it "find the correct records" do
        Author.has_many :books
        author = Author.create :id => 1
        author.books.should =~ [@included_book_1, @included_book_2]
      end
    end

    context "with ActiveHash children" do
      before do
        @included_author_1  = Author.create :city_id => 1
        @included_author_2  = Author.create :city_id => 1
        @excluded_author    = Author.create :city_id => 2
      end

      it "find the correct records" do
        City.has_many :authors
        city = City.create :id => 1
        city.authors.should =~ [@included_author_1, @included_author_2]
      end
    end

  end

  describe "#belongs_to" do

    context "with an ActiveRecord parent" do
      it "find the correct records" do
        City.belongs_to :country
        country = Country.create
        city = City.create :country_id => country.id
        city.country.should == country
      end
    end

    context "with an ActiveHash parent" do
      it "find the correct records" do
        Author.belongs_to :city
        city = City.create
        author = Author.create :city_id => city.id
        author.city.should == city
      end
    end

  end

end
