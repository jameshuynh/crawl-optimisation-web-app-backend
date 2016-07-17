## db/seeds.db

[
  {
    name: 'James Huynh',
    title: 'MR',
    bio: 'I am a Rails & Front End Developer'
  },
  {
    name: 'Ivy Pham',
    title: 'MS',
    bio: 'I am a manager assistant'
  }
].each do |user_data|
  User.create(user_data)
end
