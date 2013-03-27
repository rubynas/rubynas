# In the production environment should the root volume always be available
if Rails.env.production?
  unless Volume.find_by_name_and_path("System Volume", "/")
    Volume.create(name: "System Volume", path: "/")
  end
end
