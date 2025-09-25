---added new column sku_id----
alter table zepto
add sku_id int identity(1,1) primary key;

----check for null values---

select * 
from zepto
where Category is Null 
or
name is Null 
or
mrp is Null 
or
discountPercent is Null 
or
discountedSellingPrice is Null 
or
weightInGms is Null 
or
outOfStock is Null 
or
quantity is Null;

----- check for price is zero----

select *
from zepto
where mrp=0 
or discountedSellingPrice =0

----- one record is found---

delete from zepto
where mrp=0 or discountedSellingPrice=0;

-----convert weight from grams to kilo----

update zepto
set mrp=mrp/100,
discountedSellingPrice=discountedSellingPrice/100;

---- Q1. Find the top 10 best-value products based on the discount percentage.----

select distinct name, mrp,discountPercent, discountedSellingPrice
from zepto
order by discountPercent desc
offset 0 rows
fetch next 10 rows only;

-------Q2.What are the Products with High MRP but Out of Stock-----

select distinct name, mrp, 
case
  when outOfStock=0 then 'The item is out of stock'
else 'The item is in stock'
end as "stock status"
from zepto
where outOfStock= 0 and mrp>300
order by mrp desc;


----Q3.Calculate Estimated Revenue for each category----

select Category, sum(discountedSellingPrice* availableQuantity) as total_revenue
from zepto
group by Category
order by total_revenue desc;

---- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.----

select distinct name, mrp, discountPercent
from zepto
where mrp> 500 
and discountPercent< 10
order by mrp desc, discountPercent desc;

---- Q5. Identify the top 5 categories offering the highest average discount percentage.----

select Category, avg( discountPercent) as highest_avg_discount
from zepto
group by Category
order by highest_avg_discount desc
offset 0 rows
fetch next 5 rows only;

------ Q6. Find the price per gram for products above 100g and sort by best value.----

select distinct name,mrp, discountedSellingPrice, (discountedSellingPrice/weightInGms) as price_per_gram
from zepto
where weightInGms>=100
order by price_per_gram desc;


----Q7.Group the products into categories like Low, Medium, Bulk.----

 select distinct name, weightInGms, 
 case
  when weightInGms < 1000 then 'low'
  when weightInGms <5000 then 'Medium'
  else 'Bulk'
  end as prod_categories
  from zepto

----Q8.What is the Total Inventory Weight Per Category----

select Category, sum(cast(weightInGms as BIGINT) *  cast(availableQuantity as bigint)) as Total_weight
from zepto
group by Category
order by Total_weight desc;

---As size of the inter is samll we used casting-----







