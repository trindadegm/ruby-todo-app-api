class Task < ApplicationRecord
    validates :owner, presence: true
    validates :title, presence: true
    validates :status, presence: true
    validates :visibility, presence: true
end
