# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(name: 'TV Comedies')
Category.create(name: 'Comedies')
Category.create(name: 'Animation')

Video.create(title: 'Family Guy', description: 'A guy and his family.', small_cover: 'tmp/family_guy.jpg', large_cover: 'tmp/monk_large.jpg', category_id: 1)
Video.create(title: 'Futurama', description: 'A guy in the future.', small_cover: 'tmp/futurama.jpg', large_cover: 'tmp/monk_large.jpg', category_id: 1)
monk = Video.create(title: 'Monk', description: 'A guy named Monk.', small_cover: 'tmp/monk.jpg', large_cover: 'tmp/monk_large.jpg', category_id: 1)
Video.create(title: 'South Park', description: 'Some kids in South Park', small_cover: 'tmp/south_park.jpg', large_cover: 'tmp/monk_large.jpg', category_id: 1)

Video.create(title: 'Futurama', description: 'A guy in the future.', small_cover: 'tmp/futurama.jpg', large_cover: 'tmp/monk_large.jpg', category_id: 2)
Video.create(title: 'Monk', description: 'A guy named Monk.', small_cover: 'tmp/monk.jpg', large_cover: 'tmp/monk_large.jpg', category_id: 2)
Video.create(title: 'South Park', description: 'Some kids in South Park', small_cover: 'tmp/south_park.jpg', large_cover: 'tmp/monk_large.jpg', category_id: 2)

Video.create(title: 'Monk', description: 'A guy named Monk.', small_cover: 'tmp/monk.jpg', large_cover: 'tmp/monk_large.jpg', category_id: 3)
Video.create(title: 'South Park', description: 'Some kids in South Park', small_cover: 'tmp/south_park.jpg', large_cover: 'tmp/monk_large.jpg', category_id: 3)

panda = User.create(email: 'panda@panda.com', full_name: 'Panda Edwards', password: 'password')

Review.create(user: panda, video: monk, rating: 5, content: "A good movie" )
Review.create(user: panda, video: monk, rating: 3, content: "An average movie" )
