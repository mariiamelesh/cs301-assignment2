create index idx_interactions_type_user_prod 
on interactions (interaction_type, user_id, product_id);
create index idx_reviews_product_rating 
on reviews (product_id, rating);
create index idx_purchases_user_product
on purchases (user_id, product_id);

explain analyze

with premium_products as (
	select product_id, product_name
	from products
	where product_name like '%Pro%' or product_name like '%Max%'
), bad_reviews as (
	select distinct r.user_id, pp.product_id
	from reviews r
	join premium_products pp on r.product_id = pp.product_id
	where rating <= 3
), long_view as ( 
	select br.user_id, br.product_id
	from bad_reviews br
	join interactions i on br.user_id = i.user_id and br.product_id = i.product_id
	where i.interaction_type = 'view'
	group by br.user_id, br.product_id
	having sum(i.dwell_time_ms) > 60000
), lifetime_value as (
	select lv.user_id, sum(p.total_amount) as lifetime_value
	from long_view lv
	join purchases p on lv.user_id = p.user_id
	group by lv.user_id
)

select u.user_id, u.country, p.product_name, ltv.lifetime_value
from lifetime_value ltv
join users u on ltv.user_id = u.user_id
join long_view lv on ltv.user_id = lv.user_id
join products p on lv.product_id = p.product_id