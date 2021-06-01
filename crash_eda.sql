with signup as (select id as userid,
						min(creationtime_istdate) as date
				from public.user
				where creationtime_istdate::date between '2020-12-01' and '2020-12-31'
				and studentinfo_grade in ('12','13')
				group by 1),
crash_order as (select distinct o.userid, 
                        min(o.creationtime_istdate) as date
                from public.orders o
                where o.amount > 0
                and o.entityid in ('5f80592885548271859b7ae3','5f805833d7a0821609c56ce0','5ff4174457575a68d49396d6','5ff4168db6ac242ec95906e6',
                					'6005ca2c4c84fa7da7fc8c42', '5fd8ccb01c698759d1338aef', '5fd8cc48d294a47a81f2260a')
                and o.paymentstatus in ('PAID','PARTIALLY_PAID','FORFEITED','PAYMENT_SUSPENDED')
                and (o.agentcode is null or o.agentcode ='VD00028')
                and o.useremail not like '%vedantu.com'
                group by 1),
engagement as (select userid,
						min(date) as date
				from analytics_reporting.ep_kpi
				group by 1)
select count(distinct e.userid) as "NewSignup_engaged",
		count(distinct case when co.userid is not null and e.userid is not null then s.userid end) as New_engaged_converted,
		count(distinct case when co.userid is not null and e.userid is null then s.userid end) as New_notengaged_butconverted
from signup s
left join crash_order co on co.userid = s.userid and co.date = dateadd('day', 1, s.date)
left join engagement e on e.userid = s.userid and e.date <= dateadd('day', 1, s.date)