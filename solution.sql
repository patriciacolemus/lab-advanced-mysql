USE Publications_3;


# Step 1: Royalties of each sales for each author 
# sales_royalty = titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100
CREATE TEMPORARY TABLE royalty_sale_author
SELECT t.title_id, a.au_id, (t.price * s.qty * t.royalty /100 * ta.royaltyper /100) AS sales_royalty
FROM titles AS t 
JOIN titleauthor AS ta
USING (title_id)
JOIN authors AS a
USING (au_id)
JOIN sales AS s
USING (title_id) 
ORDER BY a.au_id;

# Step 2: Royalties for each title for each author
CREATE TEMPORARY TABLE royalty_title_author #rta
SELECT title_id, au_id, SUM(sales_royalty) AS royalties
FROM royalty_sale_author
GROUP BY au_id, title_id
ORDER BY royalties desc;

# Step 3: Total profits of each author
CREATE TEMPORARY TABLE total_profits_author 
SELECT rta.au_id, rta.royalties + t.advance AS total_profits
FROM royalty_title_author AS rta
INNER JOIN titles AS t ON rta.title_id = t.title_id
ORDER BY total_profits DESC LIMIT 3;

#Challenge 3 
#table named most_profiting_authors to hold the data about the most profiting authors
CREATE TABLE most_profiting_authors
SELECT tpa.au_id, (tpa.royalties + t.advance) AS total_profits
FROM royalty_title_author AS tpa
JOIN titles AS t ON tpa.title_id = t.title_id 
ORDER BY total_profits;
