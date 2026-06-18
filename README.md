# Practice Lab 2
### trigger warning: even more of barely readable code. beware! :P  
## Dataset description
Dataset used for querying consists of 6 tables and shows an imitation data from a customer activity logger at a medium-sized online retailer. It contains information on users(`users` table), products available(`products` table ), a list of completed purchases(`purchases` table) and reviews(`reviews` table). Additionally, there's users' activity sessions log(`sessions` table) and a detailed interaction log (`interactions` table).
## Query description
Purpose of the query is to point out a specific group of customers which have left a negative review(reviews with rating <= 3) after a purchase of a product from an exclusively expensive category. Additionally, query filters out the users to include only those that have an overall view-type interaction with product for over than 1 minute(means that the user has been viewing the product before purchase for a good amount of time). In the result, query returns an information on the customer(id and country of origin), product name and customers' lifetime value(total amount of money a person spent at the retailers' shop). Basically, this query is good for nothing but just fun. Doesn't bring any useful information to the table, however can be used for lolz.
## Optimization plan!
### Input
On the input (see `unoptimized_query.sql` for reference) we have a query so unefficient it almost crashed my DBeaver as I ran it. On the image it is clearly noticible that the input query has some issues with efficiency and readability: 

<img width="756" height="372" alt="image" src="https://github.com/user-attachments/assets/56f164ca-8e90-494f-82d2-2f16910c6186" />  

Additionally, the EXPLAIN ANALYZE query plan shows an enourmous Execution time figures(for full Query plan see `unoptimized_query_analyze.txt`):  

<img width="1035" height="66" alt="image" src="https://github.com/user-attachments/assets/30d02b50-4ed4-4e38-bbb7-0622585a691b" />  

### Procedure
Firstly, to optimize such a monster, it is important to outline possible CTE's to get rid of the subqueries in SELECT/WHERE. Therefore, the query does around 4 things:  
```
selects premium products -> 
    selects users that left a negative review on these products -> 
        filters users to find those that spent over 1 minute viewing before purchase. ->
            calculates the sum of all the purchases made by customer(CLV)
```
That's 4 CTE's to start from.  
And lastly, after CTE's are implemented, indexes should be created depending on the tables/columns included in filtering

### Output
After the optimization, the following query(see `optimized_query.sql` for reference) was developed:  

<img width="793" height="486" alt="image" src="https://github.com/user-attachments/assets/4bfa9262-574f-4770-b663-8211128c2775" />  

Indexing choice in `interaction` table can be explained by the fact that `long_view` CTE is filtering that table by `interaction_type` and further joins it by `user_id` and `product_id`. Same goes for `reviews`, where filtering is done by using <= operators on `rating` column and joins on `product_id` column. As per `purchases` table, `lifetime_value` CTE doesn't actually do any filtering on it, however joins it to the `long_view` table. As a matter of fact, I chose not to use indexing for `products` table, since it won't do any good for %-like filtering and the algorithm would complete a Full-Text Scan anyway.  

To see how indexing affected the Execution time, here's the Before/After comparison figure(see `optimized_query_unindexed_analyze.txt` and `optimized_query_indexed_analyze.txt` for detailed Query plan):  
<img width="1831" height="376" alt="image" src="https://github.com/user-attachments/assets/4e6e67e6-27fa-4b5c-87ba-75df147025f2" />  

Basically, after the optimization Execution time got 35 times smaller(around 2600 -> 74). Furthermore, after adding indexing, query execution time became 10 times lower(74 -> 7). In the result, we have a x350 decrease of query execution time, which I believe to be a full-on victory :)

## BONUS! Optimizer control
