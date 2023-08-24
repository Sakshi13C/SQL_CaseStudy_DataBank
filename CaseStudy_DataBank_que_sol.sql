/*_____________A. Customer Nodes Exploration___________*/

/* 1. How many unique nodes are there on the Data Bank system?  */
SELECT COUNT(DISTINCT(node_id)) unique_node
FROM data_bank.customer_nodes;

/* 2. What is the number of nodes per region? */
SELECT r.region_name, COUNT(DISTINCT(node_id)) node_count
FROM data_bank.regions r
JOIN data_bank.customer_nodes cn
ON r.region_id=cn.region_id
GROUP BY 1;

/* 3. How many customers are allocated to each region? */
SELECT region_id, COUNT(DISTINCT(customer_id))
FROM data_bank.customer_nodes
GROUP BY region_id;


/*_____________B. Customer Transactions___________*/

/* 1. What is the unique count and total amount for each transaction type? */ 
SELECT txn_type, COUNT(txn_type) unique_count, SUM(txn_amount) total_amount
FROM data_bank.customer_transactions 
GROUP BY txn_type;

/* 2. What is the average total historical deposit counts and amounts for all customers? */
SELECT ROUND(AVG(deposit_count)), AVG(deposit_amt)
FROM(SELECT customer_id, COUNT(txn_type) deposit_count, AVG(txn_amount) deposit_amt
     FROM data_bank.customer_transactions
     WHERE txn_type='deposit'
	 GROUP BY customer_id) sub;

/* 3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal 
in a single month?*/
SELECT txn_month, COUNT(DISTINCT(customer_id))
FROM(SELECT customer_id, DATE_PART('month',txn_date) txn_month,
	 SUM(IF txn_type='deposit' THEN 1 END IF) AS deposit_count,
     SUM(IF txn_type='withdrawal' THEN 1 END IF) AS withdrawal_count,
     SUM(IF txn_type='purchase' THEN 1 END IF) AS purchase_count
     FROM data_bank.customer_transactions
	 GROUP BY customer_id) sub
WHERE deposit_count>1 AND (purchase_count = 1 OR withdrawal_count = 1)
GROUP BY txn_month
ORDER BY txn_month;






