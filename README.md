# Practice Lab 2
### trigger warning: even more of barely readable code. beware! :P  
## Dataset description
Dataset used for querying consists of 6 tables and shows an imitation data from a customer activity logger at a medium-sized online retailer. It contains information on users(`users` table), products available(`products` table ), a list of completed purchases(`purchases` table) and reviews(`reviews` table). Additionally, there's users' activity sessions log(`sessions` table) and a detailed interaction log (`interactions` table).
## Query description
Purpose of the query is to point out a specific group of customers which have left a negative review(reviews with rating <= 3) after a purchase of a product form an exclusively expensive category. Additionally, query filters out the users to include only those that have an overall view-type interaction with product for over than 1 minute(means that the user has been viewing the product before purchase for a good amount of time). In the result, query returns an information on the customer(id and country of origin), product name and customers' lifetime value(total amount of money a person spent at the retailers' shop). Basically, this query is good for nothing but just fun. Doesn't bring any useful information to the table, however can be used for lolz.
## Optimization plan!
### Input
On the input (see `unoptimized_query.sql` for reference) we have a query so unefficient it almost crashed my DBeaver as I ran it.
