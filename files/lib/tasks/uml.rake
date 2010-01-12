namespace :uml do
  desc 'Builds UML graphs for the project'
  task :build_model do
    `railroad -M | dot -Tpng > models.png`
  end
  
  desc task :build_controllers do
    `railroad -C | dot -Tpng > controllers.png`
  end
end