class User < ActiveRecord::Base
  has_secure_password

   before_save :titleize_fname
   before_save :titleize_lname

  # before_create :titleize_fname
  # before_create :titleize_lname

  has_many :memberships, dependent: :destroy
  has_many :projects, through: :memberships

  has_many :comments
  has_many :tasks, through: :comments


  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true


  def titleize_fname
    write_attribute(:first_name, first_name.titleize)
  end

  def titleize_lname
    write_attribute(:last_name, last_name.titleize)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.co_member(project)
    project.memberships.include?(users && current_user)
  end

  def last_owner?(project)
    project.memberships.where(role: 0).count == 1
  end

  # def owner?(project)
  #   project.memberships.find_by(role: Membership.roles[:owner], user_id: id)
  # end


end
