class Dataset < ApplicationRecord
  validates :arpu_name, :arpu_std_name, :size_name, :feature_name , presence: true
end
