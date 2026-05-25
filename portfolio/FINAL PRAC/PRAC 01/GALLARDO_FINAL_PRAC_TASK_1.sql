CREATE DEFINER=`root`@`localhost` PROCEDURE `clean_data`()
BEGIN
	-- 1. REMOVE THE
SELECT shipment_id,
	proper_case(trim(origin_warehouse)) AS origin_warehouse,
    proper_case(trim(destination_city)) AS destination_city,
    ucase(destination_state) AS destionation_state,
    proper_case(trim(carrier)) AS carrier,
    
 -- 2. CHANGE DATE FORMAT FOR SHIP_DATE AND DELIVERY_DATE   
str_to_date(delivery_date, '%y, %m, %d') AS delivery_date,
str_to_date(ship_date, '%y, %m, %d') AS ship_date,
    
-- 3. VALIDATE DATE ENTRIES FOR DELIVERY AND SHIPMENTS
datediff(delivery_date,ship_date) AS No_of_days_delivered,
CASE
	WHEN(delivery_date < ship_date) THEN 'Invalid'
	WHEN(delivery_date = ship_date) THEN 'Same Day Delivery'
	ELSE 'Valid'
END AS delivery_status,

-- 4. 
CASE
	WHEN weight_kg < 0 THEN abs(weight_kg)
    WHEN weight_kg = 0 THEN abs(weight_kg)
	ELSE weight_kg
END as valid_weight,
    
-- 5. 
ROW_NUMBER() OVER(
partition by origin_warehouse, destination_city, destination_state,ship_date, carrier,
CONVERT(weight_kg,char),
CONVERT(freight_cost,char)
ORDER BY shipment_id) AS row_num

FROM shipments_db.dirty_shipments;    

-- 6. remove duplicate
DELETE FROM dirty_shipments
	WHERE shipment_id IN 
    (
	SELECT shipment_id FROM (
		SELECT shipment_id, ROW_NUMBER() OVER
		(PARTITION BY origin_warehouse, destination_city, ship_date
		ORDER BY shipment_id) AS row_num
		FROM dirty_shipments
	) AS sub
    WHERE row_num > 1
);

END