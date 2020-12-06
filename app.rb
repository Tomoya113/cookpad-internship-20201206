require 'sinatra'
require 'sinatra/reloader' if development?
require_relative 'lib/poll'
require_relative 'lib/vote'

$polls = [
  Poll.new('好きな料理', ['肉じゃが', 'しょうが焼き', 'から揚げ']),
  Poll.new('人気投票', ['おむすびけん', 'クックパッドたん']),
]

get '/' do
  erb :index, locals: { polls: $polls }
end

get '/polls/new' do
  erb :new_poll
end

post '/polls/new' do
  halt 404, '選択肢を2つ以上入力してください' if params['candidates'].length < 1
  $polls.push(
    Poll.new(params['title'], params['candidates'])
  )
  redirect to("/"), 303
end


get '/polls/:id' do
  index = params['id'].to_i
  poll = $polls[index]
  halt 404, '投票が見つかりませんでした' if poll.nil?

  erb :poll, locals: { index: index, poll: poll }
end

post '/polls/:id/votes' do
  index = params['id'].to_i
  poll = $polls[index]
  halt 404, '投票が見つかりませんでした' if poll.nil?
  p params
  vote = Vote.new(params['voter'], params['candidate'])
  poll.add_vote(vote)

  redirect to("/polls/#{index}"), 303
rescue Poll::InvalidCandidateError
  halt 400, '不正な候補名です'
end

get '/polls/:id/result' do
  index = params['id'].to_i
  poll = $polls[index]
  halt 404, '投票が見つかりませんでした' if poll.nil?

  result = poll.count_votes

  erb :result, locals: { poll: poll, result: result }
end
