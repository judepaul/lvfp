json.extract! lead, :id, :email, :firstname, :lastname, :company, :phone, :address, :city, :state, :country, :zip, :created_at, :updated_at
json.url lead_url(lead, format: :json)
