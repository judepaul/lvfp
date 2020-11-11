module UsersHelper
  
  def owner user_id 
    User.find(user_id).username
  end
    
end
