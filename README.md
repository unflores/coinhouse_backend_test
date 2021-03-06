# README

![alt text](https://github.com/cmiran/coinhouse_backend_test/blob/dev/schema_sql.jpg)

ruby 3.0.0  
rails 6.3.1  

*Un-native gems:*  
jbuilder, redis, bcrypt, graphql, graphiql,  pry, ransack, sidekiq, redis-rails, rspec-rails, rspec-sidekiq, faker, letter-opener  

```
# Drop, create, migrate, populate db
rails db:drop db:create db:migrate db:seed

# Launch server
rails s

# Tests
bundle exec rspec
```

```
# Sign up
curl -X POST -d user='{"first_name"=>"David","last_name"=>"Copperfield","email"=>"big_dave@yolo.com","password"=>"password"}' http://localhost:3000/api/users

# Login
curl -X POST -d email="big_dave@yolo.com" -d password="password" http://localhost:3000/api/login

# Create Event
curl -X POST -H "Authorization: Token token=<token>" -d event='{"kind"=>"workshop","date"=>"2021-03-21","start_at"=>"12:00:00 +0100","end_at"=>"12:59:59 +0100","name"=>"Hello World","location"=>"Narnia","description"=>"Quas at vel. Et laboriosam doloremque. Sit quidem molestias.","limit"=>5}' -d speaker='{"first_name"=>"Elon","last_name"=>"Musk","email"=>"elon@spacex.com"}' http://localhost:3000/api/events

# Index events
curl -X GET http://localhost:3000/api/events

# Search
curl -X GET -d q='{"location_i_cont"=>"arena","user_first_name_eq"=>"Sylvain"}' http://localhost:3000/api/events

# Attend event
curl -X POST -H "Authorization: Token token=<token>" http://localhost:3000/api/events/2/attend

...
```

Dockerisation is on it's way
```
docker-compose -f docker-compose.yml up --build
docker-compose run api rails db:reset db:migrate db:seed
docker-compose up
```

The search use ransack, bellow are all the matchers
| Predicate | Description | Notes |
| ------------- | ------------- |-------- |
| `*_eq`  | equal  | |
| `*_not_eq` | not equal | |
| `*_matches` | matches with `LIKE` | e.g. `q[email_matches]=%@gmail.com`|
| `*_does_not_match` | does not match with `LIKE` | |
| `*_matches_any` | Matches any | |
| `*_matches_all` | Matches all  | |
| `*_does_not_match_any` | Does not match any | |
| `*_does_not_match_all` | Does not match all | |
| `*_lt` | less than | |
| `*_lteq` | less than or equal | |
| `*_gt` | greater than | |
| `*_gteq` | greater than or equal | |
| `*_present` | not null and not empty | Only compatible with string columns. Example: `q[name_present]=1` (SQL: `col is not null AND col != ''`) |
| `*_blank` | is null or empty. | (SQL: `col is null OR col = ''`) |
| `*_null` | is null | |
| `*_not_null` | is not null | |
| `*_in` | match any values in array | e.g. `q[name_in][]=Alice&q[name_in][]=Bob` |
| `*_not_in` | match none of values in array | |
| `*_lt_any` | Less than any |  SQL: `col < value1 OR col < value2` |
| `*_lteq_any` | Less than or equal to any | |
| `*_gt_any` | Greater than any | |
| `*_gteq_any` | Greater than or equal to any | |
| `*_lt_all` | Less than all | SQL: `col < value1 AND col < value2` |
| `*_lteq_all` | Less than or equal to all | |
| `*_gt_all` | Greater than all | |
| `*_gteq_all` | Greater than or equal to all | |
| `*_not_eq_all` | none of values in a set | |
| `*_start` | Starts with | SQL: `col LIKE 'value%'` |
| `*_not_start` | Does not start with | |
| `*_start_any` | Starts with any of | |
| `*_start_all` | Starts with all of | |
| `*_not_start_any` | Does not start with any of | |
| `*_not_start_all` | Does not start with all of | |
| `*_end` | Ends with | SQL: `col LIKE '%value'` |
| `*_not_end` | Does not end with | |
| `*_end_any` | Ends with any of | |
| `*_end_all` | Ends with all of | |
| `*_not_end_any` | | |
| `*_not_end_all` | | |
| `*_cont` | Contains value | uses `LIKE` |
| `*_cont_any` | Contains any of | |
| `*_cont_all` | Contains all of | |
| `*_not_cont` | Does not contain |
| `*_not_cont_any` | Does not contain any of | |
| `*_not_cont_all` | Does not contain all of | |
| `*_i_cont` | Contains value with case insensitive | uses `ILIKE` |
| `*_i_cont_any` | Contains any of values with case insensitive | |
| `*_i_cont_all` | Contains all of values with case insensitive | |
| `*_not_i_cont` | Does not contain with case insensitive |
| `*_not_i_cont_any` | Does not contain any of values with case insensitive | |
| `*_not_i_cont_all` | Does not contain all of values with case insensitive | |
| `*_true` | is true | |
| `*_false` | is false | |
