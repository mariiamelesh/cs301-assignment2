with bad_reviews as (
	select user_id, rating
	from reviews
	where rating < 3
)

select br.user_id, br.rating, users.country
from bad_reviews br
join users on br.user_id = users.user_id