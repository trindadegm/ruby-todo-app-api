class Task < ApplicationRecord
    validates_presence_of :owner
    validates_presence_of :title
    validates_presence_of :status
    validates_presence_of :visibility
    validates_inclusion_of :status, :in => ['pending', 'done'], :message => 'Invalid status'
    validates_inclusion_of :visibility, :in => ['public', 'private'], :message => 'Invalid visibility'
end
