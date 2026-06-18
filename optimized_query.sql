with bad_reviews as (
	select r.user_id, country, product_name
	from reviews r
	join users u on r.user_id = u.user_id
	join products p on r.product_id = p.product_id
	where rating < 3
), lifetime_value as (
	select user_id, sum(total_amount) as lifetime_value
	from purchases
	group by user_id
)

select br.user_id, br.country, br.product_name, ltv.lifetime_value
from bad_reviews br
join lifetime_value ltv on br.user_id = ltv.user_id
