module ApplicationHelper
  def name_email(user)
    "#{user.fname} #{user.lname} (#{user.email})"
  end
end
