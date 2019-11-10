class Document < ActiveRecord::Base
  belongs_to :user

  rails_admin do
    configure :player do
      label 'Owner of this ball: '
    end
  end
end
