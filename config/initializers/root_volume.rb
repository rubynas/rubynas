# In the production environment should the root volume always be available
unless Rails.env.test?
  unless Volume.find_by_name_and_path("System Volume", "/")
    Volume.create(name: "System Volume", path: "/")
  end
end
