use Namma_Yatri;
go
select*from trips_details;
select * from trips;
select*from loc;
select*from duration;
select*from payments;

--1.find total trips
select count(distinct tripid) from trips_details;

--2.find duplicate trip id
select tripid,count(tripid) cnt from trips_details
group by tripid
having count(tripid)>1;

--3.total No. of drivers
select count(distinct driverid) from trips;

--4.find total earnings or fare
select sum(fare) Earning from trips;

--5.find total completed trips
select sum(end_ride) Completed_trips from trips_details;
select count(distinct tripid) trips from trips;

--6.total searches
select sum(searches) from trips_details;

--7.total searches_got_estimate
select sum(searches_got_estimate) fare_estimate from trips_details;

--8.total searches for quotes
select sum(searches_for_quotes) from trips_details;

--9.total searches got quotes
select sum(searches_got_quotes) from trips_details;

--10.total driver cancelled
select count(*)-sum(driver_not_cancelled) from trips_details;

--11.total otp entered
select sum(otp_entered) from trips_details;

--12.total end ride
select sum(end_ride) from trips_details;

--13.average distance per trip
select avg(distance) from trips;

--14.Average fare per trip
select avg(fare) from trips;

--15.total distance travelled
select sum(distance) from trips;

--16.which is most used paymenet method
select a.method from payments a inner join
(select top 1 faremethod,count(distinct tripid) cnt from trips
group by faremethod
order by count(distinct tripid) desc) b
on a.id= b.faremethod;

--17.the highest payment was made through which instrument
select a.method from payments a inner join
(select top 1 *from trips
order by fare desc)b
on a.id=b.faremethod;  --1

select a.method from payments a inner join
(
select top 1 faremethod, sum(fare) fare from trips
group by faremethod
order by sum(fare) desc)b
on a.id=b.faremethod;


--18.which two locations had the most trips
select* from
(select*,DENSE_RANK() over(order by trip desc) rnk
from
(select loc_from,loc_to,count(distinct tripid) trip from trips 
group by loc_from,loc_to) a) b
where rnk=1;

--19.top 5 earning drivers
select * from
(select *, DENSE_RANK() over (order by fare desc)rnk
from
(select driverid,sum(fare) fare from trips
group by driverid)b)c
where rnk<6;

--20.which duration had more trips
select*from
(select *,rank() over (order by cnt desc) rnk from
(select duration,count(distinct tripid) cnt from trips
group by duration)b)c
where rnk=1;

--21.which driver , customer pair had more orders
select*from
(select*,rank() over (order by cnt desc) rnk from
(select driverid, custid, count(distinct tripid) cnt from trips
group by driverid,custid)c)d
where rnk=1;

--22.search to estimate rate
select sum(searches_got_estimate)*100.0/sum(searches) estimate from trips_details;

--23.estimate to search for quote rates
select sum(searches_for_quotes)*100.0/sum(searches_got_estimate) estimate from trips_details;

--24.quote acceptance rate
select sum(searches_got_quotes)*100.0/sum(searches_for_quotes) estimate from trips_details;

--25.quote to booking rate
select sum(otp_entered)*100.0/sum(searches_got_quotes) estimate from trips_details;

--26.which area got highest trips in which duration
select*from
(select *,rank()over (partition by duration order by cnt desc)rnk from
(select duration, loc_from, count(distinct tripid) cnt from trips
group by duration, loc_from)a)c
where rnk=1;

--27.which duration got highest trips in which location
select*from
(select *,rank()over (partition by loc_from order by cnt desc)rnk from
(select duration, loc_from, count(distinct tripid) cnt from trips
group by duration, loc_from)a)c
where rnk=1;

--28.which area got the highest fares, cancellations,trips,
select*from
(select*,rank() over (order by fare desc) rnk from
(select loc_from,sum(fare) fare from trips
group by loc_from)b)c
where rnk=1;

select*from
(select*,rank() over (order by cancelled desc) rnk from
(select loc_from, count(*)-sum(driver_not_cancelled) cancelled
from trips_details
group by loc_from)b)c
where rnk=1;

select*from
(select*,rank() over (order by cancelled desc) rnk from
(select loc_from, count(*)-sum(customer_not_cancelled) cancelled
from trips_details
group by loc_from)b)c
where rnk=1;


--29.which duration got the highest trips and fares
select*from
(select*,rank() over (order by fare desc) rnk from
(select duration,sum(fare) fare from trips
group by duration)b)c
where rnk=1;

select*from
(select*,rank() over (order by cnt desc) rnk from
(select duration,count(distinct tripid) cnt from trips
group by duration)b)c
where rnk=1;

--30.Ranking trips by fare per customer
select distinct custid, tripid, fare, 
rank() over(partition by custid order by fare desc) rnk
from trips;

select*from
(select*,rank() over (partition by custid order by fare desc) rnk
from
(select distinct custid, tripid, fare from trips)b)c
where rnk=1;