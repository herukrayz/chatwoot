# == Schema Information
#
# Table name: articles
#
#  id          :bigint           not null, primary key
#  content     :text
#  description :text
#  status      :integer
#  title       :string
#  views       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :integer          not null
#  author_id   :bigint
#  category_id :integer
#  folder_id   :integer
#  portal_id   :integer          not null
#
# Indexes
#
#  index_articles_on_author_id  (author_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#
class Article < ApplicationRecord
  belongs_to :account
  belongs_to :category
  belongs_to :portal
  # belongs_to :folder
  belongs_to :author, class_name: 'User'

  before_validation :ensure_account_id
  validates :account_id, presence: true
  validates :category_id, presence: true
  validates :author_id, presence: true
  validates :title, presence: true
  validates :content, presence: true

  enum status: { draft: 0, published: 1 }

  def self.search(query)
    joins(:category).where('categories.slug = ? AND categories.locale = ?', query[:category_slug], query[:locale])
  end

  private

  def ensure_account_id
    self.account_id = portal&.account_id
  end
end
