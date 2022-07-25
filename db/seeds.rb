# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create(email: 'mesxiana3@gmail.com',
            password: 'password',
            password_confirmation: 'password',
            username: 'anuka',
            role: User.roles[:admin],
            confirmed_at: Time.now )
User.create(email: 'a.meskhii@gmail.com',
              password: 'password',
              password_confirmation: 'password',
              username: 'anuki',
              )
User.create(email: 'a.m5eskhii@gmail.com',
                password: 'password',
                password_confirmation: 'password',
                username: 'anuki',)
User.create(email: 'a.m6eskhii@gmail.com',
                  password: 'password',
                  password_confirmation: 'password',
                  username: 'anuki',
                  )
User.create(email: 'a.m1eskhii@gmail.com',
                    password: 'password',
                    password_confirmation: 'password',
                    username: 'anuki',
                    )
                    User.create(email: 'a.me2skhii@gmail.com',
                      password: 'password',
                      password_confirmation: 'password',
                      username: 'anuki',
                      )
 User.create(email: 'a.m2eskhii@gmail.com',
                        password: 'password',
                        password_confirmation: 'password',
                        username: 'anuki',
                        )
 User.create(email: 'a.m3eskhii@gmail.com',
                          password: 'password',
                          password_confirmation: 'password',
                          username: 'anuki',
                          )
User.create(email: 'a.m4eskhii@gmail.com',
                            password: 'password',
                            password_confirmation: 'password',
                            username: 'anuki',
                            )
10.times do |x|
  post = Post.create(title: "Title #{x}",
                     body: "Body #{x} Words go here Idk",
                     user_id: User.first.id)
end